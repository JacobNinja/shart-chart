require 'test/unit'
require File.expand_path('./../../lib/shart_chart', __FILE__)

class ShartChartTest < Test::Unit::TestCase

  test 'single object' do
    result = ShartChart.pooooop(<<-RUBY)
class Foo; end
    RUBY
    assert_includes result, {name: 'Foo', references: []}
  end

  test 'single object references other object' do
    result = ShartChart.pooooop(<<-RUBY).first
class Foo; Object.foo(); end
    RUBY
    assert_includes result[:references], ShartChart::Reference.new('Object')
  end

  test 'multiple objects' do
    result = ShartChart.pooooop(<<-RUBY)
class Foo; end
class Bar; end
    RUBY
    assert_includes result, {name: 'Foo', references: []}
    assert_includes result, {name: 'Bar', references: []}
  end

  test 'multiple objects reference each other' do
    result = ShartChart.pooooop(<<-RUBY)
class Foo; end
class Bar; def foo; Foo.bar(); end; end
    RUBY
    assert_includes result, {name: 'Bar', references: [ShartChart::Reference.new('Foo')]}
  end

  test 'multiple references to another object' do
    result = ShartChart.pooooop(<<-RUBY)
class Bar; def foo; Foo.bar(); end; Foo.baz(); end
    RUBY
    assert_includes result, {name: 'Bar', references: [ShartChart::Reference.new('Foo')] * 2}
  end

  test 'ignores top level references' do
    result = ShartChart.pooooop(<<-RUBY)
Object.tap()
    RUBY
    assert_empty result
  end

end