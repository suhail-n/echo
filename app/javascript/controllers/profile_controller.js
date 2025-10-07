import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile"
export default class extends Controller {
  static targets = ["themeToggle"]

  connect() {
    this.highlightCurrentTheme();
  }

  highlightCurrentTheme() {
    const currentTheme = localStorage.getItem("theme") || "";
    this.themeToggleTarget
      .querySelectorAll('input')
      .forEach(toggle => {
        console.log(`Current theme: ${currentTheme}, Toggle value: ${toggle}`);
        if (currentTheme === toggle.value) {
          toggle.checked = true;
        } else {
          toggle.checked = false;
        }
      });
  }
}
