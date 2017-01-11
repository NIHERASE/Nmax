module Nmax
  class CLI
    INFO_MESSAGE = %(
nmax outputs N largest numbers found in STDIN.
nmax accepts single argument N -- maximum count of numbers to show.
    )
    def self.start(argv)
      new(argv).run
    end

    def initialize(arguments)
      @arguments = arguments
      @nmax = nmax
    end

    def run
      top = TopNArray.new(@nmax)
      StreamDigitScanner.new(STDIN).scan do |i|
        top << i.to_i
      end

      puts "Top #{@nmax} largest numbers:"
      puts top.to_a
    end

    def nmax
      n = @arguments[0].to_i
      unless n > 0
        STDERR.puts INFO_MESSAGE
        exit(1)
      end
      n
    end
  end
end
