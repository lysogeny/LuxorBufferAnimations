abstract type AbstractScene end

render!(::AbstractScene) = nothing
update!(::AbstractScene) = nothing

mutable struct CircleScene <: AbstractScene
    θ::Float64
    r::Float64
    frame::Int
    CircleScene() = new(0, 30, 0)
end

function update!(scene::CircleScene)
    scene.θ += 0.1
    scene.r += 0.1
    scene.frame += 1
end

function render!(scene::CircleScene, buffer::Matrix{UInt32})
    r = scene.r
    θ = scene.θ
    w, h = size(buffer)
    Luxor.@imagematrix! buffer begin
        Luxor.background("black")
        Luxor.sethue("red")
        Luxor.circle(Luxor.Point(r*cos(θ), r*sin(θ)), r/2-5, action=:fill)
        Luxor.sethue("green")
        Luxor.circle(Luxor.Point(0, 0), r/2-5, action=:fill)
        Luxor.sethue("blue")
        Luxor.circle(Luxor.Point(r*cos(θ+pi), r*sin(θ+pi)), r/2-5, action=:fill)
        Luxor.sethue("white")
        Luxor.fontsize(20)
        Luxor.text("frame=$(lpad(scene.frame, 4, '0'))", -w/2+5, h/2-5, halign=:left, valign=:bottom)
    end w h
end

struct SceneWrapper
    fb::FrameBuffer
    scene::AbstractScene
end

SceneWrapper(fb::FrameBuffer, scene::DataType) = SceneWrapper(fb, scene())

SceneWrapper(w::Int, h::Int, scene::DataType) = SceneWrapper(FrameBuffer(w, h), scene())

function render!(wrapper::SceneWrapper)
    render!(wrapper.scene, wrapper.fb.buffer)
    update!(wrapper.fb)
end

update!(wrapper::SceneWrapper) = update!(wrapper.scene)

function loop(wrapper::SceneWrapper)
    while true
        state = render!(wrapper)
        if state != MiniFB.STATE_OK
            break
        end
        update!(wrapper)
    end
end
