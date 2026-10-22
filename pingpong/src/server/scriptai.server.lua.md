--[[
    Projeto001 - Ping Pong 3D (fisica da bola)
    Contem: mesa, bola, gravidade, quique na mesa, colisao nos limites
    (X = comprimento da mesa, Y = altura, Z = largura) e progressao de dificuldade.

    Teste com Run (F8) no Studio, para nao nascer personagem.
]]

local RunService = game:GetService("RunService")

-- ===== CONSTANTES =====
local PARENT = workspace

-- mesa
local MESA_NOME = "Mesa"
local MESA_TAMANHO = Vector3.new(30, 1, 10)
local MESA_POSICAO = Vector3.new(0, 0, 0)
local TOPO_MESA = MESA_POSICAO.Y + MESA_TAMANHO.Y / 2

-- bola
local BOLA_NOME = "Ball"
local BOLA_TAMANHO = Vector3.new(1, 1, 1)
local BOLA_RAIO = BOLA_TAMANHO.Y / 2
local BOLA_POSICAO_INICIAL = Vector3.new(-12, 6, 0)

-- fisica
local GRAVIDADE = -30            -- aceleracao no eixo Y (studs/s^2)
local ALTURA_QUIQUE = 4          -- altura maxima desejada acima da mesa
local VELOCIDADE_QUIQUE = math.sqrt(2 * math.abs(GRAVIDADE) * ALTURA_QUIQUE) -- v = raiz(2*g*h)

-- progressao de dificuldade
local ACELERACAO = 2             -- soma na velocidade X a cada intervalo
local INTERVALO_ACELERACAO = 5   -- segundos

-- limites onde a bola quica (centro da bola nao passa disso)
-- X: no futuro, aqui entram as raquetes e a pontuacao
local LIMITE_X = MESA_TAMANHO.X / 2 - BOLA_RAIO
local LIMITE_Z = MESA_TAMANHO.Z / 2 - BOLA_RAIO

-- ===== CRIACAO DOS OBJETOS =====
local function criar_parte(nome, tamanho, posicao, forma)
    local parte = Instance.new("Part")
    parte.Name = nome
    parte.Anchored = true
    parte.Size = tamanho
    parte.CFrame = CFrame.new(posicao)
    if forma then
        parte.Shape = forma
    end
    parte.Parent = PARENT -- Parent por ultimo
    return parte
end

local mesa = criar_parte(MESA_NOME, MESA_TAMANHO, MESA_POSICAO)
local bola = criar_parte(BOLA_NOME, BOLA_TAMANHO, BOLA_POSICAO_INICIAL, Enum.PartType.Ball)

-- ===== ESTADO DA BOLA =====
local velocidade_x = 5
local velocidade_y = 0
local velocidade_z = 3
local tempo_decorrido = 0

-- ===== LOOP PRINCIPAL =====
RunService.Heartbeat:Connect(function(deltaTime)
    -- 1) gravidade: atualiza a velocidade Y antes da posicao
    velocidade_y += GRAVIDADE * deltaTime

    -- 2) nova posicao nos tres eixos
    local pos = bola.Position
    local x = pos.X + velocidade_x * deltaTime
    local y = pos.Y + velocidade_y * deltaTime
    local z = pos.Z + velocidade_z * deltaTime

    -- 3) colisao com a mesa (parte de baixo da bola x topo da mesa)
    -- so quica se estiver descendo, para nao prender a bola
    if y - BOLA_RAIO <= TOPO_MESA and velocidade_y < 0 then
        y = TOPO_MESA + BOLA_RAIO
        velocidade_y = VELOCIDADE_QUIQUE
    end

    -- 4) colisao nos limites em X (substituir pelas raquetes depois)
    if x > LIMITE_X then
        x = LIMITE_X
        velocidade_x = -math.abs(velocidade_x)
    elseif x < -LIMITE_X then
        x = -LIMITE_X
        velocidade_x = math.abs(velocidade_x)
    end

    -- 5) colisao nos limites em Z (laterais da mesa)
    if z > LIMITE_Z then
        z = LIMITE_Z
        velocidade_z = -math.abs(velocidade_z)
    elseif z < -LIMITE_Z then
        z = -LIMITE_Z
        velocidade_z = math.abs(velocidade_z)
    end

    -- 6) aplica a posicao uma unica vez por frame
    bola.Position = Vector3.new(x, y, z)

    -- 7) progressao de dificuldade: aumenta a velocidade mantendo o sentido
    tempo_decorrido += deltaTime
    if tempo_decorrido >= INTERVALO_ACELERACAO then
        tempo_decorrido -= INTERVALO_ACELERACAO
        velocidade_x += math.sign(velocidade_x) * ACELERACAO
    end
end)