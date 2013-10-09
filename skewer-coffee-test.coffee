# lightweight processing-esque canvas wrapper
class Sketch
  constructor: (width, height) ->
    @running = false
    @canvas = (document.getElementsByTagName 'canvas')[0]
    if @canvas
      @canvas.parentNode.removeChild @canvas
    @canvas = document.createElement 'canvas'
    @canvas.width  = width
    @canvas.height = height
    @ctx = @canvas.getContext '2d'
    @ctx.translate width / 2, height / 2
    @ctx.save()
    document.body.appendChild @canvas
    @framerate = 30
    @running = false

  drawLoop: ->
    @draw()
    setTimeout(@drawLoop.bind(this), (1000/@framerate)) if @running

  start: ->
    if @setup
      @setup
    @running = true
    @drawLoop()

  stop: ->
    @running = false

  clear: ->
    @ctx.restore()
    @ctx.clearRect(@canvas.width/-2, @canvas.height/-2, @canvas.width, @canvas.height)

window.sketch = new Sketch(800,800)

window.sketch.draw = ->
  @ctx.strokeStyle = ['#ec5d20','#b23267','#2d212c'][(~~(Math.random()*3))]
  boxWidth  = 400
  boxHeight = 400
  @ctx.rotate(Math.PI / (Math.random()*12))
  @ctx.strokeRect(boxWidth/-2, boxHeight/-2, boxWidth, boxHeight)

window.sketch.start()

# redefine the draw function while it's running
window.sketch.drawLine = (x1,y1,x2,y2) ->
  @ctx.beginPath()
  @ctx.moveTo(x1,x2)
  @ctx.lineTo(x2,y2)
  @ctx.stroke()

window.sketch.draw = ->
  @ctx.rotate(0)
  @ctx.strokeStyle = ['#ec5d20','#b23267','#2d212c'][(~~(Math.random()*3))]
  lines = ([0...3].map (n) -> (Math.random() * 360)).map (a) -> [0,0,(400 * Math.sin(a)),(400 * Math.cos(a))]
  @drawLine(l[0],l[1],l[2],l[3]) for l in lines

window.sketch.stop()

window.sketch.clear()
