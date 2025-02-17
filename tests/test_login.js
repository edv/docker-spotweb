const { Builder, By, until } = require('selenium-webdriver');

/*
 * This test will login to the Spotweb login page and check if the JSON result is as expected.
 */
(async function testLogin() {
  const driver = await new Builder().forBrowser('chrome').build();
  try {
    await driver.get(
      'http://localhost:8080/?page=login&data[htmlheaderssent]=true'
    );

    const usernameField = await driver.findElement(
      By.name('loginform[username]')
    );
    await usernameField.sendKeys('admin');

    const passwordField = await driver.findElement(
      By.name('loginform[password]')
    );
    await passwordField.sendKeys('spotweb');

    const submitButton = await driver.findElement(
      By.name('loginform[submitlogin]')
    );
    await submitButton.click();

    // Wait for the specific JSON result
    const expectedJsonResult =
      '{"result":"success","data":[],"info":[],"warnings":[],"errors":[]}';
    await driver.wait(async () => {
      const result = await driver.executeScript(
        'return document.body.innerText'
      );
      return result.includes(expectedJsonResult);
    }, 10000);
  } finally {
    await driver.quit();
  }
})();
