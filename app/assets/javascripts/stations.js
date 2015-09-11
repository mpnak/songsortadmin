$(function() {
  var $target = $("#station-song-loader");

  $target.on("dragenter", function(e) {
    // give the user visual feedback
    $target.removeClass("dropped");
    $target.addClass("draggingOver");
  });

  $target.on("dragleave", function(e) {
    $target.removeClass("draggingOver");
  });

  $target.on("dragover", function(e) {
      e.preventDefault();
      return false;
  });

  $target.on("drop", function(e) {
    // dropped! Check out e.dataTransfer
    $target.removeClass("draggingOver");
    addDroppedUIState($target);
    var message = e.originalEvent.dataTransfer.getData("text/plain");
    e.preventDefault();
    matchAndAlert(message);
   });

   function addDroppedUIState($target) {
      $target.addClass("dropped");
      $target.find(".loader-content").text("Cheers big ears");

      _.delay(function($target) {
        $target.removeClass("dropped");
        $target.find(".loader-content").text("Drag and drop spotify tracks or playlists");
      }, 1000, $target);
   }

   function matchAndAlert(text) {
     var re = /^http:\/\/open\.spotify\.com\/track\/(.*)/;
     var matches = text.match(re);
     if (matches) {
      alert(matches[1]);
     }
   }
});

