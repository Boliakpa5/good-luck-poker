import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="raise"
export default class extends Controller {
  static values = {
    max: Number
  }
  static get targets() {
    return ['range', 'value', 'sender']
  }

  connect() {
    if (this.hasSenderTarget) {console.log("sender est ici") }
    if (this.hasValueTarget) {
       this.valueTarget.innerHTML = this.rangeTarget.value
      }
    this.url = this.senderTarget.href;
  }

  updateValue(event) {
    this.valueTarget.innerHTML = event.currentTarget.value;
    this.senderTarget.href = `${this.url}?raise_amount=${event.currentTarget.value}`;
    // console.log(event.currentTarget.value)
    // console.log(this.maxValue)

    if (event.currentTarget.value == this.maxValue) {
      this.senderTarget.innerText = "all-in"
    } else {
      this.senderTarget.innerText = "raise"
    }
  }

}
