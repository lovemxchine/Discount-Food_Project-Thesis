const express = require("express");

module.exports = (db, express) => {
  const router = express.Router();
  router.get("/mainScreen/:uid", async (req, res) => {
    const shopUid = req.params.uid;
    const shop = await db
      .collection("shop")
      .doc(shopUid)
      .collection("products")
      .get();
    const shopList = [];
    shop.forEach((doc) => {
      try {
        let data = doc.data();
        data.discountAt = data.discountAt.toDate();
        data.expiredDate = data.expiredDate.toDate();
        shopList.push(data);
      } catch (e) {
        console.log("error");
      }
    });
    return res.status(200).send({ status: "success", data: shopList });
  });
  return router;
};
