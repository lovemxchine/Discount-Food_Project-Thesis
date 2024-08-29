const express = require("express");

module.exports = (db) => {
  const router = express.Router();

  router.post("/customer", async (req, res) => {
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

  router.post("/registerShop", async (req, res) => {
    const data = req.body;
    console.log("test");
    try {
      await db
        .collection("in_register_shop")
        .doc("/" + data.temporaryUID + "/")
        .create({
          uid: data.temporaryUID,
          name: data.name,
          surname: data.surname,
          shopLocation: {
            province: data.shopLocation.province,
            district: data.shopLocation.district,
            subdistrict: data.shopLocation.subdistrict,
            postcode: data.shopLocation.postcode,
          },
          nationality: data.nationality,
          place: data.place,
          email: data.email,
          tel: data.tel,
          role: "shopkeeper",
        });

      return res.status(200).send({ status: "success", message: "data saved" });
    } catch (error) {
      console.log(error.message);
      return res.status(500).send({ status: "failed" });
    }
  });

  return router;
};
