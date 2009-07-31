google.load("jquery", "1");

function getNewItemBlock(data) {
	var trend = data.trend;
	var imgs = selectImages(data);
	var contentBlock =	'<div class="item"> \
				<span class="itemlink">\
		    		<span class="title"><a href="#">' + trend + ' ('+data.news.length+' noticias)</a></span>\
					<div class="img">';
	for(var i = 0; i < imgs.length; i++) {
		contentBlock += '<img alt="'+imgs[i][0]+'" src="'+imgs[i][1]+'" width="90" height="60">';
	}				
	contentBlock += '</div></span>\
					<div class="news">';
	
	for(var i = 0; i < data.news.length; i++) {
		var title = data.news[i].title;
		var abstract = data.news[i].abstract;
		var url = data.news[i].url;
		contentBlock += '<a class="newslink" href="'+url+'" title="'+title+'"><div class="newsitem">\
			<span class="newstitle">'+title+'</span><div class="subtitle">'+abstract+'</div>\
			</div></a>';
	}
	
	contentBlock += '</div>\
		</div>';
	
	return contentBlock;	
}

function selectImages(data) {
	var count = 0;
	var imgs = new Array();
	for(var i = 0; i < data.news.length & count < 3; i++) {
		for(var j=0; j < data.news[i].images.length & count < 3; j++) {
			var details = [data.news[i].images[j].alt, data.news[i].images[j].src];
			imgs.push(details);
			count++;
		}
	}
	return imgs;
}

function showLoading() {
	$('#content').append("<div class='message'>please wait, loading...</div<div id='loading'> </div>");
}

function addAnimations() {
	$(".itemlink").click(function (event) {
		var parent = $(this).parent();
		var children = parent.children(".news");
		children.toggle('slow');
		return false;
	});
}

function scaleImages() {
	// TODO
}



// ########### main piece ####

  // on page load complete, fire off a jQuery json-p query
  // against Google web search
  google.setOnLoadCallback(function() {
	showLoading();
    $.getJSON("http://trendnews.info/rtve/sample.txt?callback=?",
      // on search completion, process the results
      function (topics) {
		var contentBlock = '';
		for(var i = 0; i < topics.length; i++) {
			contentBlock +=	getNewItemBlock(topics[i]);
		}
		$("#content").html(contentBlock);
		$(".news").hide();
		addAnimations();
		scaleImages()
      });
    });


