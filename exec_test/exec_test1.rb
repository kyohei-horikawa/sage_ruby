require "./sagemath"

require "benchmark"

result = Benchmark.realtime do
  sage = Sage.new
  sage.define_symbol("x")
  sage.add_command("y=x^3+1")
  sage.add_command("factor(y)")
  p sage.exec_command
end

puts "処理概要 #{result}s"
