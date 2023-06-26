module LuxorBuffer

import MiniFB
import Luxor
import Mods

include("framebuffer.jl")
include("utils.jl")
include("scenes.jl")
include("images.jl")

function main()
    wrapper = SceneWrapper(512, 512, CircleScene)
    loop(wrapper)
end

export main

end # module LuxorBuffer
