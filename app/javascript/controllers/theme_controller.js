import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.initializeTheme()
    }

    initializeTheme() {
        // Get theme from localStorage or default to light
        const savedTheme = localStorage.getItem('theme')

        if (!savedTheme) {
            // No saved theme - use system preference
            this.applySystemTheme()
        } else {
            // Apply saved theme
            document.documentElement.setAttribute('data-theme', savedTheme)
        }
    }
    /**
     * @param {Event} event
     */
    changeTheme(event) {
        console.log("change theme is called");
        const selectedElement = event.currentTarget.value.trim();
        if (selectedElement) {
            document.documentElement.setAttribute('data-theme', selectedElement);
            localStorage.setItem('theme', selectedElement);
        } else {
            this.applySystemTheme();
        }
    }

    applySystemTheme() {
        localStorage.removeItem('theme');
        document.documentElement.removeAttribute('data-theme');
    }

}