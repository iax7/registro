// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("bootstrap/dist/js/bootstrap")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import 'bootstrap'

import jQuery from "jquery";
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

document.addEventListener("turbolinks:load", () => {
    // Bootstrap Tooltip fancy view
    let tooltip_opt = {
        placement: "top"
    };
    $('[data-toggle="tooltip"]').tooltip(tooltip_opt);

    let popover_opt = {
        trigger: "hover",
        placement: "bottom"
    };
    $('[data-toggle="popover"]').popover();
})
