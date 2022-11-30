import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="raise"
export default class extends Controller {
  static value
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
    // this.senderTarget.setAttribute("raise_amount", event.currentTarget.value);
    this.senderTarget.href = `${this.url}?raise_amount=${event.currentTarget.value}`;
    console.log(this.senderTarget.href)
    // console.log(this.senderTarget.dataset)
    // this.senderTarget.insertAdjacentHTML= `<%= link_to "raise", raise_hand_player_hand_path(current_user.player_hands.last.id, data: { turbo_method: :patch } %>`
  }

}
