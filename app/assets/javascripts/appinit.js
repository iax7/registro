window.App || (window.App = {});

App.init = function () {
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
};

$(document).on("turbolinks:load", function () {
  App.init();
});
