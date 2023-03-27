const Seller = require('../models/seller_model');

exports.readSellerData = async (req, res, next) => {
    try {
        const name = req.params.name;
        const data = await Seller.findOne({ name });
        if (!data) {
            return res.status(404).json({ message: 'There is no document for this shop' });
        }
        return res.status(200).json( data );
    } catch (e) {
        console.log('readSellerData: ' + e);
        next(e);
    }
};

exports.initialDocument = async (req, res, next) => {
    const { name } = req.body;
    try {
        console.log('try initialDocument: ' + name);
        await Seller.create({ name: name });

        return res.status(200).json({
            message: 'Success'
        });
    } catch (e) {
        console.log('initialDocument: ' + e);
        next(e);
    }
};

exports.addGame = async (req, res, next) => {
    const { sellerName, gameName } = req.body;

    try {
        // Find the Seller document with the specified name
        const seller = await Seller.findOne({ name: sellerName });

        // If the Seller is not found, return a 404 Not Found error
        if (!seller) {
            return res.status(404).json({
                message: 'Seller not found'
            });
        }

        // Add the new game to the seller's games array
        seller.games.push({ game_name: gameName });

        // Save the updated Seller document
        await seller.save();

        return res.status(200).json({
            message: 'Game added successfully'
        });
    } catch (e) {
        next(e);
    }
};
exports.addPaymentMethod = async (req, res, next) => {
    const { sellerName, paymentMethods } = req.body;

    try {
        // Find the Seller document with the specified name
        const seller = await Seller.findOne({ name: sellerName });

        // If the Seller is not found, return a 404 Not Found error
        if (!seller) {
            return res.status(404).json({
                message: 'Seller not found'
            });
        }

        // Loop through each payment method in the paymentMethods Map
        for (const [key, value] of Object.entries(paymentMethods)) {
            const { name, account_name, account_number, status } = value;
            
            // Check if the payment method with the specified name already exists in the Mop field
            const existingPayment = seller.MoP.get(name);

            // If the payment method already exists, update its values
            if (existingPayment) {
                existingPayment.account_name = account_name;
                existingPayment.account_number = account_number;
                existingPayment.status = status;
            } else {
                // If the payment method doesn't exist, create a new payment method object and add it to the Mop field
                const newPayment = {
                    account_name: account_name,
                    account_number: account_number,
                    payment_name: name,
                    status: status
                };
                seller.MoP.set(name, newPayment);
            }
        }

        // Save the updated Seller document
        await seller.save();

        return res.status(200).json({
            message: 'Payment methods added/updated successfully'
        });
    } catch (e) {
        next(e);
    }
};
