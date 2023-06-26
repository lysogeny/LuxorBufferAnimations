function rgb_circles(w::Int, h::Int; θ=pi, r=50, text="")
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
        Luxor.text(text, -w/2+5, h/2-5, halign=:left, valign=:bottom)
    end w h
end

mutable struct Circles
    fb::FrameBuffer
    w::Int
    h::Int
    θ::Float64
    frame::Int
end

function Circles(w::Int, h::Int) 
    Circles(FrameBuffer(w, h), w, h, 0, 0)
end

function render!(scene::Circles)
    scene.frame += 1
    frame = rgb_circles(scene.w, scene.h, θ=scene.θ, text="frame=$(scene.frame)") |> render
    scene.fb.buffer = frame
    update!(scene.fb)
end

function loop(scene::Circles)
    while true
        state = render!(scene)
        if state != MiniFB.STATE_OK
            break
        end
        scene.θ += 0.1
    end
end

