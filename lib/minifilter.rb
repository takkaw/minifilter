require 'minitest/unit'
require 'ostruct'
# minitest output formatter and colorizer

# monkey pache for MiniTest::Unit.output is not exist.
module MiniTest
  class Unit
    def self.output
      @@out
    end
  end
end

# MiniFilter 
module MiniFilter
  # ansi color codes
  COLORS = OpenStruct.new(
    :red     => "\e[31m",
    :green   => "\e[32m",
    :yellow  => "\e[33m",
    :blue    => "\e[34m",
    :magenta => "\e[35m",
    :cyan    => "\e[36m",
    :clear   => "\e[0m"
  )
 
  class << self
    @@filters = []
    
    # regist block argument.
    def register(&block)
      @@filters << block
    end

    # for debugging
    def register!(&block)
    end

    def filter o
      @@filters.each{ |f| o = f.call(o) }
      o
    end

    # print after filter.
    def print o
      @@io.print filter(o)
    end
    private :filter

    # puts after filter.
    def puts(o='')
      o = filter(o.chomp)
      @@io.puts o if o
    end

    def method_missing msg, *args
      @@io.send(msg, *args)
    end
    private :method_missing

  end

  @@io = MiniTest::Unit.output
  MiniTest::Unit.output = self
end

