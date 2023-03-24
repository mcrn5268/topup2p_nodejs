const jwt = require('jsonwebtoken');
const User = require('../models/user_model');
const config = require('../config');
const RevokedToken = require('../models/revoked_token_model');

//to check if token is revoked when creating a token
//if its revoked then login/register will create a new one
const isTokenRevoked = async (token) => {
    const revokedToken = await RevokedToken.findOne({ token: token });
    return !!revokedToken;
};

exports.register = async (req, res, next) => {
    try {
        // Validate and sanitize input data
        const { user, password } = req.body;
        if (!user || !user.email || !user.name || !user.type) {
            return res.status(400).json({ message: 'Missing required fields' });
        }
        const sanitizedEmail = validator.normalizeEmail(user.email);

        // Check if user already exists
        const existingUser = await User.findOne({ email: sanitizedEmail });
        if (existingUser) {
            return res.status(400).json({ message: 'Email address already registered' });
        }

        // Create new user and generate token
        const newUser = await User.create({
            email: sanitizedEmail,
            password,
            name: user.name,
            type: user.type,
            image: user.image,
            image_url: user.image_url,
        });
        let flag = true;
        let token;
        while (flag) {
            token = jwt.sign({ userId: newUser._id }, config.jwtSecret, { expiresIn: '30d' });
            console.log('register token: ' + token);

            const isRevoked = await isTokenRevoked(token);
            if (isRevoked) {
                // Regenerate token if it was revoked
                continue;
            } else {
                flag = false;
            }
        }

        // Return new user and token
        return res.status(201).json({
            uid: newUser._id,
            token: token,
        });
    } catch (error) {
        // Handle errors
        console.log('Error register: ', error);
        if (error.name === 'ValidationError') {
            return res.status(400).json({ message: error.message });
        } else if (error.code === 11000) {
            return res.status(400).json({ message: 'Email address already registered' });
        } else {
            return res.status(500).json({ message: 'Internal Server Error' });
        }
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({ email });

        if (!user) {
            return res.status(401).json({ message: 'There is no account registered for this email' });
        }

        const isValidPassword = await user.isValidPassword(password);

        if (!isValidPassword) {
            return res.status(401).json({ message: 'Wrong password' });
        }

        let flag = true;
        let token;
        while (flag) {
            token = jwt.sign({ userId: user._id }, config.jwtSecret, { expiresIn: '30d' });
            console.log('login token: ' + token);

            const isRevoked = await isTokenRevoked(token);
            if (isRevoked) {
                // Regenerate token if it was revoked
                continue;
            } else {
                flag = false;
            }
        }

        return res.status(200).json({
            uid: user._id, token
        });
    } catch (e) {
        console.log("Error login: ", e);
        res.status(500).json({ message: "Internal Server Error" });
    }
};
exports.logout = async (req, res, next) => {
    try {//revoking token
        const token = req.headers.authorization.split(' ')[1];
        const revokedToken = await RevokedToken.create({ token });
        // const revokedToken = new RevokedToken({ token });
        // await revokedToken.save();
        res.status(200).json({ message: 'Token revoked' });

    } catch (e) {
        console.log("Error logout: ", e);
        res.status(500).json({ message: "Internal Server Error" });
    }

};


exports.check_jwt_token = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Authentication required' });
    }

    try {
        const decoded = jwt.verify(token, config.jwtSecret);
        req.user = decoded;
        next();
    } catch (e) {
        return res.status(403).json({ message: 'Invalid token' });
    }
};