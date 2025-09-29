import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "modal",
        "selectedExercise",
        "emptyState",
        "exerciseName",
        "exerciseMuscles",
        "searchInput",
        "exerciseList",
        "exerciseOption"
    ]

    connect() {
        this.exerciseIdField = this.element.querySelector("input[name*='exercise_id']")
    }

    openModal() {
        this.modalTarget.showModal()
        this.searchInputTarget.focus()
        this.clearSearch()
    }

    closeModal() {
        this.modalTarget.close()
    }

    selectExercise(event) {
        const option = event.currentTarget
        const exerciseId = option.dataset.exerciseId
        const exerciseName = option.dataset.exerciseName
        const exerciseMuscles = option.dataset.exerciseMuscles

        // Update the hidden field
        this.exerciseIdField.value = exerciseId

        // Update the display
        this.exerciseNameTarget.textContent = exerciseName
        this.exerciseMusclesTarget.textContent = exerciseMuscles

        // Show selected exercise, hide empty state
        this.selectedExerciseTarget.classList.remove("hidden")
        this.emptyStateTarget.classList.add("hidden")

        // Close modal
        this.modalTarget.close()
    }

    search() {
        const searchTerm = this.searchInputTarget.value.toLowerCase().trim()

        this.exerciseOptionTargets.forEach(option => {
            const searchText = option.dataset.searchText.toLowerCase()

            if (searchTerm === "" || searchText.includes(searchTerm)) {
                option.style.display = "block"
            } else {
                option.style.display = "none"
            }
        })
    }

    clearSearch() {
        this.searchInputTarget.value = ""
        this.search() // Show all exercises
    }
}