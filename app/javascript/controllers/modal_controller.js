import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["detailButton"];

  connect() {
    this.shoppingIds = this.detailButtonTargets.map(
      (button) => button.dataset.shoppingId
    );
    this.currentShoppingId = null;
  }

  // hiddenになっていたモーダル要素を表示する
  showModal(evt) {
    this.currentShoppingId = evt.target.dataset.shoppingId;
    this.toggleModal(true);
    this.makeModalContent();
  }

  // ×ボタンを押したときにモーダルとオーバーレイを閉じるメソッド
  closeModal() {
    this.toggleModal(false);
  }

  prevPage(evt) {
    this.switchPage("prev");
  }

  nextPage(evt) {
    this.switchPage("next");
  }

  // 前ページに行くか、次ページに行くか決めるメソッド
  switchPage(direction) {
    const currentIndex = this.shoppingIds.indexOf(this.currentShoppingId);
    let newIndex = 0;
    if (direction === "next") {
      // 最後のshoppingを表示していた時に、次へボタンを押したら最初の要素を表示する
      // 例: [1,3,5]の配列があって、現在5の要素を表示していた。その時にnextPageを呼び出すと、次は1の要素を表示する
      newIndex =
        currentIndex === this.shoppingIds.length - 1 ? 0 : currentIndex + 1;
    } else if (direction === "prev") {
      // 最初のshoppingを表示していた時に、前へボタンを押したら最後の要素を表示する
      // 例: [1,3,5]の配列があって、現在1の要素を表示していた。その時にprevPageを呼び出すと、次は5の要素を表示する
      newIndex =
        currentIndex === 0 ? this.shoppingIds.length - 1 : currentIndex - 1;
    }
    this.currentShoppingId = this.shoppingIds[newIndex];
    this.switchOldToNewModal();
  }

  // モーダルの内容を作成
  async makeModalContent() {
    // 詳細ボタンを押下した要素のデータをAPIで取得
    const shoppingId = this.currentShoppingId;
    const data = await this.fetchData(`shoppings/${shoppingId}/modal`);

    // 買物名を表示
    const shoppingNameNode = document.getElementById("shopping-name");
    shoppingNameNode.innerHTML = data["shopping_name"];

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
        "flex flex-row w-full space-x-2 my-2 border-b-2 border-blue-200"
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

  // モーダルの表示・非表示を切り替えるメソッド
  toggleModal(isVisible) {
    const modal = document.getElementById("modal");
    const overlay = document.getElementById("overlay");
    const prevBtn = document.getElementById("prev-button");
    const nextBtn = document.getElementById("next-button");
    const detailsContentNode = document.getElementById("details-content");

    if (isVisible) {
      modal.classList.remove("hidden");
      overlay.classList.remove("hidden");
      prevBtn.classList.remove("hidden");
      nextBtn.classList.remove("hidden");
    } else {
      modal.classList.add("hidden");
      overlay.classList.add("hidden");
      prevBtn.classList.add("hidden");
      nextBtn.classList.add("hidden");
      this.removeAllChildNodes(detailsContentNode);
    }
  }

  // 子要素をすべて削除するメソッド
  removeAllChildNodes(node) {
    while (node.firstChild) {
      node.removeChild(node.firstChild);
    }
  }

  // ページ移動の際に、前回表示していたモーダルを削除してから次のモーダルを表示するメソッド
  switchOldToNewModal() {
    this.toggleModal(false);
    this.toggleModal(true);
    this.makeModalContent();
  }
}
