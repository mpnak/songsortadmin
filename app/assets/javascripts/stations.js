$(function() {

  // Undergroundess rating

  $(".rating-selector .rating-item").on('click', function() {
    console.log('clicked');

    var $this = $(this);

    // Update the background color instantly for perceived responsivness

    $this.siblings().toggleClass('selected', false);
    $this.toggleClass('selected', true);

    // Send the update to the server
    var rating = $this.attr("data-rating");
    var track_id = $this.attr("data-track");
    var data = {
      "track": {
        "undergroundness": rating
      }
    };

    $.ajax({
      type: "PUT",
      url: "/tracks/" + track_id,
      data: data,
      success: function() {},
    });
  });

  // Song loader

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
      var track_data = {
        "track": {
          "spotify_id": matches[1],
          "station_id": gon.station_id
        }
      };

      $.ajax({
        type: "POST",
        url: "/tracks",
        data: track_data,
        success: trackCreated,
      });
    }
  }

  function trackCreated(data) {
    $('#tracks').mixItUp('prepend', $(data));
  }
});

$(function(){

  $sortSelect = $('#sort-select'),
    $container = $('#tracks');

  $container.mixItUp({
    selectors: {
      target: '.track', /* .mix */
      filter: '.filter-btn' /* .filter */
    },
    load: {
      sort: 'created_at:desc' /* default:asc */
    },
    animation: {
      enable: false
    },
    callbacks: {
      onMixLoad: function(){
        $(this).mixItUp('setOptions', {
          animation: {
            enable: true
          },
        });
      }
    }
  });

  $sortSelect.on('change', function(){
    $container.mixItUp('sort', this.value);
  });

});

