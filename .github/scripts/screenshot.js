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
    // Default protocolTimeout is 180s. A single in-page wait (see image loop
    // below) must never be able to burn through it, but give some headroom.
    protocolTimeout: 240000,
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
      // Hard stop: if the page never stabilizes (lazy content that keeps
      // growing the height, an animated element, etc.) don't spin forever.
      setTimeout(() => {
        clearInterval(timer);
        resolve();
      }, 30000);
    });
  });

  // Wait for every <img> to finish loading (or error out), but never block on a
  // single image. An image that never enters the viewport (e.g. a loading="lazy"
  // logo on an off-screen carousel slide) fires neither load nor error, so an
  // unbounded Promise.all would hang until the CDP protocolTimeout and fail the
  // job. Cap each image's wait and move on.
  await page.evaluate(async () => {
    const PER_IMG_MS = 8000;
    await Promise.all(
      Array.from(document.images).map((img) =>
        img.complete
          ? Promise.resolve()
          : new Promise((r) => {
              const done = () => r();
              img.addEventListener("load", done);
              img.addEventListener("error", done);
              setTimeout(done, PER_IMG_MS);
            })
      )
    );
  });

  await page.evaluate(() => window.scrollTo(0, 0));

  // Force-reveal elements that app.js fades in on scroll (a one-way
  // IntersectionObserver starts .research-paper / .collaboration-item at
  // opacity:0). If the observer didn't fire for the bottom grid during the
  // scroll, those stay invisible — so set them visible explicitly.
  await page.evaluate(() => {
    document.querySelectorAll(".research-paper, .collaboration-item").forEach((el) => {
      el.style.opacity = "1";
      el.style.transform = "none";
      el.style.transition = "none";
    });
  });

  // Hide the back-to-top button (it becomes visible after scrolling).
  await page.addStyleTag({ content: ".to-top{display:none!important}" });

  // Extra settle time for background-image posters (lite-youtube) and the
  // async star / HF / npm / views badges that are fetched and revealed by JS.
  await new Promise((r) => setTimeout(r, SETTLE));

  await page.screenshot({ path: OUT, fullPage: true });
  await browser.close();
  console.log("saved", OUT);
})();
