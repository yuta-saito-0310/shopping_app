import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("connected to cart");
  }

  create_cart_row() {
    const cartRow = this.element.querySelector(".cart-row");
    const newCartRow = cartRow.cloneNode(true);

    newCartRow.querySelectorAll("input").forEach((input) => (input.value = ""));

    const cartContent = this.element.querySelector("#cart-content");
    cartContent.appendChild(newCartRow);
  }
}
