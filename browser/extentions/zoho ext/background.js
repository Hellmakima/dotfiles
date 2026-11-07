chrome.tabs.onUpdated.addListener((tabId, info, tab) => {
  if (
    info.status === 'complete' &&
    tab.url &&
    tab.url.includes('https://sprints.zoho.in/workspace/') &&
    (tab.url.includes('/board/') || tab.url.includes('/timesheet'))
  ) {
    chrome.scripting.executeScript({
      target: { tabId: tabId },
      func: () => {
        const collapseOnlyExpanded = () => {
          const toggles = Array.from(
            document.querySelectorAll('.bdrSwmHClps, .tsmGHIco')
          )
          const toCollapse = toggles.filter(
            el => el.getAttribute('agtitle') === 'Collapse'
          )
          if (toCollapse.length > 0) {
            toCollapse.forEach(el => el.click())
            console.log(`[ZohoExpander] Collapsed ${toCollapse.length} items`)
          } else {
            console.warn('[ZohoExpander] No items to collapse')
          }
        }
        let attempts = 0
        const maxAttempts = 20
        const interval = setInterval(() => {
          attempts++
          const toggles = document.querySelectorAll('.bdrSwmHClps, .tsmGHIco')

          if (toggles.length > 0 || attempts >= maxAttempts) {
            clearInterval(interval)
            collapseOnlyExpanded()
          }
        }, 500)
      }
    })
  }
})
