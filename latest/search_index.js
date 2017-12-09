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
    "text": "Latexify.jl is a package which supplies functions for producing LaTeX formatted strings from Julia objects. Among the supported input types are Julia Expressions, which gets converted to properly formatted LaTeX maths."
},

{
    "location": "index.html#Supported-objects-1",
    "page": "Latexify.jl",
    "title": "Supported objects",
    "category": "section",
    "text": "This package supplies functionality for latexifying objects of the following types:Expressions,\nStrings,\nNumbers (including rational and complex),\nDataFrames' NA type,\nSymbols,\nSymbolic expressions from SymEngine.jl.Along with any shape of array which contains elements of the above types.Example:julia> str = \"x/(2*k_1+x^2)\"\njulia> print(latexify(str))\n\n\\frac{x}{2 \\cdot k_{1} + x^{2}}which renders as\\begin{equation*} \\frac{x}{2 \\cdot k_{1} + x^{2}} \\end{equation*}"
},

{
    "location": "index.html#Functions-1",
    "page": "Latexify.jl",
    "title": "Functions",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#latexraw(x)-1",
    "page": "Latexify.jl",
    "title": "latexraw(x)",
    "category": "section",
    "text": "Latexifies an object x and returns a LaTeX formatted string. If the input is an array, latexraw recurses it and latexifies its elements.This function does not surround the resulting string in any LaTeX environments."
},

{
    "location": "index.html#latexify(x)-1",
    "page": "Latexify.jl",
    "title": "latexify(x)",
    "category": "section",
    "text": "Passes x to latexraw, but converts the output to a LaTeXString and surrounds it with a simple $$ environment."
},

{
    "location": "index.html#latexalign()-1",
    "page": "Latexify.jl",
    "title": "latexalign()",
    "category": "section",
    "text": "Latexifies input and surrounds it with an align environment. Useful for systems of equations and such fun stuff."
},

{
    "location": "index.html#latexarray()-1",
    "page": "Latexify.jl",
    "title": "latexarray()",
    "category": "section",
    "text": "Latexifies a 1 or 2D array and generates a corresponding LaTeX array."
},

{
    "location": "index.html#Automatic-copying-to-clipboard-1",
    "page": "Latexify.jl",
    "title": "Automatic copying to clipboard",
    "category": "section",
    "text": "The strings that you would see when using print on any of the above functions can be automatically copied to the clipboard if you so specify. Since I do not wish to mess with your clipboard without you knowing it, this feature must be activated by you.To do so, run'''julia Latexify.copy_to_clipboard(true) '''To once again disable the feature, pass false to the same function.The copying to the clipboard will now occur at every call to a Latexify.jl function, regardless of how you chose to display the output."
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
    "text": "takes a Julia object x and returns a LaTeX formatted string. It also surrounds the output in a simple $$ environment. This works for x of many types, including expressions, which returns LaTeX code for an equation.julia> ex = :(x-y/z)\njulia> latexify(ex)\nL\"$x - \\frac{y}{z}$\"In Jupyter or Hydrogen this automatically renders as:x - fracyzAmong the supported types are:Expressions,\nStrings,\nNumbers (including rational and complex),\nSymbols,\nSymbolic expressions from SymEngine.jl.\nParameterizedFunctions.It can also take arrays, which it recurses and latexifies the elements, returning an array of latex strings."
},

{
    "location": "tutorials/latexalign.html#",
    "page": "latexalign",
    "title": "latexalign",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/latexalign.html#latexalign-1",
    "page": "latexalign",
    "title": "latexalign",
    "category": "section",
    "text": "This function converts its input to LaTeX align environments. One way of using the function is to pass it two vectors, one which holds the left-hand-side of the equations and the other which holds the right. For example:lhs = [\"dx/dt\", \"dy/dt\"]\nrhs = [\"y^2 - x\", \"x/y - y\"]\nprint(latexalign(lhs, rhs))outputs:\\begin{align}\n\\frac{dx}{dt} =& y^{2} - x \\\\\n\\frac{dy}{dt} =& \\frac{x}{y} - y \\\\\n\\end{align}In Jupyter, this can be rendered by:display( latexalign(lhs, rhs))\\begin{align*} \\frac{dx}{dt} =& y^{2} - x \\\\\n\\frac{dy}{dt} =& \\frac{x}{y} - y \\\\\n\\end{align*}"
},

