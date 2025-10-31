// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import jQuery from "jquery"

window.$ = window.jQuery = jQuery

import Popper from "popper.js/dist/umd/popper";
window.Popper = Popper;

import * as bootstrap from "bootstrap"

document.addEventListener("turbo:load", () => {
    // Bootstrap Tooltip fancy view
    const tooltip_opt = {
        placement: "top"
    }
    $('[data-toggle="tooltip"]').tooltip(tooltip_opt)

    const popover_opt = {
        trigger: "hover",
        placement: "right"
    }
    $('[data-toggle="popover"]').popover(popover_opt)
})
