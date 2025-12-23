-- SERVERSCRIPT (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Configuración del Evento
local evento = ReplicatedStorage:FindFirstChild("EventoHitbox") or Instance.new("RemoteEvent", ReplicatedStorage)
evento.Name = "EventoHitbox"

local hitboxActiva = false
local escalaActual = 2

-- Función principal para modificar las cabezas
local function actualizarCabezas()
    for _, jugador in pairs(Players:GetPlayers()) do
        local personaje = jugador.Character
        if personaje and personaje:FindFirstChild("Head") then
            local cabeza = personaje.Head
            
            if hitboxActiva then
                -- Aplicar Hitbox: Roja y Transparente
                cabeza.Size = Vector3.new(escalaActual, escalaActual, escalaActual)
                cabeza.Color = Color3.new(1, 0, 0) -- Rojo puro
                cabeza.Transparency = 0.5 -- Transparencia
                cabeza.CanCollide = true
            else
                -- Restaurar a la normalidad
                cabeza.Size = Vector3.new(1.2, 1.2, 1.2)
                cabeza.Color = Color3.fromRGB(163, 162, 165)
                cabeza.Transparency = 0
            end
        end
    end
end

-- Escuchar comandos del Menú
evento.OnServerEvent:Connect(function(player, accion, valor)
    if accion == "Estado" then
        hitboxActiva = valor
    elseif accion == "Tamano" then
        escalaActual = tonumber(valor) or 2
    end
    actualizarCabezas()
end)

-- Sistema de Daño (Detecta cuando la bala toca la cabeza)
Players.PlayerAdded:Connect(function(jugador)
    jugador.CharacterAdded:Connect(function(personaje)
        local cabeza = personaje:WaitForChild("Head")
        
        cabeza.Touched:Connect(function(objeto)
            -- Cambia "Bala" por el nombre del proyectil que uses en tu juego
            if objeto.Name == "Bala" and hitboxActiva then
                local humanoid = personaje:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:TakeDamage(40) -- Daño por cada tiro
                    print("¡Tiro a la cabeza en " .. jugador.Name .. "!")
                end
            end
        end)
    end)
end)
