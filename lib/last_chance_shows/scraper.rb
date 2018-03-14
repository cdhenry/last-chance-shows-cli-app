class LastChanceShows::Scraper

  def get_page
    Nokogiri::HTML(open("http://www.playbill.com/article/last-chance-schedule-of-upcoming-broadway-and-off-broadway-show-closings"))
  end

  def get_shows
    get_page.css(".bsp-article-content").children #all the elements in the .bsp-article-content class
  end

  def make_shows
    closing_i = 0   #index counter for keeping track of the 'Closing..' <h2>'s
    print "Loading"
    get_shows.each_with_index do |element, i| #find shows and closings by iterating through each child of '.bsp-article-content'
      if element.name == "h2" #capture and index for each 'Show Closing' date
        closing_i = i
      end

      if element.name == "p" && closing_i > 0 && !(element.text.include?("To purchase")) && element.children[0].name == "u" #find the <p>'s that contain show information based on current site format (2/26/2018)
        title = element.children[0].text #assign title based on text in first child of <p>
        closing = get_shows[closing_i].text #assign closing based on text in the last <h2> field
        url = make_show_url(title) #assign url based on title
        print "."
        LastChanceShows::Show.new(title, closing, url) unless closing_to_date(closing) < Date.today
      end
    end
  end

  def make_search_url(title)
    search_url = "http://www.google.com/search?q=playbill+"
     title_parse = title.split(" ")
     title_parse.each do |word|
       if word.length > 2
         search_url += word + "+"
       end
     end
     search_url.chomp("+")
  end

  def make_show_url(title)
    google_page = Nokogiri::HTML(open(make_search_url(title)))
    links = google_page.css(".r a")
    long_show_link = find_show_link_long(links)
    link_end = long_show_link.index("&") - 1
    show_link = long_show_link[7..link_end]
  end

  def find_show_link_long(links)
    links.each do |link|
      if link["href"].include?"/production/"
        return link["href"]
      end
    end
  end

  def closing_to_date(closing)
    day = Date::DAYNAMES.detect{|d| closing.include?(d)}
    month = Date::MONTHNAMES.detect{|m| closing.include?(m) unless m == nil}
    month_integer = Date::MONTHNAMES.index(month)
    day_integer = closing.gsub(",", "").gsub("Closing", "").gsub(day, "").gsub(month, "").strip[0..1].strip.to_i
    year_integer = closing.gsub(",", "").gsub("Closing", "").gsub(day, "").gsub(month, "").strip[-4..-1].strip.to_i
    Date.new(year_integer, month_integer, day_integer)
  end

end
