module LuxorBuffer

import MiniFB
import Luxor
import Mods

include("framebuffer.jl")
include("utils.jl")
include("images.jl")

function main()
    scene = Circles(512, 512)
    loop(scene)
end

export main

end # module LuxorBuffer
