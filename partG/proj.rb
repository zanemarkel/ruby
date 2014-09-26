#!/usr/bin/ruby
### Parts A-G
# 99 Bottles of beer, in Ruby
# By Victor Borja, Sep 14, 2006
# This one shows my favorite Ruby features:
#   continuations, open classes, singleton classes, blocks and being funny!

class Integer # The bottles
  # create an Instance method that lowers number of bottles by 1
  def drink
    #$increment = ( rand(10) + 1)
    #self + $increment
    
    # Only allow a random number that does not result in the specified end point being exceeded
    self + ($remaining < 10 ? rand($remaining) + 1 : rand(10) + 1)
  end
  #def drink; self - 1; end
end

# Creates an instance of Object, named 'song', and opens up a singleton class.
#    Adds defines the symbol ':wall' and makes it accessible.
class << song = nil
  # Other ways to do this
  #1) song = nil
  #   class << song

  #2) class song
  attr_accessor :wall # defines :wall symbol and allows it to be accessed from outside of class

  # Defines the function 'bottles()'
  def bottles
    # If @bottles == 0,then return "no more", otherwise return the num bottles as a string 
    (@bottles.zero? ? "no more" : @bottles).to_s <<
      # Append " bottle" and if @bottles != 1, append an 's' to the end
      " line" << ("s" unless @bottles == 1).to_s
  end
  
  # Define the function 'of(bottles)'
  def of(bottles)
    # Create and set the value of bottles (value is specified in the call to 'callcc')
    @bottles = bottles # @bottles is an instance variable (inside the song singleton class), bottles is the argument to the function
    
    # Opens the classes singleton class and defines a new method called ':buy' that returns 
    #   the number of bottles that is initially specified in the block of the 'callcc' command.
    #  	This class, with the new method, is returned.
    (class << self; self; end).module_eval do
      #define_method(:buy) { bottles }
      define_method(:buy) { bottles * 110}
    end
    self
  end

  
  def sing(&step)# '&step', the block { |beer| beer.drink }, is converted to a Proc object, which is assigned to the parameter.
    #    Used this way, the value acessible insude 'sing()' when 'step' is referenced is a number (<= initial number
    #	  specified). However, when 'step' == 0, 'step = method :buy' gets executed, changing 'step' into the method ':buy'.
    #	  When this happens, 'sing()' does 
    if Integer === bottles
      puts "#{prime_fact(bottles)} of text on the screen, #{prime_fact(bottles)} of text."
    else
      # Capitalize the first bottles in case bottles == 'no more'
      puts "#{bottles.capitalize} of text on the screen, #{bottles} of text." 
    end

    #if @bottles.zero?
    tmp = @bottles
    @bottles = step[@bottles]
    #puts ""
    #puts "tmp = #{tmp}"
    #puts "@bottles = #{@bottles}"
    #puts "step[tmp] = #{step[tmp]}"
    #puts "step[@bottles] = #{step[@bottles]}"
    #puts "step[@bottles] = #{step[@bottles]}"
    #puts "step[@bottles] = #{step[@bottles]}"
    #puts ""
    if @bottles >= $total_iterations #100
      #print "Go to the store buy some more, "
      print "Print #{@bottles - tmp} out, stand up and shout, "
      # Setting 'step' to be the method :buy will cause the :buy function to be called once and then end the program, rather than 
      #   executing 'wall.call()' again and decrementing the number of bottles.
      step = method :buy
    else
      print "Print #{@bottles - tmp} out, stand up and shout, "
    end
    #@bottles = step[@bottles] # Equivalent to step.call(@bottles) --> jumps back up to the 'sing()' method with @bottles as the argument
    puts "#{prime_facts(bottles)} of text on the screen."
    # Pause for 1 second after printing out each stanza, for "dramatic effect"
    sleep(1)
    
    $remaining = $total_iterations - @bottles
    # Print a newline and execute 'wall.call' continuation if 'step' is not a method (i.e. as long as it's a number and not :buy)
    #   Uses 'or' instead of 'and' because 'puts()' always returns nil and would shortcircuit, preventing the 'wall.call()'
    puts "" or wall.call unless step.kind_of? Method
  end
end

  def prime_fact(num)
    facts = []
	while num % 2 == 0 do
      facts << 2
      num = num./(2)
	end

	lower = 3
	while lower <= num/2 do
      while num % lower == 0 do
        facts << lower
        num = num./(lower)
	  end
      lower += 2
	end
    if num != 0 and num != 1
      facts << num
    end
  '(' + facts.join('*') + ')'
  #facts
end


  

  print "How many lines? "
  STDOUT.flush
  $total_iterations = gets.chomp.to_i
  $remaining = $total_iterations
  puts "User entered #{$total_iterations}"
  puts "The factors of #{$total_iterations} are #{prime_fact($total_iterations)}"
  # Call the Bottles of Beer song, starting with 15 bottles on the wall
  #callcc { |song.wall| song.of(1) }.sing { |beer| beer.drink }
