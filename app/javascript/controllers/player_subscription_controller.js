import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="player-subscription"
export default class extends Controller {
  static values = { playerId: Number }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "PlayerChannel", id: this.pokerTableIdValue },
      { received: data => {
        console.log(data)
        this.element.outerHTML = data.html
        // if (data.event = 'player_seated') {
        //   switch (data.position) {
        //     case 1:
        //       this.player1Target.innerHTML = data.html
        //       break;

        //     default:
        //       console.log('wtf?')
        //       break;
        //   }
        // }
      }}
    )
    console.log(`Subscribe to the poker table with the id ${this.pokerTableIdValue}.`)
  }
}
