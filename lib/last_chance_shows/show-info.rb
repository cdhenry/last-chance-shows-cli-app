#Individual show information scraper
class LastChanceShows::Show
  attr_accessor :blurb, :schedule, :run_time, :theater_url
  attr_reader :url

  def self.info(url)
    self.scrape_info(url)
  end

  def self.scrape_info(url)
    doc = Nokogiri::HTML(open(url))
    info = doc.css(".bsp-bio-text").text.strip
    last = info.length
    show = self.new

    #search for where 'schedule' or 'show times' are printed and format text accordingly
    if info.include?("SCHEDULE")
      blurb_i = info.index /[.]\S/
      schedule_i = info.index("SCHEDULE")
      show.blurb = info[0..blurb_i]
      if show.blurb.include?("SYNOPSIS:")
        show.blurb.gsub!("SYNOPSIS: ", "")
      end
      show.schedule = info[schedule_i..last]
    elsif info.include?("Show Times")
      blurb_i = info.index /[.]\S/
      schedule_i = info.index("Show Times")
      last_i = info.index("Tickets") - 1
      show.blurb = info[0..blurb_i]
      if show.blurb.include?("SYNOPSIS:")
        show.blurb.gsub!("SYNOPSIS: ", "")
      end
      show.schedule = info[schedule_i..last_i]
    end

    #find where run time is listed
    list = doc.css(".bsp-bio-primary-list")
    if list.children[1].text.strip.include?("Running")
      show.run_time = list.children[1].text.strip
    else
      show.run_time = "Run Time Unavailable"
    end

    #get the theater url from a level deeper
    if doc.css(".bsp-bio-subtitle")[0].text.include?("Off-Broadway")
      last_link = doc.css(".bsp-bio-text a").length - 1
      show.theater_url = doc.css(".bsp-bio-text a")[last_link]["href"]
    else
      show.theater_url = doc.css(".bsp-bio-social-links a")[0]["href"]
    end

    show
  end

end
