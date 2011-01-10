// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

if (history && history.pushState) {

  $(function() {
    
    $(".index th a, .index .pagination a").live("click", function(e) {
      $.getScript(this.href);
      history.pushState(null, document.title, this.href);
      e.preventDefault();
    });

    $("#index_search input").keyup(function() {
      $.get($("#index_search").attr("action"), $("#index_search").serialize(), null, "script");
      history.replaceState(null, document.title, $("#index_search").attr("action") + "?" + $("#index_search").serialize());
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

    $(document).ready(function(){
      var localserver = document.location.hostname;
      // unfortunately misses if any uppercase used in link scheme
      $("a[href^=http://],a[href^=https://]")
        .not("a[href^=http://"+localserver+"]")
        .not("a[href^=http://www."+localserver+"]")
        .click(function(e){
            $(this).attr("target", "_blank");
            _gaq.push(['_trackEvent', 
                       'Outgoing Click',
                       $(this).attr("href"),
                       $(this).text()
                     ]);
            return true;
        });
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
  
  category = 'Downloads';
  action = 'album';

  try {
    _gaq.push(['_trackEvent', category, action]);
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
  
  category = 'Downloads';
  action = link.id;

  try {
    _gaq.push(['_trackEvent', category, action]);
    setTimeout('document.location = "' + dl_href + '"', 100)
  } catch(err) {}

}


function recordDonateButtonClick(page) {
  category = 'Donate';
  action = page;
  try {
    _gaq.push(['_trackEvent', category, action]);
  } catch(err) {}
}

