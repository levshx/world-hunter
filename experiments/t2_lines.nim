import nimgl/[opengl, glfw]
import math
  
iterator countTo(n: int): int =
  var i = 0
  while i <= n:
    yield i
    inc i

proc keypress(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress:
        if key == int(GLFWKey.Escape):
            window.setWindowShouldClose(true)

discard glfwInit()
glfwWindowHint(GLFWResizable, GLFW_TRUE)

var window = glfwCreateWindow(800, 800, "GAME ENGINE") # создание окошка

discard window.setKeyCallback(GLFWKeyFun(keypress))
window.makeContextCurrent
doAssert glInit()

glClearColor(0.7, 1.0, 0.7, 0.0)

glEnable(GL_POINT_SMOOTH);
glEnable(GL_LINE_SMOOTH);

proc render(window: GLFWWindow) =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  
  glPointSize(30)
  glEnable(GL_LINE_STIPPLE)
  glLineStipple(1,0b0001100011111111)
  glLineWidth(3)
  glBegin(GL_LINE_STRIP)
  glColor3f(0,0,0)
  glVertex2f(-0.5,-0.5)
  glVertex2f(-0.5,0.5)
  glVertex2f(0.5,0.5)
  glVertex2f(0.5,-0.5) 
  glEnd()
  glDisable(GL_LINE_STIPPLE)

  glBegin(GL_LINE_LOOP)
  glColor3f(0,0,0)
  glVertex2f(-0.3,-0.3)
  glVertex2f(-0.3,0.3)
  glVertex2f(0.3,0.3)
  glVertex2f(0.3,-0.3)
  glEnd()

  glBegin(GL_POINTS)
  glColor3f(1,0,0)
  glVertex2f(-0.5,-0.5)
  glColor3f(0,0,0)
  glVertex2f(-0.5,0.5)
  glColor3f(1,0,0)
  glVertex2f(0.5,-0.5)
  glColor3f(0,0,0)
  glVertex2f(0.5,0.5)
  glEnd()
  
  # glBegin(GL_TRIANGLE_FAN)
  # glColor3f(0,0,0)
  # glVertex2f(-0.2,-0.2)
  # glVertex2f(-0.2,0.2)
  # glColor3f(1,0,0)
  # glVertex2f(0.2,0.2)
  # glColor3f(0,0,1)
  # glVertex2f(0.2,-0.2)
  # glEnd()
  
  var x,y: float = 0
  var cnt = 10
  var l: float = 0.2f
  var a: float = PI * 2f / float(cnt) 
  glBegin(GL_TRIANGLE_FAN)
  glColor3f(1,0,1)
  for i in countTo(cnt-1):
    x = (sin(a*float(i))) * l
    y = (cos(a*float(i))) * l
    glVertex2f(x,y)

  glEnd()

  window.swapBuffers()

# рендер луп
while not window.windowShouldClose():
  render(window)
  glfwPollEvents()

window.destroyWindow()
glfwTerminate()