module Nmax
  class StreamDigitScanner
    NUMBERS    = '0'..'9'
    REGEX      = /\d+/
    READ_LIMIT = 2000 # bytes

    def initialize(stream)
      @stream         = stream
      @previous_chunk = ''
    end

    def scan(&block)
      while chunk = next_chunk
        scan_chunk(chunk).each(&block)
      end
      scan_chunk('').each(&block)
    end

    def scan_chunk(chunk)
      matches = (@previous_chunk + chunk).scan(REGEX)
      if NUMBERS.cover? chunk[-1]
        @previous_chunk = matches.pop
      else
        @previous_chunk = ''
      end
      matches
    end

    def next_chunk
      return nil if @stream.eof?
      @stream.read(READ_LIMIT)
    end
  end
end
