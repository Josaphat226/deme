const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { otpRequestLimiter, otpVerifyLimiter } = require('../middleware/rateLimiter');

// POST /api/auth/request-otp
router.post('/request-otp', otpRequestLimiter, authController.requestOtp);

// POST /api/auth/verify-otp
router.post('/verify-otp', otpVerifyLimiter, authController.verifyOtp);

// POST /api/auth/resend-otp
router.post('/resend-otp', otpRequestLimiter, authController.resendOtp);

module.exports = router;