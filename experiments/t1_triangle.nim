import nimgl/[opengl, glfw]

var rotX = 0f 
var rotY = 0f 
var rotOfst = 5f

proc keyEnter(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress or action == GLFWRepeat:
    if key == int(GLFWKey.Escape): #256
      window.setWindowShouldClose(true)
    if key == int(GLFWKey.A):
      rotX += rotOfst
    if key == int(GLFWKey.D):
      rotX -= rotOfst
    if key == int(GLFWKey.W):
      rotY += rotOfst
    if key == int(GLFWKey.S):
      rotY -= rotOfst
    if key == int(GLFWKey.Left):
      rotOfst -= 1
    if key == int(GLFWKey.Right):
      rotOfst += 1


discard glfwInit()
glfwWindowHint(GLFWResizable, GLFW_TRUE)

var window = glfwCreateWindow(800, 600, "GAME ENGINE") # создание окошка

window.setInputMode(GLFWCursorSpecial, GLFW_CURSOR_DISABLED) # прятать мышку

discard window.setKeyCallback(GLFWKeyFun(keyEnter))

window.makeContextCurrent()

doAssert glInit()

glClearColor(172.0/255.0, 246.0/255.0, 246.0/255.0, 1.0)
glEnable(GL_DEPTH_TEST)
glEnable(GL_DEPTH_CLAMP)


proc render(window: GLFWWindow) =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glLoadIdentity()
  glPushMatrix()
  glRotatef(rotX,0,1,0) # угол вращения, оси
  glRotatef(rotY,1,0,0) # угол вращения, оси

  glBegin(GL_TRIANGLES)
  glColor3f(1,0,0)
  glVertex2f(0,1)
  glColor3f(0,1,0)
  glVertex2f(1f,-1)
  glColor3f(0,0,1)
  glVertex2f(-1f,-1)
  glEnd()

  glPopMatrix()
  window.swapBuffers()

while not window.windowShouldClose():
  render(window)
  glfwPollEvents()

window.destroyWindow()
glfwTerminate()