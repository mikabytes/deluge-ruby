require './deluge'

host = ARGV.shift || 'localhost'

deluge = Deluge.new(host)
counter = 0

loop do
  line = $stdin.readline
  index_start = line.index '{'
  index_stop = line.index '}'

  kwargs = if index_start
    eval(line.slice!(index_start, index_stop))
  else
    {}
  end

  args = line.split(' ')
  method = args.shift

  args.map!{|a| eval(a)}

  deluge.send([counter+=1, method, args, kwargs])
  while deluge.count == 0
    sleep 0.1
  end

  while deluge.count > 0
    msg = deluge.read
    if msg[0] == 1
      p msg[2]
    else
      p msg
    end
  end
end
