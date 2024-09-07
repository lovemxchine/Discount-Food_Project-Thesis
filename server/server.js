const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://project-2-6b3c1.firebaseio.com",
  storageBucket: "project-2-6b3c1.appspot.com",
});

const port = 3000;
const app = express();
const db = admin.firestore();
const bucket = admin.storage().bucket();
const multer = require("multer");

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// Routes
const registerRoute = require("./routes/authentication/register")(db, express);
const signInRoute = require("./routes/authentication/signIn")(db, express);
const shopRoute = require("./routes/shop")(db, express);
const customerRoute = require("./routes/customer")(db, express);

app.use(express.json(), cors({ origin: true }));

app.use("/authentication", signInRoute);
app.use("/authentication", registerRoute);
app.use("/customer", customerRoute);
app.use("/shop", shopRoute);

app.post("/upload", upload.single("file"), async (req, res) => {
  if (!req.file) {
    return res.status(400).send("No files were uploaded.");
  }
  const metadata = {
    metadata: {
      firebaseStorageDownloadTokens: req.file.originalname,
    },
    contentType: req.file.mimetype,
    cacheControl: "public, max-age=31536000",
  };
  const bucket = admin.storage().bucket();
  const blob = bucket.file(req.file.originalname);
  const blobStream = blob.createWriteStream({ metadata });
  blobStream.on("error", (err) => {
    console.error(err);
    return res.status(500).send({ status: "failed", message: err.message });
  });

  blobStream.on("finish", () => {
    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;
    return res.status(200).send({ status: "success", url: publicUrl });
  });

  blobStream.end(req.file.buffer);
});

app.listen(port, () => {
  console.log("Server is running on port " + port);
});
