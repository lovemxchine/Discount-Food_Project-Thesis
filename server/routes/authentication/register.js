// const express = require("express");

module.exports = (db, express) => {
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
          fname: req.body.fname,
          lname: req.body.lname,
          email: req.body.email,
          birthday: birthdayDate,
          tel: req.body.tel,
          role: "customer",
        });

      return res.status(200).send({ status: "success", message: "data saved" });
    } catch (error) {
      console.log(error.message);
      console.log("error");
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
          nationality: data.nationality,
          email: data.email,
          tel: data.tel,
          role: "shopkeeper",

          // shop img url
          imgUrl: {
            shopCoverImg: data.imgUrl.shopCoverImg,
            shopImg: data.imgUrl.shopImg,
            certificateImg: data.imgUrl.certificateImg,
          },
          // shop location from user input
          shopLocation_th: {
            province: data.shopLocation.province,
            district: data.shopLocation.district,
            subdistrict: data.shopLocation.subdistrict,
            postcode: data.shopLocation.postcode,
          },
          // shop location from google map api
          googleLocation: {
            lat: data.googleLocation.lat,
            lng: data.googleLocation.lng,
            formatted_address: data.googleLocation.formatted_address,
            place_name: data.googleLocation.place_name,
          },
          // shopkeeper location from user input
          shopkeeperLocation: {
            province: data.shopkeeperLocation.province,
            district: data.shopkeeperLocation.district,
            subdistrict: data.shopkeeperLocation.subdistrict,
            postcode: data.shopkeeperLocation.postcode,
          },
        });

      return res.status(200).send({ status: "success", message: "data saved" });
    } catch (error) {
      console.log(error.message);
      return res.status(500).send({ status: "failed" });
    }
  });

  return router;
};
