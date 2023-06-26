module LuxorBuffer

import MiniFB
import Luxor
import Mods

include("framebuffer.jl")
include("utils.jl")
include("scenes.jl")
include("bounce.jl")
include("images.jl")

function main()
    fb = FrameBuffer(512, 512)
    wrapper = SceneWrapper(fb, BounceScene)
    loop(wrapper)
end

export main

end # module LuxorBuffer
