import { Controller } from "@hotwired/stimulus"

export default class ClearForm extends Controller {
  reset() {
    this.element.reset()
  }
}
