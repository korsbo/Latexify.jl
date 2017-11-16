var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Latexify.jl",
    "title": "Latexify.jl",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Latexify.jl-1",
    "page": "Latexify.jl",
    "title": "Latexify.jl",
    "category": "section",
    "text": "Latexify.jl is a package which supplies functions for producing LaTeX formatted strings from Julia objects.This package allows, among other things, for converting a Julia expression to a LaTeX formatted equation."
},

{
    "location": "index.html#At-a-glance-1",
    "page": "Latexify.jl",
    "title": "At a glance",
    "category": "section",
    "text": "This package provides a few functions of potential interest:"
},

{
    "location": "index.html#latexify(x)-1",
    "page": "Latexify.jl",
    "title": "latexify(x)",
    "category": "section",
    "text": "takes a Julia object x and returns a LaTeX formatted string. This works for x of many types, including expressions, which returns LaTeX code for an equation.julia> ex = :(x-y/z)\njulia> latexify(ex)\n\"x - \\\\frac{y}{z}\"Among the supported types are:Expressions,\nStrings,\nNumbers (including rational and complex),\nSymbols,\nSymbolic expressions from SymEngine.jl.It can also take arrays, which it recurses and latexifies the elements, returning an array of latex strings."
},

{
    "location": "index.html#latexalign(x)-1",
    "page": "Latexify.jl",
    "title": "latexalign(x)",
    "category": "section",
    "text": "While latexify does not provide a LaTeX environment surrounding the resulting string, latexalign does. As the name implies, it creates an align environment."
},

{
    "location": "index.html#Inner-workings-1",
    "page": "Latexify.jl",
    "title": "Inner workings",
    "category": "section",
    "text": "This package contains a large number of methods, but two of these are of special importance. These are:latexify(ex::Expr)andlatexoperation(ex::Expr, prevOp::AbstractArray)Almost all other functions or methods eventually lead to these two.latexify(ex::Expr) utilises Julias homoiconicity to infer the correct latexification of an expression by recursing through the expression tree. Whenever it hits the end of a recursion it passes the last expression to latexoperation(). By the nature of this recursion, this expression is one which only contains symbols or strings."
},

{
    "location": "index.html#Explanation-by-example-1",
    "page": "Latexify.jl",
    "title": "Explanation by example",
    "category": "section",
    "text": "Let's define a variable of the expression type:julia> ex = :(x + y/z)This expression has a field which contains the first operation which must be done, along with the objects that this operation will operate on:julia> ex.args\n\n3-element Array{Any,1}:\n :+      \n :x      \n :(y / z)The first two element are both Symbols, while the third one is an expression:julia> typeof.(ex.args)\n\n3-element Array{DataType,1}:\n Symbol\n Symbol\n ExprSince at least one of these elements is an expression, the next step of the recursive algorithm is to dive into that expression:julia> newEX = ex.args[3]\njulia> newEx.args\n\n3-element Array{Any,1}:\n :/\n :y\n :zSince none of these arguments is another expression, newEx will be passed to latexoperation(). This function checks which mathematical operation is being done and converts newEx to an appropriately formatted string. In this case, that string will be \"\\\\frac{y}{z}\" (and yes, a double slash is needed).newEx is now a string (despite its name):julia> newEx\n\n\"\\\\frac{y}{z}\"The recursive latexify() pulls this value back to the original expression ex, such that:julia> ex.args\n\n3-element Array{Any,1}:\n :+      \n :x      \n :\"\\\\frac{y}{z}\"Now, since this expression does not consist of any further expressions, it is passed to latexoperation(). The operator is now \"+\", and it should be applied on the second and third element of the expression, resulting in:\"x + \\\\frac{y}{z}\"using the print function you get:julia> print(latexify(ex))\n\n\"x + \\frac{y}{z}\"which in a LaTeX maths environment renders as:x + fracyz"
},

{
    "location": "index.html#Extended-functionality-1",
    "page": "Latexify.jl",
    "title": "Extended functionality",
    "category": "section",
    "text": "With the above example we can understand how an expression is converted to a LaTeX formatted string (unless my pedagogical skills are worse than I fear).So, anything which can be converted to a Julia expression of the Expr type can be latexified. Luckily, since Julia needs to convert your code to expressions before it can be evaluated, Julia is already great at doing this.There are already some methods for converting other types to expressions and passing them to the core method, for example:latexify(str::String) = latexify(parse(str))but if you find yourself wanting to parse some other type, it is often easy to overload the latexify function."
},

{
    "location": "index.html#Latexifying-Arrays-1",
    "page": "Latexify.jl",
    "title": "Latexifying Arrays",
    "category": "section",
    "text": "Also, if you pass an array to latexify, it will recursively try to convert the elements of that array to LaTeX formatted strings.julia> arr = [:(x-y/(k_10+z)), \"x*y*z/3\"]\njulia> latexify(arr)\n2-element Array{String,1}:\n \"x - \\\\frac{y}{k_{10} + z}\"     \n \"\\\\frac{x \\\\cdot y \\\\cdot z}{3}\"\n\njulia> println.(latexify(arr))\nx - \\frac{y}{k_{10} + z}\n\\frac{x \\cdot y \\cdot z}{3}"
},

{
    "location": "tutorials/latexify.html#",
    "page": "latexify",
    "title": "latexify",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/latexify.html#latexify-1",
    "page": "latexify",
    "title": "latexify",
    "category": "section",
    "text": ""
},

