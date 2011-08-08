require 'minifilter'

### formatter

# shade loaded suite
MiniFilter.register { |o|
  /Loaded suite.*/ =~ o ? nil : o
}

# shade options
MiniFilter.register { |o|
  /options:.*/ =~ o ? nil : o
}

# report shorter
MiniFilter.register { |o|
  #/(Error:)|(Failure:)/ =~ o ? o.gsub(/(?!^)\n/ , "\n    ") : o
  o ? o.each_line.map { |line|
    /^    / =~ line ? nil : line
  }.join : o
}

# error location formatter
MiniFilter.register { |o|
  o.sub!($&,$1 + "\n" + "[" + $2 + "]:") if /^(.*)\[(.*)\]:/ =~ o
  o.sub(File.expand_path('.') ,'.') if o
}

### colorizer

# [.EF] colorizer
MiniFilter.register { |o|
  col = MiniFilter::COLORS
  case o
  when "."
    "#{col.green}.#{col.clear}"
  when "E","F"
    "#{col.red}#{o}#{col.clear}"
  else
    o
  end
}

# error messages colorizer
MiniFilter.register { |o|
  col = MiniFilter::COLORS
  case o
  when /^ *\d+\) Failure:/,/^ *\d+\) Error:/,/^ *\d+\) Skipped:/
    o.each_line.map.with_index { |x,i|
      "#{ i == 1 ? col.red : col.cyan }#{x}#{col.clear}"
    }.join
  else
    o
  end
}

# report colorizer
MiniFilter.register { |o|
  o ? o.each_line.map { |line|
    /^    / =~ line ? nil : line
  }.join : o
}

# status colorizer
MiniFilter.register { |o|
  col = MiniFilter::COLORS
  if /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors, \d+ skips/ =~ o
    if $1.to_i + $2.to_i == 0
      "#{col.green}#{o}#{col.clear}"
    else
      "#{col.red}#{o}#{col.clear}"
    end
  else
    o
  end
}

