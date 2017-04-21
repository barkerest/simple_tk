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
  # message::
  #     The message to display.
  # icon::
  #     The icon to display (one of :info, :error, :question, or :warning).
  #
  # Returns true.
  def self.alert(message, icon = :info)
    Tk::messageBox message: message, icon: icon.to_s
    true
  end

  ##
  # Creates a basic yes/no message box.
  #
  # message::
  #     The message to display.
  # icon::
  #     The icon to display (one of :info, :error, :question, or :warning).
  # ok_cancel::
  #     Set to true to make the buttons OK and Cancel instead of Yes and No.
  #
  # Returns true for 'Yes' (or 'OK') or false for 'No' (or 'Cancel').
  def self.ask(message, icon = :question, ok_cancel = false)
    %w(ok yes).include?(Tk::messageBox(message: message, type: ok_cancel ? 'okcancel' : 'yesno', icon: icon))
  end

end
