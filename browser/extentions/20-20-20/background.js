const messages = [
  "Time for a quick eye break",
  "Look away from the screen for a bit.",
  "Find something far away to focus on.",
  "Rest your eyes. You've earned it.",
  "Blink. Breathe. Refocus.",
  "The work can wait. Take a break.",
];

chrome.runtime.onInstalled.addListener(() => {
  chrome.alarms.create("eyeReminder", { periodInMinutes: 20 });
});

chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === "eyeReminder") {
    const message = messages[Math.floor(Math.random() * messages.length)];
    chrome.notifications.create({
      type: "basic",
      iconUrl: "break.png",
      title: "Take a short visual break",
      message: message,
      priority: 2,
    });
  }
});
