import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
    static targets = ["container", "template", "emptyState", "reorderToggle"]

    connect() {
        this.initializeSortable()
        this.updateState()
        // Initialize reorder mode state
        this.isReorderMode = false
        this.updateReorderModeUI()
    }

    initializeSortable() {
        this.sortable = Sortable.create(this.containerTarget, {
            animation: 150,
            ghostClass: "opacity-50",
            chosenClass: "ring-2",
            dragClass: "shadow-xl",
            handle: ".drag-handle", // Only allow dragging by the handle
            disabled: true, // Start with dragging disabled
            onEnd: (event) => {
                // this.updateOrderState()
                setTimeout(() => this.updateOrderState(), 0);
            }
        })
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
        this.updateState()

        // Update reorder mode UI for new elements
        this.updateReorderModeUI()
    }

    remove(event) {
        event.preventDefault()

        const workoutDayWrapper = event.target.closest('.workout-day-wrapper')
        const destroyInput = workoutDayWrapper.querySelector('input[name*="_destroy"]')
        if (workoutDayWrapper.dataset.newRecord === "true") {
            // If this is a new record, just remove it from the DOM
            workoutDayWrapper.remove()
        } else {
            // If this is an existing record, mark it for destruction
            destroyInput.value = '1'
            workoutDayWrapper.style.display = 'none'

            // Remove required attributes from hidden fields to prevent validation errors
            const requiredFields = workoutDayWrapper.querySelectorAll('input[required], select[required], textarea[required]')
            requiredFields.forEach(field => field.removeAttribute('required'))
        }

        // Update the empty state visibility
        this.updateState()
    }

    updateOrderState() {
        const visibleWorkoutDays = this.containerTarget.querySelectorAll('.workout-day-wrapper:not([style*="display: none"])')
        visibleWorkoutDays.forEach((wrapper, index) => {
            const orderInput = wrapper.querySelector('input[type="hidden"][name*="order"][class*="workout-item-order-field"]')
            if (orderInput) {
                orderInput.value = index + 1
            }
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

    updateState() {
        this.updateEmptyState()
        this.updateOrderState()
    }

    toggleReorderMode(event) {
        this.isReorderMode = event.target.checked

        if (this.isReorderMode) {
            // Enable reorder mode
            this.containerTarget.classList.add('reorder-mode')
            this.sortable.option("disabled", false) // Enable dragging
        } else {
            // Disable reorder mode
            this.containerTarget.classList.remove('reorder-mode')
            this.sortable.option("disabled", true) // Disable dragging
        }

        this.updateReorderModeUI()
    }

    updateReorderModeUI() {
        // Show/hide elements based on reorder mode
        const allWrappers = this.containerTarget.querySelectorAll('.workout-day-wrapper')

        allWrappers.forEach(wrapper => {
            const dragHandle = wrapper.querySelector('.drag-handle')
            const editableElements = wrapper.querySelectorAll('.reorder-hide')
            const exerciseDetails = wrapper.querySelector('details')

            if (this.isReorderMode) {
                // Show drag handle
                if (dragHandle) dragHandle.style.display = 'flex'
                // Hide editable elements
                editableElements.forEach(el => el.style.display = 'none')
                // Collapse exercise details
                if (exerciseDetails) exerciseDetails.removeAttribute('open')
            } else {
                // Hide drag handle
                if (dragHandle) dragHandle.style.display = 'none'
                // Show editable elements
                editableElements.forEach(el => el.style.display = '')
                // Expand exercise details
                if (exerciseDetails) exerciseDetails.setAttribute('open', '')
            }
        })
    }

    disconnect() {
        if (this.sortable) {
            this.sortable.destroy()
        }
    }
}