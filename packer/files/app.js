// Application that queries and displays records from MongoDB
const express = require('express');
const mongoose = require('mongoose');
const app = express();

// Database connection string
// The plaintext password is for demonstration purposes only.
const mongoURI = 'mongodb://user_mydb:pass.123@mongodb.lab.test:27017/mydb';

const dbOptions = {
    useNewUrlParser: true,
    useUnifiedTopology: true
};

let dbConnectionStatus = 'Not connected';

async function connectToDatabase() {
    try {
        await mongoose.connect(mongoURI, dbOptions);
        dbConnectionStatus = 'MongoDB connected successfully';
        console.log(dbConnectionStatus);

        const messagesSchema = new mongoose.Schema({
            msg: String,
            date: Date
        });

        const Messages = mongoose.model('messages', messagesSchema);

        // Query and display records from the Database collection
        app.get('/', async (req, res) => {
            try {
                const data = await Messages.find({}).exec();
                console.log(data);
                res.json(data); // Send fetched documents as JSON response
            } catch (err) {
                console.error(err);
                res.status(500).send('Error fetching documents');
            }
        });

    } catch (err) {
        dbConnectionStatus = `MongoDB connection error: ${err.message}`;
        console.error(dbConnectionStatus);
    }
}

connectToDatabase();

// Displays DB status and Host name
app.get('/db-status', (req, res) => {
    const hostname = req.hostname;
    const statusWithHostname = `Database status: ${dbConnectionStatus} | Hostname: ${hostname}`;
    res.send(statusWithHostname);
});

// Start the server using port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});