import nimgl/[opengl, glfw], random

randomize()

type 
  Cell= object
    mine: bool
    flag: bool
    open: bool
    cntAround: int

const mapW = 10
const mapH = 10
const cntMines = 5
const winSizeX = 500
const winSizeY = 500

var closedCells: int
var failed = false
var map: seq[Cell]

proc isCellInMap(x, y: int): bool =
  return (x>=0) and (y>=0) and (x<mapW) and (y<mapH)

iterator countTo(n: int): int =
  var i = 0
  while i <= n:
    yield i
    inc i

proc drawTriangle(x1,y1,x2,y2,x3,y3,r,g,b: float): void =
  glBegin(GL_TRIANGLES)
  glColor3f(r,g,b)
  glVertex2f(x1,y1)
  glVertex2f(x2,y2)
  glVertex2f(x3,y3)
  glEnd()

proc line(x1,y1,x2,y2: float): void =
    glVertex2f(x1,y1)
    glVertex2f(x2,y2)

proc newGame(): void = 
  map.setLen(0)
  map.setLen(mapW*mapH)
  closedCells = map.len
  failed = false
  var minesCounter = cntMines
  for i in 0 ..< minesCounter: 
    let sx = rand(0 .. mapW-1)
    let sy = rand(0 .. mapH-1)
    if map[sy*mapW+sx].mine == true:
      inc minesCounter
    else:
      map[sy*mapW+sx].mine = true

      for dx in -1 ..< 2:
        for dy in -1 ..< 2:
          if isCellInMap(sx+dx,sy+dy):
            map[sx+dx+(sy+dy)*mapW].cntAround += 1

proc openFields(x,y: int): void =
  if (not isCellInMap(x,y) or map[x+y*mapH].open): 
    return
  map[x+y*mapH].open = true
  closedCells-=1
  if (map[x+y*mapH].cntAround == 0):
    for dx in -1 ..< 2:
        for dy in -1 ..< 2:
          openFields(x+dx, y+dy)
  if (map[x+y*mapH].mine):
    failed = true
    for dx in 0 ..< mapH:
      for dy in 0 ..< mapW:
        map[dx+dy*mapH].open = true


proc keypress(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress:
        if key == GLFWKey.Escape:
            window.setWindowShouldClose(true)


proc mouse(window: GLFWWindow, button: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress:
        if button == GLFWMousebutton.Button1:
          if failed:
            newGame()
          else:
            var xpos, ypos: float
            getCursorPos(window, addr xpos, addr ypos)
            let ox = (int)xpos/winSizeX*mapW
            let oy =(int)mapH-ypos/winSizeY*mapH       
            if isCellInMap(ox,oy) and not map[ox+oy*mapH].flag:
              openFields(ox,oy)
              if closedCells == cntMines:
                newGame()

        if button == GLFWMousebutton.Button2:
          var xpos, ypos: float
          getCursorPos(window, addr xpos, addr ypos)
          let ox = (int)xpos/winSizeX*mapW
          let oy =(int)mapH-ypos/winSizeY*mapH       
          if isCellInMap(ox,oy):
            map[ox+oy*mapH].flag = not map[ox+oy*mapH].flag


proc drawField(): void =
  glBegin(GL_TRIANGLE_STRIP)
  glColor3f(0.8,0.8,0.8); glVertex2f(0,1);
  glColor3f(0.7,0.7,0.7); glVertex2f(1,1); glVertex2f(0,0);
  glColor3f(0.6,0.6,0.6); glVertex2f(1,0);
  glEnd()

proc drawFieldOpen(): void =
  glBegin(GL_TRIANGLE_STRIP)
  glColor3f(0.3,0.7,0.3); glVertex2f(0,1);
  glColor3f(0.3,0.6,0.3); glVertex2f(1,1); glVertex2f(0,0);
  glColor3f(0.3,0.5,0.3); glVertex2f(1,0);
  glEnd()

proc drawFlag(): void=
  glBegin(GL_TRIANGLES)
  glColor3f(1,0,0)
  glVertex2f(0.25,0.75)
  glVertex2f(0.85,0.5)
  glVertex2f(0.25,0.25)
  glEnd()
  glLineWidth(5)
  glBegin(GL_LINES)
  glColor3f(0,0,0)
  glVertex2f(0.25,0.75)
  glVertex2f(0.25,0)
  glEnd()


proc drawCount(a: int): void =
  glLineWidth(3)
  glColor3f(1,1,0)
  glBegin(GL_LINES)
  if (a != 1) and (a != 4):
    line(0.3,0.85,0.7,0.85)
  if (a != 0) and (a != 1) and (a != 7):
    line(0.3,0.5,0.7,0.5)
  if (a != 1) and (a != 4) and (a != 7):
    line(0.3,0.15,0.7,0.15)
  if (a != 5) and (a != 6):
    line(0.7,0.5,0.7,0.85)
  if (a != 2):
    line(0.7,0.5,0.7,0.15)
  if (a != 1) and (a != 2) and (a != 3) and (a != 7):
    line(0.3,0.5,0.3,0.85)
  if (a == 0) or (a == 2) or (a == 6) or (a == 8):
    line(0.3,0.5,0.3,0.15)
  glEnd()



proc drawMine(): void =
  glBegin(GL_TRIANGLE_STRIP)
  glColor3f(0,0,0); glVertex2f(0.2,0.8);
  glVertex2f(0.8,0.8); glVertex2f(0.2,0.2);
  glVertex2f(0.8,0.2);
  glEnd()


proc drawGame(): void =
  glLoadIdentity() 
  glScalef(2.0/float(mapW), 2.0/float(mapH), 1)
  glTranslatef(-mapW*0.5, -mapH*0.5, 0)
  for sy in 0 ..< mapH:
    for sx in 0 ..< mapW:
      glPushMatrix()
      glTranslatef(float(sx), float(sy), 0)
      if (map[sx+sy*mapH].open):
        drawFieldOpen()
        if (map[sx+sy*mapH].mine):
          drawMine()
        else:        
          if (map[sx+sy*mapH].cntAround>0): 
            drawCount(map[sx+sy*mapH].cntAround)
      else:
        drawField()
        if (map[sx+sy*mapH].flag):
          drawFlag()
      glPopMatrix()


discard glfwInit()
glfwWindowHint(GLFWResizable, GLFW_TRUE)

var window = glfwCreateWindow(winSizeX, winSizeY, "САПЁРЧИК ЕМАЕ")
window.setWindowSizeLimits(winSizeX, winSizeY, winSizeX, winSizeY)
discard window.setKeyCallback(GLFWKeyFun(keypress))
discard window.setMouseButtonCallback(GLFWMousebuttonFun(mouse))
window.makeContextCurrent

doAssert glInit()

glClearColor(0.7, 1.0, 0.7, 0.0)

glEnable(GL_POINT_SMOOTH);
glEnable(GL_LINE_SMOOTH);

newGame()

proc render(window: GLFWWindow) =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  drawGame()
  window.swapBuffers()

while not window.windowShouldClose():
  render(window)
  glfwPollEvents()

window.destroyWindow()
glfwTerminate()