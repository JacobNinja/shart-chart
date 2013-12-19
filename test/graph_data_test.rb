require 'test/unit'
require File.expand_path('./../../lib/graph_data', __FILE__)
require File.expand_path('./../../lib/shart_chart', __FILE__)

class GraphDataTest < Test::Unit::TestCase

  test 'returns node starting at group 0' do
    sut = GraphData.new([ShartChart::Result.new('Foo', [])])
    assert_equal [{name: 'Foo', group: 0}], sut.nodes
  end

  test 'returns nodes incrementing group' do
    sut = GraphData.new([ShartChart::Result.new('Foo', []), ShartChart::Result.new('Bar', [])])
    assert_equal [{name: 'Foo', group: 0}, {name: 'Bar', group: 1}], sut.nodes
  end

  test 'returns nodes as unique groups' do
    sut = GraphData.new([ShartChart::Result.new('Foo', []), ShartChart::Result.new('Foo', [])])
    assert_equal [{name: 'Foo', group: 0}], sut.nodes
  end

  test 'returns node for reference' do
    sut = GraphData.new([ShartChart::Result.new('Foo', [ShartChart::Reference.new('Bar')])])
    assert_equal [{name: 'Foo', group: 0}, {name: 'Bar', group: 1}], sut.nodes
  end

  test 'returns link for reference' do
    sut = GraphData.new([ShartChart::Result.new('Foo', [ShartChart::Reference.new('Bar')])])
    assert_equal [{source: 0, target: 1, value: 1}], sut.links
  end

  test 'returns multiple links for multiple references to same source' do
    sut = GraphData.new([ShartChart::Result.new('Foo', [ShartChart::Reference.new('Bar'),
                                                        ShartChart::Reference.new('Baz')])])
    assert_equal [{source: 0, target: 1, value: 1}, {source: 0, target: 2, value: 1}], sut.links
  end

  test 'accumulates value for n references' do
    sut = GraphData.new([ShartChart::Result.new('Foo', [ShartChart::Reference.new('Bar'),
                                                        ShartChart::Reference.new('Bar')])])
    assert_equal [{source: 0, target: 1, value: 2}], sut.links
  end

end