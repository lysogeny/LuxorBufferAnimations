function render(frame::AbstractMatrix)
    frame = reinterpret(reshape, UInt8, frame)[1:3,:,:]
    [MiniFB.mfb_rgb(reverse(frame[:,x,y])...) for y in axes(frame, 3), x in axes(frame, 2)]
end
