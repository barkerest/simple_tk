require 'simple_tk'

win = SimpleTk::Window.new(title: 'Basic Entry') do

  # We start in :free placement mode.

  # We'll add a label using the :position option.
  add_label :header, 'A simple fake login dialog.', position: { x: 0, y: 0, w: 2, h: 1 }, sticky: 'we'

  # And another just to be sure the code is working properly.
  add_label :subheader, 'Another line of text...', position: [ 0, 1, 2, 1 ], sticky: 'we'

  # Now we'll go into :flow placement mode.
  set_placement_mode :flow, first_column: 0, first_row: 2, column_count: 2

  # Add the fields using a with_options block.
  with_options padx: 10, pady: 5 do
    add_label :user_label, 'User name:', sticky: 'e'
    add_text_box :user_name, sticky: 'w', width: 20

    add_label :pwd_label, 'Password:', sticky: 'e'
    add_text_box :pwd, sticky: 'w', password: true, width: 20

    add_check_box :remember, 'Remember me?', skip: 1, sticky: 'w'
  end

  # And we'll stick our buttons into a frame to subdivide the second column.
  add_frame :buttons, skip: 1, sticky: 'ew', padding: 0 do
    # Note that the new frame does not inherit the :flow placement mode, we are back in :free placement mode.
    add_button(:login, 'Login', col: 0, row: 0, padding: 5) { SimpleTk.alert 'Logging you on...' }
    add_button(:cancel, 'Cancel', col: 1, row: 0, padding: 5) { SimpleTk.alert 'Cancelling the login dialog...' }
  end

  # Add the footer text and a button to pass the test.
  add_label :footer, "This concludes the form.\nCheck the fields and buttons out.\nWhen done, click the button below.", colspan: 2
  add_button :success, 'Click me to pass the test.', command: ->{ exit 0 }

end

SimpleTk.run

exit 1
