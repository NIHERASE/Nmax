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
      top = Nmax.in_stream(STDIN, nmax)

      puts "Top #{@nmax} largest numbers:"
      top.each { |n| puts n }
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
