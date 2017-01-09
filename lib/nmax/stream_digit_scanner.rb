module Nmax
  class StreamDigitScanner
    NUMBERS = '0'..'9'
    REGEX   = /\d+/

    def initialize(stream)
      @stream         = stream
      @previous_chunk = ''
    end

    def scan(&block)
      while chunk = next_chunk
        scan_chunk(chunk).each(&block)
      end
    end

    def scan_chunk(chunk)
      matches = chunk.scan(REGEX)
      if NUMBERS.cover? @chunk[-1]
        set_chunk_part(matches.pop)
      end
      matches
    end

    def next_chunk
      @chunk = @previous_chunk + @stream.read(10).to_s
      puts "buffer is now: #{@chunk.inspect}"
      @previous_chunk = ''
      return nil if @chunk.empty?
      @chunk
    end

    def set_chunk_part(part)
      @previous_chunk = part
    end
  end
end
