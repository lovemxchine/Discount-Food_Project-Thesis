const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const multer = require("multer");
const { getStorage } = require("firebase/storage");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "gs://discount-project-6dfc5.appspot.com",
});

const port = 3000;
const app = express();
const db = admin.firestore();
const bucket = admin.storage().bucket(); // Using bucket from Firebase Admin SDK
const upload = multer({ storage: multer.memoryStorage() });

// Routes
const registerRoute = require("./routes/authentication/register")(db, express);
const signInRoute = require("./routes/authentication/signIn")(db, express);
const shopRoute = require("./routes/shop")(db, express, bucket, upload);
const customerRoute = require("./routes/customer")(db, express);

app.use(express.json());
app.use(cors({ origin: true }));

app.use("/authentication", signInRoute);
app.use("/authentication", registerRoute);
app.use("/customer", customerRoute);
app.use("/shop", shopRoute);

// Dynamically import the gemini route
(async () => {
  const { default: geminiRoute } = await import(
    "./routes/gemini/geminiEndpoint.mjs"
  );
  app.use("/gemini", geminiRoute(express));
})();

// app.post("/upload", upload.single("image"), (req, res) => {
//   if (!req.file) {
//     return res.status(400).send("No file uploaded.");
//   }
// console.log(uploadSingleImage(req, res, bucket));
// });

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
