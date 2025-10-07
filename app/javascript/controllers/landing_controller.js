import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landing"
export default class extends Controller {
  connect() {
    this.setTheme();
  }
  setTheme() {
    document.documentElement.setAttribute('data-theme', 'light');
  }
}
