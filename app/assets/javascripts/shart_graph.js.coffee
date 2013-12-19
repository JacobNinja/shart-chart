window.onload = ->

  return unless document.getElementById('graph')

  width = window.innerWidth
  height = window.innerHeight

  svg = d3.select('#graph').attr('height', height).attr('width', width)
  force = d3.layout.force().gravity(0).distance(300).charge(0).size([width, height])

  node = svg.selectAll('.node').data(json.nodes).enter().append('g').attr('class', 'node').call(force.drag)
  poop = svg.selectAll('.poop').data(json.links).enter().append('image').attr('xlink:href', 'poop.jpg').attr('height', 10).attr('width', 10).attr('class', 'poop')
  path = svg.selectAll('.path').data(json.links).enter().append('path').attr('stroke', 'black').attr('stroke-width', 2).attr('fill', 'none').attr('class', 'path')

  node.append('text').attr('dx', 12).attr('dy', '.35em').text (d) -> d.name
  force.on 'start', ->
    poop.attr 'x', (d) -> d.source.x
    poop.attr 'y', (d) -> d.source.y
    poop.attr 'height', (d) -> d.value * 10
    poop.attr 'width', (d) -> d.value * 10
    path.attr 'd', (d) -> "M#{d.source.x},#{d.source.y}L#{d.source.x},#{d.source.y}"
    node.attr 'transform', (d) -> "translate(#{d.x}, #{d.y})"
    d3.selectAll('.poop').transition().duration(3000).attr('x', (d) -> d.target.x).attr('y', (d) -> d.target.y)
    transition = d3.selectAll('.path').transition().duration(3000)
    transition.attr('d', (d) -> "M#{d.source.x},#{d.source.y}L#{d.target.x},#{d.target.y}")
    transition.attr('stroke-width', (d) -> d.value)

  force.nodes(json.nodes).links(json.links).start()
