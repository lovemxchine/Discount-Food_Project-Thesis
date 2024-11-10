import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from "dotenv";

const result = dotenv.config();
if (result.error) {
  console.error("Error loading .env file:", result.error);
} else {
  console.log(".env file loaded successfully");
}

const API_KEY = process.env.GEMINI_API_KEY;
// console.log("API_KEY" + API_KEY);

// โมเดล
const MODEL_NAME = "gemini-1.5-flash-latest";

const genAI = new GoogleGenerativeAI(API_KEY);

export async function analyzeImage(imageBuffer) {
  const model = genAI.getGenerativeModel({ model: MODEL_NAME });

  // ส่งรูปไปโมเดล
  const imageParts = [
    {
      inlineData: {
        data: imageBuffer.toString("base64"),
        mimeType: "image/jpeg",
      },
    },
  ];

  // คำถามที่จะถามเกี่ยวกับรูปภาพ
  const prompt = `สกัดคำรูปภาพนี้และระบุข้อมูลต่อไปนี้:
1. ชื่อสินค้า
2. ราคาเดิม (ถ้ามี)
3. ราคาใหม่
4. วันที่หมดอายุ (ถ้ามี) if
**Important ! Buddhist Era change to BC DD/MM/YYYY **

กรุณาตอบในรูปแบบ JSON ดังนี้:
{
  "product_name": "ชื่อสินค้า",
  "old_price": "ราคาเดิม (หรือ null ถ้าไม่มี)",
  "new_price": "ราคาใหม่",
  "expiry_date": "วันที่หมดอายุ (หรือ null ถ้าไม่มี)"
}

หมายเหตุ:
- ลองวิเคราะห์ว่าคำไหนเป็นชื่ออาหาร
- ชื่อสินค้าในป้ายบางอันอาจจะมีผสมชื่อแบรนด์
- ใช้ภาษาไทยสำหรับชื่อสินค้า
- ใช้ตัวเลขสำหรับราคา (ไม่ต้องมีสัญลักษณ์สกุลเงิน)
- ใช้รูปแบบ YYYY/MM/DD สำหรับวันที่
- ตอบเฉพาะ JSON เท่านั้น ไม่ต้องมีข้อความอื่นๆ`;

  try {
    const result = await model.generateContent([prompt, ...imageParts]);
    const response = await result.response;
    const text = response.text();
    return JSON.parse(text);
  } catch (error) {
    console.error("Error in analyzeImage:", error);
    throw error;
  }
}
