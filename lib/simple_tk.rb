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

  ##
  # Creates a basic alert message box.
  #
  # message:: The message to display.
  # icon::    The icon to display (one of :info, :error, :question, or :warning).
  #
  # Returns true.
  def self.alert(message, icon = :info)
    Tk::messageBox message: message, icon: icon.to_s
    true
  end

  ##
  # Creates a basic yes/no message box.
  #
  # message:: The message to display.
  # icon::    The icon to display (one of :info, :error, :question, or :warning).
  #
  # Returns true for 'Yes' or false for 'No'.
  def self.ask(message, icon = :question)
    Tk::messageBox(message: message, type: 'yesno', icon: icon) == 'yes'
  end

end
