require 'simple_tk/get_set_helper'

module SimpleTk
  ##
  # A class representing a window that all the other controls get piled into.
  class Window

    ##
    # Creates a new window.
    #
    # Valid options:
    # title::
    #     The title to put on the window.
    #     Defaults to "My Application".
    # parent::
    #     The parent window for this window.
    #     Use your main window for any popup windows you create.
    #     Defaults to nil.
    # padding::
    #     The padding for the content frame.
    #     This can be a single value, or multiple values for top, bottom, left, and right.
    #     Defaults to "3 3 12 12".
    # sticky::
    #     The stickiness for the content frame.
    #     This defaults to "nsew" and most likely you don't want to change it, but the
    #     option is available.
    #
    def initialize(options = {})
      @object = {}
      @var = {}

      options = {
          title: 'My Application',
          padding: '3 3 12 12',
          sticky: 'nsew'
      }.merge(options.inject({}) { |m,(k,v)| m[k.to_sym] = v; m})

      title = options.delete(:title) || 'My Application'
      parent = options.delete(:parent)
      is_frame = options.delete(:stk___frame)

      @object[:stk___root] =
          if is_frame
            parent
          elsif parent
            TkToplevel.new(parent)
          else
            TkRoot.new
          end

      unless is_frame
        root.title title
        TkGrid.columnconfigure root, 0, 1
        TkGrid.rowconfigure root, 0, 1
      end

      @object[:stk___content] = Tk::Tile::Frame.new(root)
      apply_options content, options

      # TODO: Add column/row management internally.
    end

    ##
    # Allows you to configure the grid options for all cells in a column.
    def config_column(col, options = {})
      TkGrid.columnconfigure content, col, options
    end

    ##
    # Allows you to configure the grid options for all cells in a row.
    def config_row(row, options = {})
      TkGrid.rowconfigure content, row, options
    end

    ##
    # Gets all of the children on this window.
    def children
      TkWinfo.children(content)
    end

    ##
    # Gets objects from the window.
    def object
      @object_helper ||= SimpleTk::GetSetHelper.new( self, :@object, true, nil, ->(i,v) {  } )
    end

    ##
    # Gets or sets variable values for this window.
    def var
      @var_helper ||= SimpleTk::GetSetHelper.new(self, :@var, true, :value, :value=)
    end

    ##
    # Binds a method or Proc to a window event.
    def on(event, proc = nil, &block)
      cmd =
          if block
            block
          elsif proc.is_a?(Proc)
            proc
          elsif proc.is_a?(Symbol) && self.respond_to?(proc, true)
            self.method(proc)
          else
            ->{ }
          end
      root.bind(event) { cmd.call }
    end


    # TODO: Add widget helpers.



    private


    def root
      @object[:stk___root]
    end

    def content
      @object[:stk___content]
    end

    def set_text(object, label_text)
      if label_text.is_a?(Symbol)
        @var[label_text] = TkVariable.new
        object.textvariable @var[label_text]
      else
        object.text label_text
      end
    end

    def apply_options(object, options)
      widget_opt, grid_opt = split_widget_grid_options(options)
      widget_opt.each do |key,val|
        if val.is_a?(Proc)
          object.send key, &val
        else
          object.send key, val
        end
      end
      object.grid(grid_opt)
    end

    def split_widget_grid_options(options)
      wopt = options.dup
      gopt = {}

      [
          :row, :column, :columnspan, :rowspan,
          :padx, :pady, :ipadx, :ipady,
          :sticky,
      ].each do |attr|
        val = wopt.delete(attr)
        if val
          gopt[attr] = val
        end
      end

      [ wopt, gopt ]
    end

  end
end