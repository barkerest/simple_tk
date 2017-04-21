require 'simple_tk'

# create a window
win = SimpleTk::Window.new(title: 'Hello World', window_geometry: '300x300')

# add a label
win.add_label :hello, 'Hello World!', column: 0, row: 0, padding: 5

# and a button
win.add_button :click_me, 'Click me to pass the test', column: 0, row: 1, padding: 5 do
  # exit with a 1 if the button is clicked.
  exit 1
end

# tell the first (and only) column to resize with the window.
win.config_column 0, weight: 1

# tell the first row to resize with the window.
# this should make the label stay centered and the button stick to the bottom of the window.
win.config_row 0, weight: 1

# run our application.
SimpleTk.run

# exit with a 0 if the user does not click the button.
exit 0


