const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
const db = admin.firestore();

app.use(express.json(), cors({ origin: true }));

const port = 8080;

app.get("/api/user/customer/", (req, res) => {
  return res.status(200).send({ status: "okay" });
});

app.get("/api/user/shopkeeper/", (req, res) => {
  return res.status(200).send({ status: "okay" });
});
app.post("/api/signIn", async (req, res) => {
  const registerShop = await db
    .collection("register_shop")
    .doc(req.body.checkUID)
    .get();
  if (registerShop.exists) {
    return res
      .status(200)
      .send({ userStatus: "registerShop", data: registerShop.data() });
  }
  const user = await db.collection("users").doc(req.body.checkUID).get();
  if (user.exists) {
    const data = user.data();
    // console.log(role === "customer");
    return res
      .status(200)
      .send({ userStatus: "success", role: data.role, data: data });
    // if (role === "customer") {
    //   return res
    //     .status(200)
    //     .send({ userStatus: "success", role: role, data: user.data() });
    // } else if (role === "shopkeeper") {
    //   return res
    //     .status(200)
    //     .send({ userStatus: "success", role: role, data: user.data() });
    // }
  }

  return res.status(404).send({ status: "not_found", data: null });
});

app.post("/api/register/customer", async (req, res) => {
  try {
    console.log(req.body);

    const [day, month, year] = req.body.birthday.split("/");
    const birthdayDate = new Date(`${year}-${month}-${day}`);

    await db
      .collection("users")
      .doc("/" + req.body.uid + "/")
      .create({
        uid: req.body.uid,
        fname: req.body.name,
        lname: req.body.surname,
        email: req.body.email,
        birthday: birthdayDate,
        tel: req.body.tel,
        role: "customer",
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
