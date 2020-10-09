require "pty"
require "timeout"

$sage = "/Applications/SageMath/sage"
res = Array.new

# command = <<EOS
# x = var('x')
# solve(x^2 + 3*x + 2, x)
# EOS

# command = ["sin(x)", "cos(x)", "tan(x)", "sin(x)", "5*5", "x=var('x')"]
command = ["x=var('x')", "z=var('z')", "y=var('y')"]

PTY.getpty($sage) do |i, o|
  begin
    Timeout.timeout(1) do
      loop { i.getc }
    end
  rescue Timeout::Error
  end

  count = 0
  # command.each do |com|
  #   o.puts com
  #   if count % 2 == 0
  #     3.times do
  #       res << i.gets
  #     end
  #   else
  #     4.times do
  #       res << i.gets
  #     end
  #   end

  #   count += 1
  # end

  command.each do |com|
    o.puts com
    begin
      Timeout.timeout(1) do
        loop do
          res << i.gets
        end
      end
    rescue Timeout::Error
    end
  end

  res.each_with_index do |r, i|
    p "#{i}: #{r}"
    puts
  end

  # p res[-1]
  # res[-1].split("\e[")[-1].match(/0m(.*)\r\n/)
  # p $1
end
