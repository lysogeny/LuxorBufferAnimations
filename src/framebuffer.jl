mutable struct FrameBuffer
    window::Ptr{Cvoid}
    buffer::Matrix{UInt32}
    function FrameBuffer(buffer::Matrix{UInt32}; title="MiniFB.jl") 
        w, h = size(buffer)
        window = MiniFB.mfb_open(title, w, h)
        new(window, buffer)
    end
end

function FrameBuffer(w::Int, h::Int)
    buffer = zeros(UInt32, w, h)
    FrameBuffer(buffer)
end

function update_loop(fb::FrameBuffer)
    state = update!(fb)
    while state == MiniFB.STATE_OK
        state = update!(fb)
        sleep(1/30)
    end
end

update!(fb::FrameBuffer) = MiniFB.mfb_update(fb.window, fb.buffer)
