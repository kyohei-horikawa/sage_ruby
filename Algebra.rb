require "./SageMath.rb"

class Algebra < Sage
  def add(a, b)
    @command_list << "#{a}+#{b}"
  end

  def factor(f)
    @command_list << "factor(#{f})"
  end

  def expand(f)
    @command_list << "expand(#{f})"
  end
end

a = Algebra.new()

input = "(y+1)**2"
a.define_symbol("x,y,z")
a.expand(input)

output1 = a.exec_command
p output1

a.factor(output1)
output2 = a.exec_command
p output2
