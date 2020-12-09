require "./sagemath"

require "benchmark"

result = Benchmark.realtime do
  data = [[0.6, -0.2], [0.2, -1], [0.3, 0.4], [0.8, -0.1], [0.4, 0.5]] # 配列の配列でデータを渡す．
  sage = Sage.new #インスタンス作成
  sage.fit(data) #インスタンスメソッドのfitを呼ぶ fit(data,xmin,xmax)
end

puts "処理概要 #{result}s"

`open plot.png`
sleep(1)
`rm plot.png`

# http://www.pwv.co.jp/~take/TakeWiki/index.php?sage%2Ftext%2F%E3%83%87%E3%83%BC%E3%82%BF%E3%83%95%E3%82%A3%E3%83%83%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0
