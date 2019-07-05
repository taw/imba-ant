class AntSimulation
  def initialize
    @trace = []
    @trace_idx = {}
    @x = 0
    @y = 0
    @dx = 1
    @dy = 0

    @ymin = -10
    @xmin = -10
    @ymax = 10
    @xmax = 10

  def current_state
    let idx = "{@x},{@y}"
    if idx in @trace_idx
      let loc = @trace_idx[idx]
      @trace[loc]
    else
      0

  def increment_current_state
    let idx = "{@x},{@y}"
    if @trace_idx[idx] != undefined
      let loc = @trace_idx[idx]
      let c = @trace[loc]:c
      @trace[loc]:c = (c + 1) % 2
      c
    else
      @ymin = Math.min(@ymin, @y - 1)
      @xmin = Math.min(@xmin, @x - 1)
      @ymax = Math.max(@ymax, @y + 1)
      @xmax = Math.max(@xmax, @x + 1)

      let loc = @trace:length
      # resize here
      @trace_idx[idx] = loc
      @trace.push {x:@x, y:@y, c:1}
      0

  # FFS, no destructuring
  def turn_left
    let t = @dx
    @dx = @dy
    @dy = -t
    null

  def turn_right
    let t = @dx
    @dx = -@dy
    @dy = t
    null

  def step
    @x += @dx
    @y += @dy
    let c = increment_current_state
    if c == 0
      turn_right
    else
      turn_left

tag App
  def setup
    @sim = AntSimulation.new

    set-interval(&,10) do
      for i in [1..1000]
        @sim.step
      Imba.commit

  def transform
    let xmin = @sim:_xmin
    let ymin = @sim:_ymin
    let xmax = @sim:_xmax
    let ymax = @sim:_ymax
    let xsize = (xmax - xmin + 1) * 20
    let ysize = (ymax - ymin + 1) * 20
    let s = 400 / Math.max(xsize, ysize)
    "scale({s}) translate({-xmin*20}px, {-ymin*20}px)"

  def render
    <self>
      <header>
        "Hello, world!"
      <svg:svg>
        <svg:g style="transform: {transform};">
          for t in @sim:_trace
            <svg:rect .{"color-{t:c}"} x=(20*t:x) y=(20*t:y) height=18 width=18>

Imba.mount <App>
