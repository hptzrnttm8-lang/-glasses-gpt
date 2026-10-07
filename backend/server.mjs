import "dotenv/config";
import express from "express";
import OpenAI from "openai";

const app = express();
app.use(express.json({ limit: "100kb" }));

const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

app.post("/ask", async (req, res) => {
  try {
    const text = typeof req.body?.text === "string" ? req.body.text.trim() : "";
    if (!text) {
      return res.status(400).json({ error: "Missing text" });
    }

    const response = await client.responses.create({
      model: "gpt-5.6-terra",
      reasoning: { effort: "low" },
      instructions:
        "You are a voice assistant speaking through smart glasses. " +
        "Answer in the user's language. Keep answers concise unless the user asks for detail. " +
        "Avoid markdown because the answer will be spoken aloud.",
      input: text
    });

    res.json({
      text: response.output_text ?? "",
      response_id: response.id
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "OpenAI request failed" });
  }
});

const port = Number(process.env.PORT || 8787);
app.listen(port, () => {
  console.log(`Ray-Ban ChatGPT backend listening on :${port}`);
});
