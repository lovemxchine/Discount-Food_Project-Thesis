const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const port = 3000;
const app = express();
const db = admin.firestore();
// console.log(db);

// Routes
const registerRoute = require("./routes/register")(db);
const shopRoute = require("./routes/shop/shop")(db);
const customerRoute = require("./routes/customer")(db);

app.use(express.json(), cors({ origin: true }));
app.use("/register", registerRoute);
app.use("/customer", customerRoute);
app.use("/shop", customerRoute);

app.post("/signIn", async (req, res) => {
  const registerShop = await db
    .collection("in_register_shop")
    .doc(req.body.checkUID)
    .get();
  if (registerShop.exists) {
    // ถ้าร้านค้าสมัครแล้ว (ยังไม่ได้ยืนยันข้อมูล) ส่งข้อมูลกลับไปให้หน้าบ้านแสดงว่ายังเข้าไม่ได้
    return res
      .status(200)
      .send({ userStatus: "registerShop", data: registerShop.data() });
  }
  const user = await db.collection("users").doc(req.body.checkUID).get();
  if (user.exists) {
    const data = user.data();
    // console.log(role === "customer");
    return res.status(200).send({
      userStatus: "success",
      role: data.role,
      data: [user.data(), req.body.checkUID],
    });
  }

  return res.status(404).send({ status: "not_found", data: null });
});

app.listen(port, () => {
  console.log("Server is running on port " + port);
});
