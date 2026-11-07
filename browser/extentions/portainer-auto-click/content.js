(function () {
  const targetPattern = /#!\/\d+\/kubernetes\/applications\/.+/;
  const exactExcludedPattern = /#!\/\d+\/kubernetes\/applications$/;

  const currentUrl = window.location.href;

  if (!targetPattern.test(currentUrl) || exactExcludedPattern.test(currentUrl)) {
    return;
  }

  console.log("K8s Auto Logs Extension Triggered");

  function getElementByXPath(xpath) {
    return document.evaluate(
      xpath,
      document,
      null,
      XPathResult.FIRST_ORDERED_NODE_TYPE,
      null
    ).singleNodeValue;
  }

  function waitForElement(xpath, timeout = 15000) {
    return new Promise((resolve, reject) => {
      const startTime = Date.now();

      const interval = setInterval(() => {
        const element = getElementByXPath(xpath);
        if (element) {
          clearInterval(interval);
          resolve(element);
        } else if (Date.now() - startTime > timeout) {
          clearInterval(interval);
          reject(`Timeout waiting for ${xpath}`);
        }
      }, 500);
    });
  }

  const consoleTriggers = [
    "arina-web",
    "grafana",
    "nginx",
    "nginx",
    "nginx",
    "kube-state-metrics",
    "loki",
    "mysql",
    "postgres",
    "prom2teams",
    "prometheus",
    "promtail",
    "redis",
    "weaviate"
  ];

  function shouldOpenConsole(url) {
    return consoleTriggers.some(keyword => url.includes(keyword));
  }

  async function runAutomation() {
    try {
      const isConsole = shouldOpenConsole(currentUrl);

      // 1️⃣ Click application link
      const firstXpath = isConsole
        ? '//*[@id="view"]//table//tr//td[9]//a[contains(@href,"console")]'
        : '//*[@id="view"]//table//tr//td[9]//a[contains(@href,"logs")]';

      const firstElement = await waitForElement(firstXpath);
      firstElement.click();

      // 2️⃣ Click logs toggle
      const secondXpath =
        '//*[@id="view"]/kubernetes-application-logs-view/div/div[1]/div/rd-widget/div/rd-widget-body/div/div/form/div[2]/div/label/span';

      const secondElement = await waitForElement(secondXpath);
      secondElement.click();

      // 3️⃣ Scroll logs to bottom
      const logsXpath =
        '//*[@id="view"]/kubernetes-application-logs-view/div/div[2]/div/pre';

      const logsElement = await waitForElement(logsXpath);

      logsElement.scrollTop = logsElement.scrollHeight;

      // Also auto-scroll if content keeps updating
      const observer = new MutationObserver(() => {
        logsElement.scrollTop = logsElement.scrollHeight;
      });

      observer.observe(logsElement, {
        childList: true,
        subtree: true,
      });

    } catch (err) {
      console.error("Automation error:", err);
    }
  }

  runAutomation();
})();

