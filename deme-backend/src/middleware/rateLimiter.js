const rateLimit = require('express-rate-limit');

// Limiteur pour la demande d'OTP (ex: 5 demandes toutes les 15 minutes par IP)
const otpRequestLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // 5 tentatives max
    message: { success: false, error: 'Trop de demandes. Réessayez dans 15 minutes.' },
    standardHeaders: true,
    legacyHeaders: false,
});

// Limiteur pour la vérification d'OTP (ex: 10 tentatives toutes les 15 minutes)
const otpVerifyLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 10,
    message: { success: false, error: 'Trop de tentatives de vérification. Réessayez plus tard.' },
    standardHeaders: true,
    legacyHeaders: false,
});

module.exports = { otpRequestLimiter, otpVerifyLimiter };