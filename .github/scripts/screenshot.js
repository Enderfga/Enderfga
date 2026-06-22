// Full-page desktop screenshot of the homepage.
// Scrolls the whole page first so every loading="lazy" image / lite-youtube
// poster passes through the viewport and actually loads, then captures fullPage.
const puppeteer = require("puppeteer-core");

const URL = process.env.SHOT_URL || "https://enderfga.cn";
const OUT = process.env.SHOT_OUT || "homepage.png";
const EXE = process.env.CHROME_PATH; // required: path to a Chrome/Chromium binary

(async () => {
  const browser = await puppeteer.launch({
    executablePath: EXE,
    headless: "new",
    args: ["--no-sandbox", "--disable-gpu", "--disable-dev-shm-usage", "--hide-scrollbars"],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1280, height: 900, deviceScaleFactor: 2 });
  await page.goto(URL, { waitUntil: "networkidle2", timeout: 90000 });

  // Scroll to the bottom in steps to trigger lazy-loaded media everywhere.
  await page.evaluate(async () => {
    await new Promise((resolve) => {
      let y = 0;
      const step = 500;
      const timer = setInterval(() => {
        window.scrollBy(0, step);
        y += step;
        if (y >= document.body.scrollHeight) {
          clearInterval(timer);
          resolve();
        }
      }, 150);
    });
  });
  await page.evaluate(() => window.scrollTo(0, 0));

  // Hide the back-to-top button (it becomes visible after scrolling).
  await page.addStyleTag({ content: ".to-top{display:none!important}" });

  // Give images a moment to finish decoding before the shot.
  await new Promise((r) => setTimeout(r, 4000));

  await page.screenshot({ path: OUT, fullPage: true });
  await browser.close();
  console.log("saved", OUT);
})();
