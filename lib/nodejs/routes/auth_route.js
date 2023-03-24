const express = require('express');
const authController = require('../controllers/auth_controller');
const authMiddleware = require('../middlewares/auth_middleware');

const router = express.Router();

router.post('/register',authController.register);
router.post('/login', authController.login);
router.post('/logout', authMiddleware.verifyToken, authController.logout);
router.post('/check_jwt_token', authMiddleware.verifyToken, (req, res) => {
    console.log('status code: ' + res.statusCode);
    res.status(res.statusCode).json({
        message: res.statusCode === 200
            ? 'Token is valid'
            : 'Token is not valid'
    });

});

module.exports = router;
