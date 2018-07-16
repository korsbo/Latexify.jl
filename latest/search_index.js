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
    "text": "Latexify.jl is a package which supplies functions for producing LaTeX formatted strings from Julia objects. The package allows for latexification of a many different kinds of Julia object and it can output several different LaTeX or Markdown environments.A small teaser:using Latexify\ncopy_to_clipboard(true)\nm = [2//3 \"e^(-c*t)\" 1+3im; :(x/(x+k_1)) \"gamma(n)\" :(log10(x))]\nlatexify(m)beginequation\nleft\nbeginarrayccc\nfrac23  e^ - c cdot t  1+3textiti \nfracxx + k_1  Gammaleft( n right)  log_10left( x right) \nendarray\nright\nendequation"
},

{
    "location": "index.html#Supported-input-1",
    "page": "Latexify.jl",
    "title": "Supported input",
    "category": "section",
    "text": "This package supplies functionality for latexifying objects of the following types:Expressions,\nStrings,\nNumbers (including rational and complex),\nMissings\' Missing type,\nSymbols,\nSymbolic expressions from SymEngine.jl,\nAny shape of array containing a mix of any of the above types,\nParameterizedFunctions from DifferentialEquations.jl,\nReactionNetworks from DifferentialEquations.jlExample:julia> str = \"x/(2*k_1+x^2)\"\njulia> latexify(str)\nfracx2 cdot k_1 + x^2"
},

{
    "location": "index.html#Supported-output-1",
    "page": "Latexify.jl",
    "title": "Supported output",
    "category": "section",
    "text": "Latexify has support for generating a range of different LaTeX environments. The main function of the package, latexify(), automatically picks a suitable output environment based on the type(s) of the input. However, you can override this by passing the keyword argument env =. The following environments are available:environment env= description\nno env :raw Latexifies an object and returns a LaTeX formatted string. If the input is an array it will be recursed and all its elements latexified. This function does not surround the resulting string in any LaTeX environments.\nInline :inline latexify the input and surround it with $$ for inline rendering.\nAlign :align Latexifies input and surrounds it with an align environment. Useful for systems of equations and such fun stuff.\nArray :array Latexify the elements of an Array or an Associative and output them in a LaTeX array.\nTabular :table or :tabular Latexify the elements of an array and output a tabular environment. Note that tabular is not supported by MathJax and will therefore not be rendered in Jupyter, etc.\nMarkdown Table :mdtable Output a Markdown table. This will be rendered nicely by Jupyter, etc.\nMarkdown Text :mdtext Output and render any string which can be parsed into Markdown. This is really nothing but a call to Base.Markdown.parse(),  but it does the trick. Useful for rendering bullet lists and such things.\nChemical arrow notation :chem, :chemical, :arrow or :arrows Latexify an AbstractReactionNetwork to \\LaTeX formatted chemical arrow notation using mhchem."
},

{
    "location": "index.html#Modifying-the-output-1",
    "page": "Latexify.jl",
    "title": "Modifying the output",
    "category": "section",
    "text": "Some of the different outputs can be modified using keyword arguments. You can for example transpose an array with transpose=true or specify a header of a table or mdtable with header=[]. For more options, see the sections for the respective output environment."
},

{
    "location": "index.html#Printing-vs-displaying-1",
    "page": "Latexify.jl",
    "title": "Printing vs displaying",
    "category": "section",
    "text": "latexify() returns a LaTeXString. Using display() on such a string will try to render it.latexify(\"x/y\") |> displayfracxyUsing print() will output text which is formatted for latex.latexify(\"x/y\") |> print$\\frac{x}{y}$"
},

{
    "location": "index.html#Automatic-copying-to-clipboard-1",
    "page": "Latexify.jl",
    "title": "Automatic copying to clipboard",
    "category": "section",
    "text": "The strings that you would see when using print on any of the above functions can be automatically copied to the clipboard if you so specify. Since I do not wish to mess with your clipboard without you knowing it, this feature must be activated by you.To do so, runcopy_to_clipboard(true)To once again disable the feature, pass false to the same function.The copying to the clipboard will now occur at every call to a Latexify.jl function, regardless of how you chose to display the output."
},

