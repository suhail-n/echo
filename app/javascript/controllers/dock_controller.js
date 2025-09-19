import { Controller } from "@hotwired/stimulus"

// Persist and restore the active dock button using localStorage.
// Buttons must have `data-action="click->dock#setActive"` and `data-dock-key="<key>"`.
export default class extends Controller {
    connect() {
        this.storageKey = "dock:active"
        this.buttons = Array.from(this.element.querySelectorAll("[data-dock-key]"))
        this.restoreActive()
    }

    setActive(event) {
        const button = event.currentTarget
        const key = button.dataset.dockKey
        if (!key) return
        this.clearActive()
        button.classList.add("dock-active")
        try {
            localStorage.setItem(this.storageKey, key)
        } catch (e) {
            // ignore storage errors (private mode)
        }
    }

    restoreActive() {
        let key = null
        try {
            key = localStorage.getItem(this.storageKey)
        } catch (e) {
            // ignore
        }
        if (!key) return
        const btn = this.buttons.find(b => b.dataset.dockKey === key)
        if (btn) {
            this.clearActive()
            btn.classList.add("dock-active")
        }
    }

    clearActive() {
        this.buttons.forEach(b => b.classList.remove("dock-active"))
    }
}
