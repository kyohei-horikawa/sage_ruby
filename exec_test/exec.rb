require "./sagemath"

require "benchmark"

result = Benchmark.realtime do
  r = [[1, 2], [2, 30], [3, 4]]
  sage = Sage.new
  sage.define_symbol("x", "y")
  sage.set_plot("10*cos(x)")
  sage.set_point_plot(r)
  sage.add_command("p=point+plot")
  sage.plot("p")
end

puts "処理概要 #{result}s"

`open plot.png`
sleep(1)
`rm plot.png`
