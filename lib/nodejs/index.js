const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const config = require('./config');
const authRoutes = require('./routes/auth_route');
const userRoutes = require('./routes/user_route');
const favsRoutes = require('./routes/favs_route');

const app = express();

app.use(bodyParser.json());

mongoose.connect(config.db.url, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to database');
  })
  .catch((error) => {
    console.log(error);
  });

app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/favs', favsRoutes);

app.use((error, req, res, next) => {
  console.log(error);
  return res.status(500).json({ message: 'An error occurred' });
});

app.listen(config.port, () => {
  console.log(`Server listening on port ${config.port}`);
});
