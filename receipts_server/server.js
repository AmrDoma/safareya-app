const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');

function loadConfig() {
  const rawdata = fs.readFileSync('../config.json');
  const config = JSON.parse(rawdata);
  return config;
}

const config = loadConfig();
const backendUrl = config.backendUrl;
const port = config.port;
const databaseUrl = config.databaseUrl;

console.log(`Backend URL: ${backendUrl}`);
console.log(`Port: ${port}`);
console.log(`Database URL: ${databaseUrl}`);

const app = express();

mongoose.connect(databaseUrl, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('Connected to MongoDB');
}).catch((error) => {
  console.error('Error connecting to MongoDB', error);
});

const receiptSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  totalAmount: { type: Double, required: true },
  items: [{
    name: { type: String, required: true },
    amount: { type: Double, required: true },
  }],
  date: { type: Date, required: true },
});

const Receipt = mongoose.model('Receipt', receiptSchema);

app.use(bodyParser.json());
app.use(cors());


app.post('/receipts', async (req, res) => {
  try {
    const { title, description, items, date } = req.body;
    console.log("start");

    // Validate the request body
    if (!title || !description || !Array.isArray(items) || items.length === 0 || !date) {
      console.log("Invalid receipt data");
      return res.status(400).send({ error: 'Invalid receipt data' });
    }

    // Validate and convert timestamp to Date object
    const dateObj = new Date(parseInt(date));
    console.log(dateObj);
    if (isNaN(dateObj.getTime())) {
      return res.status(400).send({ error: 'Invalid date format' });
    }

    // Calculate total amount
    const totalAmount = items.reduce((sum, item) => sum + item.amount, 0);

    const receipt = new Receipt({ title, description, totalAmount, items, date: dateObj });
    await receipt.save();
    res.status(201).send(receipt);
  } catch (error) {
    console.error(error);
    console.log(error);
    res.status(500).send({ error: 'Internal Server Error' });
  }
});

app.get('/receipts', async (req, res) => {
  try {
    const { date, category, paymentMethod } = req.query;
    const filter = {};

    if (date) filter.date = new Date(date);
    if (category) filter.category = category;
    if (paymentMethod) filter.paymentMethod = paymentMethod;

    const receipts = await Receipt.find(filter);
    res.send(receipts);
  } catch (error) {
    res.status(500).send(error);
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});