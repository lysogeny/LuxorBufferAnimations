mutable struct BounceScene <: AbstractScene
    frame::Int
    x::Float64
    y::Float64
    s::Float64
    θ::Float64
end
BounceScene() = BounceScene(0, 0, 0, 1, 0)

function render!(scene::BounceScene, buffer::Matrix{UInt32})
    w, h = size(buffer)
    Luxor.@imagematrix! buffer begin
        Luxor.background("white")
        Luxor.rotate(scene.θ)
        Luxor.translate(scene.x, scene.y)
        Luxor.scale(scene.s)
        Luxor.julialogo(action=:fill, centered=true)
    end w h
end

function update!(scene::BounceScene)
    #scene.θ += rand(-0.1:0.01:0.1)
    scene.x += rand(-5:0.1:5)
    scene.y += rand(-5:0.1:5)
    scene.s = exp(log(scene.s) + rand(-0.05:0.01:0.05))
end

