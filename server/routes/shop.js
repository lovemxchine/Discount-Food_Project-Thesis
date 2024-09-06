const express = require("express");
module.exports = (db) => {
  app.get("mainScreen", async (req, res) => {
    const shop = await db.collection("shop").get();
    const shopList = [];
    shop.forEach((doc) => {
      shopList.push(doc.data());
    });
    return res.status(200).send({ status: "success", data: shopList });
  });
};
