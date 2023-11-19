import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tab", "content"];
  static values = { index: Number };

  connect() {
    this.indexValue = 0;
  }

  select(evt) {
    const tab = evt.currentTarget;
    const index = this.tabTargets.indexOf(tab);
    this.indexValue = index;
  }

  indexValueChanged() {
    this.hideAll();
    this.showSelected();
  }

  hideAll() {
    this.contentTargets.forEach((el, i) => {
      el.classList.add("hidden");
      this.tabTargets[i].classList.remove("bg-blue-500", "text-white");
      this.tabTargets[i].classList.add("bg-white", "textt-blue-500");
    });
  }

  showSelected() {
    this.contentTargets[this.indexValue].classList.remove("hidden");
    this.tabTargets[this.indexValue].classList.remove(
      "bg-white",
      "text-blue-500"
    );
    this.tabTargets[this.indexValue].classList.add("bg-blue-500", "text-white");
  }
}
