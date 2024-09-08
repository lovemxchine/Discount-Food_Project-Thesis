const uploadSingleImage = (req, res, bucket) => {
  if (!req.file) {
    return res.status(400).send("No file uploaded.");
  }

  const file = req.file;
  const fileName = `${Date.now()}_${file.originalname}`;
  const fileUpload = bucket.file(`images/${fileName}`);
  let publicUrl;
  console.log("Attempting to upload file:", fileName);

  const blobStream = fileUpload.createWriteStream({
    metadata: {
      contentType: file.mimetype,
    },
  });

  blobStream.on("error", (error) => {
    console.error("Error uploading to Firebase:", error);
    res.status(500).send(`Error uploading file: ${error.message}`);
  });

  blobStream.on("finish", () => {
    publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileUpload.name}`;
    console.log("Uploaded success. URL", publicUrl);
    res.status(200).send({
      message: "File uploaded successfully",
      url: publicUrl,
    });
  });

  blobStream.end(file.buffer);
  return `https://storage.googleapis.com/${bucket.name}/${fileUpload.name}`;
};
module.exports = uploadSingleImage;
