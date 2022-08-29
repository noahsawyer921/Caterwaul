import { Controller } from "@hotwired/stimulus"

export default class MessageList extends Controller {
  connect() {
    const config = { attributes: false, childList: true, subtree: true };

    const observer = new MutationObserver((mutationList, observer) => {
      for (const mutation of mutationList) {
        if (mutation.type === 'childList') {
          this.scrollToBottom();
        }
      }
    })

    observer.observe(this.element, config);
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight;
  }
}
