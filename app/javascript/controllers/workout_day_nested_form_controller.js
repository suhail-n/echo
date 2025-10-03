import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["workoutDayItems", "template", "emptyState"]

    connect() {
        this.updateState()
    }

    add(event) {
        event.preventDefault()

        const timestamp = new Date().getTime()
        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, timestamp)
        this.workoutDayItemsTarget.insertAdjacentHTML("beforeend", content)
        this.updateState()
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
        this.updateState()
    }
    updateState() {
        this.updateEmptyState()
        this.updateOrderState()
    }
    updateEmptyState() {
        const visibleItems = this.workoutDayItemsTarget.querySelectorAll('.workout-exercise-item:not([style*="display: none"])');
        this.emptyStateTarget.style.display = visibleItems.length > 0 ? "none" : "block";
    }

    updateOrderState() {
        this.workoutDayItemsTarget
            .querySelectorAll('.workout-exercise-item:not([style*="display: none"])')
            .forEach((wrapper, index) => {
                const orderInput = wrapper.querySelector('input[type="hidden"][name*="order"]')
                if (orderInput) {
                    orderInput.value = index + 1
                }
            });
    }
}