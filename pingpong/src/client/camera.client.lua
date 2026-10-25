local CurrentCamera = workspace.CurrentCamera
CurrentCamera.CameraType = Enum.CameraType.Scriptable




local objeto_base = workspace:WaitForChild("MESA")
local pos = objeto_base.Position

local x = pos.X/2
local y = 10
local OFFSET_Z = 10

CurrentCamera.CFrame = CFrame.new(Vector3.new(x, y, OFFSET_Z))  * CFrame.Angles(math.rad(-24),0,0)
CurrentCamera.FieldOfView = 80

print("Mesa:", objeto_base:GetFullName())
print("Posição:", pos)
print("Câmera:", CurrentCamera.CFrame.Position)
print("Tipo:", CurrentCamera.CameraType)