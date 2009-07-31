require 'pp'
require 'cgi'
require 'open-uri'
require 'rubygems'
require 'json'

module Google
  class News
    TARGET_URL = "http://ajax.googleapis.com/ajax/services/search/news?v=1.0&ned=es&hl=es&q={topic}"
    attr_accessor :url
  
    def self.search_for_topic(topic)
      url = build_query_url(topic)
      content = open(url).read
      results = get_results(JSON.parse(content))
      return results
    end
    
    def images
      []
    end
    
    private
    def initialize(result)
      self.url = result['unescapedUrl']
    end
  
    def self.get_results(results)
      results['responseData']['results'].collect { |result|
        News.new(result)
      }
    end
  
    def self.build_query_url(topic)
      TARGET_URL.gsub(/\{topic\}/, CGI.escape(topic))
    end
  end
  
  class NewsRTVE < News
    def self.build_query_url(topic)
      super("site:rtve.es #{topic}")
    end
  end
end

module Twitter
  class TrendingTopics
    TARGET_URL = "http://search.twitter.com/trends/weekly.json?exclude=hashtags"
    def self.get_topics
      content = open(TARGET_URL).read
      result = extract_terms(JSON.parse(content))
      return result
    end
    
    private
    def self.extract_terms(result)
      topics = []
      result['trends'].values.flatten.each do |topic|
        topics << topic['name']
      end
      return sort_topics(topics)
    end
    
    def self.sort_topics(topics)
      result = {}
      topics.each do |topic|
        result[topic] ||= 0
        result[topic] += 1
      end
      return result.to_a.sort { |a, b| b[1] <=> a[1] }.collect {|topic, number| topic}
    end
  end
end

module Yahoo
  class News
    TARGET_URL = "http://boss.yahooapis.com/ysearch/web/v1/{TARGET_URL}?format=json&view=keyterms&start=0&count=10&appid=EfbpGbHV34EsqAafBVlzjbsQdwPtKJJUspHE7QiHxtxrX4PvCl1eYTj1t9QNpDgAfhjIg1I-&abstract=long"
    attr_accessor :title, :abstract, :terms, :url
    
    def self.get_related_news(topic, url)
      query_url = build_query_url(url)
      content = open(query_url).read
      candidates = get_results(JSON.parse(content))
      return candidates.find_all { |candidate| candidate.terms.grep(/#{topic}/).any? and candidate.url.include?("rtve.es") }
    end
    
    private
    def initialize(result)
      pp result
      self.title = result['title']
      self.abstract = result['abstract']
      self.terms = result['keyterms']['terms'] || []
      self.url = result['url']
    end
    
    def self.get_results(response)
      response = response['ysearchresponse']
      raise "connection failed" if response['responsecode'] != "200"
      (response['resultset_web'] || []).collect { |result|
        self.new(result)
      }
    end

    def self.build_query_url(url)
      TARGET_URL.gsub(/\{TARGET_URL\}/, CGI.escape(url))
    end
    
    def to_json
      {
        :title => self.title,
        :abstract => self.abstract,
        :url => self.url,
        :terms => self.terms
      }.to_json
    end
  end
  
  class NewsRTVE < News
    YQL_IMG_EXTRACT = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20html%20where%20url%3D'{URL}'%20and%20xpath%3D'%2F%2Fbody%5B%40id%3D%22noticias%22%5D%2Fdiv%5B%40id%3D%22wrapper%22%5D%2Fdiv%5B2%5D%2F%2Fimg%5B%40title%5D'%20limit%203&format=json"

    def images
      url = YQL_IMG_EXTRACT.gsub(/\{URL\}/, CGI.escape(self.url))
      results = JSON.parse(open(url).read)['query']['results']
      if results
        [results['img']].flatten.collect {|img| img['src'] = "http://www.rtve.es#{img['src']}"; img }
      else
        []
      end
    end
    
    def abstract=(value)
      @abstract = value.split("<b>...</b>").first;
    end
    
    def title=(value)
      @title = value.sub(%r{ - <b>RTVE.es</b>}, '')
    end
    
    def to_json
      {
        :title => self.title,
        :abstract => self.abstract,
        :url => self.url,
        :terms => self.terms,
        :images => self.images
      }.to_json
    end
  end
end


result = []
Twitter::TrendingTopics.get_topics.each do |topic|
  possible_news = Google::NewsRTVE.search_for_topic(topic)
  news = []
  possible_news.each do |gnews|
    news << Yahoo::NewsRTVE.get_related_news(topic, gnews.url)
  end
  news.flatten!
  result << {:trend => topic, :news => news} if news.any?
end

puts result.to_json

