require 'simple_tk/version'

##
# A real cheap wrapper around the Ruby Tk bindings.
module SimpleTk

  ##
  # Runs the Tk application.
  def self.run
    Tk.mainloop
  end

end
