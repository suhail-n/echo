import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
    static targets = ["workoutDayItems", "template", "emptyState"]

    connect() {
        this.initializeSortable();
        this.updateState();
        this.isReorderMode = false;
        this.updateReorderModeUI();
    }

    initializeSortable() {
        if (this.nestedSortable) {
            console.debug("Nested sortable already initialized, skipping re-initialization.");
            return;
        };
        console.debug('connected to nested');
        this.nestedSortable = Sortable.create(this.workoutDayItemsTarget, {
            animation: 150,
            ghostClass: "opacity-50",
            chosenClass: "ring-2",
            dragClass: "shadow-xl",
            handle: ".workoutItemDragHandle", // Only allow dragging by the handle
            disabled: true, // Start with dragging disabled
            fallbackOnBody: true,
            forceFallback: true,
            swapThreshold: 0.65,
            group: "exercise-items",
            onEnd: (event) => {
                setTimeout(() => this.updateOrderState(), 0);
            }
        })
    }

    add(event) {
        event.preventDefault()

        const timestamp = new Date().getTime()
        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, timestamp)
        this.workoutDayItemsTarget.insertAdjacentHTML("beforeend", content)
        this.updateState()

        // Apply reorder mode styling to new item if in reorder mode
        if (this.isReorderMode) {
            this.updateReorderModeUI()
        }
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
        console.debug("calling updateOrderState");
        const found = this.workoutDayItemsTarget.querySelectorAll('.workout-exercise-item:not([style*="display: none"])');
        // console.debug("found items:", found);
        this.workoutDayItemsTarget
            .querySelectorAll('.workout-exercise-item:not([style*="display: none"])')
            .forEach((wrapper, index) => {
                const orderInput = wrapper.querySelector('input[type="hidden"][name*="order"]')
                // console.debug("updating order for:", orderInput);
                // console.debug(`current order: ${orderInput.value}`);
                if (orderInput) {
                    orderInput.value = index + 1
                }
                // console.debug(`new order: ${orderInput.value}`);
            });
    }
    /**
     * Toggles the exercise reorder mode.
     * @param {Event} event 
     */
    toggleExerciseReorderMode(event) {
        this.isReorderMode = event.target.checked;
        this.workoutDayItemsTarget.classList.toggle("reorder-mode", this.isReorderMode);
        this.nestedSortable.option("disabled", !this.isReorderMode)
        this.updateReorderModeUI();
    }
    updateReorderModeUI() {
        this.workoutDayItemsTarget
            .querySelectorAll('.workout-exercise-item')
            .forEach(wrapper => wrapper.classList.toggle('reorder-mode', this.isReorderMode));
    }

    disconnect() {
        console.debug("disconnecting from nested");
        // Add a small delay to check if we're really being disconnected
        // or if this is just a temporary DOM manipulation from dragging
        setTimeout(() => {
            // Only destroy if the element is actually no longer in the DOM
            const stillConnected = document.contains(this.element) &&
                this.hasWorkoutDayItemsTarget &&
                document.contains(this.workoutDayItemsTarget);
            if (!stillConnected) {
                console.debug("Actually disconnecting - destroying sortable");
                if (this.nestedSortable) {
                    this.nestedSortable.destroy();
                    this.nestedSortable = null;
                }
            } else {
                console.debug("False disconnect - element still in DOM, re-initializing sortable");
                // Re-initialize if needed
                if (!this.nestedSortable) {
                    this.initializeSortable();
                }
            }
        }, 10);
    }
}