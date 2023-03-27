const express = require('express');
const sellerController = require('../controllers/seller_controller');
const authMiddleware = require('../middlewares/auth_middleware');

const router = express.Router();

router.post('/initialDocument', authMiddleware.verifyToken, sellerController.initialDocument);
router.post('/addGame', authMiddleware.verifyToken, sellerController.addGame);
router.post('/addPaymentMethod', authMiddleware.verifyToken, sellerController.addPaymentMethod);
router.get('/readSellerData/:name', authMiddleware.verifyToken, sellerController.readSellerData);

module.exports = router;
