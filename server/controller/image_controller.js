const uploadSingleImage = async (req, bucket) => {
  if (!req.file) {
    throw new Error("No file uploaded.");
  }

  const file = req.file;
  const fileName = `${Date.now()}_${file.originalname}`;
  const fileUpload = bucket.file(`images/${fileName}`);

  console.log("Attempting to upload file:", fileName);

  // Upload the image to Firebase Storage
  await fileUpload.save(file.buffer, {
    metadata: {
      contentType: file.mimetype, // Set the content type based on the file's mimetype
    },
  });

  // Firebase Storage URL format: firebase-storage.googleapis.com/v0/b/<bucket-name>/o/<encoded-file-path>?alt=media
  const firebaseStorageUrl = `https://firebasestorage.googleapis.com/v0/b/${
    bucket.name
  }/o/${encodeURIComponent(`images/${fileName}`)}?alt=media`;

  return firebaseStorageUrl;
};

module.exports = uploadSingleImage;