{
    "location": "index.html#Automatic-displaying-of-result-1",
    "page": "Latexify.jl",
    "title": "Automatic displaying of result",
    "category": "section",
    "text": "You can toggle whether the result should be automatically displayed. Instead oflatexify(\"x/y\") |> display\n## or\ndisplay( latexify(\"x/y\") )one can toggle automatic display by:auto_display(true)after which all calls to latexify will automatically be displayed. This can be rather convenient, but it can also cause a lot of unwanted printouts if you are using latexify in any form of loop. You can turn off this behaviour again by passing false to the same function."
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
    "text": "In the latexalign tutorial I mentioned that one can use latexalign directly on a ParameterizedFunction. Here, I make a somewhat more convoluted and hard-to-read example (you\'ll soon se why):using Latexify\nusing ParameterizedFunctions\ncopy_to_clipboard(true)\n\node = @ode_def positiveFeedback begin\n    dx = y*y*y/(k_y_x + y) - x - x\n    dy = x^n_x/(k_x^n_x + x^n_x) - y\nend k_y k_x n_x\n\nlatexify(ode)beginalign\nfracdxdt = fracy cdot y cdot yk_y_x + y - x - x \nfracdydt = fracx^n_xk_x^n_x + x^n_x - y \nendalignThis is pretty nice, but there are a few parts of the equation which could be reduced. Using a keyword argument, you can utilise the SymEngine.jl to reduce the expression before printing.latexify(ode, field=:symfuncs)beginalign\nfracdxdt = -2 cdot x + fracy^3k_y_x + y \nfracdydt =  - y + fracx^n_xk_x^n_x + x^n_x \nendalign"
},

{
    "location": "tutorials/parameterizedfunctions.html#Side-by-side-rendering-of-multiple-system.-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Side-by-side rendering of multiple system.",
    "category": "section",
    "text": "A vector of ParameterizedFunctions will be rendered side-by-side:ode2 = @ode_def negativeFeedback begin\n    dx = y/(k_y + y) - x\n    dy = k_x^n_x/(k_x^n_x + x^n_x) - y\nend k_y k_x n_x\n\nlatexify([ode, ode2])beginalign\nfracdxdt  =  fracy cdot y cdot yk_y_x + y - x - x    fracdxdt  =  fracyk_y + y - x    \nfracdydt  =  fracx^n_xk_x^n_x + x^n_x - y    fracdydt  =  frack_x^n_xk_x^n_x + x^n_x - y    \nendalign"
},

{
    "location": "tutorials/parameterizedfunctions.html#Visualise-your-parameters.-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Visualise your parameters.",
    "category": "section",
    "text": "Another thing that I have found useful is to display the parameters of these functions. The parameters are usually in a vector, and if it is somewhat long, then it can be annoying to try to figure out which element belongs to which parameter. There are several ways to solve this. Here are two:## lets say that we have some parameters\nparam = [3.4,5.2,1e-2]\nlatexify(ode.params, param)beginalign\nk_y = 34 \nk_x = 52 \nn_x = 001 \nendalignorlatexify([ode.params, param]; env=:array, transpose=true)beginequation\nleft\nbeginarrayccc\nk_y  k_x  n_x \n34  52  001 \nendarray\nright\nendequationsignif.() is your friend if your parameters have more significant numbers than you want to see."
},

{
    "location": "tutorials/parameterizedfunctions.html#Get-the-jacobian,-hessian,-etc.-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Get the jacobian, hessian, etc.",
    "category": "section",
    "text": "ParameterizedFunctions symbolically calculates the jacobian, inverse jacobian, hessian, and all kinds of goodness. Since they are available as arrays of symbolic expressions, which are latexifyable, you can render pretty much all of them.latexify(ode.symjac)beginequation\nleft\nbeginarraycc\n-2  frac3 cdot y^2k_y_x + y - fracy^3left( k_y_x + y right)^2 \nfracx^-1 + n_x cdot n_xk_x^n_x + x^n_x - fracx^-1 + 2 cdot n_x cdot n_xleft( k_x^n_x + x^n_x right)^2  -1 \nendarray\nright\nendequation"
},

