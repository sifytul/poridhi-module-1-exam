import cookieParser from "cookie-parser";
import cors from "cors";
import "dotenv/config";
import express from "express";
import helmet from "helmet";
import mysql from "mysql2/promise"; // Changed from mongoose
import path from "path";
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// middleware in use
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(cookieParser());
app.use(helmet());
app.use(express.static(path.join(__dirname, 'public')));

// MySQL Connection
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Make pool available in app
app.locals.db = pool;

// Test connection on startup
pool.getConnection()
  .then(connection => {
    console.log("DB connected");
    connection.release();
    
    app.listen(process.env.PORT || 7000, () => {
      console.log(`Server is listening on PORT:${process.env.PORT || 7000}`);
    });
  })
  .catch(err => {
    console.error("Database connection failed:", err);
    process.exit(1);
  });

// route is use
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get("/health", (req, res) => {
  res.status(200).json({message: "Everything is allright"});
});

app.get("/users", async (req, res) => {
  try {
    // Get connection from pool
    const connection = await req.app.locals.db.getConnection();
    
    // Execute query
    const [rows] = await connection.query("SELECT * FROM users");
    connection.release(); // Always release connection!

    res.status(200).json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch users",
      error: error.message
    });
  }
});

export default app;
