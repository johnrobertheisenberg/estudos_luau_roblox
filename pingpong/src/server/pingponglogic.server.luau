--[[
    Contexto: Projeto001 estudo progressivo gamedev. Criar um pequeno jogo de ping pong.
        Regras para esse jogo: 
            1 - PingPong não deve usar o character.
            2 - A camera tem que ser estatica ou movimentada seguindo a bola movimentação limpa
            3 - As raquetes de pingpong serão controlada pelas setas do teclado ou WASD usando UserInputService.
            4 - Precisará ter uma progressão de dificuldade a bola cada vez fica mais rapida.
            5 - O projeto precisa salvar o tempo recorder do jogador


    Regras: 1 - O Script não pode ser feito por IA
            2 - Você sim pode consultar a IA como meio para aprender, você agente IA deve ensinar o usuario
                a como programar o script, explicando logica e mostrando scripts. 
            3- O projeto tem que ser feito totalmente via script sem Roblox Studio. Usando Apenas Rojo e usando O Studio apenas para executar.
]]
local Players = game:GetService("Players")


local PINGPONG_NAME_BALL = "BALL"
local PINGPONG_POSITION = Vector3.new(0,1,0)
local PINGPONG_SIZE = Vector3.new(2,2,2)

-- mesa
local PINGPONG_MESA_NAME = "MESA"
local PINGPONG_MESA_POSITION = Vector3.new(0,0,0)
local PINGPONG_MESA_SIZE = Vector3.new(20,1,10)

-- raquetes
local RAQUETE_SIZE = Vector3.new(2,5,3)
local RAQUETE_POSITION = PINGPONG_MESA_POSITION.X + PINGPONG_MESA_SIZE.X/2
local offset_Y = 2
local offset_X = 3

local PARENT_OBJECTS = workspace
-- dados --

local RunService = game["RunService"]

local VelocidadeX = 10
local VelocidadeY = 0 
local VelocidadeZ = 3

local ACELERACAO = 4
local TEMPO_DECORRIDO = 0
local GRAVIDADE = -30

local function createpart(nome,tamanho,posicao,forma)
    local LOCAL_PART = Instance.new("Part")
    
    LOCAL_PART.Name = nome
    LOCAL_PART.Size = tamanho
    LOCAL_PART.CFrame = CFrame.new(posicao)
    LOCAL_PART.Shape = forma

    LOCAL_PART.Anchored = true

    LOCAL_PART.Parent = PARENT_OBJECTS
    
    return LOCAL_PART
end

local PINGPONG_BALL_PART = createpart(PINGPONG_NAME_BALL, PINGPONG_SIZE,PINGPONG_POSITION,Enum.PartType.Ball)
local MESA_PINGPONG_PART = createpart(PINGPONG_MESA_NAME,PINGPONG_MESA_SIZE,PINGPONG_MESA_POSITION,Enum.PartType.Block)

local raquete_esquerda = createpart("raquete", RAQUETE_SIZE, Vector3.new(-RAQUETE_POSITION + -offset_X,offset_Y,0), Enum.PartType.Block)

local raquete_direita = createpart("raquertadireita", RAQUETE_SIZE, Vector3.new(RAQUETE_POSITION + offset_X,offset_Y), Enum.PartType.Block)




local TOPO_MESA = MESA_PINGPONG_PART.Position.Y +  PINGPONG_MESA_SIZE.Y/2
local BOLA_RAIO = PINGPONG_BALL_PART.Size.Y/2

local ALTURA_QUICA = 10
local VELOCIDADE_QUIQUE = math.sqrt(2 * math.abs(GRAVIDADE) * ALTURA_QUICA)

local LIMITE_X = PINGPONG_MESA_SIZE.X/2 - BOLA_RAIO
local LIMITE_Y = PINGPONG_MESA_SIZE.Y/2 - BOLA_RAIO

--- evento de movimentação + ReplicatedStorage
local ReplStorage = game["ReplicatedStorage"]
--- EVENT
local event_movement = ReplStorage:WaitForChild("event_movement")


