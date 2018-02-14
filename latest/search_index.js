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
    "text": "This package supplies functionality for latexifying objects of the following types:Expressions,\nStrings,\nNumbers (including rational and complex),\nMissings' Missing type,\nSymbols,\nSymbolic expressions from SymEngine.jl.Along with any shape of array which contains elements of the above types.Example:julia> str = \"x/(2*k_1+x^2)\"\njulia> print(latexify(str))\n\n\\frac{x}{2 \\cdot k_{1} + x^{2}}which renders as\\begin{equation*} \\frac{x}{2 \\cdot k_{1} + x^{2}} \\end{equation*}"
},

{
    "location": "index.html#Functions,-at-a-glance-1",
    "page": "Latexify.jl",
    "title": "Functions, at a glance",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#latexify(x)-1",
    "page": "Latexify.jl",
    "title": "latexify(x)",
    "category": "section",
    "text": "Latexifies x and returns it in a suitable latex environment. Inputs which are not containers are converted into inline equations $$, container types (AbstractArray) are converted to arrays, and ParameterizedFunctions are converted to align environments."
},

{
    "location": "index.html#latexraw(x)-1",
    "page": "Latexify.jl",
    "title": "latexraw(x)",
    "category": "section",
    "text": "Latexifies an object x and returns a LaTeX formatted string. If the input is an array, latexraw recurses it and latexifies its elements.This function does not surround the resulting string in any LaTeX environments."
},

{
    "location": "index.html#latexinline(x)-1",
    "page": "Latexify.jl",
    "title": "latexinline(x)",
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
    "location": "index.html#latextabular()-1",
    "page": "Latexify.jl",
    "title": "latextabular()",
    "category": "section",
    "text": "Latexifies the elements of a 1 or 2D array and puts them in a tabular environment."
},

{
    "location": "index.html#Automatic-copying-to-clipboard-1",
    "page": "Latexify.jl",
    "title": "Automatic copying to clipboard",
    "category": "section",
    "text": "The strings that you would see when using print on any of the above functions can be automatically copied to the clipboard if you so specify. Since I do not wish to mess with your clipboard without you knowing it, this feature must be activated by you.To do so, runLatexify.copy_to_clipboard(true)To once again disable the feature, pass false to the same function.The copying to the clipboard will now occur at every call to a Latexify.jl function, regardless of how you chose to display the output."
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
    "text": "This is a wrapper of some of the other latexXXX functions. It tries to infer a suitable output mode for the given input. If the environment you are using supports the MIME type \"text/latex\", then the output will be rendered nicely.using Latexify\ncopy_to_clipboard(true)\n\nex = :(x/y)\nlatexify(ex)\nfracxyIf you print the output rather than display, then you will enforce the print-out of a string which is ready for some copy-pasting into your LaTeX document.println(latexify(ex))\n\n## or the equivalent:\nlatexify(ex) |> println$\\frac{x}{y}$A matrix, or a single vector, is turned into an array.M = signif.(rand(3,4), 2)\n\nlatexify(M)\\begin{equation} \\left[ \\begin{array}{cccc} 0.85 & 0.99 & 0.85 & 0.5\\\\\n0.59 & 0.061 & 0.77 & 0.48\\\\\n0.7 & 0.17 & 0.7 & 0.82\\\\\n\\end{array} \\right] \\end{equation}You can transpose the output using the keyword argument transpose=true.If you give two vectors as an argument, they will be displayed as the left-hand-side and right-hand-side of an align environment:latexify([\"x/y\", :z], Any[2.3, 1//2])\\begin{align} \\frac{x}{y} =& 2.3 \\\\\nz =& \\frac{1}{2} \\\\\n\\end{align}If you input a ParameterizedFunction or a ReactionNetwork from the DifferentialEquations.jl you will also get an align environment. For more on this, have a look on their respective sections."
},

