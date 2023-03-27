const User = require('../models/user_model');

exports.read = async (req, res, next) => {
    try {
        const userId = req.params.uid;
        const user = await User.findById(userId).select('email name type image image_url');

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.status(200).json({ ...user['_doc'] });
    } catch (e) {
        next(e);
    }
};

//todo
//make this reusable
exports.update = async (req, res, next) => {
    const { data, uid } = req.body;

    try {
        const updatedUser = await User.findOneAndUpdate(
            { _id: uid },
            { $set: data },
            { new: true }
        );

        if (!updatedUser) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json(updatedUser);
    } catch (e) {
        next(e);
    }
};


exports.initialDocument = async (req, res, next) => {
    const { name } = req.body;
    try {

    } catch (e) {
        next(e);
    }
};