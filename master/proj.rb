# 99 Bottles of beer, in Ruby
# Modified by Aaron Fleming and Zane Markel

################################################################################
# DEFINITIONS
################################################################################

class Integer # The lines
    # create an Instance method that increases remaining by between 1 and 10
    def printlns
        # Only allow a random number that does not result in the specified end 
        #point being exceeded
        remaining = $total_lines - self
        self + (remaining < 10 ? rand(remaining) + 1 : rand(10) + 1)
    end
end

# Creates an instance of Object, named 'song', and opens up a singleton class.
class << song = nil

    # Takes an integer and returns a string of its prime factors
    def prime_fact(num)
        num = num.to_i
        facts = [] # list of prime factors of num

        # For efficiency, we divide by two on its own
        # That way, we only have to check odd numbers for future prime factors
        while num % 2 == 0 do
            facts << 2
            num = num./(2)
        end

        lower = 3
        while lower <= ( num / 2 ) do
            while num % lower == 0 do
                facts << lower
                num = num./(lower)
            end
            lower += 2
        end
        if num != 0 and num != 1
            facts << num
        end
        
        # Construct the string from the list of prime factors
        '(' + facts.join('*') + ')'
    end

    # defines :screen symbol and allows it to be accessed from outside of class
    attr_accessor :screen 

    # Returns a string with the prime factored number of lines accumulated,
    # plus either ' line' (if there is 1 line) or ' lines'
    def lines
        prime_fact(@lines) << " line" << ("s" unless @lines == 1).to_s
    end

    # Define the function 'of(lines)'
    def of(lines)
        # Create and set the value of lines 
        # (value is specified in the call to 'callcc')
        # Note: @lines is an instance variable (inside the song singleton class)
        # lines is the argument to the function
        @lines = lines 

        # Opens the classes singleton class and defines a new method called 
        # ':end' that returns the number of lines that is initially specified 
        # in the block of the 'callcc' command.
        # This class, with the new method, is returned.
        (class << self; self; end).module_eval do
            define_method(:end) { lines * 110}
        end
        self # of returns itself
    end


    # sing generates the multi-line "song" that will be both printed to stdout
    # and written to out.txt
    def sing(&step) # '&step' takes the block { |lines| lines.printlns }
                    # Used this way, the value acessible inside 'sing()' when 
                    #'step' is referenced is a number (<= initial number 
                    #specified). 

        $output << "#{lines} of text on the screen, #{lines} of text.\n"

        tmp = @lines
        @lines = step[@lines]

        # Get a string of the factored number of lines remaining
        factorednum = prime_fact(@lines - tmp)

        # Check if we've reached the desired number of lines
        if @lines == $total_lines
            $output << "Print #{factorednum} out, stand up and shout, "
            # Setting 'step' to be the method :end will cause the :end function
            # to be called once and then end the program, rather than executing
            # 'screen.call()' again and decrementing the number of lines.
            step = method :end
        else
            $output << "Print #{factorednum} out, stand up and shout, "
        end

    $output << "#{lines} of text on the screen.\n"

    # Print a newline and execute 'screen.call' continuation if 'step' is not a 
    # method (i.e. as long as it's a number and not :end)
    ($output << "\n") and screen.call unless step.kind_of? Method

    end

end

# Prints the "song" in $output to the ostream (either STDOUT or out.txt)
# Then prints either "Screen finished" or "File finished" to STDERR.
# This function comprises one entire thread
def print_results(ostream, finishstr)

    linecnt = 0 # used to tell if at end of stanza
    $output.each_line do |line|

    # If it's the end of a stanza and ostream is stdout, then sleep
    if STDOUT == ostream and (linecnt % 3 == 0) # Each stanza is 3 lines
        sleep(1)
    end

    ostream.write(line)
    linecnt += 1 
    end

    # This line marks the end of the thread
    STDERR.write("#{finishstr} finished\n")
end


################################################################################
# BEGINNING OF CODE EXECUTION 
################################################################################

# Open the global out.txt
$outf = File.open("out.txt", "w")

# Prompt for how many lines
puts "How many lines? "
STDOUT.flush
$total_lines = gets.chomp.to_i

# global $output will contain a multi-line string comprising the song's contents
$output = ''

# Call the "Bottles of Beer" song
# Which puts the song string in $output
callcc { |song.screen| song.of(1) }.sing{ |lines| lines.printlns }

# Call threads to write the song to STDOUT and to output.txt
t1 = Thread.new{print_results(STDOUT, 'Screen')}
t2 = Thread.new{print_results($outf, 'File')}
t1.join
t2.join

# Housekeeping
$outf.close

