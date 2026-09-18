const otpService = require('../services/otpService');
const whatsappService = require('../services/whatsappService');

// 1. Demander un OTP
exports.requestOtp = async (req, res) => {
    try {
        const { phone } = req.body;

        if (!phone) {
            return res.status(400).json({ success: false, error: 'Le numéro de téléphone est requis.' });
        }

        // Créer l'OTP en base de données
        const otpData = await otpService.createOtp(phone);

        // Envoyer l'OTP via WhatsApp
        const whatsappResult = await whatsappService.sendOtp(phone, otpData.code);

        if (!whatsappResult.success) {
            // Si WhatsApp échoue, on pourrait annuler l'OTP en base, mais ici on log juste l'erreur
            console.warn('Échec envoi WhatsApp:', whatsappResult.message);
            return res.status(502).json({ success: false, error: whatsappResult.message });
        }

        // ⚠️ SÉCURITÉ : Ne JAMAIS renvoyer le code OTP dans la réponse API !
        res.status(200).json({
            success: true,
            message: 'Code de vérification envoyé via WhatsApp.'
        });

    } catch (error) {
        console.error('Erreur requestOtp:', error);
        res.status(500).json({ success: false, error: 'Erreur interne du serveur.' });
    }
};

// 2. Vérifier un OTP
exports.verifyOtp = async (req, res) => {
    try {
        const { phone, code } = req.body;

        if (!phone || !code) {
            return res.status(400).json({ success: false, error: 'Numéro et code requis.' });
        }

        const result = await otpService.verifyOtp(phone, code);

        if (result.success) {
            // Ici, plus tard, on créera la session JWT ou le compte utilisateur
            res.status(200).json({
                success: true,
                message: result.message,
                // On pourra ajouter un token JWT ici plus tard
            });
        } else {
            res.status(400).json({ success: false, error: result.message });
        }

    } catch (error) {
        console.error('Erreur verifyOtp:', error);
        res.status(500).json({ success: false, error: 'Erreur interne du serveur.' });
    }
};

// 3. Renvoyer un OTP (Réutilise la logique de demande)
exports.resendOtp = async (req, res) => {
    // On appelle simplement requestOtp, le service OTP s'occupe d'invalider l'ancien
    exports.requestOtp(req, res);
};