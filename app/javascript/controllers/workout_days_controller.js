import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "template", "emptyState"]

    connect() {
        this.updateEmptyState()
    }

    add(event) {
        event.preventDefault()

        // Get the template content
        const template = this.templateTarget.innerHTML

        // Use a timestamp as a unique identifier
        const timestamp = new Date().getTime()

        // Replace NEW_RECORD with the timestamp
        const content = template.replace(/NEW_RECORD/g, timestamp)

        // Create a new element and insert it
        const wrapper = document.createElement('div')
        wrapper.innerHTML = content
        this.containerTarget.appendChild(wrapper.firstElementChild)

        // Update the empty state visibility
        this.updateEmptyState()
        this.updateOrderState()
    }

    remove(event) {
        event.preventDefault()

        const workoutDayWrapper = event.target.closest('.workout-day-wrapper')
        const destroyInput = workoutDayWrapper.querySelector('input[name*="_destroy"]')

        if (destroyInput) {
            // If this is an existing record, mark it for destruction
            destroyInput.value = '1'
            workoutDayWrapper.style.display = 'none'

            // Remove required attributes from hidden fields to prevent validation errors
            const requiredFields = workoutDayWrapper.querySelectorAll('input[required], select[required], textarea[required]')
            requiredFields.forEach(field => field.removeAttribute('required'))
        } else {
            // If this is a new record, just remove it from the DOM
            workoutDayWrapper.remove()
        }

        // Update the empty state visibility
        this.updateEmptyState()
        this.updateOrderState()
    }

    updateOrderState() {
        const workoutDayWrappers = Array.from(this.containerTarget.querySelectorAll('.workout-day-wrapper > input[type="hidden"][name*="order"]'))
        workoutDayWrappers.forEach((input, index) => {
            input.value = index + 1
        })
    }

    updateEmptyState() {
        const visibleWorkoutDays = this.containerTarget.querySelectorAll('.workout-day-wrapper:not([style*="display: none"])')

        if (visibleWorkoutDays.length === 0) {
            this.emptyStateTarget.style.display = 'block'
        } else {
            this.emptyStateTarget.style.display = 'none'
        }
    }
}