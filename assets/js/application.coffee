CrossRef =
  papers: []
  get_json: ->
    url = 'https://api.crossref.org/works?query.affiliation=Kavli+Institute+for+Theoretical+Physics&sort=published&order=desc&mailto=wolfwm@uwec.edu'
    $.ajax(url, ->

      $('#paper-list').html
    )
  getPapers: (institution, numPapers) ->
    query = this.query(institution, numPapers)
    $.get(query, CrossRef.addPapersContent)
  addPapersContent: xml ->
  content = $('<div class="row" id="crossref"><div class="col">' +
      '<a id="papers"></a><div class="card">' +
      '<div class="card-header"><h3 class="card-title">Recent Papers from ' +
      'KITP Scholars</h3></div><div class="card-content">'+
      '<ul class="list-group" id="papers-content">' +
      '</div><a href="#papers"><div class="card-footer text-center ' +
      'expandable"><span class="glyphicon glyphicon-chevron-down"></span>' +
      '</div></a></div></div></div>');
    content.insertAfter('#insert-here');
    $('.expandable').click(Arxiv.toggleExtraPapers);

    # initially only show this many papers, make others visible via dropdown
    displayNum = 3;
    papersDisplayed = 0;

    # individual papers are wrapped in <entry></entry>, so find each of those
    # and iterate through them to extract paper details
    $(xml).find('entry').each(function() {
      var title = $(this).find('title').text();
      var author = '';
      $(this).find('author').each(function() {
        author = author + $(this).find('name').text() + ', ';
      });
      // remove trailing comma and space
      author = author.substring(0, author.length - 2);
      var url = $(this).find('id').text();
      var toAdd;
      if (papersDisplayed >= displayNum) {
        toAdd = $('<a href=' + url + ' class="list-group-item paper toggle">' +
          '<h4>' + title + '</h4>' + author + '</a>');
      } else {
        toAdd = $('<a href=' + url + ' class="list-group-item paper"><h4>' +
          title + '</h4>' + author + '</a>');
      }
      toAdd.appendTo('#papers-content')
      papersDisplayed += 1
    });
    return content;

  setup: ->
    CrossRef.papers = CrossRef.get_json
