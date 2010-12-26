// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $("#donors th a, #donors .pagination a, #books th a, #books .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#album_link a").live("click", function() {
    downloadAlbum(this);
    return false;
  });
  $(".track_link a").live("click", function() {
    downloadTrack(this);
    return false;
  });
  $("#donors_search input").keyup(function() {
    $.get($("#donors_search").attr("action"), $("#donors_search").serialize(), null, "script");
    return false;
  });
  $("#books_search input").keyup(function() {
    $.get($("#books_search").attr("action"), $("#books_search").serialize(), null, "script");
    return false;
  });
  $("#schools_search input").keyup(function() {
    $.get($("#schools_search").attr("action"), $("#schools_search").serialize(), null, "script");
    return false;
  });
  $("#articles_search input").keyup(function() {
    $.get($("#articles_search").attr("action"), $("#articles_search").serialize(), null, "script");
    return false;
  });
  $("#questions_search input").keyup(function() {
    $.get($("#questions_search").attr("action"), $("#questions_search").serialize(), null, "script");
    return false;
  });
  $("table.index tr").live("click", function(e) {
    if (e.metaKey) {
      var newWindow = window.open($('a', this).attr('href'));
      newWindow.focus();
    } else {
      document.location = $('a', this).attr('href');
    }
    return false;
  });
});

function downloadAlbum(link) {
  if ( pageTracker ) {
    pageTracker._trackPageview('/downloads/album');
  }

  dl_href = link.href
  if ( document.all ) {
    document.getElementById('album_link').innerText = 'Your Album is Now Downloading!';
  } else {
    document.getElementById('album_link').textContent = 'Your Album is Now Downloading!';    
  }
  document.getElementById('album_link').className = 'downloading';
  document.location = link.href;
}


function downloadTrack(link) {
  if ( pageTracker ) {
    pageTracker._trackPageview('/downloads/' + link.id);
  }
  
  dl_href = link.href
  li_id = link.id + '_li'
  track_name = link.textContent
  if ( document.all ) {
    document.getElementById(li_id).innerText = track_name + ': Now Downloading!';    
  } else {
    document.getElementById(li_id).textContent = track_name + ': Now Downloading!';        
  }
  document.getElementById(li_id).className = 'downloading';
  document.location = dl_href;
}

function recordOutboundLink(link, category, action) {
  try {
    var myTracker=_gat._getTrackerByName();
    _gaq.push(['myTracker._trackEvent', ' + category + ', ' + action + ']);
    setTimeout('document.location = "' + link.href + '"', 100)
  }catch(err){}
}
