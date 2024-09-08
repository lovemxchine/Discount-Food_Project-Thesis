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

  router.post("/product/addProduct", async (req, res) => {
    try {
      // const shopUid = req.params.uid;
      const data = req.body;
      const [day, month, year] = data.expired_date.split("/");
      const formattedDate = new Date(`${year}-${month}-${day}`);

      console.log(data);
      uploadSingleImage(req, res, bucket);
      await db
        .collection("shop")
        .doc(data.uid)
        .collection("products")
        .add({
          productName: data.product_name,
          salePrice: parseInt(data.sale_price),
          originalPrice: parseInt(data.original_price),
          stock: parseInt(data.stock),
          expiredDate: formattedDate,

          // discount: data.discount,
          // discountAt: data.discountAt,
        });

      return res.status(200).send({ status: "success", data: data });
    } catch (err) {
      console.log(err.message);
    }
  });
  return router;
};
