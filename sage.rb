require "pty"
require "timeout"

$sage = "/Applications/SageMath/sage"

class Sage
  def initialize
    @command = Array.new
    @time = Array.new
    @res = Array.new
    @flag = true
  end

  def add_command(com)
    @command << com
    @time << 0.2
  end

  def define_symbol(*symbol)
    cnt = 0
    tmp = ""
    (symbol.size).times do
      tmp = tmp + "#{symbol[cnt]},"
      cnt += 1
    end
    tmp[-1] = ""
    @command << "#{tmp}=var('#{tmp}')"
    @time << 1
  end

  def plot(function, name = "plot")
    @command << "#{function}.save('#{name}.png')"
    @time << 0.5
    @flag = false

    exec_command()
  end

  def set_plot(function, min = -5, max = 5)
    @command << "plot=plot(#{function}, (x,#{min},#{max}))"
    @time << 0.2
  end

  def set_point_plot(array)
    @command << "point=list_plot(#{array},color='red')"
    @time << 0.2
  end

  def fit
  end

  def exec_command
    PTY.getpty($sage) do |i, o|
      begin
        Timeout.timeout(0.7) do
          loop { i.getc }
        end
      rescue Timeout::Error
      end
      p @time
      p @command.join(";")
      @command.each_with_index do |command, cnt|
        o.puts command

        begin
          Timeout.timeout(@time[cnt]) do
            loop do
              @res << i.gets
            end
          end
        rescue Timeout::Error
        end
      end

      if @flag
        @res[-1].split("\e[")[-1].match(/0m(.*)\r\n/)
        return $1
      else
        return 0
      end
    end
  end
end