{
    "location": "tutorials/latexinline.html#",
    "page": "latexinline",
    "title": "latexinline",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/latexinline.html#latexinline-1",
    "page": "latexinline",
    "title": "latexinline",
    "category": "section",
    "text": "takes a Julia object x and returns a LaTeX formatted string. It also surrounds the output in a simple $$ environment. This works for x of many types, including expressions, which returns LaTeX code for an equation.julia> ex = :(x-y/z)\njulia> latexinline(ex)\nL\"$x - \\frac{y}{z}$\"In Jupyter or Hydrogen this automatically renders as:x - fracyzAmong the supported types are:Expressions,\nStrings,\nNumbers (including rational and complex),\nSymbols,\nSymbolic expressions from SymEngine.jl.\nParameterizedFunctions.It can also take arrays, which it recurses and latexifies the elements, returning an array of latex strings."
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
    "text": "The motivation for creating this function was mainly to be able to render ODEs. In my own work, I tend to use DifferentialEquations.jl to define ODEs as ParameterizedFunctions. Therefore, I found it useful to create a method which simply takes the ParameterizedFunction as input:using Latexify\nusing DifferentialEquations\node = @ode_def positiveFeedback begin\n    dx = y/(k_y + y) - x\n    dy = x^n_x/(k_x^n_x + x^n_x) - y\nend k_y k_x n_x\n\nlatexalign(ode)\\begin{align} \\frac{dx}{dt} =& \\frac{y}{k_{y} + y} - x \\\\\n\\frac{dy}{dt} =& \\frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y \\\\\n\\end{align}"
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
    "text": "This functions takes a 1 or 2D array and spits out a latex array environment. For example:julia> arr = eye(Int,3)\njulia> print(latexarray(arr))\n\n\\begin{equation}\n\\left[\n\\begin{array}{ccc}\n1 & 0 & 0\\\\\n0 & 1 & 0\\\\\n0 & 0 & 1\\\\\n\\end{array}\n\\right]\n\\end{equation}which renders as:\\begin{equation} \\left[ \\begin{array}{ccc} 1 & 0 & 0\\\\\n0 & 1 & 0\\\\\n0 & 0 & 1\\\\\n\\end{array} \\right] \\end{equation}latexraw() is called for each element of the input, individually. It therefore does not matter if the input array is of a mixed type.arr = [1.0, 2-3im, 3//4, :(x/(k_1+x)), \"e^(-k_b*t)\"]\nlatexarray(arr)renders as:\\begin{equation} \\left[ \\begin{array}{c} 1.0\\\\\n2-3\\textit{i}\\\\\n\\frac{3}{4}\\\\\n\\frac{x}{k_{1} + x}\\\\\ne^{- k_{b} \\cdot t}\\\\\n\\end{array} \\right] \\end{equation}"
},

{
    "location": "tutorials/latextabular.html#",
    "page": "latextabular",
    "title": "latextabular",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/latextabular.html#latextabular-1",
    "page": "latextabular",
    "title": "latextabular",
    "category": "section",
    "text": "using Latexify\ncopy_to_clipboard(true)\narr = [\"x/y\" :(y^n); 1.0 :(alpha(x))]\nlatextabular(arr) |> printlnoutputs:\\begin{tabular}{cc}\n$\\frac{x}{y}$ & $y^{n}$\\\\\n$1.0$ & $\\alpha\\left( x \\right)$\\\\\n\\end{tabular}Unfortunately, this does not render nicely in Markdown. But you get the point.latextabular takes two keywords, one for changing the adjustment of the columns (centered by default), and one for transposing the whole thing.latextabular(arr; adjustment=:l, transpose=true) |> println\\begin{tabular}{ll}\n$\\frac{x}{y}$ & $1.0$\\\\\n$y^{n}$ & $\\alpha\\left( x \\right)$\\\\\n\\end{tabular}"
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
    "text": "In the latexalign tutorial I mentioned that one can use latexalign directly on a ParameterizedFunction. Here, I make a somewhat more convoluted and hard-to-read example (you'll soon se why):using Latexify\nusing DifferentialEquations\ncopy_to_clipboard(true)\n\node = @ode_def positiveFeedback begin\n    dx = y*y*y/(k_y_x + y) - x - x\n    dy = x^n_x/(k_x^n_x + x^n_x) - y\nend k_y k_x n_x\n\nlatexalign(ode)\\begin{align} \\frac{dx}{dt} =& \\frac{y \\cdot y \\cdot y}{k_{y_x} + y} - x - x \\\\\n\\frac{dy}{dt} =& \\frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y \\\\\n\\end{align}This is pretty nice, but there are a few parts of the equation which could be reduced. Using a keyword argument, you can utilise the SymEngine.jl to reduce the expression before printing.latexalign(ode, field=:symfuncs)\\begin{align} \\frac{dx}{dt} =& -2 \\cdot x + \\frac{y^{3}}{k_{y_x} + y} \\\\\n\\frac{dy}{dt} =& - y + \\frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} \\\\\n\\end{align}"
},

