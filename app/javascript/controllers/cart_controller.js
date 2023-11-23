import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cartRow", "sumPrice"];
  connect() {
    this.calculateSumPrice();
  }

  // カート内の合計金額を求めるメソッド
  calculateSumPrice() {
    const sum = this.cartRowTargets.reduce((acc, row) => {
      const itemPrice =
        parseFloat(row.querySelector(`[data-target="cart.itemPrice"]`).value) ||
        0;
      const itemCount =
        parseFloat(row.querySelector(`[data-target="cart.itemCount"]`).value) ||
        0;
      return acc + itemCount * itemPrice;
    }, 0);

    this.sumPriceTarget.textContent = sum.toFixed(0);
  }

  // 行追加ボタンを押したときに、新しい行を作成するメソッド
  createCartRow() {
    const cartRow = this.element.querySelector(".cart-row");
    const newCartRow = cartRow.cloneNode(true);

    newCartRow.querySelectorAll("input").forEach((input) => (input.value = ""));

    const cartContent = this.element.querySelector("#cart-content");
    cartContent.appendChild(newCartRow);
  }

  // 個数や料金を変更したときに、合計金額を更新する
  updateSumPrice() {
    this.calculateSumPrice();
  }

  // テキスト入力時にEnterキーを押すと、POST送信されてしまうことを防ぐ
  preventSubmit(event) {
    // Tabキーで隣のインプットに移動するなどの機能は阻止したくない
    if (event.key === "Enter") {
      event.preventDefault();
    }
  }
}
