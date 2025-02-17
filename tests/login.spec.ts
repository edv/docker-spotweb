import { test } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto(
    'http://localhost:8080/?page=login&data[htmlheaderssent]=true'
  );
});

test.describe('Login', () => {
  test('should allow me to login with admin/spotweb', async ({ page }) => {
    await page.fill('input[name="loginform[username]"]', 'admin');
    await page.fill('input[name="loginform[password]"]', 'spotweb');
    await page.click('input[name="loginform[submitlogin]"]');

    // Wait for the specific JSON result
    const expectedJsonResult =
      '{"result":"success","data":[],"info":[],"warnings":[],"errors":[]}';
    await page.waitForFunction(
      (expectedJsonResult) =>
        document.body.innerText.includes(expectedJsonResult),
      expectedJsonResult
    );
  });
});
