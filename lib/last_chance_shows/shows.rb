#Show scraper for all the shows that are closing soon
class LastChanceShows::Shows

  attr_accessor :title, :venue, :closing, :url

  def self.closings
    self.scrape_closings
  end

  def self.scrape_closings
    doc = Nokogiri::HTML(open("http://www.playbill.com/article/last-chance-schedule-of-upcoming-broadway-and-off-broadway-show-closings"))
    shows = []

    #all the elements in the .bsp-article-content class
    elements = doc.css(".bsp-article-content").children

    #index counter for keeping track of the 'Closing..' <h2>'s
    closing_i = 0

    #find relevant Show Class information by iterating through each element in css class '.bsp-article-content'
    elements.each_with_index do |element, i|

      #capture and index for each 'Show Closing' date
      if element.name == "h2"
        closing_i = i
      end

      #find the <p>'s that contain show information based on current site format (2/26/2018)
      if element.name == "p" && closing_i > 0 && !(element.text.include?("To purchase")) && element.children[0].name == "u"

        #for each new show create a show class
        show = self.new

        #assign title based on text in first child of <p>
        show.title = element.children[0].text

        #assign closing based on text in the last <h2> field
        show.closing = elements[closing_i].text

        #assign venue based on second child of <p>, but if it contains links continue to capture venue until a <br>
        venue_i = 2
        venue = ""
        until element.children[venue_i].name == "br"
          venue += element.children[venue_i].text
          venue_i += 1
        end
        show.venue = venue

        #create show url based on current site url system (2/26/2018) ***Must happen after show.title is assigned
        s_url = "http://www.playbill.com/searchpage/search?q="
        title_parse = show.title.split(" ")
        title_parse.each do |word|
          if word.length > 2
            s_url += word + "+"
          end
        end
        s_url.chomp("+")
        s_url = s_url + "&sort=Relevance&shows=on&qasset="
        linkpage = Nokogiri::HTML(open(s_url))
        show_links = linkpage.css(".bsp-list-promo-title a")
        show_i = 0
        found = false

        show_links.each do |item|
          #this is a temporary if statement for a show currently on the website that has a formatting error
          #this should be removed in subsequent updates and a better fix for formatting errors should be concieved
          if item.text.match(/[\u007B-\u00BF\u02B0-\u037F\u2000-\u2BFF]/)
            if item.text.strip.length - 11 == show.title.length && item.text.strip[-5..-2].to_i >= Time.now.year - 30
              show.url = "http://www.playbill.com" + item["href"]
            end
          end

          #check to see if the searched for link matches the shows title
          if item.text.strip.length - 7 == show.title.length && item.text.strip[-5..-2].to_i >= Time.now.year - 30
            show.url = "http://www.playbill.com" + item["href"]
          end
        end

        #add show to show array
        shows << show
      end
    end

    #return shows
    shows
  end

end
