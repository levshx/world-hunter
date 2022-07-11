import nimgl/[opengl, glfw]
  
proc keypress(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress:
        if key == int(GLFWKey.Escape):
            window.setWindowShouldClose(true)

discard glfwInit()
glfwWindowHint(GLFWResizable, GLFW_TRUE)

var window = glfwCreateWindow(960, 540, "GAME ENGINE") # создание окошка

discard window.setKeyCallback(GLFWKeyFun(keypress))
window.makeContextCurrent
doAssert glInit()

glClearColor(172.0/255.0, 246.0/255.0, 246.0/255.0, 1.0)

proc render(window: GLFWWindow) =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  
  glPointSize(10)
  glLineWidth(10)
  
  glBegin(GL_LINES)
  glColor3f(0,0,0)
  glVertex2f(0,0)
  glVertex2f(0,1)
  glEnd()
  
  window.swapBuffers()

# рендер луп
while not window.windowShouldClose():
  render(window)
  glfwPollEvents()

window.destroyWindow()
glfwTerminate()