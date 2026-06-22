// Full-page desktop screenshot of the homepage.
// Scrolls the whole page first so every loading="lazy" image / lite-youtube
// poster passes through the viewport and actually loads, waits for all images
// to finish, then captures fullPage.
const puppeteer = require("puppeteer-core");

const URL = process.env.SHOT_URL || "https://enderfga.cn";
const OUT = process.env.SHOT_OUT || "homepage.png";
const EXE = process.env.CHROME_PATH; // required: path to a Chrome/Chromium binary
const SETTLE = Number(process.env.SHOT_SETTLE_MS || 10000);

(async () => {
  const browser = await puppeteer.launch({
    executablePath: EXE,
    headless: "new",
    args: ["--no-sandbox", "--disable-gpu", "--disable-dev-shm-usage", "--hide-scrollbars"],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1280, height: 900, deviceScaleFactor: 2 });
  await page.goto(URL, { waitUntil: "networkidle2", timeout: 120000 });

  // Scroll to the bottom until the position stabilizes, so every lazy element
  // (which only loads when it enters the viewport) gets triggered.
  await page.evaluate(async () => {
    await new Promise((resolve) => {
      let last = -1;
      let stable = 0;
      const timer = setInterval(() => {
        window.scrollBy(0, 700);
        const y = window.scrollY;
        if (y === last) {
          if (++stable >= 4) {
            clearInterval(timer);
            resolve();
          }
        } else {
          stable = 0;
          last = y;
        }
      }, 250);
    });
  });

  // Wait for every <img> to finish loading (or error out).
  await page.evaluate(async () => {
    await Promise.all(
      Array.from(document.images).map((img) =>
        img.complete
          ? Promise.resolve()
          : new Promise((r) => {
              img.addEventListener("load", r);
              img.addEventListener("error", r);
            })
      )
    );
  });

  await page.evaluate(() => window.scrollTo(0, 0));

  // Hide the back-to-top button (it becomes visible after scrolling).
  await page.addStyleTag({ content: ".to-top{display:none!important}" });

  // Extra settle time for background-image posters (lite-youtube) and the
  // async star / HF / npm / views badges that are fetched and revealed by JS.
  await new Promise((r) => setTimeout(r, SETTLE));

  await page.screenshot({ path: OUT, fullPage: true });
  await browser.close();
  console.log("saved", OUT);
})();
