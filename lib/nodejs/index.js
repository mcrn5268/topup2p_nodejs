const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const config = require('./config');
const authRoutes = require('./routes/auth_route');
const userRoutes = require('./routes/user_route');
const favsRoutes = require('./routes/user_favs_route');
const sellerRoutes = require('./routes/seller_route');
const chatRoutes = require('./routes/chat_route');
const streamRoutes = require('./routes/stream_route');
const app = express();
const http = require('http');
const server = http.createServer(app);
const io = require('socket.io')(server);

app.use(bodyParser.json());

mongoose.connect(config.db.url, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to database');
  })
  .catch((error) => {
    console.log(error);
  });

  const collection = mongoose.connection.db.collection('last_message');

  io.on('connection', (socket) => {
    let intervalId = null;
  
    socket.on('startListening', (uid) => {
      console.log('Starting listening for UID:', uid);
      if (uid) {
        intervalId = setInterval(() => {
          collection.find({ 'uid': uid }).toArray((err, docs) => {
            if (err) {
              console.log(err);
            } else {
              socket.emit('data', docs);
            }
          });
        }, 1000);
      }
    });
  
    socket.on('stopListening', () => {
      clearInterval(intervalId);
    });
  });

  
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/favs', favsRoutes);
app.use('/seller', sellerRoutes);
app.use('/chat', chatRoutes);
//app.use('/stream', streamRoutes);

app.use((error, req, res, next) => {
  console.log(error);
  return res.status(500).json({ message: 'An error occurred' });
});

app.listen(config.port, () => {
  console.log(`Server listening on port ${config.port}`);
});
