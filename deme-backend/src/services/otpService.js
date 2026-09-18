const supabase = require('../config/supabase');
const crypto = require('crypto');

const OTP_LENGTH = 6;
const OTP_EXPIRY_MINUTES = 5;
const MAX_ATTEMPTS = 5;
const RESEND_COOLDOWN_MINUTES = 2;

class OtpService {
    // Génère un code aléatoire sécurisé à 6 chiffres
    generateCode() {
        return crypto.randomInt(100000, 999999).toString();
    }

    // Crée un nouvel OTP en base de données
    async createOtp(phoneNumber) {
        // 1. Invalider les anciens OTP pour ce numéro (sécurité)
        await supabase
            .from('otp_codes')
            .update({ used: true, used_at: new Date().toISOString() }) // On les marque comme utilisés pour les désactiver
            .eq('phone', phoneNumber)
            .eq('used', false);

        // 2. Générer le nouveau code
        const code = this.generateCode();
        const expiresAt = new Date(Date.now() + OTP_EXPIRY_MINUTES * 60000).toISOString();

        // 3. Sauvegarder en base
        const { data, error } = await supabase
            .from('otp_codes')
            .insert([{ phone: phoneNumber, code, expires_at: expiresAt, used: false, attempts: 0 }])
            .select()
            .single();

        if (error) throw new Error('Erreur lors de la création de l\'OTP : ' + error.message);
        return data;
    }

    // Vérifie si un OTP est valide
    async verifyOtp(phoneNumber, code) {
        // Récupérer le dernier OTP non utilisé pour ce numéro
        const { data: otp, error } = await supabase
            .from('otp_codes')
            .select('*')
            .eq('phone', phoneNumber)
            .eq('code', code)
            .eq('used', false)
            .order('created_at', { ascending: false })
            .limit(1)
            .single();

        if (error || !otp) {
            return { success: false, message: 'Code invalide.' };
        }

        // Vérifier l'expiration
        if (new Date(otp.expires_at) < new Date()) {
            return { success: false, message: 'Le code a expiré.' };
        }

        // Vérifier le nombre de tentatives
        if (otp.attempts >= MAX_ATTEMPTS) {
            return { success: false, message: 'Trop de tentatives. Demandez un nouveau code.' };
        }

        // Incrémenter les tentatives
        await supabase
            .from('otp_codes')
            .update({ attempts: otp.attempts + 1 })
            .eq('id', otp.id);

        // Si le code est bon, on le marque comme utilisé
        await supabase
            .from('otp_codes')
            .update({ used: true, used_at: new Date().toISOString() })
            .eq('id', otp.id);

        return { success: true, message: 'Code vérifié avec succès.' };
    }
}

module.exports = new OtpService();