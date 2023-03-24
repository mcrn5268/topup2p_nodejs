module.exports = {
    port: process.env.PORT || 3000,
    jwtSecret: 'mysecretkey',
    db: {
      //url: 'mongodb://127.0.0.1:27017/topup2p'
      url: 'mongodb+srv://topup2pAdmin:ua7UbqDIkiwiKBWO@topup2p.erobldz.mongodb.net/topup2p?retryWrites=true&w=majority'
    }
  };
  