// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

if (history && history.pushState) {

  $(function() {
    
    $(".index th a, .index .pagination a").live("click", function(e) {
      $.getScript(this.href);
      history.pushState(null, document.title, this.href);
      e.preventDefault();
    });

    $("#donors_search input").keyup(function() {
      $.get($("#donors_search").attr("action"), $("#donors_search").serialize(), null, "script");
      history.replaceState(null, document.title, $("#donors_search").attr("action") + "?" + $("#donors_search").serialize());
    });

    $("#books_search input").keyup(function() {
      $.get($("#books_search").attr("action"), $("#books_search").serialize(), null, "script");
      history.replaceState(null, document.title, $("#books_search").attr("action") + "?" + $("#books_search").serialize());
    });

    $("#schools_search input").keyup(function() {
      $.get($("#schools_search").attr("action"), $("#schools_search").serialize(), null, "script");
      history.replaceState(null, document.title, $("#schools_search").attr("action") + "?" + $("#schools_search").serialize());
    });

    $("#articles_search input").keyup(function() {
      $.get($("#articles_search").attr("action"), $("#articles_search").serialize(), null, "script");
      history.replaceState(null, document.title, $("#articles_search").attr("action") + "?" + $("#articles_search").serialize());
    });

    $("#questions_search input").keyup(function() {
      $.get($("#questions_search").attr("action"), $("#questions_search").serialize(), null, "script");
      history.replaceState(null, document.title, $("#questions_search").attr("action") + "?" + $("#questions_search").serialize());
    });

    $("#snippets_search input").keyup(function() {
      $.get($("#snippets_search").attr("action"), $("#snippets_search").serialize(), null, "script");
      history.replaceState(null, document.title, $("#snippets_search").attr("action") + "?" + $("#snippets_search").serialize());
    });

    $("table.index tr").live("click", function(e) {
      if (e.metaKey) {
        var newWindow = window.open($('a', this).attr('href'));
        newWindow.focus();
      } else {
        document.location = $('a', this).attr('href');
      }
    });

    $(window).bind("popstate", function() {
      $.getScript(location.href);
    });

    $("#album_link a").live("click", function() {
      downloadAlbum(this);
      return false;
    });

    $(".track_link a").live("click", function() {
      downloadTrack(this);
      return false;
    });

  });

}


function downloadAlbum(link) {

  dl_href = link.href
  if ( document.all ) {
    document.getElementById('album_link').innerText = 'Your Album is Now Downloading!';
  } else {
    document.getElementById('album_link').textContent = 'Your Album is Now Downloading!';    
  }
  document.getElementById('album_link').className = 'downloading';
  try {
    var myTracker=_gat._getTrackerByName();
    _gaq.push(['myTracker._trackEvent', 'downloads', 'album' ]);
    setTimeout('document.location = "' + link.href + '"', 100)
  }catch(err){}
}

function downloadTrack(link) {
  
  dl_href = link.href
  li_id = link.id + '_li'
  track_name = link.textContent
  if ( document.all ) {
    document.getElementById(li_id).innerText = track_name + ': Now Downloading!';    
  } else {
    document.getElementById(li_id).textContent = track_name + ': Now Downloading!';        
  }
  document.getElementById(li_id).className = 'downloading';
  try {
    var myTracker=_gat._getTrackerByName();
    _gaq.push(['myTracker._trackEvent', 'downloads', link.id ]);
    setTimeout('document.location = "' + dl_href + '"', 100)
  }catch(err){}
}

function recordOutboundLink(link, category, action) {
  try {
    var myTracker=_gat._getTrackerByName();
    _gaq.push(['myTracker._trackEvent', category, action]);
    setTimeout('document.location = "' + link.href + '"', 100)
  }catch(err){}
}

function recordDonateButtonClick(page) {
  try {
    var myTracker=_gat._getTrackerByName();
    _gaq.push(['myTracker._trackEvent', 'donate', page]);
  }catch(err){}
}