{
    "location": "tutorials/latexarray.html#",
    "page": "latexarray",
    "title": "latexarray",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/latexarray.html#latexarray-1",
    "page": "latexarray",
    "title": "latexarray",
    "category": "section",
    "text": ""
},

{
    "location": "functions/latexify.html#",
    "page": "latexify",
    "title": "latexify",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexify.html#Latexify.latexify",
    "page": "latexify",
    "title": "Latexify.latexify",
    "category": "Function",
    "text": "latexify(arg)\n\nGenerate LaTeX equations from arg.\n\nParses expressions, ParameterizedFunctions, SymEngine.Base and arrays thereof. Returns a string formatted for LaTeX.\n\nExamples\n\nusing expressions\n\nexpr = :(x/(y+x))\nlatexify(expr)\n\n# output\n\n\"\\\\frac{x}{y + x}\"\n\nexpr = parse(\"x/(y+x)\")\nlatexify(expr)\n\n# output\n\n\"\\\\frac{x}{y + x}\"\n\nusing ParameterizedFunctions\n\nusing DifferentialEquations;\nf = @ode_def feedback begin\n         dx = y/c_1 - x\n         dy = x^c_2 - y\n       end c_1=>1.0 c_2=>1.0\nlatexify(f)\n\n# output\n\n2-element Array{String,1}:\n \"dx/dt = \\\\frac{y}{c_{1}} - x\"\n \"dy/dt = x^{c_{2}} - y\"\n\nusing SymEngine\n\nusing SymEngine\n@vars x y\nsymExpr = x + x + x*y*y\nlatexify(symExpr)\n\n# output\n\n\"2 \\\\cdot x + x \\\\cdot y^{2}\"\n\n\n\n"
},

{
    "location": "functions/latexify.html#latexify-1",
    "page": "latexify",
    "title": "latexify",
    "category": "section",
    "text": "DocTestSetup = quote\nusing Latexify\nendlatexifyDocTestSetup = nothing"
},

{
    "location": "functions/latexalign.html#",
    "page": "latexalign",
    "title": "latexalign",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexalign.html#Latexify.latexalign",
    "page": "latexalign",
    "title": "Latexify.latexalign",
    "category": "Function",
    "text": "latexalign()\n\nGenerate a LaTeX align environment from an input.\n\nExamples\n\nuse with arrays\n\nlhs = [:(dx/dt), :(dy/dt), :(dz/dt)]\nrhs = [:(y-x), :(x*z-y), :(-z)]\nlatexalign(lhs, rhs)\n\n# output\n\n\"\\\\begin{align}\\n\\\\frac{dx}{dt} =& y - x \\\\\\\\ \\n\\\\frac{dy}{dt} =& x \\\\cdot z - y \\\\\\\\ \\n\\\\frac{dz}{dt} =& - z \\\\\\\\ \\n\\\\end{align}\\n\"\n\nuse with ParameterizedFunction\n\nusing DifferentialEquations\node = @ode_def foldChangeDetection begin\n    dm = r_m * (i - m)\n    dy = r_y * (p_y * i/m - y)\nend i=>1.0 r_m=>1.0 r_y=>1.0 p_y=>1.0\n\nlatexalign(ode)\n\n# output\n\n\"\\\\begin{align}\\n\\\\frac{dm}{dt} =& r_{m} \\\\cdot (i - m) \\\\\\\\ \\n\\\\frac{dy}{dt} =& r_{y} \\\\cdot (\\\\frac{p_{y} \\\\cdot i}{m} - y) \\\\\\\\ \\n\\\\end{align}\\n\"\n\n\n\n"
},

{
    "location": "functions/latexalign.html#latexalign-1",
    "page": "latexalign",
    "title": "latexalign",
    "category": "section",
    "text": "DocTestSetup = quote\nusing Latexify\nusing DifferentialEquations\nendlatexalignDocTestSetup = nothing"
},

{
    "location": "functions/latexarray.html#",
    "page": "latexarray",
    "title": "latexarray",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexarray.html#Latexify.latexarray",
    "page": "latexarray",
    "title": "Latexify.latexarray",
    "category": "Function",
    "text": "latexarray{T}(arr::AbstractArray{T, 2})\n\nCreate a LaTeX array environment using latexify.\n\nExamples\n\narr = [1 2; 3 4]\nlatexarray(arr)\n# output\n\"\\begin{equation}\n\\left[\n\\begin{array}{cc}\n1 & 2\\\\ \n3 & 4\\\\ \n\\end{array}\n\\right]\n\\end{equation}\n\"\n\n\n\n"
},

{
    "location": "functions/latexarray.html#latexarray-1",
    "page": "latexarray",
    "title": "latexarray",
    "category": "section",
    "text": "DocTestSetup = quote\nusing Latexify\nusing DifferentialEquations\nendlatexarrayDocTestSetup = nothing"
},

{
    "location": "functions/latexoperation.html#",
    "page": "latexoperation",
    "title": "latexoperation",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexoperation.html#Latexify.latexoperation",
    "page": "latexoperation",
    "title": "Latexify.latexoperation",
    "category": "Function",
    "text": "latexoperation(ex::Expr, prevOp::AbstractArray)\n\nTranslate a simple operation given by ex to LaTeX maths syntax. This uses the information about the previous operations to deside if a parenthesis is needed.\n\n\n\n"
},

{
    "location": "functions/latexoperation.html#latexoperation-1",
    "page": "latexoperation",
    "title": "latexoperation",
    "category": "section",
    "text": "This function is not exported.DocTestSetup = quote\nusing Latexify\nusing DifferentialEquations\nendLatexify.latexoperationDocTestSetup = nothing"
},

]}
