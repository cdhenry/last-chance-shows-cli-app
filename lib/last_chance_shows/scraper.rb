class LastChanceShows::Scraper

  def self.get_page
    Nokogiri::HTML(open("http://www.playbill.com/article/last-chance-schedule-of-upcoming-broadway-and-off-broadway-show-closings"))
  end

  def self.get_shows
    self.get_page.css(".bsp-article-content").children #all the elements in the .bsp-article-content class
  end

  def self.make_shows
    closing_i = 0   #index counter for keeping track of the 'Closing..' <h2>'s
    self.get_shows.each_with_index do |element, i| #find shows and closings by iterating through each child of '.bsp-article-content'
      if element.name == "h2" #capture and index for each 'Show Closing' date
        closing_i = i
      end

      if element.name == "p" && closing_i > 0 && !(element.text.include?("To purchase")) && element.children[0].name == "u" #find the <p>'s that contain show information based on current site format (2/26/2018)
        title = element.children[0].text #assign title based on text in first child of <p>
        closing = self.get_shows[closing_i].text #assign closing based on text in the last <h2> field
        url = self.make_show_url(title) #assign url based on title

        LastChanceShows::Show.new(title, closing, url) unless self.closing_to_date(closing) < Date.today
      end
    end
  end

  def self.make_search_url(title)
    search_url = "http://www.playbill.com/searchpage/search?q="
    title_parse = title.split(" ")
    title_parse.each do |word|
      if word.length > 2
        search_url += word + "+"
      end
    end
    search_url.chomp("+")
    search_url = search_url + "&sort=Relevance&shows=on&qasset="
  end

  def self.make_show_url(title)
    linkpage = Nokogiri::HTML(open(make_search_url(title)))
    show_links = linkpage.css(".bsp-list-promo-title a")

    show_links.each do |item|
      #this is a temporary if statement for a show currently on the website that has a formatting error
      #this should be removed in subsequent updates and a better fix for formatting errors should be concieved
      if item.text.match(/[\u007B-\u00BF\u02B0-\u037F\u2000-\u2BFF]/)
        if item.text.strip.length - 11 == title.length && item.text.strip[-5..-2].to_i >= Time.now.year - 30
          return "http://www.playbill.com" + item["href"]
        end
      end

      #check to see if the searched for link matches the shows title
      if item.text.strip.length - 7 == title.length && item.text.strip[-5..-2].to_i >= Time.now.year - 30
        return "http://www.playbill.com" + item["href"]
      end
    end
  end

  def self.closing_to_date(closing)
    day = Date::DAYNAMES.detect{|d| closing.include?(d)}
    month = Date::MONTHNAMES.detect{|m| closing.include?(m) unless m == nil}
    month_integer = Date::MONTHNAMES.index(month)
    day_integer = closing.gsub(",", "").gsub("Closing", "").gsub(day, "").gsub(month, "").strip[0..1].strip.to_i
    year_integer = closing.gsub(",", "").gsub("Closing", "").gsub(day, "").gsub(month, "").strip[-4..-1].strip.to_i
    Date.new(year_integer, month_integer, day_integer)
  end

  #
  #   closing_i = 0 #index counter for keeping track of the 'Closing..' <h2>'s
  #   #find relevant Show Class information by iterating through each element in css class '.bsp-article-content'
  #   elements.each_with_index do |element, i|
  #     if element.name == "h2"   #capture and index for each 'Show Closing' date
  #       closing_i = i
  #     end
  #     #find the <p>'s that contain show information based on current site format (2/26/2018)
  #     if element.name == "p" && closing_i > 0 && !(element.text.include?("To purchase")) && element.children[0].name == "u"
  #
  #
  #   binding.pry
  # end

end
