// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $("#donors th a, #donors .pagination a, #books th a, #books .pagination a").live("click", function() {
    $.getScript(this.href);
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
});


function downloadAction(link) {
  document.location = link.href
  document.getElementById('album_link').innerText = 'Your Album is Now Downloading!';
  document.getElementById('album_link').className = 'downloading'
}