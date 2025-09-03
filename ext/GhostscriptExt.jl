module GhostscriptExt
import Latexify._gs_cmd
isdefined(Base, :get_extension) ? (using Ghostscript_jll) : (using ..Ghostscript_jll)

_gs_cmd(::Bool) = gs()

end
