const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const multer = require("multer");
const { getStorage } = require("firebase/storage");
const cron = require("node-cron");
const guest = require("./routes/guest");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "gs://discount-project-6dfc5.appspot.com",
});

const port = 3000;
const app = express();
const db = admin.firestore();
const bucket = admin.storage().bucket(); // Using bucket from Firebase Admin SDK
const upload = multer({ storage: multer.memoryStorage() });

// Routes
const registerRoute = require("./routes/authentication/register")(db, express);
const signInRoute = require("./routes/authentication/signIn")(db, express);
const shopRoute = require("./routes/shop")(db, express, bucket, upload);
const customerRoute = require("./routes/customer")(db, express);
const guestRoute = require("./routes/guest")(db, express);

app.use(express.json());
app.use(cors({ origin: true }));

// TODO : add middleware to each endpoint/route for authentication (role)

app.use("/authentication", signInRoute);
app.use("/authentication", registerRoute);
app.use("/customer", customerRoute);
app.use("/shop", shopRoute);
app.use("/guest", guestRoute);

// Dynamically import the gemini route
(async () => {
  const { default: geminiRoute } = await import(
    "./routes/gemini/geminiEndpoint.mjs"
  );
  app.use("/gemini", geminiRoute(express));
})();

// Cron job to update showStatus

cron.schedule("12 21 * * *", async () => {
  console.log("เช็คสินค้าที่มีส่วนลดเกิน 2 วันแล้ว");

  try {
    // Retrieve all documents in the 'shop' collection
    const shopsSnapshot = await db.collection("shop").get();
    const currentTime = admin.firestore.Timestamp.now();

    for (const shopDoc of shopsSnapshot.docs) {
      const shopId = shopDoc.id;

      const productsSnapshot = await db
        .collection("shop")
        .doc(shopId)
        .collection("products")
        .get();

      for (const productDoc of productsSnapshot.docs) {
        const productData = productDoc.data();
        const productTimestamp = productData.discountAt;

        if (productTimestamp) {
          const daysDifference =
            currentTime.toDate() - productTimestamp.toDate();
          const daysPassed = daysDifference / (1000 * 60 * 60 * 24);

          if (daysPassed > 2) {
            await productDoc.ref.update({ showStatus: false });
            console.log(
              `อัพเดต showStatus เป็น false รหัสสินค้า (productID): ${productDoc.id} รหัสร้านค้า (shopID): ${shopId}`
            );
          }
        }
      }
    }
  } catch (error) {
    console.error("Error updating showStatus: ", error);
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
