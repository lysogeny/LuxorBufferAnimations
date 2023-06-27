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
    Object(xy, uv, 1, 0, (-512+20, 512-20), (-512+20, 512-20))
end

function check_collision_x(object::Object)
    if !(object.xlim[1] < object.xy[1] < object.xlim[2])
        object.xy[1] = min(max(object.xlim[1], object.xy[1]), object.xlim[2])
        object.uv[1] *= -1
        object.θ += rand(-1:0.1:1) * 0.1 * pi
    end
end

function check_collision_y(object::Object)
    if !(object.ylim[1] < object.xy[2] < object.ylim[2])
        object.xy[2] = min(max(object.ylim[1], object.xy[2]), object.ylim[2])
        object.uv[2] *= -1
        object.θ += rand(-1:0.1:1) * 0.1 * pi
    end
end

function update!(object::Object)
    #scene.θ += rand(-0.1:0.01:0.1)
    object.xy += 5 * object.uv
    check_collision_x(object)
    check_collision_y(object)
end

function iscollided(a::Object, b::Object)
    r = 20
    xy = a.xy - b.xy
    norm(xy) < r
end

function v_new(v1, v2, x1, x2)
    d = x1 - x2
    v1 - d * dot(v1 - v2, d) / (norm(d)^2) 
end

function collide(a::Object, b::Object)
    a_new = v_new(a.uv, b.uv, a.xy, b.xy)
    b_new = v_new(b.uv, a.uv, b.xy, a.xy)
    @info "Was $(a.uv) is $(a_new)"
    a.uv = a_new
    b.uv = b_new
end

mutable struct BounceScene <: AbstractScene
    frame::Int
    objects::Vector{Object}
end

function BounceScene() 
    BounceScene(0, [Object() for _ in 1:20])
end

function render!(scene::BounceScene, buffer::Matrix{UInt32})
    w, h = size(buffer)
    Luxor.@imagematrix! buffer begin
        Luxor.background("white")
        for object in scene.objects
            Luxor.@layer begin
                Luxor.translate(object.xy...)
                Luxor.circle(0, 0, 40, action=:stroke)
                Luxor.scale(0.2)
                Luxor.rotate(object.θ)
                Luxor.julialogo(action=:fill, centered=true)
            end
        end
    end w h
end

function check_collisions(scene::BounceScene)
    objects = scene.objects
    indices = axes(objects, 1)
    for i = indices, j = indices
        if i == j
            continue
        end
        if iscollided(objects[i], objects[j])
            collide(objects[i], objects[j])
        end
    end
end

function update!(scene::BounceScene)
    Threads.@threads for object in scene.objects
        update!(object) 
    end
    check_collisions(scene)
end
