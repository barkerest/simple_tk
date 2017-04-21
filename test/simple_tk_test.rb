require 'test_helper'

class SimpleTkTest < Minitest::Test

  def sample_files
    @sample_files ||= Dir.glob(File.expand_path('../samples/*.rb', __FILE__))
  end

  def run_sample(name)
    regex = /(.*\/)?\d+_#{name}.rb$/i

    sample_file = sample_files.find{ |f| f =~ regex }
    assert sample_file, "Missing file for #{name} sample."

    system("ruby -Ilib \"#{sample_file}\"")
    assert_equal 1, $?.exitstatus, "Sample #{name} did not return 1."
  end

  def test_alert
    assert SimpleTk.alert("This is a simple alert box.\nAll you can do is click OK.")
  end

  def test_ask
    assert_equal true, SimpleTk.ask("This is a simple question box.\nClick YES to pass this test.")
    assert_equal false, SimpleTk.ask("This is another simple question box.\nThis time click NO to pass the test.")
  end

  def test_hello_world
    puts 'Awaiting user interaction, please click the button on the sample window.'
    run_sample 'hello_world'
  end

end
