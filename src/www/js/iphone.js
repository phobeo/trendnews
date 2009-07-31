var Results;

function headerNews(news) {
  return $("<div id='header'><h1>"+news.trend+"</h1><a href='#' id='backButton' onclick='loadResultList();'>Back</a><</div>");
}

function loadNews(news_id) {
  var news = Results[news_id];
  var content = $("#content");
  content.text("");
  headerNews(news).appendTo(content);
  $("<h1>"+news.trend+"</h1>").appendTo(content);
  content.append("<ul class='data'></ul>");
  $.each(news.news, function(i, heading){
    $("ul").append("<li onclick='Device.safari(\""+heading.url+"\");'><p><em><strong>"+heading.title+"</strong></em></p><p>"+heading.abstract+"</p><p><a href='#' onclick='Device.safari(\""+heading.url+"\");'>leer más</a></p></li>");
  });
}

function loadResultList() {
  var content = $("#content");
  content.text("");
  $("<div id='header'><h1>Últimas noticias</h1></div>").appendTo(content);
  $("<h1>Trending topics</h1>").appendTo(content);
  content.append("<ul></ul>");
  $.each(Results, function(i, topic) {
    $("ul").append("<li class='arrow'><small>"+topic.news.length+"</small><a href='#' onclick='loadNews("+i+");'>"+topic.trend+"</a><a href='#' onclick='loadNews("+i+");'>"+topic.news[0].title+"</a></li>");
  });
}

function DeviceLoad() {
  var url = "/rtve/sample.txt";
  $.getJSON(url, function(data) {
    Results = data;
    loadResultList();
  });
}

window.onload = function() {
  Device.start(DeviceLoad);
}
