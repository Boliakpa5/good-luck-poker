import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="player-subscription"
export default class extends Controller {
  static values = { playerId: Number }

  connect() {
    console.log(`Subscribe to the chatroom with the id ${this.playerIdValue}.`)

    this.channel = createConsumer().subscriptions.create(
      { channel: "PlayerChannel", id: this.playerIdValue },
      { received: data => {
        console.log(data)
        this.element.innerHTML = data.html
      }}
    )
  }

  disconnect() {
    console.log("Unsubscribed from the PlayerRoom")
    this.channel.unsubscribe()
  }
}
