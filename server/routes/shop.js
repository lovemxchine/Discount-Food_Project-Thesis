const express = require("express");
const uploadSingleImage = require("../controller/image_controller"); // Adjust the path as necessary
const { Timestamp } = require("firebase-admin/firestore");

module.exports = (db, express, bucket, upload) => {
  const router = express.Router();

  // Get all products
  router.get("/:uid/getAllProduct/", async (req, res) => {
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
        // data.discountAt = data.discountAt.toDate();
        data.expiredDate = data.expiredDate.toDate();
        shopList.push(data);
      } catch (e) {
        console.log("error");
      }
    });
    return res.status(200).send({ status: "success", data: shopList });
  });

  // Add Product
  router.post(
    "/:uid/product/addProduct",
    upload.single("image"),
    async (req, res) => {
      try {
        const shopUid = req.params.uid;
        const imageUrl = await uploadSingleImage(req, bucket);
        // const shopUid = req.params.uid;
        const data = req.body;
        const [day, month, year] = data.expired_date.split("/");
        const formattedDate = new Date(`${year}-${month}-${day}`);

        console.log(data);

        const doc = await db
          .collection("shop")
          .doc(shopUid)
          .collection("products")
          .add({
            productName: data.product_name,
            salePrice: parseInt(data.sale_price),
            originalPrice: parseInt(data.original_price),
            stock: parseInt(data.stock),
            expiredDate: formattedDate,
            imageUrl: imageUrl,
            discountAt: Timestamp.now(),
            showStatus: true,

            // discountAt: data.discountAt,
          });
        await doc.update({ productId: doc.id });

        return res.status(200).send({ status: "success", data: data });
      } catch (err) {
        console.log(err.message);
      }
    }
  );
  // Delete Product
  router.delete("/:uid/product/:prodId", async (req, res) => {
    try {
      const prodId = req.params.prodId;
      const shopUid = req.params.uid;
      const data = req.body;
      // const decodedPath = decodeURIComponent(
      //   data.imageUrl.split("/o/")[1].split("?")[0]
      // );
      // await bucket.file(decodedPath).delete();
      console.log(prodId);
      console.log(data);
      await db
        .collection("shop")
        .doc(shopUid)
        .collection("products")
        .doc(prodId)
        .delete();

      return res.status(200).send({ status: "delete success", data: data });
    } catch (err) {
      console.log(err.message);
    }
  });

  // Update Product
  router.patch("/:uid/product/:prodId", async (req, res) => {
    try {
      const { uid, prodId } = req.params;
      const data = req.body;
      console.log(uid, prodId);
      console.log(data);
      // Update Status and Expired Date
      if (data.allow) {
        const [day, month, year] = data.expired_date.split("/");
        const formattedDate = new Date(`${year}-${month}-${day}`);
        await db
          .collection("shop")
          .doc(uid)
          .collection("products")
          .doc(prodId)
          .update({
            expiredDate: formattedDate,
            stock: data.updateStock,
            showStatus: data.showStatus,
            discountAt: Timestamp.now(),
          });
      }
      // Update Stock
      if (data.allow === false) {
        console.log("false");
        console.log(data.updateStock);
        await db
          .collection("shop")
          .doc(uid)
          .collection("products")
          .doc(prodId)
          .update({
            stock: data.updateStock,
          });
      }
      return res.status(200).send({ status: "success", data: req.body });
    } catch (err) {
      console.log(err.message);
      return res.status(400).send({ status: "error" });
    }
  });

  return router;
};
