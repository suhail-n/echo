import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
    static targets = ["workoutDayItems", "template", "emptyState"]

    connect() {
        this.initializeSortable();
        this.updateState();
        this.isReorderMode = false;
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
        if (this.isReorderMode) {
            this.workoutDayItemsTarget.classList.add("reorder-mode");
        } else {
            this.workoutDayItemsTarget.classList.remove("reorder-mode");
        }
        this.updateReorderModeUI();
    }
    updateReorderModeUI() {
        this.workoutDayItemsTarget.querySelectorAll('.workout-exercise-item').forEach(wrapper => {
            const dragHandle = wrapper.querySelector('.workoutItemDragHandle')
            const setsRepsContainer = wrapper.querySelector('.flex.gap-3')
            const exerciseEditButton = wrapper.querySelector('[data-action*="exercise-selection#openModal"]')
            const deleteButton = wrapper.querySelector('[data-action*="workout-day-nested-form#remove"]')
            const emptyState = wrapper.querySelector('[data-exercise-selection-target="emptyState"]')
            const exerciseNameContainer = wrapper.querySelector('[data-exercise-selection-target="selectedExercise"] .flex')
            const exerciseMuscles = wrapper.querySelector('[data-exercise-selection-target="exerciseMuscles"]')

            if (this.isReorderMode) {
                // Show drag handle
                if (dragHandle) dragHandle.style.display = 'flex'

                // Hide sets/reps inputs
                if (setsRepsContainer) {
                    setsRepsContainer.style.display = 'none'
                }

                // Hide exercise edit button
                if (exerciseEditButton) exerciseEditButton.style.display = 'none'

                // hide exercise muscles
                if (exerciseMuscles) exerciseMuscles.classList.add('hidden')

                // Hide empty state button if visible
                if (emptyState && !emptyState.classList.contains('hidden')) {
                    emptyState.style.display = 'none'
                }

                // Move delete button to be inline with exercise name
                if (deleteButton && exerciseNameContainer) {
                    // Create a container for the delete button if it doesn't exist
                    let reorderDeleteContainer = wrapper.querySelector('.reorder-delete-container')
                    if (!reorderDeleteContainer) {
                        reorderDeleteContainer = document.createElement('div')
                        reorderDeleteContainer.className = 'reorder-delete-container'
                        exerciseNameContainer.parentElement.appendChild(reorderDeleteContainer)
                    }

                    // Move the delete button to the new container and style it appropriately
                    reorderDeleteContainer.appendChild(deleteButton)
                    reorderDeleteContainer.style.display = 'flex'
                    reorderDeleteContainer.style.alignItems = 'center'

                    // Update the parent container to space between elements
                    exerciseNameContainer.parentElement.style.display = 'flex'
                    exerciseNameContainer.parentElement.style.justifyContent = 'space-between'
                    exerciseNameContainer.parentElement.style.alignItems = 'center'

                }
            } else {
                // Hide drag handle
                if (dragHandle) dragHandle.style.display = 'none'

                // Show sets/reps inputs
                if (setsRepsContainer) {
                    setsRepsContainer.style.display = ''
                }

                // Show exercise edit button
                if (exerciseEditButton) exerciseEditButton.style.display = ''

                // Show empty state button if it should be visible
                if (emptyState && !emptyState.classList.contains('hidden')) {
                    emptyState.style.display = ''
                }

                // show exercise muscles
                if (exerciseMuscles) exerciseMuscles.classList.remove('hidden')

                // Move delete button back to its original position
                if (deleteButton && setsRepsContainer) {
                    const deleteButtonContainer = setsRepsContainer.querySelector('.flex.items-end')
                    if (deleteButtonContainer) {
                        deleteButtonContainer.appendChild(deleteButton)
                    }

                    // Clean up the temporary container
                    const reorderDeleteContainer = wrapper.querySelector('.reorder-delete-container')
                    if (reorderDeleteContainer) {
                        reorderDeleteContainer.remove()
                    }

                    // Reset the parent container styling
                    if (exerciseNameContainer) {
                        exerciseNameContainer.parentElement.style.display = ''
                        exerciseNameContainer.parentElement.style.justifyContent = ''
                        exerciseNameContainer.parentElement.style.alignItems = ''
                    }
                }
            }
        })
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