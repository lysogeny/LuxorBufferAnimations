mutable struct BounceScene <: AbstractScene
    frame::Int
    xy::Vector{Float64}
    uv::Vector{Float64}
    s::Float64
    θ::Float64
    xlim::Tuple{Float64, Float64}
    ylim::Tuple{Float64, Float64}
end

function BounceScene() 
    xy = [rand(-256:256), rand(-256:256)]
    uv = [1, 0.7]
    BounceScene(0, xy, uv, 1, 0, (-256*1.25, 256*1.25), (-256, 256))
end

function render!(scene::BounceScene, buffer::Matrix{UInt32})
    w, h = size(buffer)
    Luxor.@imagematrix! buffer begin
        Luxor.background("white")
        Luxor.rotate(scene.θ)
        Luxor.translate(scene.xy...)
        Luxor.scale(scene.s)
        Luxor.julialogo(action=:fill, centered=true)
    end w h
end

function update!(scene::BounceScene)
    #scene.θ += rand(-0.1:0.01:0.1)
    scene.xy += 5*scene.uv
    if !(scene.xlim[1] < scene.xy[1] < scene.xlim[2])
        scene.uv[1] *= -1
    end
    if !(scene.ylim[1] < scene.xy[2] < scene.ylim[2])
        scene.uv[2] *= -1
    end
end
