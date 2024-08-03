const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
const db = admin.firestore();


const port = 8080;
app.listen(port, () => {
  console.log("Server is running on port " + port);
});

app.get('/api/customer/', (req,res)=>{
  return res.status(200).send({status: "okay"})
})

app.get('/api/shopkeeper/', (req,res)=>{
  return res.status(200).send({status: "okay"})
})





app.use(
  express.json(),
  cors({ credentials: true, origin: ["http://localhost:3000"] })
);
