require "./sagemath"

require "benchmark"

result = Benchmark.realtime do
  r = [[0.6, -0.2], [0.2, -1], [0.3, 0.4], [0.8, -0.1], [0.4, 0.5]]
  sage = Sage.new
  sage.fit(r)
end

puts "処理概要 #{result}s"

`open plot.png`
sleep(1)
`rm plot.png`
