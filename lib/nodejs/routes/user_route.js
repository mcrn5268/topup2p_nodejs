const express = require('express');
const userController = require('../controllers/user_controller');
const authMiddleware = require('../middlewares/auth_middleware');

const router = express.Router();

router.get('/read/:uid', authMiddleware.verifyToken, userController.read);
router.patch('/update/', authMiddleware.verifyToken, userController.update);


//seller
router.post('/seller/initialDocument', authMiddleware.verifyToken, userController.initialDocument);

module.exports = router;
