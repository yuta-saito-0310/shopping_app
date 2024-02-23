import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // hiddenになっていたモーダル要素を表示する
  async showModal(evt) {
    const modal = document.getElementById("modal");
    modal.classList.remove("hidden");

    await this.makeModalContent(evt, modal);
  }

  // モーダルの内容を作成
  async makeModalContent(evt, modal) {
    // 詳細ボタンを押下した要素のデータをAPIで取得
    const shoppingId = evt.target.dataset.shoppingId;
    const data = await this.fetchData(`shoppings/${shoppingId}/modal`);

    // 買物名を表示
    const shoppingNameNode = document.getElementById("shopping-name");
    shoppingNameNode.innerHTML = `: ${data["shopping_name"]}`;

    //合計金額を表示
    const sumPriceNode = document.getElementById("sum-price");
    const sumPrice = this.calculateSumPrice(data["shopping_details"]);
    sumPriceNode.innerHTML = sumPrice;

    // 品名・単価・個数を表示
    this.showDetails(data["shopping_details"]);
  }

  // APIリクエストを送る
  async fetchData(url) {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error("Failed to fetch data");
    }
    return await response.json();
  }

  // 合計金額を計算
  calculateSumPrice(details) {
    return details.reduce(
      (sum, itemRow) => sum + itemRow.item_count * itemRow.item_price,
      0
    );
  }

  // 品名・単価・個数を表示
  showDetails(details) {
    const detailsContentNode = document.getElementById("details-content");

    details.forEach((item) => {
      const itemRow = document.createElement("div");
      itemRow.setAttribute(
        "class",
        "text-center flex flex-row w-full space-x-2 my-2 border-b-2 border-blue-200"
      );

      const itemName = this.createItemElement(
        item.item_name,
        "item-name w-1/2 text-xl"
      );
      const itemPrice = this.createItemElement(
        item.item_price,
        "item-price w-1/4 text-xl"
      );
      const itemAmount = this.createItemElement(
        item.item_count,
        "item-amount w-1/4 text-xl"
      );

      itemRow.append(itemName, itemPrice, itemAmount);
      detailsContentNode.appendChild(itemRow);
    });
  }

  // 品名・単価・個数のセルを作成するメソッド
  createItemElement(item, className) {
    const element = document.createElement("p");
    element.setAttribute("class", className);
    element.innerHTML = item;
    return element;
  }
}
