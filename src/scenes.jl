abstract type AbstractScene end

render!(::AbstractScene) = nothing
update!(::AbstractScene) = nothing

mutable struct CircleScene <: AbstractScene
    w::Int
    h::Int
    θ::Float64
    r::Int
    frame::Int
    CircleScene(w::Int, h::Int) = new(w, h, 0, 30, 0)
end

function update!(scene::CircleScene)
    scene.θ += 0.1
    scene.frame += 1
end

function render!(scene::CircleScene)
    r = scene.r
    θ = scene.θ
    Luxor.@imagematrix begin
        Luxor.background("black")
        Luxor.sethue("red")
        Luxor.circle(Luxor.Point(r*cos(θ), r*sin(θ)), r/2-5, action=:fill)
        Luxor.sethue("green")
        Luxor.circle(Luxor.Point(0, 0), r/2-5, action=:fill)
        Luxor.sethue("blue")
        Luxor.circle(Luxor.Point(r*cos(θ+pi), r*sin(θ+pi)), r/2-5, action=:fill)
        Luxor.sethue("white")
        Luxor.fontsize(20)
        Luxor.text("frame=$(scene.frame)", -scene.w/2+5, scene.h/2-5, halign=:left, valign=:bottom)
    end scene.w scene.h
end

struct SceneWrapper
    fb::FrameBuffer
    scene::AbstractScene
end

function SceneWrapper(fb::FrameBuffer, scene::DataType)
    SceneWrapper(fb, scene(size(fb.buffer)...))
end

function SceneWrapper(w::Int, h::Int, scene::DataType)
    fb = FrameBuffer(w, h)
    SceneWrapper(fb, scene(w, h))
end

function render!(wrapper::SceneWrapper)
    wrapper.fb.buffer = render(render!(wrapper.scene))
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
