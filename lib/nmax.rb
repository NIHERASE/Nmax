require 'rbtree'
require 'nmax/version'
require 'nmax/stream_digit_scanner'
require 'nmax/top_n'

module Nmax
  StringNumberComparsionProc = proc do |a, b|
    next a.size <=> b.size if a.size != b.size
    a <=> b
  end

  def self.in_stream(stream, n)
    top = TopN.new(n, &StringNumberComparsionProc)

    StreamDigitScanner.new(stream).scan do |i|
      top << i
    end

    top
  end
end