{
    "location": "tutorials/latexalign.html#Using-DifferentialEquations.jl-1",
    "page": "latexalign",
    "title": "Using DifferentialEquations.jl",
    "category": "section",
    "text": "The motivation for creating this function was mainly to be able to render ODEs. In my own work, I tend to use DifferentialEquations.jl to define ODEs as ParameterizedFunctions. Therefore, I found it useful to create a method which simply takes the ParameterizedFunction as input:using DifferentialEquations\node = @ode_def positiveFeedback begin\n    dx = y/(k_y + y) - x\n    dy = x^n_x/(k_x^n_x + x^n_x) - y\nend k_y=>1.0 k_x=>1.0 n_x=>1\n\nprint(latexalign(ode))This generates LaTeX code that renders as:\\begin{align} \\frac{dx}{dt} =& \\frac{y}{k_{y} + y} - x \\\\\n\\frac{dy}{dt} =& \\frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y \\\\\n\\end{align}"
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
    "text": "This functions takes a 1 or 2D array and spits out a latex array environment. For example:julia> arr = eye(Int,3)\njulia> print(latexarray(arr))\n\n\\begin{equation}\n\\left[\n\\begin{array}{ccc}\n1 & 0 & 0\\\\\n0 & 1 & 0\\\\\n0 & 0 & 1\\\\\n\\end{array}\n\\right]\n\\end{equation}which renders as:\\begin{equation} \\left[ \\begin{array}{ccc} 1 & 0 & 0\\\\\n0 & 1 & 0\\\\\n0 & 0 & 1\\\\\n\\end{array} \\right] \\end{equation}latexify() is called for each element of the input, individually. It therefore does not matter if the input array is of a mixed type.arr = [1.0, 2-3im, 3//4, :(x/(k_1+x)), \"e^(-k_b*t)\"]\nprint(latexarray(arr))renders as:\\begin{equation} \\left[ \\begin{array}{c} 1.0\\\\\n2-3\\textit{i}\\\\\n\\frac{3}{4}\\\\\n\\frac{x}{k_{1} + x}\\\\\ne^{- k_{b} \\cdot t}\\\\\n\\end{array} \\right] \\end{equation}"
},

{
    "location": "tutorials/parameterizedfunctions.html#",
    "page": "Use with ParameterizedFunctions",
    "title": "Use with ParameterizedFunctions",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/parameterizedfunctions.html#Use-with-ParameterizedFunctions-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Use with ParameterizedFunctions",
    "category": "section",
    "text": "In the latexalign tutorial I mentioned that one can use latexalign directly on a ParameterizedFunction. Here, I make a somewhat more convoluted and hard-to-read example (you'll soon se why):using Latexify\nusing DifferentialEquations\node = @ode_def positiveFeedback begin\n    dx = y*y*y/(k_y_x + y) - x - x\n    dy = x^n_x/(k_x^n_x + x^n_x) - y\nend k_y=>1.0 k_x=>1.0 n_x=>1\n\nlatexalign(ode)\nprint(latexalign(ode))This generates LaTeX code that renders as:\\begin{align} \\frac{dx}{dt} =& \\frac{y \\cdot y \\cdot y}{k_{y_x} + y} - x - x \\\\\n\\frac{dy}{dt} =& \\frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y \\\\\n\\end{align}This is pretty nice, but there are a few parts of the equation which could be reduced. Using a keyword argument, you can utilise the SymEngine.jl to reduce the expression before printing.latexalign(ode, field=:symfuncs)\\begin{align} \\frac{dx}{dt} =& -2 \\cdot x + \\frac{y^{3}}{k_{y_x} + y} \\\\\n\\frac{dy}{dt} =& - y + \\frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} \\\\\n\\end{align}ParameterizedFunctions symbolically calculates the jacobian, inverse jacobian, hessian, and all kinds of goodness. Since they are available as arrays of symbolic expressions, which are latexifyable, you can render pretty much all of them.latexarray(ode.symjac)\\begin{equation} \\left[ \\begin{array}{cc} -2 & \\frac{3 \\cdot y^{2}}{k_{y_x} + y} - \\frac{y^{3}}{\\left( k_{y_x} + y \\right)^{2}}\\\\\n\\frac{x^{-1 + n_{x}} \\cdot n_{x}}{k_{x}^{n_{x}} + x^{n_{x}}} - \\frac{x^{-1 + 2 \\cdot n_{x}} \\cdot n_{x}}{\\left( k_{x}^{n_{x}} + x^{n_{x}} \\right)^{2}} & -1\\\\\n\\end{array} \\right] \\end{equation}Pretty neat huh? And if you learn how to use latexify, latexalign, latexraw and latexarray you can really format the output in pretty much any way you want."
},

