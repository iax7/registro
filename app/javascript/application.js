// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import jQuery from "jquery"

window.$ = window.jQuery = jQuery

document.addEventListener("turbo:load", () => {
    // Bootstrap Tooltip fancy view
    let tooltip_opt = {
        placement: "top"
    }
    $('[data-toggle="tooltip"]').tooltip(tooltip_opt)

    let popover_opt = {
        trigger: "hover",
        placement: "bottom"
    }
    $('[data-toggle="popover"]').popover()
})
