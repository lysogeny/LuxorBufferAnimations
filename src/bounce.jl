mutable struct Object
    xy::Vector{Float64}
    uv::Vector{Float64}
    s::Float64
    θ::Float64
    xlim::Tuple{Float64, Float64}
    ylim::Tuple{Float64, Float64}
end

function Object()
    xy = [rand(-256:256), rand(-256:256)]
    uv = [rand(0.1:0.1:2), rand(0.1:0.1:2)]
    Object(xy, uv, 1, 0, (-256*1.8, 256*1.8), (-256*1.8, 256*1.8))
end

function update!(object::Object)
    #scene.θ += rand(-0.1:0.01:0.1)
    object.xy += 5 * object.uv
    if !(object.xlim[1] < object.xy[1] < object.xlim[2])
        object.xy[1] = min(max(object.xlim[1], object.xy[1]), object.xlim[2])
        object.uv[1] *= -1
        object.θ += rand(-1:0.1:1) * 0.1 * pi
    end
    if !(object.ylim[1] < object.xy[2] < object.ylim[2])
        object.xy[2] = min(max(object.ylim[1], object.xy[2]), object.ylim[2])
        object.uv[2] *= -1
        object.θ += rand(-1:0.1:1) * 0.1 * pi
    end
end

mutable struct BounceScene <: AbstractScene
    frame::Int
    objects::Vector{Object}
end

function BounceScene() 
    BounceScene(0, [Object() for _ in 1:50])
end

function render!(scene::BounceScene, buffer::Matrix{UInt32})
    w, h = size(buffer)
    Luxor.@imagematrix! buffer begin
        Luxor.background("white")
        for object in scene.objects
            Luxor.@layer begin
                Luxor.translate(object.xy...)
                Luxor.scale(0.2)
                Luxor.rotate(object.θ)
                Luxor.julialogo(action=:fill, centered=true)
            end
        end
    end w h
end

function update!(scene::BounceScene)
    Threads.@threads for object in scene.objects
        update!(object) 
    end
end
