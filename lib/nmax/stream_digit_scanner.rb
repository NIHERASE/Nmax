module Nmax
  class StreamDigitScanner
    NUMBERS    = '0'..'9'
    REGEX      = /\d+/
    READ_LIMIT = 400 * 1024 # Bytes

    def initialize(stream, read_limit = READ_LIMIT)
      @stream         = stream
      @previous_chunk = ''
      @read_limit     = read_limit
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
      return nil if @stream.closed? || @stream.eof?
      bytes = @stream.read(@read_limit)
      @stream.close if bytes.size < @read_limit

      bytes
    end
  end
end