{
    "location": "tutorials/parameterizedfunctions.html#Available-options-1",
    "page": "Use with ParameterizedFunctions",
    "title": "Available options",
    "category": "section",
    "text": "include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if :ParameterizedFunction in arg.types || :Any in arg.types]\nlatexify(args, env=:mdtable, types=false)"
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
    "text": "Latexify.jl has methods for dealing with AbstractReactionNetworks. For more information regarding this DSL, turn to its docs. The latexify end of things are pretty simple: feed a reaction network to latexify() and let it do its magic.using DiffEqBiological\nusing Latexify\ncopy_to_clipboard(true)\n\n@reaction_func hill2(x, v, k) = v*x^2/(k^2 + x^2)\n\nrn = @reaction_network MyRnType begin\n  hill2(y, v_x, k_x), 0 --> x\n  p_y, 0 --> y\n  (d_x, d_y), (x, y) --> 0\n  (r_b, r_u), x ↔ y\nend v_x k_x p_y d_x d_y r_b r_u\n\nlatexify(rn)beginalign\nfracdxdt = fracv_x cdot y^2k_x^2 + y^2 - d_x cdot x - r_b cdot x + r_u cdot y \nfracdydt = p_y - d_y cdot y + r_b cdot x - r_u cdot y \nendalignThe method has a keyword for choosing between outputting the ODE or the noise term. While it is not obvious from the latexify output, the noise in the reaction network is correlated.latexify(rn; noise=true)beginalign\nfracdxdt = sqrtfracv_x cdot y^2k_x^2 + y^2 - sqrtd_x cdot x - sqrtr_b cdot x + sqrtr_u cdot y \nfracdydt = sqrtp_y - sqrtd_y cdot y + sqrtr_b cdot x - sqrtr_u cdot y \nendalign"
},

{
    "location": "tutorials/DiffEqBiological.html#Chemical-arrow-notation-1",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Chemical arrow notation",
    "category": "section",
    "text": "DiffEqBiologicals reaction network is all about chemical arrow notation, so why should we not be able to render arrows?Use latexify\'s env keyword argument to specify that you want :chemical (or the equivalent :arrow, :arrows or :chem).latexify(rn; env=:chemical)\\begin{align} \\require{mhchem} \\ce{ \\varnothing &->[\\frac{v_{x} \\cdot y^{2}}{k_{x}^{2} + y^{2}}] x}\\\\\n\\ce{ \\varnothing &->[p_{y}] y}\\\\\n\\ce{ x &->[d_{x}] \\varnothing}\\\\\n\\ce{ y &->[d_{y}] \\varnothing}\\\\\n\\ce{ x &<=>[{r_{b}}][{r_{u}}] y}\\\\\n\\end{align}The default output is meant to be rendered directly on the screen. This rendering is typically done by MathJax. To get the chemical arrow notation to render automatically, I have included a MathJax command (\\require{mhchem}) in the output string. If you want to use the output in a real LaTeX document, you can pass the keyword argument mathjax=false and this extra command will be omitted. In such case you should also add \\usepackage{mhchem} to the preamble of your latex document.Another keyword argument that may be of use is expand=false (defaults to true). This determines whether your functions should be expanded or not. Also, starred=true will change the outputted latex environment from align to align*. This results in the equations not being numbered.latexify(rn; env=:chemical, expand=false, starred=true)beginalign*\nrequiremhchem\nce varnothing -mathrmhill2left( y v_x k_x right) x\nce varnothing -p_y y\nce x -d_x varnothing\nce y -d_y varnothing\nce x =r_br_u y\nendalign*"
},