local movimentoY = 0
local R_ALTURA_MAXIMA = ALTURA_QUICA
local R_ALTURA_MINIMA = TOPO_MESA - RAQUETE_SIZE.Y/2

local VELOCIDADE_RAQUETE = 10

-- function mover_raquete()
local function mover_raquete(raquete,deltaTime)
 local posicao_atual = raquete.Position

 local x = posicao_atual.X
 local y = posicao_atual.Y
 local z = posicao_atual.Z

 local novaY = y + movimentoY * VELOCIDADE_RAQUETE * deltaTime

 novaY = math.clamp(novaY,R_ALTURA_MINIMA,R_ALTURA_MAXIMA)

  raquete.Position  = Vector3.new(x,novaY,z)


  print("DEBUG mover_raquete() server -> \n Status -> movendo")
end

--function OnServerEvent
event_movement.OnServerEvent:Connect(function(player, eixoY)

  if eixoY ~= -1 and eixoY ~= 0 and eixoY ~= 1 then
    return
  end
   print("DEBUG input_ended() client -> \n Status -> MovimentoY. Valor -> " .. tonumber(movimentoY) )
  movimentoY = eixoY
end)


RunService.Heartbeat:Connect(function(deltaTime)
  local pos = PINGPONG_BALL_PART.Position 
  
  local direita_x_min = raquete_direita.Position.X - raquete_direita.Size.X /2
  local esquerda_x_max = raquete_esquerda.Position.X + raquete_esquerda.Size.X /2

  local direita_y_min = raquete_direita.Position.Y - raquete_direita.Size.Y /2
  local direita_y_max = raquete_direita.Position.Y + raquete_direita.Size.Y/2

  local direita_z_min = raquete_direita.Position.Z - raquete_direita.Size.Z/2
  local direita_z_max = raquete_direita.Position.Z + raquete_direita.Size.Z/2


  local esquerda_y_min = raquete_esquerda.Position.Y - raquete_esquerda.Size.Y/2
  local esquerda_y_max = raquete_esquerda.Position.Y + raquete_esquerda.Size.Y/2

  local esquerda_z_min = raquete_esquerda.Position.Z - raquete_esquerda.Size.Z/2
  local esquerda_z_max = raquete_esquerda.Position.Z + raquete_esquerda.Size.Z/2


  VelocidadeY += GRAVIDADE * deltaTime

  local x = pos.X + VelocidadeX * deltaTime
  local y = pos.Y + VelocidadeY * deltaTime
  local z = pos.Z 


  if y - BOLA_RAIO <= TOPO_MESA and VelocidadeY < 0 then
    y = TOPO_MESA + BOLA_RAIO
    VelocidadeY = VELOCIDADE_QUIQUE
  end

  
  if VelocidadeX > 0
    and x + BOLA_RAIO >= direita_x_min
    and y + BOLA_RAIO >= direita_y_min
    and y - BOLA_RAIO <= direita_y_max
    and z + BOLA_RAIO >= direita_z_min
    and z - BOLA_RAIO <= direita_z_max then

    x = direita_x_min - BOLA_RAIO
    VelocidadeX = -math.abs(VelocidadeX)

-- A bola alcança a raquete esquerda enquanto vai para a esquerda?
elseif VelocidadeX < 0
    and x - BOLA_RAIO <= esquerda_x_max
    and y + BOLA_RAIO >= esquerda_y_min
    and y - BOLA_RAIO <= esquerda_y_max
    and z + BOLA_RAIO >= esquerda_z_min
    and z - BOLA_RAIO <= esquerda_z_max then

    x = esquerda_x_max + BOLA_RAIO
    VelocidadeX = math.abs(VelocidadeX)
end

 
  mover_raquete(raquete_direita,deltaTime)
  mover_raquete(raquete_esquerda,deltaTime)
  PINGPONG_BALL_PART.Position = Vector3.new(x,y,z)

  TEMPO_DECORRIDO += deltaTime
  if TEMPO_DECORRIDO >= 25 then
    VelocidadeX += math.sign(VelocidadeX) * ACELERACAO
    TEMPO_DECORRIDO -= TEMPO_DECORRIDO
  end

end)