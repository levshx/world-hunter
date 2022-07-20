import nimgl/[opengl, glfw]
import math
  
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
  
  glLoadIdentity()

  glRotatef(45f,0,0,1)  
  glTranslatef(0.5,0,0)
  glScalef(0.3,0.3,1)
  
  for i in countTo(7):
    glPushMatrix()
    glRotatef(45*float(i),0,0,1)
    glTranslatef(0.5,0,0)
    drawTriangle(0,0,0,0.5,0.5,0,1,0,0)
    glPopMatrix()

  glLoadIdentity() 

  glBegin(GL_LINES)
  glColor3f(0,0,0)
  glVertex2f(-1,0)
  glVertex2f(1,0)
  glVertex2f(0,1)
  glVertex2f(0,-1)
  glEnd() 

  window.swapBuffers()

# рендер луп
while not window.windowShouldClose():
  render(window)
  glfwPollEvents()

window.destroyWindow()
glfwTerminate()