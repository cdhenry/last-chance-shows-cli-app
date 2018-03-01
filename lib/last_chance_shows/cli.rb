#CLI Controller
class LastChanceShows::CLI

  def call
    puts "It's your last chance to see these Broadway/Off-Broadway shows in New York City!"
    list_shows
    menu
    goodbye
  end

  def list_shows
    @shows = LastChanceShows::Shows.closings
    @shows.each.with_index(1) do |show, i|
      puts "#{i}. #{show.title}"
      puts "     #{show.venue} // #{show.closing}"
    end
  end

  def menu
    input = nil
    while input != "exit"
      puts "Enter the number of the show you'd like more info on or type 'list' to see the shows again or type 'exit':"
      input = gets.strip.downcase

      if input.to_i > 0 && input.to_i <= @shows.length
        more_info(@shows[input.to_i - 1].url, @shows[input.to_i - 1].title)
      elsif input == "list"
        list_shows
      end
    end
  end

  def more_info(input_url, input_title)
    show = LastChanceShows::Show.info(input_url)
    puts ""
    puts "A little bit about #{input_title} :: "
    puts ""
    puts "     " + show.blurb
    puts ""
    puts "     " + show.schedule
    puts ""
    puts "     " + show.run_time
    puts ""
    puts "     For more information go to :: " + show.theater_url
    puts ""
  end

  def goodbye
     puts "Have a great time, and check back again soon before more shows you want to see close!"
  end
end
