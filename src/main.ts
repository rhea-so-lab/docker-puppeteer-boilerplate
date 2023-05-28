import puppeteer from "puppeteer";

async function main() {
  const browser = await puppeteer.launch({
    executablePath:
      process.env.HOST === "docker" ? "/usr/bin/chromium-browser" : undefined,
    args: ["--no-sandbox", "--disable-dev-shm-usage"],
    headless: "new",
  });

  const page = await browser.newPage();

  await page.goto("https://www.google.com");

  const height = await page.evaluate(() => document.body.scrollHeight);
  await page.setViewport({ width: 800, height });
  await page.screenshot({ path: "screenshot.png", fullPage: true });

  console.log("Screenshot saved to screenshot.png");

  const html = await page.content();
  console.log(html);

  await browser.close();
}

main();