{
    "location": "tutorials/inner_workings.html#",
    "page": "Inner workings",
    "title": "Inner workings",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/inner_workings.html#Inner-workings-1",
    "page": "Inner workings",
    "title": "Inner workings",
    "category": "section",
    "text": "This package contains a large number of methods, but two of these are of special importance. These are:latexraw(ex::Expr)andlatexoperation(ex::Expr, prevOp::AbstractArray)These two methods are involved with all conversions to LaTeX equations. latexraw(ex::Expr) utilises Julias homoiconicity to infer the correct latexification of an expression by recursing through the expression tree. Whenever it hits the end of a recursion it passes the last expression to latexoperation(). By the nature of this recursion, this expression is one which only contains symbols or strings."
},

{
    "location": "tutorials/inner_workings.html#Explanation-by-example-1",
    "page": "Inner workings",
    "title": "Explanation by example",
    "category": "section",
    "text": "Let's define a variable of the expression type:julia> ex = :(x + y/z)This expression has a field which contains the first operation which must be done, along with the objects that this operation will operate on:julia> ex.args\n\n3-element Array{Any,1}:\n :+      \n :x      \n :(y / z)The first two element are both Symbols, while the third one is an expression:julia> typeof.(ex.args)\n\n3-element Array{DataType,1}:\n Symbol\n Symbol\n ExprSince at least one of these elements is an expression, the next step of the recursive algorithm is to dive into that expression:julia> newEX = ex.args[3]\njulia> newEx.args\n\n3-element Array{Any,1}:\n :/\n :y\n :zSince none of these arguments is another expression, newEx will be passed to latexoperation(). This function checks which mathematical operation is being done and converts newEx to an appropriately formatted string. In this case, that string will be \"\\\\frac{y}{z}\" (and yes, a double slash is needed).newEx is now a string (despite its name):julia> newEx\n\n\"\\\\frac{y}{z}\"The recursive latexraw() pulls this value back to the original expression ex, such that:julia> ex.args\n\n3-element Array{Any,1}:\n :+      \n :x      \n :\"\\\\frac{y}{z}\"Now, since this expression does not consist of any further expressions, it is passed to latexoperation(). The operator is now \"+\", and it should be applied on the second and third element of the expression, resulting in:\"x + \\\\frac{y}{z}\"using the print function you get:julia> print(latexraw(ex))\n\n\"x + \\frac{y}{z}\"which in a LaTeX maths environment renders as:x + fracyz"
},

{
    "location": "tutorials/inner_workings.html#Extended-functionality-1",
    "page": "Inner workings",
    "title": "Extended functionality",
    "category": "section",
    "text": "With the above example we can understand how an expression is converted to a LaTeX formatted string (unless my pedagogical skills are worse than I fear).So, anything which can be converted to a Julia expression of the Expr type can be latexified. Luckily, since Julia needs to convert your code to expressions before it can be evaluated, Julia is already great at doing this.There are already some methods for converting other types to expressions and passing them to the core method, for example:latexraw(str::String) = latexraw(parse(str))but if you find yourself wanting to parse some other type, it is often easy to overload the latexraw function."
},

{
    "location": "tutorials/inner_workings.html#Latexifying-Arrays-1",
    "page": "Inner workings",
    "title": "Latexifying Arrays",
    "category": "section",
    "text": "Also, if you pass an array to latexraw, it will recursively try to convert the elements of that array to LaTeX formatted strings.julia> arr = [:(x-y/(k_10+z)), \"x*y*z/3\"]\njulia> latexraw(arr)\n2-element Array{String,1}:\n \"x - \\\\frac{y}{k_{10} + z}\"     \n \"\\\\frac{x \\\\cdot y \\\\cdot z}{3}\"\n\njulia> println.(latexraw(arr))\nx - \\frac{y}{k_{10} + z}\n\\frac{x \\cdot y \\cdot z}{3}"
},

{
    "location": "functions/latexify.html#",
    "page": "latexify",
    "title": "latexify",
    "category": "page",
    "text": ""
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
    "text": "latexarray{T}(arr::AbstractArray{T, 2})\n\nCreate a LaTeX array environment using latexraw.\n\nExamples\n\narr = [1 2; 3 4]\nlatexarray(arr)\n# output\n\"\\begin{equation}\n\\left[\n\\begin{array}{cc}\n1 & 2\\\\ \n3 & 4\\\\ \n\\end{array}\n\\right]\n\\end{equation}\n\"\n\n\n\n"
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
