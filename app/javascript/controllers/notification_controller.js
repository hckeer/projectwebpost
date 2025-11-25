import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    hideAfter: { type: Number, default: 5000 }
  }

  connect() {
    if (this.hideAfterValue > 0) {
      this.timeout = setTimeout(() => {
        this.hide()
      }, this.hideAfterValue)
    }
  }

  hide() {
    this.element.classList.add("opacity-0", "translate-x-full")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}
