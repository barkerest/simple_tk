require 'simple_tk'

win = SimpleTk::Window.new(title: "My Program", window_geometry: "400x300") do
  add_label :label1, "Hello World!", :column => 0, :row => 0
  add_frame(:frame1, :column => 0, :row => 1) do
    add_button(:btn1, "Button 1", :position => [ 0, 0 ]) do
      SimpleTk.alert "You clicked Button 1!"
    end
    add_button :btn2,
               "Button 2",
               :position => { x: 1, y: 0 },
               :command => ->{ SimpleTk.alert "You clicked Button 2!" }
  end
end

win.add_label :label2, "Goodby World!", :column => 0, :row => 2

win.config_column 0, weight: 1

(0..win.row_count).each do |row|
  win.config_row row, weight: 1
end

win.object[:frame1].object[:btn2].bind("3") do
  SimpleTk.alert "You right-clicked on Button 2!"
end

SimpleTk.run

exit 0
