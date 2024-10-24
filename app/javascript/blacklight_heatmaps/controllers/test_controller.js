import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected")
    this.element.textContent = "Hello World! This is a Javascript from the controller"
  }
}
