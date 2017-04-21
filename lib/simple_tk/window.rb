require 'simple_tk/errors'
require 'simple_tk/get_set_helper'
require 'simple_tk/widget_helpers'

module SimpleTk
  ##
  # A class representing a window that all the other controls get piled into.
  class Window

    ##
    # Allows you to get or set the linked object for this window.
    #
    # A linked object can be used to provide command callbacks.
    attr_accessor :linked_object

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
    #     This can be a single value to have the same padding all around.
    #     It can also be two numbers to specify horizontal and vertical padding.
    #     If you specify four numbers, they are for left, top, right, and bottom padding.
    #     Defaults to "3".
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
          padding: '3',
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
    #
    # event::     The event to bind to (eg - "1", "Return", "Shift-2")
    # proc::      A predefined proc to bind to the event, only used if no block is provided.
    #
    # If a block is provided it will be bound, otherwise the +proc+ argument is looked at.
    # If the proc argument specifies a Proc it will be bound.  If the proc argument is a Symbol
    # and the Window or +linked_object+ responds to the proc, then the method from the Window
    # or +linked_object+ will be bound.
    def on(event, proc = nil, &block)
      cmd = get_command proc, &block
      root.bind(event) { cmd.call }
    end

    ##
    # Adds a new label to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # label_text::  The text to put in the label.
    #               If this is a Symbol, then a variable will be created with this value as its name.
    #               Otherwise the label will be given the string value as a static label.
    # options::     Options for the label.  Common options are :column, :row, and :sticky.
    def add_label(name, label_text, options = {})
      add_widget Tk::Tile::Label, name, label_text, options
    end

    ##
    # Adds a new image to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # image_path::  The path to the image, can be relative or absolute.
    # options::     Options for the image.  Common options are :column, :row, and :sticky.
    def add_image(name, image_path, options = {})
      image = TkPhotoImage.new(file: image_path)
      add_widget Tk::Tile::Label, name, nil, options.merge(image: image)
    end

    ##
    # Adds a new button to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # label_text::  The text to put in the button.
    #               If this is a Symbol, then a variable will be created with this value as its name.
    #               Otherwise the button will be given the string value as a static label.
    # options::     Options for the button.  Common options are :column, :row, :sticky, and :command.
    #
    # If a block is provided, it will be used for the button command.  Otherwise the :command option
    # will be used.  This can be a Proc or Symbol.  If it is a Symbol it should reference a method in
    # the current Window object or in the +linked_object+.
    #
    # If no block or proc is provided, a default proc that prints to $stderr is created.
    def add_button(name, label_text, options = {}, &block)
      proc = get_command(options.delete(:command), &block) || ->{ $stderr.puts "Button '#{name}' does nothing when clicked." }
      add_widget Tk::Tile::Button, name, label_text, options, &proc
    end

    ##
    # Adds a new image button to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # image_path::  The path to the image, can be relative or absolute.
    # options::     Options for the image button.  Common options are :column, :row, :sticky, and :command.
    #
    # If a block is provided, it will be used for the button command.  Otherwise the :command option
    # will be used.  This can be a Proc or Symbol.  If it is a Symbol it should reference a method in
    # the current Window object or in the +linked_object+.
    #
    # If no block or proc is provided, a default proc that prints to $stderr is created.
    def add_image_button(name, image_path, options = {}, &block)
      image = TkPhotoImage.new(file: image_path)
      proc = get_command(options.delete(:command), &block) || ->{ $stderr.puts "Button '#{name}' does nothing when clicked." }
      add_widget Tk::Tile::Button, name, nil, options.merge(image: image), &proc
    end

    ##
    # Adds a new text box to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # options::     Options for the text box.  Common options are :column, :row, :sticky, :width, :value, and :password.
    #
    # Accepts a block or command the same as a button. Unlike the button there is no default proc assigned.
    # The proc, if specified, will be called for each keypress.  It should return 1 (success) or 0 (failure).
    def add_text_box(name, options = {}, &block)
      if options.delete(:password)
        options[:show] = '*'
      end
      proc = get_command(options.delete(:command), &block)
      item = add_widget Tk::Tile::Entry, name, nil, options.merge(create_var: :textvariable)
      # FIXME: Should the command be processed for validation or bound to a specific event?
      if proc
        item.send :validate, 'key'
        item.send(:validatecommand) { proc.call }
      end
      item
    end

    ##
    # Adds a new check box to the window
    #
    # name::        A unique label for this item, cannot be nil.
    # label_text::  The text to put in the button.
    #               If this is a Symbol, then a variable will be created with this value as its name.
    #               Otherwise the button will be given the string value as a static label.
    # options:      Options for the check box.  Common options are :column, :row, :sticky, and :value.
    #
    # Accepts a block or command the same as a button.  Unlike a button there is no default proc assigned.
    def add_check_box(name, label_text, options = {}, &block)
      proc = get_command(options.delete(:command), &block)
      add_widget Tk::Tile::Checkbutton, name, label_text, options.merge(create_var: :variable), &proc
    end

    ##
    # Adds a new image check box to the window
    #
    # name::        A unique label for this item, cannot be nil.
    # image_path::  The path to the image, can be relative or absolute.
    # options:      Options for the check box.  Common options are :column, :row, :sticky, and :value.
    #
    # Accepts a block or command the same as a button.  Unlike a button there is no default proc assigned.
    def add_image_check_box(name, image_path, options = {}, &block)
      image = TkPhotoImage.new(file: image_path)
      proc = get_command(options.delete(:command), &block)
      add_widget Tk::Tile::Checkbutton, name, nil, options.merge(image: image, create_var: :variable), &proc
    end

    ##
    # Adds a new radio button to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # group::       The name of the variable this radio button uses.
    # label_text::  The text to put in the button.
    #               If this is a Symbol, then a variable will be created with this value as its name.
    #               Otherwise the button will be given the string value as a static label.
    # options:      Options for the check box.  Common options are :column, :row, :sticky, :value, and :selected.
    #
    # Accepts a block or command the same as a button.  Unlike a button there is no default proc assigned.
    def add_radio_button(name, group, label_text, options = {}, &block)
      raise ArgumentError, 'group cannot be blank' if group.to_s.strip == ''
      group = group.to_sym
      @var[group] ||= TkVariable.new
      options[:variable] = @var[group]
      options[:value] ||= name.to_s.strip
      if options.delete(:selected)
        @var[group] = options[:value]
      end
      proc = get_command(options.delete(:command), &block)
      add_widget Tk::Tile::Radiobutton, name, label_text, options, &proc
    end

    ##
    # Adds a new radio button to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # group::       The name of the variable this radio button uses.
    # image_path::  The path to the image, can be relative or absolute.
    # options:      Options for the check box.  Common options are :column, :row, :sticky, :value, and :selected.
    #
    # Accepts a block or command the same as a button.  Unlike a button there is no default proc assigned.
    def add_image_radio_button(name, group, image_path, options = {}, &block)
      raise ArgumentError, 'group cannot be blank' if group.to_s.strip == ''
      group = group.to_sym
      @var[group] ||= TkVariable.new
      options[:variable] = @var[group]
      options[:value] ||= name.to_s.strip
      if options.delete(:selected)
        @var[group] = options[:value]
      end
      proc = get_command(options.delete(:command), &block)
      image = TkPhotoImage.new(file: image_path)
      add_widget Tk::Tile::Radiobutton, name, nil, options.merge(image: image), &proc
    end

    ##
    # Adds a new combo box to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # options:      Options for the check box.  Common options are :column, :row, :sticky, :value, and :values.
    #
    # The :values option will define the items in the combo box, the :value option sets the selected option if set.
    #
    # Accepts a block or command the same as a button.  Unlike a button there is no default proc assigned.
    def add_combo_box(name, options = {}, &block)
      proc = get_command(options.delete(:command), &block)
      item = add_widget TK::Tile::Combobox, name, nil, options.merge(create_var: :textvariable)
      if proc
        item.bind('<ComboboxSelected>') { proc.call }
      end
      item
    end

    ##
    # Adds a new frame to the window.
    #
    # name::        A unique label for this item, cannot be nil.
    # options::     Options for the frame.  Common options are :column, :row, and :padding.
    #
    # A frame can be used as a sub-window.  The returned object has all of the same methods as a Window
    # so you can add other widgets to it and use it as a grid within the parent grid.
    def add_frame(name, options = {})
      name = name.to_sym
      raise DuplicateNameError if @object.include?(name)
      @object[name] = new SimpleTk::Window(options.merge(parent: self, stk___frame: true))
    end


    private


    def root
      @object[:stk___root]
    end

    def content
      @object[:stk___content]
    end

    def add_widget(klass, name, label_text, options = {}, &block)
      raise ArgumentError, 'name cannot be blank' if name.to_s.strip == ''
      name = name.to_sym
      raise DuplicateNameError if @object.include?(name)
      cmd = get_command options.delete(:command), &block
      if cmd
        options[:command] = cmd
      end

      if (attrib = options.delete(:create_var))
        @var[name] ||= TkVariable.new
        if attrib.is_a?(Symbol)
          options[attrib] = @var[name]
        end
        init_val = options.delete(:value)
        var[name] = init_val if init_val
      end

      @object[name] = klass.new(content)
      if label_text
        set_text @object[name], label_text
      end
      apply_options @object[name], options

      # add disable, disabled?, and enable methods.
      @object[name].extend SimpleTk::DisableHelpers

      # return the object after creation
      @object[name]
    end

    def get_command(proc, &block)
      if block
        block
      elsif proc.is_a?(Proc)
        proc
      elsif proc.is_a?(Symbol) && self.respond_to?(proc, true)
        self.method(proc)
      elsif linked_object && proc.is_a?(Symbol) && linked_object.respond_to?(proc, true)
        linked_object.method(proc)
      else
        nil
      end
    end

    def set_text(object, label_text)
      if label_text.is_a?(Symbol)
        @var[label_text] ||= TkVariable.new
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