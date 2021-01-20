require "pty"
require "timeout"

$sage = "/Applications/SageMath/sage"

class Sage
  def initialize
    @define_command = Array.new
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
    @define_command << "#{symbol}=var('#{symbol}')"
  end

  def exec_command
    PTY.getpty($sage) do |i, o|
      begin
        Timeout.timeout(0.7) do
          loop { i.getc }
        end
      rescue Timeout::Error
      end

      @command_list.unshift(@define_command)
      p @command = @command_list.join(";")

      o.puts @command

      time = 5

      begin
        Timeout.timeout(time) do
          loop do
            @res << i.gets
          end
        end
      rescue Timeout::Error
      end

      @command_list = []

      if @flag
        @res[-1].split("\e[")[-1].match(/0m(.*)\r\n/)
        return $1
      else
        return 0
      end
    end
  end
end