{
    "location": "tutorials/parameterizedfunctions.html#Side-by-side-rendering-of-multiple-system.-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Side-by-side rendering of multiple system.",
    "category": "section",
    "text": "A vector of ParameterizedFunctions will be rendered side-by-side:ode2 = @ode_def negativeFeedback begin\n    dx = y/(k_y + y) - x\n    dy = k_x^n_x/(k_x^n_x + x^n_x) - y\nend k_y k_x n_x\n\nlatexalign([ode, ode2])\\begin{align} \\frac{dx}{dt}  &=  \\frac{y}{k_{y} + y} - x  &  \\frac{dx}{dt}  &=  \\frac{y}{k_{y} + y} - x  &  \\\\\n\\frac{dy}{dt}  &=  \\frac{x^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y  &  \\frac{dy}{dt}  &=  \\frac{k_{x}^{n_{x}}}{k_{x}^{n_{x}} + x^{n_{x}}} - y  &  \\\\\n\\end{align}"
},

{
    "location": "tutorials/parameterizedfunctions.html#Visualise-your-parameters.-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Visualise your parameters.",
    "category": "section",
    "text": "Another thing that I have found useful is to display the parameters of these functions. The parameters are usually in a vector, and if it is somewhat long, then it can be annoying to try to figure out which element belongs to which parameter. There are several ways to solve this. Here are two:## lets say that we have some parameters\nparam = [3.4,5.2,1e-2]\nlatexify(ode.params, param)\\begin{align} k_{y} =& 3.4 \\\\\nk_{x} =& 5.2 \\\\\nn_{x} =& 0.01 \\\\\n\\end{align}orlatexarray([ode.params, param]; transpose=true)\\begin{equation} \\left[ \\begin{array}{ccc} k_{y} & k_{x} & n_{x}\\\\\n3.4 & 5.2 & 0.01\\\\\n\\end{array} \\right] \\end{equation}"
},

{
    "location": "tutorials/parameterizedfunctions.html#Get-the-jacobian,-hessian,-etc.-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Get the jacobian, hessian, etc.",
    "category": "section",
    "text": "ParameterizedFunctions symbolically calculates the jacobian, inverse jacobian, hessian, and all kinds of goodness. Since they are available as arrays of symbolic expressions, which are latexifyable, you can render pretty much all of them.latexarray(ode.symjac)\\begin{equation} \\left[ \\begin{array}{cc} -2 & \\frac{3 \\cdot y^{2}}{k_{y_x} + y} - \\frac{y^{3}}{\\left( k_{y_x} + y \\right)^{2}}\\\\\n\\frac{x^{-1 + n_{x}} \\cdot n_{x}}{k_{x}^{n_{x}} + x^{n_{x}}} - \\frac{x^{-1 + 2 \\cdot n_{x}} \\cdot n_{x}}{\\left( k_{x}^{n_{x}} + x^{n_{x}} \\right)^{2}} & -1\\\\\n\\end{array} \\right] \\end{equation}Pretty neat huh? And if you learn how to use latexify, latexalign, latexraw and latexarray you can really format the output in pretty much any way you want."
},

{
    "location": "tutorials/DiffEqBiological.html#",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Use with @reaction_network from DiffEqBiological.jl.",
    "category": "page",
    "text": ""
},

