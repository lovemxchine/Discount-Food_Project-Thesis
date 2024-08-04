const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
const db = admin.firestore();


app.use(
  express.json(),
  cors(  {origin: true}),

);

const port = 8080;


app.get('/api/user/customer/', (req,res)=>{
  return res.status(200).send({status: "okay"})
})

app.get('/api/user/shopkeeper/', (req,res)=>{
  return res.status(200).send({status: "okay"})
  
})

app.post("/api/register/customer", async (req, res) => {
  try {
    console.log(req.body);
    console.log(req.body);
    await db
      .collection("users")
      .doc("/" + req.body.uid + "/")
      .create({
        uid: req.body.uid,
        fname: req.body.name,
        lname: req.body.surname,
        email: req.body.email,
        birthday: req.body.birthday,
        tel: req.body.tel,
        role:"customer",
      });

    return res.status(200).send({ status: "success", message: "data saved" });
  } catch (error) {
    console.log(error.message);
    return res.status(500).send({ status: "failed" });
  }
});



app.listen(port, () => {
  console.log("Server is running on port " + port);
});