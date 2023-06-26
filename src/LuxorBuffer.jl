module LuxorBuffer

import MiniFB
import Luxor

include("framebuffer.jl")

mutable struct Scene
    fb::FrameBuffer
    w::Int
    h::Int
end
Scene(w::Int, h::Int) = Scene(FrameBuffer(w, h), w, h)

function render(scene::Scene)
    frame = Luxor.@imagematrix begin
        Luxor.background("black")
        Luxor.sethue("white")
        Luxor.fontface("Georgia")
        Luxor.fontsize(180)
        Luxor.text("&", halign=:center, valign=:middle)
    end scene.w scene.h
    frame = reinterpret(reshape, UInt8, frame)[1:3,:,:]
    [MiniFB.mfb_rgb(frame[:,x,y]...) for y in axes(frame, 3), x in axes(frame, 2)]
end

function main()
    scene = Scene(512, 512)
    update!(scene.fb)
    sleep(1)
    println("Rendering")
    scene.fb.buffer = render(scene)
    update!(scene.fb)
    sleep(10)
end

export main

end # module LuxorBuffer
