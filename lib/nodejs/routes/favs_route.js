const express = require('express');
const favsController = require('../controllers/favs_controller');
const authMiddleware = require('../middlewares/auth_middleware');

const router = express.Router();

router.patch('/toggle', authMiddleware.verifyToken, favsController.toggle);
router.get('/readFavs/:uid', authMiddleware.verifyToken, favsController.readFavs);

module.exports = router;
