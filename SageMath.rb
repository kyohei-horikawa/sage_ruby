require "pty"
require "timeout"

$sage = "/Applications/SageMath/sage"

class Sage
  def initialize
    @command_list = Array.new
    @command = ""
    @res = Array.new
    @flag = true
  end

  def add_command(com)
    @command_list << com
  end

  def define_symbol(*symbol)
    symbol = symbol.join(",")
    @command_list << "#{symbol}=var('#{symbol}')"
  end

  def plot(function, name = "plot")
    @command_list << "#{function}.save('#{name}.png')"
    @flag = false

    exec_command()
  end

  def set_plot(function, min = -5, max = 5)
    @command_list << "plot=plot(#{function}, (x,#{min},#{max}))"
  end

  def set_point_plot(array)
    @command_list << "point=list_plot(#{array},color='red',pointsize=30)"
  end

  def fit(array, xmin = 0, xmax = 1)
    set_point_plot(array)
    define_symbol("w0", "w1", "w2", "w3")
    add_command("model(x) = w0 + w1*x + w2*x^2 + w3*x^3")
    add_command("data=#{array}")
    add_command("fit = find_fit(data, model, solution_dict=True)")
    add_command("f_fit(x) = model.subs(fit)")
    add_command("fit_plt = plot(f_fit, [x, #{xmin}, #{xmax}], rgbcolor='blue')")
    add_command("p=fit_plt+point")
    plot("p")
  end

  def exec_command
    PTY.getpty($sage) do |i, o|
      begin
        Timeout.timeout(0.7) do
          loop { i.getc }
        end
      rescue Timeout::Error
      end
      p @command = @command_list.join(";")

      o.puts @command

      begin
        Timeout.timeout(5) do
          loop do
            @res << i.gets
          end
        end
      rescue Timeout::Error
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
