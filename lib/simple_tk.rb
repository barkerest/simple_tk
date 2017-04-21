require 'simple_tk/version'
require 'simple_tk/get_set_helper'
require 'simple_tk/window'

##
# A real cheap wrapper around the Ruby Tk bindings.
module SimpleTk

  ##
  # Runs the Tk application.
  def self.run
    Tk.mainloop
  end

end