{
    "location": "tutorials/DiffEqBiological.html#Use-with-@reaction_network-from-DiffEqBiological.jl.-1",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Use with @reaction_network from DiffEqBiological.jl.",
    "category": "section",
    "text": "Latexify.jl has methods for dealing with AbstractReactionNetworks. For more information regarding this DSL, turn to its docs. The latexify end of things are pretty simple: feed a reaction network to the latexify or latexalign functions (they do the same thing in this case) and let them do their magic.using DifferentialEquations\nusing Latexify\ncopy_to_clipboard(true)\n\n@reaction_func hill2(x, v, k) = v*x^2/(k^2 + x^2)\n\nrn = @reaction_network MyRnType begin\n  hill2(y, v_x, k_x), 0 --> x\n  p_y, 0 --> y\n  (d_x, d_y), (x, y) --> 0\n  (r_b, r_u), x ↔ y\nend v_x k_x p_y d_x d_y r_b r_u\n\nlatexify(rn)\\begin{align} \\frac{dx}{dt} =& - x \\cdot d_{x} - x \\cdot r_{b} + y \\cdot r_{u} + \\frac{y^{2} \\cdot v_{x}}{k_{x}^{2} + y^{2}} \\\\\n\\frac{dy}{dt} =& p_{y} + x \\cdot r_{b} - y \\cdot d_{y} - y \\cdot r_{u} \\\\\n\\end{align}The method has a keyword for choosing between outputting the ODE or the noise term. While it is not obvious from the latexify output, the noise in the reaction network is correlated.latexify(rn; noise=true)\\begin{align} \\frac{dx}{dt} =& - \\sqrt{x \\cdot d_{x}} - \\sqrt{x \\cdot r_{b}} + \\sqrt{y \\cdot r_{u}} + \\sqrt{\\frac{y^{2} \\cdot v_{x}}{k_{x}^{2} + y^{2}}} \\\\\n\\frac{dy}{dt} =& \\sqrt{p_{y}} + \\sqrt{x \\cdot r_{b}} - \\sqrt{y \\cdot d_{y}} - \\sqrt{y \\cdot r_{u}} \\\\\n\\end{align}"
},

{
    "location": "tutorials/DiffEqBiological.html#Turning-off-the-SymEngine-magic-1",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Turning off the SymEngine magic",
    "category": "section",
    "text": "SymEngine will be used by default to clean up the expressions. A disadvantage of this is that the order of the terms and the operations within the terms becomes unpredictable. You can therefore turn this symbolic magic off. The result has some ugly issues with + -1, but the option is there, and here is how to use it:  latexify(rn; symbolic=false)\\begin{align} \\frac{dx}{dt} =& \\frac{v_{x} \\cdot y^{2}}{k_{x}^{2} + y^{2}} + -1 \\cdot d_{x} \\cdot x + -1 \\cdot r_{b} \\cdot x + r_{u} \\cdot y \\\\\n\\frac{dy}{dt} =& p_{y} + -1 \\cdot d_{y} \\cdot y + r_{b} \\cdot x + -1 \\cdot r_{u} \\cdot y \\\\\n\\end{align}latexify(rn; noise=true, symbolic=false)\\begin{align} \\frac{dx}{dt} =& \\sqrt{\\frac{v_{x} \\cdot y^{2}}{k_{x}^{2} + y^{2}}} + - \\sqrt{d_{x} \\cdot x} + - \\sqrt{r_{b} \\cdot x} + \\sqrt{r_{u} \\cdot y} \\\\\n\\frac{dy}{dt} =& \\sqrt{p_{y}} + - \\sqrt{d_{y} \\cdot y} + \\sqrt{r_{b} \\cdot x} + - \\sqrt{r_{u} \\cdot y} \\\\\n\\end{align}"
},

{
    "location": "tutorials/DiffEqBiological.html#Getting-the-jacobian.-1",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Getting the jacobian.",
    "category": "section",
    "text": "The ReactionNetwork type has a field for a symbolically calculated jacobian. This can be rendered by:latexarray(rn.symjac)\\begin{equation} \\left[ \\begin{array}{cc}d_{x} - r_{b} & r_{u} + \\frac{2 \\cdot y \\cdot v_{x}}{k_{x}^{2} + y^{2}} - \\frac{2 \\cdot y^{3} \\cdot v_{x}}{\\left( k_{x}^{2} + y^{2} \\right)^{2}}\\\\\nr_{b} & - d_{y} - r_{u}\\\\\n\\end{array} \\right] \\end{equation}The DiffEqBiological package is currently undergoing development, but when the reaction network type gets extended with invers Jacobians, Hessians, etc, latexarray will be able to latexify them."
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

]}
