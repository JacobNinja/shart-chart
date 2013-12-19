class GraphData

  def initialize(results)
    @results = results
  end

  def nodes
    node_names = @results.map(&:klass) + @results.flat_map {|r| r.references.map(&:klass) }
    node_names.uniq.map.with_index do |klass, i|
      {name: klass, group: i}
    end
  end

  def links
    @results.flat_map do |result|
      node_source = nodes.index {|n| n[:name] == result.klass }
      result.references.group_by(&:klass).map do |klass, references|
        target_source = nodes.index {|n| n[:name] == klass }
        {source: node_source, target: target_source, value: references.count}
      end
    end
  end

end