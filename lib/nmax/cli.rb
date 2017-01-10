module Nmax
  class CLI
    def self.start(argv)
      nmax = argv.fetch(0).to_i

      top = TopNArray.new(nmax)
      StreamDigitScanner.new(STDIN).scan do |i|
        top << i.to_i
      end

      puts top.to_a
    end
  end
end
