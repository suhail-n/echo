import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["links", "template", "emptyState"]

    connect() {
        this.updateEmptyState()
    }

    add(event) {
        event.preventDefault()

        const timestamp = new Date().getTime()
        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, timestamp)
        this.linksTarget.insertAdjacentHTML("beforeend", content)
        this.updateEmptyState()
    }

    remove(event) {
        event.preventDefault()

        const wrapper = event.target.closest(".workout-exercise-item")
        const destroyInput = wrapper.querySelector("input[name*='_destroy']")

        if (wrapper.dataset.newRecord === "true") {
            // This is a new record, just remove it from the DOM
            wrapper.remove()
        } else {
            // This is an existing record, mark it for destruction
            wrapper.style.display = "none"
            if (destroyInput) {
                destroyInput.value = "1"
            }

            // Remove required attributes from hidden fields to prevent validation errors
            const requiredFields = wrapper.querySelectorAll('input[required], select[required], textarea[required]')
            requiredFields.forEach(field => field.removeAttribute('required'))
        }
        this.updateEmptyState()
    }
    updateEmptyState() {
        const visibleItems = this.linksTarget.querySelectorAll('.workout-exercise-item:not([style*="display: none"])');
        this.emptyStateTarget.style.display = visibleItems.length > 0 ? "none" : "block";
    }
}