const jwt = require('jsonwebtoken');
const config = require('../config');
const RevokedToken = require('../models/revoked_token_model');

exports.verifyToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ message: 'Authentication failed: No token provided' });
  }

  const token = authHeader.split(' ')[1];
  //console.log('token: ' + token);
  try {
    const decoded = jwt.verify(token, config.jwtSecret);
    const isRevoked = await RevokedToken.findOne({ token });
    if (isRevoked) {
      return res.status(401).json({ message: 'Authentication failed: Token revoked' });
    }
    req.userId = decoded.userId;
    next();
  } catch (e) {
    return res.status(401).json({ message: 'Authentication failed: Invalid token' });
  }
};
