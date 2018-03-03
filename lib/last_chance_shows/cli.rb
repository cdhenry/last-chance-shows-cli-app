#CLI Controller
class LastChanceShows::CLI
  def call
    LastChanceShows::Scraper.make_shows
    puts "It's your last chance to see these Broadway/Off-Broadway shows in New York City!"
    list_shows
    menu
    goodbye
  end

  def all_shows
    LastChanceShows::Show.all
  end

  def list_shows
    puts ""
    all_shows.each.with_index(1) do |show, i|
      puts "#{i}. #{show.title}"
      puts "     #{show.venue} // #{show.closing}"
      if i % 10 == 0
        puts "Press Enter to continue listings.  There are #{all_shows.length} shows in total."
        gets
      end
    end
  end

  def menu
    input = nil
    while input != "exit"
      puts "Enter the number of the show you'd like more info on or type 'list' to see the shows again or type 'exit':"
      input = gets.strip.downcase

      if input.to_i > 0 && input.to_i <= all_shows.length
        more_info(input.to_i-1)
      elsif input == "list"
        list_shows
      end
    end
  end

  def more_info(show_index)
    puts ""
    puts "#{all_shows[show_index].title} :: #{all_shows[show_index].blurb}"
    puts ""
    puts "     " + all_shows[show_index].schedule
    puts ""
    puts "     " + all_shows[show_index].run_time
    puts ""
    puts "     For more information go to :: " + all_shows[show_index].venue_url
    puts ""
  end

  def goodbye
     puts "Have a great time, and check back again soon before more shows you want to see close!"
  end
end
