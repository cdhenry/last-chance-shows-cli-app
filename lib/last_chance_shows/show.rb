class LastChanceShows::Show

  attr_accessor :title, :closing, :url, :venue, :blurb, :schedule, :run_time, :venue_url, :doc, :info

  @@all = []

  def initialize (title, closing, url)
    @title = title
    @closing = closing
    @url = url
    @@all << self
  end

  def self.all
    @@all
  end

  def self.find(id)
    self.all[id-1]
  end

  def doc
    @doc = Nokogiri::HTML(open(url))
  end

  def info
    @info = doc.css(".bsp-bio-text").text.strip
  end

  def venue
    @venue = doc.css(".bsp-bio-links a")[0].text.strip
  end

  def blurb
    blurb_i = info.index(/[.]\S/)
    text = info[0..blurb_i]

    if text.include?("SCHEDULE") || text.include?("Show Times")
      blurb_i = info.index("SCHEDULE") || info.index("Show Times")
      blurb_i -= 1
      text = info[0..blurb_i]
    end

    if text.include?("SYNOPSIS:")
      @blurb = text.gsub("SYNOPSIS:", "\n     SYNOPSIS:")
    else
      @blurb = text
    end
  end

  def schedule
    if info.include?("SCHEDULE")
      schedule_i = info.index("SCHEDULE")
      @schedule = info[schedule_i..info.length].gsub("SCHEDULE:", "SCHEDULE: ")
    elsif
      info.include?("Show Times")
      schedule_i = info.index("Show Times")
      last_i = info.index("Tickets") - 1
      @schedule = info[schedule_i..last_i]
    end
  end

  def run_time
    if doc.css(".bsp-bio-primary-list").children[1].text.strip.include?("Running")
      @run_time = doc.css(".bsp-bio-primary-list").children[1].text.strip
    else
      @run_time = "Run Time Unavailable"
    end
  end

  def venue_url
    if doc.css(".bsp-bio-subtitle")[0].text.include?("Off-Broadway")
      last_link = doc.css(".bsp-bio-text a").length - 1
      @venue_url = doc.css(".bsp-bio-text a")[last_link]["href"]
    else
      @venue_url = doc.css(".bsp-bio-social-links a")[0]["href"]
    end
  end

end
