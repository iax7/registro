// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import jQuery from "jquery"

window.$ = window.jQuery = jQuery

import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

document.addEventListener("turbo:load", () => {
    // Bootstrap Tooltip
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl, {
        placement: "top"
    }))

    // Bootstrap Popover
    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
    const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl, {
        trigger: "hover",
        placement: "right"
    }))
})
