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

// Routes
const registerRoute = require("./routes/authentication/register")(db, express);
const signInRoute = require("./routes/authentication/signIn")(db, express);
const shopRoute = require("./routes/shop")(db, express);
const customerRoute = require("./routes/customer")(db, express);

app.use(express.json(), cors({ origin: true }));

app.use("/authentication", signInRoute);
app.use("/authentication", registerRoute);
app.use("/customer", customerRoute);
app.use("/shop", shopRoute);

app.listen(port, () => {
  console.log("Server is running on port " + port);
});
