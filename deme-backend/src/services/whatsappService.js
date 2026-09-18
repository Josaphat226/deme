const { getSocket, getConnectionState } = require('../config/whatsapp');

class WhatsappService {
    async sendOtp(phoneNumber, otpCode) {
        const sock = getSocket();
        const state = getConnectionState();

        // 1. Vérifier que WhatsApp est connecté
        if (!sock || state !== 'open') {
            console.error(`Tentative d'envoi échouée : État WhatsApp = ${state}`);
            return {
                success: false,
                message: 'Le service WhatsApp n\'est pas encore disponible ou est déconnecté.'
            };
            // Note: Tu pourrais aussi lancer une erreur ici pour que le controller renvoie un 503
        }

        try {
            // 2. Normaliser le numéro pour Baileys (format JID)
            // Baileys attend : numero@s.whatsapp.net (sans le +, sans espaces)
            const cleanNumber = phoneNumber.replace(/\D/g, '');
            const jid = `${cleanNumber}@s.whatsapp.net`;

            const message = `🔐 *Code de vérification DƐMƐ*\n\nVotre code est : *${otpCode}*\n\nCe code est valable pendant quelques minutes.\nNe le partagez avec personne.`;

            // 3. Envoyer le message
            await sock.sendMessage(jid, { text: message });

            console.log(`✅ OTP envoyé avec succès à ${cleanNumber}`);
            return { success: true, message: 'OTP envoyé via WhatsApp.' };

        } catch (error) {
            console.error('❌ Erreur lors de l\'envoi WhatsApp via Baileys:', error);

            // Gestion spécifique si le numéro n'existe pas sur WhatsApp
            if (error.message?.includes('is not in whitelist') || error.message?.includes('recipient is not a user')) {
                return { success: false, message: 'Ce numéro n\'est pas associé à un compte WhatsApp.' };
            }

            return { success: false, message: 'Erreur lors de l\'envoi du message WhatsApp.' };
        }
    }
}

module.exports = new WhatsappService();