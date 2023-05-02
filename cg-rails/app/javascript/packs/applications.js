require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
import "@fortawesome/fontawesome-free/css/all.css";
import "bootstrap";
import "controllers";
import "../stylesheets/application";
$(document).on('ready turbolinks:load', () => {
    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover();
});
