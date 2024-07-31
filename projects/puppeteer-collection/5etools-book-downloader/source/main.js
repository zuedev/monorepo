import puppeteer from "puppeteer";
import { resolve } from "path";
import { rmSync } from "fs";
import { setTimeout } from "node:timers/promises";

// launch the browser and open a new blank page
const browser = await puppeteer.launch();
const page = await browser.newPage();

// set the download path
const client = await page.createCDPSession();
await client.send("Page.setDownloadBehavior", {
  behavior: "allow",
  downloadPath: resolve("./downloads"),
});

// navigate the page to a URL (using mirror as the original site uses cf protection)
await page.goto("https://5etools-mirror-2.github.io/books.html");

// set screen size
await page.setViewport({ width: 1920, height: 1080 });

// wait for the page to load
await page.waitForSelector(
  "#listcontainer > div.list.list--stats.books > div > a > span.w-100.ve-flex > span.ve-col-8-5.bold"
);

// get all book names and links
const bookNames = await page.evaluate(() => {
  const bookNames = [];
  document
    .querySelectorAll(
      "#listcontainer > div.list.list--stats.books > div > a > span.w-100.ve-flex > span.ve-col-8-5.bold"
    )
    .forEach((book) => {
      bookNames.push({
        name: book.innerText,
        link: book.parentElement.parentElement.href,
      });
    });
  return bookNames;
});

// clear the downloads folder
rmSync(resolve("./downloads"), { recursive: true, force: true });

// loop through all books
// go to the book page, wait for the page to load, click the download button
for (const book of bookNames) {
  await page.goto(book.link);

  await setTimeout(1000);

  await page.waitForSelector(
    "#pagecontent > tr:nth-child(2) > td > div > div.no-print.ve-flex-v-center.btn-group > button:nth-child(3)"
  );
  await page.click(
    "#pagecontent > tr:nth-child(2) > td > div > div.no-print.ve-flex-v-center.btn-group > button:nth-child(3)"
  );
  await page.waitForSelector(
    "body > div.ve-flex-col.ui-ctx__wrp.py-2.absolute > div:nth-child(2) > div"
  );
  await page.click(
    "body > div.ve-flex-col.ui-ctx__wrp.py-2.absolute > div:nth-child(2) > div"
  );

  console.log(`Downloading ${book.name}`);
}

console.log("All books downloaded");

// close the browser
await browser.close();
