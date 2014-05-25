class Object
  constructor: (@name, @x, @y, @blood, @attack_value, @attack_speed) ->
    @speed = 3
    @width = 20
    @move = false
    @max_blood = @blood
    @live = true

  attack: (o) ->
    return unless @live

    if o.blood < @attack_value
      attack_value = o.blood
    else
      attack_value = @attack_value
    console.log("#{@name} 对 #{o.name} 造成了#{attack_value}点伤害")
    o.setBlood(o.blood - @attack_value)

    return unless o.live
    ins = this
    setTimeout ->
      ins.attack(o)
    , @attack_speed * 1000

  setBlood: (v) ->
    if v < 0
      v = 0
      @live = false
      console.log("#{@name} 死了")
    @blood = v

  startMove: ->
    @move = true

  stopMove: ->
    @move = false

  moveTo: (x, y) ->
    # 计算下一个移动位置
    @x = @x + @speed * (x - @x) / Math.sqrt(Math.pow(y - @y, 2) + Math.pow(x - @x, 2))
    @y = @y + @speed * (y - @y) / Math.sqrt(Math.pow(y - @y, 2) + Math.pow(x - @x, 2))

    if !@move
      return

    @context.beginPath()
    @context.arc(@x, @y, @width / 2, 0, 2*Math.PI)
    if @context.isPointInPath(x, y)
      return

    ins = this
    setTimeout ->
      ins.moveTo(x, y)
    , 20

  contains: (x, y) ->
    @context.beginPath()
    @context.arc(@x, @y, 30, 0, 2*Math.PI)
    contains = @context.isPointInPath(x, y)
    # 不清除会有bug
    @context.beginPath()
    contains

  paint: ->
    # 画身体
    @context.beginPath()
    @context.strokeStyle = '#000000'
    @context.arc(@x, @y, @width / 2, 0, 2*Math.PI)
    @context.stroke()

    # 画血量
    @context.beginPath()
    @context.fillStyle = '#ff0000'
    @context.rect(@x - @width / 2 - 10, @y - @width / 2 - 5, (@blood / @max_blood) * 40, 2)
    @context.fill()

    # 画名字
    @context.font = '13px 宋体'
    if @selected
      @context.font = 'bold ' + @context.font
      @context.fillStyle = 'gold'
    else
      @context.fillStyle = '#000000'
    @context.fillText(@name, @x - @width / 2 - 10, @y - @width / 2 - 10)


init = ->
  canvas = document.getElementById('game')
  context = canvas.getContext('2d')
  objects = []

  # 绘制地图边界
  context.rect(0, 0, 900, 500)
  context.stroke()

  # 绘制玩家
  player = new Object('Player 1', 100, 75, 200, 15, 1.5)
  player.context = context
  player.paint()
  objects.push(player)

  for i in [0..4]
    x = Math.random() * 900
    y = Math.random() * 500
    monster = new Object('多钩猫', x, y, 80, 30, 2)
    monster.context = context
    monster.paint()
    objects.push(monster)

  # 每n毫秒重绘一次界面
  setInterval ->
    context.clearRect(0, 0, 900, 500)
    # 绘制地图边界
    context.rect(0, 0, 900, 500)
    context.stroke()

    # 绘制玩家和怪物
    for o in objects
      o.paint() if o.live
  , 30

  # 处理玩家移动事件
  canvas.addEventListener 'mousedown', (event) ->
    player.startMove()
    player.moveTo(event.clientX, event.clientY)
    for o in objects
      if o.selected
        player.attack(o)
        o.attack(player)


  canvas.addEventListener 'mouseup', (event) ->
    player.stopMove()

  canvas.addEventListener 'mousemove', (event) ->
    for o in objects
      continue if o == player
      o.selected = o.contains(event.clientX, event.clientY)

window.onload = init
