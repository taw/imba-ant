class AntSimulation
  def initialize(number_of_states, state_actions)
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

    @number_of_states = number_of_states
    @state_actions = state_actions

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
      @trace[loc]:c = (c + 1) % @number_of_states
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
    let action = @state_actions[c]
    if action === "R"
      turn_right
    else if action === "L"
      turn_left
    else
      0

tag App
  def setup
    @paused = false
    set-interval(&,60) do
      unless @paused
        for i in [1..100]
          @sim.step
      Imba.commit
    randomize

  def randomize
    @number_of_states = 2 + Math.floor(Math.random() * 8)
    @state_actions = {}
    for i in [0..8]
      @state_actions[i] = ["L", "R", "F"][Math.floor(Math.random()*3)]
    restart

  def restart
    @sim = AntSimulation.new(@number_of_states, @state_actions)

  def pause
    @paused = true

  def resume
    @paused = false

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
        "Langton's Ant"
      <svg:svg>
        <svg:g style="transform: {transform};">
          for t in @sim:_trace
            <svg:rect .{"color-{t:c}"} x=(20*t:x) y=(20*t:y) height=18 width=18>
      <div.form>
        <div.group>
          unless @paused
            <button :tap.pause>
              "Pause"
          if @paused
            <button :tap.resume>
              "Resume"
          <button :tap.restart>
            "Restart"
          <button :tap.randomize>
            "Randomize"
        <div.group>
          <label>
            "States"
            <input[@number_of_states] type="range" min=1 max=9>
        for i in [0..@number_of_states]
          <div.group>
            <div.state-color.{"color-{i}"}>
              "State {i+1}"
            <label>
              "Left"
              <input[@state_actions[i]] type="radio" value="L">
            <label>
              "Forward"
              <input[@state_actions[i]] type="radio" value="F">
            <label>
              "Right"
              <input[@state_actions[i]] type="radio" value="R">

Imba.mount <App>
