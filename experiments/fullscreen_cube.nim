import nimgl/[opengl, glfw]

proc render(window: GLFWWindow) =

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glLoadIdentity()
  glScalef(0.5,0.5,1)
  glRotatef(-45,1,0,0)
  glRotatef(glfwGetTime()*100,0,1,0) # Матрица вращения сцены

  glBegin(GL_TRIANGLES)

  # Верхняя хуйня
  glColor3f(0.0, 1.0, 0.0)  # трава
  glVertex3f(1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)

  # Нижняя хуйня
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # какашка
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Перд
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # какашка
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)
  glVertex3f( 1.0, -1.0, 1.0)
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)

  # Зад
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # какашка
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f( 1.0,  1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)

  # Лев
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0)  # какашка
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Прав
  glColor3f(139.0/256.0, 69.0/256.0, 19.0/256.0) # какашка
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0,  1.0,  1.0)
  glVertex3f(1.0, -1.0,  1.0)
  glVertex3f(1.0, -1.0, -1.0)
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0, -1.0,  1.0)

  glEnd()

  window.swapBuffers()
  
proc esc(window: GLFWwindow, key: int32, scancode: int32, action: int32, mods: int32){.cdecl.} =
  if action == GLFWPress:
        if key == int(GLFWKey.Escape):
            window.setWindowShouldClose(true)


discard glfwInit()
glfwWindowHint(GLFWResizable, GLFW_TRUE)

# кол-во мониторов
var monit_counter: int32
var temp = glfwGetMonitors(addr monit_counter)
echo "Кол-во мониторов:"
echo $(monit_counter) & "\n"

# Получаем инфу тэкущего монитора
var mm_width: int32
var mm_height: int32
var monitor = glfwGetPrimaryMonitor()
monitor.getMonitorPhysicalSize(addr mm_width, addr mm_height)
echo "Моник: " & $getMonitorName(monitor)
var temp2 = getVideoMode(monitor)
var resolution_width = temp2.width
var resolution_height = temp2.height
echo "width " & $resolution_width & " px. (" & $(mm_width) & " mm.)"
echo "height " & $resolution_height  & " px. (" & $(mm_height) & " mm.)" & "\n"
var window = glfwCreateWindow(resolution_width-960, resolution_height-540, "GAME ENGINE") # создание окошка

discard window.setKeyCallback(GLFWKeyFun(esc))
window.makeContextCurrent
doAssert glInit()

glClearColor(172.0/255.0, 246.0/255.0, 246.0/255.0, 1.0)
glEnable(GL_DEPTH_TEST)
glEnable(GL_DEPTH_CLAMP)

glFrustum(-1,1,-1,1,2,8)

# рендер луп
while not window.windowShouldClose():
  render(window)
  glfwPollEvents()

window.destroyWindow()
glfwTerminate()