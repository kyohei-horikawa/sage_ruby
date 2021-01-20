require "./SageMath.rb"

class Plot < Sage
  def plot(function, plotname: "plot")
    @command_list << "#{function}.save('#{plotname}.png')"
    @flag = false

    exec_command()
  end

  def set_plot(function, min: -5, max: 5)
    @command_list << "plot=plot(#{function}, (x,#{min},#{max}))"
  end

  def set_point_plot(array, color: "red")
    @command_list << "point=list_plot(#{array},color='#{color}',pointsize=30)"
  end

  def fit(array, xmin: -1, xmax: 1, plotname: "plot", point_color: "red", curve_color: "blue")
    set_point_plot(array, color: point_color)
    define_symbol("w0", "w1", "w2", "w3")
    add_command("model(x) = w0 + w1*x + w2*x^2 + w3*x^3")
    add_command("data=#{array}")
    add_command("fit = find_fit(data, model, solution_dict=True)")
    add_command("f_fit(x) = model.subs(fit)")
    add_command("fit_plt = plot(f_fit, [x, #{xmin}, #{xmax}], rgbcolor='#{curve_color}')")
    add_command("p=fit_plt+point")
    plot("p", plotname: plotname)
  end

  def animate_plot(type)
    add_command("array=[plot(c*#{type}(x), (-2*pi,2*pi), color=Color(c,0,0), ymin=-1, ymax=1) for c in sxrange(0,1,.2)]")
    add_command("a = animate(array)")
    add_command("a.save('plot.gif')")
    exec_command()
  end
end

array = [[0.0, -119.95449], [-0.2, -119.94399], [-0.1, -119.95251], [0.1, -119.95253], [0.2, -119.94389]]
a = Plot.new()
a.fit(array, plotname: "test", xmin: -1, xmax: 1, point_color: "blue", curve_color: "black")