{
    "location": "tutorials/DiffEqBiological.html#Available-options-1",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Available options",
    "category": "section",
    "text": ""
},

{
    "location": "tutorials/DiffEqBiological.html#Align-1",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Align",
    "category": "section",
    "text": "include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if (:ReactionNetwork in arg.types || :Any in arg.types) && :align in arg.env]\nlatexify(args, env=:mdtable, types=false)"
},

{
    "location": "tutorials/DiffEqBiological.html#Arrow-notation-1",
    "page": "Use with @reaction_network from DiffEqBiological.jl.",
    "title": "Arrow notation",
    "category": "section",
    "text": "include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if (:ReactionNetwork in arg.types || :Any in arg.types) && :arrow in arg.env]\nlatexify(args, env=:mdtable, types=false)"
},

{
    "location": "arguments.html#",
    "page": "List of possible arguments",
    "title": "List of possible arguments",
    "category": "page",
    "text": ""
},

{
    "location": "arguments.html#List-of-possible-arguments-1",
    "page": "List of possible arguments",
    "title": "List of possible arguments",
    "category": "section",
    "text": ""
},

{
    "location": "arguments.html#Align-1",
    "page": "List of possible arguments",
    "title": "Align",
    "category": "section",
    "text": "include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if :align in arg.env]\nlatexify(args, env=:mdtable)"
},

{
    "location": "arguments.html#Array-1",
    "page": "List of possible arguments",
    "title": "Array",
    "category": "section",
    "text": "include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if :array in arg.env]\nlatexify(args, env=:mdtable)"
},

{
    "location": "arguments.html#Tabular-1",
    "page": "List of possible arguments",
    "title": "Tabular",
    "category": "section",
    "text": "include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if :tabular in arg.env]\nlatexify(args, env=:mdtable)"
},

{
    "location": "arguments.html#Markdown-Table-1",
    "page": "List of possible arguments",
    "title": "Markdown Table",
    "category": "section",
    "text": "include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if :mdtable in arg.env]\nlatexify(args, env=:mdtable)"
},

{
    "location": "arguments.html#Chemical-arrow-notation-1",
    "page": "List of possible arguments",
    "title": "Chemical arrow notation",
    "category": "section",
    "text": "Available with ReactionNetworks from DiffEqBiological.include(\"src/table_generator.jl\")\nargs = [arg for arg in keyword_arguments if :arrow in arg.env]\nlatexify(args, env=:mdtable, types=false)"
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
    "text": "Let\'s define a variable of the expression type:julia> ex = :(x + y/z)This expression has a field which contains the first operation which must be done, along with the objects that this operation will operate on:julia> ex.args\n\n3-element Array{Any,1}:\n :+      \n :x      \n :(y / z)The first two element are both Symbols, while the third one is an expression:julia> typeof.(ex.args)\n\n3-element Array{DataType,1}:\n Symbol\n Symbol\n ExprSince at least one of these elements is an expression, the next step of the recursive algorithm is to dive into that expression:julia> newEX = ex.args[3]\njulia> newEx.args\n\n3-element Array{Any,1}:\n :/\n :y\n :zSince none of these arguments is another expression, newEx will be passed to latexoperation(). This function checks which mathematical operation is being done and converts newEx to an appropriately formatted string. In this case, that string will be \"\\\\frac{y}{z}\" (and yes, a double slash is needed).newEx is now a string (despite its name):julia> newEx\n\n\"\\\\frac{y}{z}\"The recursive latexraw() pulls this value back to the original expression ex, such that:julia> ex.args\n\n3-element Array{Any,1}:\n :+      \n :x      \n :\"\\\\frac{y}{z}\"Now, since this expression does not consist of any further expressions, it is passed to latexoperation(). The operator is now \"+\", and it should be applied on the second and third element of the expression, resulting in:\"x + \\\\frac{y}{z}\"using the print function you get:julia> print(latexraw(ex))\n\n\"x + \\frac{y}{z}\"which in a LaTeX maths environment renders as:x + fracyz"
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
