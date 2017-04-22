# SimpleTk

I wanted a really simple GUI library for Ruby.  Not because I think Ruby should be used for GUI
applications, but because I think it should be able to tbe used for GUI applications.

Really I wanted something to make a quick configuration app using an existing Ruby gem I had 
written. I started out with a simple console app, but I decided I wanted something even simpler
for the eventual day when somebody else has to use it.

So I searched.  First I found Shoes.  Which would be acceptable except Shoes 3 does not have a gem
and Shoes 4 requires JRuby.  Ok moving on, we have several other libraries that interface with other
libraries.  And then Tk, which is from the Ruby code base.  So time to learn Tk, which turns out has
a lot of repeated steps and code.  Well that's easy enough to correct.  I wrote a quick wrapper and
built my config app.

I extracted that wrapper and built it up to support more than just labels, entries, and buttons.
This gem is the end result of that action.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_tk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_tk

## Usage

You can build windows using either a block passed to a window constructor or by calling the methods
on the created window.

```ruby
win = SimpleTk::Window.new(title: "My Program", window_geometry: "400x300") do
  add_label :label1, "Hello World!", :column => 0, :row => 0
  add_frame(:frame1, :column => 0, :row => 1) do
    
  end
end


```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/barkerest/simple_tk.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

