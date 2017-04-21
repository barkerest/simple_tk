
module SimpleTk

  ##
  # Provides :disable, :disabled?, and :enable methods to widgets.
  module DisableHelpers

    ##
    # Disables this widget.
    def disable
      self.state('disabled')
    end

    ##
    # Is this widget disabled?
    def disabled?
      self.instate('disabled')
    end

    ##
    # Enables this widget.
    def enable
      self.state('!disabled')
    end

  end



end