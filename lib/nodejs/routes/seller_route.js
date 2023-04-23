const express = require('express');
const sellerController = require('../controllers/seller_controller');
const authMiddleware = require('../middlewares/auth_middleware');

const router = express.Router();

router.post('/initialDocument', authMiddleware.verifyToken, sellerController.initialDocument);
router.post('/addGame', authMiddleware.verifyToken, sellerController.addGame);
router.patch('/addPaymentMethod', authMiddleware.verifyToken, sellerController.addPaymentMethod);
router.get('/readSellerData/:shopName', authMiddleware.verifyToken, sellerController.readSellerData);
router.get('/readGameData/:shopName/:gameName', authMiddleware.verifyToken, sellerController.readGameData);
router.post('/toggleAllItems', authMiddleware.verifyToken, sellerController.toggleAllItems);

module.exports = router;
