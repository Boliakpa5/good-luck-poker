import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="player-subscription"
export default class extends Controller {
  static values = { userId: Number }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "PlayerChannel", id: this.userIdValue },
      { received: data => {
        console.log(data)
        // this.element.outerHTML = data.html
      }}
    )
    console.log(`Subscribe to the poker table with the id ${this.userIdValue}.`)
  }
}
