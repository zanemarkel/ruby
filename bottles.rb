# 99 Bottles of beer, in Ruby
# By Victor Borja, Sep 14, 2006
# This one shows my favorite Ruby features:
#   continuations, open classes, singleton classes, blocks and being funny!

class Integer # The bottles
  # create an Instance method that lowers number of bottles by 1
  #def drink; self + 1; end
  def drink; self - 1; end
end

# creates an instance of Object, named 'song', and opens up a singleton class
class << song = nil
# other ways to do this
#1) song = nil
#   class << song

#2) class song
  attr_accessor :wall # defines :wall symbol and allows it to be accessed from outside of class

  # defines the function 'bottles()'
  def bottles
    # if @bottles == 0,then return "no more", otherwise return the num bottles as a string 
    (@bottles.zero? ? "no more" : @bottles).to_s <<
      # append " bottle" and if @bottles != 1, append an 's' to the end
      " bottle" << ("s" unless @bottles == 1).to_s
  end
  
  # define the function 'of(bottles)'
  def of(bottles)
    @bottles = bottles
    (class << self; self; end).module_eval do
      define_method(:buy) { bottles }
    end
    self
  end
  
  def sing(&step)
    puts "#{bottles.capitalize} of beer on the wall, #{bottles} of beer."
    if @bottles.zero?
      print "Go to the store buy some more, "
      step = method :buy
    else
      print "Take one down and pass it around, "
    end
    @bottles = step[@bottles]
    puts "#{bottles} of beer on the wall."
    puts "" or wall.call unless step.kind_of? Method
  end

end

callcc { |song.wall| song.of(15) }.sing { |beer| beer.drink }
