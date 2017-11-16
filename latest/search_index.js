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
    "text": "Documentation for Latexify.jl"
},

{
    "location": "index.html#Tutorials-1",
    "page": "Latexify.jl",
    "title": "Tutorials",
    "category": "section",
    "text": "Pages = [\n    \"tutorials/latexify.md\",\n    \"tutorials/latexarray.md\"\n    ]\nDepth = 2"
},

{
    "location": "index.html#Functions-1",
    "page": "Latexify.jl",
    "title": "Functions",
    "category": "section",
    "text": "Pages = [\n    \"functions/latexify.md\",\n    \"functions/latexalign.md\",\n    \"functions/latexarray.md\",\n    \"functions/latexoperation.md\"\n    ]\nDepth = 2"
},

{
    "location": "index.html#Index-1",
    "page": "Latexify.jl",
    "title": "Index",
    "category": "section",
    "text": ""
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
    "page": "latexify()",
    "title": "latexify()",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexify.html#Latexify.latexify",
    "page": "latexify()",
    "title": "Latexify.latexify",
    "category": "Function",
    "text": "latexify(arg)\n\nGenerate LaTeX equations from arg.\n\nParses expressions, ParameterizedFunctions, SymEngine.Base and arrays thereof. Returns a string formatted for LaTeX.\n\nExamples\n\nusing expressions\n\nexpr = :(x/(y+x))\nlatexify(expr)\n\n# output\n\n\"\\\\frac{x}{y + x}\"\n\nexpr = parse(\"x/(y+x)\")\nlatexify(expr)\n\n# output\n\n\"\\\\frac{x}{y + x}\"\n\nusing ParameterizedFunctions\n\nusing DifferentialEquations;\nf = @ode_def feedback begin\n         dx = y/c_1 - x\n         dy = x^c_2 - y\n       end c_1=>1.0 c_2=>1.0\nlatexify(f)\n\n# output\n\n2-element Array{String,1}:\n \"dx/dt = \\\\frac{y}{c_{1}} - x\"\n \"dy/dt = x^{c_{2}} - y\"\n\nusing SymEngine\n\nusing SymEngine\n@vars x y\nsymExpr = x + x + x*y*y\nlatexify(symExpr)\n\n# output\n\n\"2 \\\\cdot x + x \\\\cdot y^{2}\"\n\n\n\n"
},

{
    "location": "functions/latexify.html#latexify()-1",
    "page": "latexify()",
    "title": "latexify()",
    "category": "section",
    "text": "DocTestSetup = quote\nusing Latexify\nendlatexifyDocTestSetup = nothing"
},

{
    "location": "functions/latexalign.html#",
    "page": "latexalign()",
    "title": "latexalign()",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexalign.html#Latexify.latexalign",
    "page": "latexalign()",
    "title": "Latexify.latexalign",
    "category": "Function",
    "text": "latexalign()\n\nGenerate a LaTeX align environment from an input.\n\nExamples\n\nuse with arrays\n\nlhs = [:(dx/dt), :(dy/dt), :(dz/dt)]\nrhs = [:(y-x), :(x*z-y), :(-z)]\nlatexalign(lhs, rhs)\n\n# output\n\n\"\\\\begin{align}\\n\\\\frac{dx}{dt} =& y - x \\\\\\\\ \\n\\\\frac{dy}{dt} =& x \\\\cdot z - y \\\\\\\\ \\n\\\\frac{dz}{dt} =& - z \\\\\\\\ \\n\\\\end{align}\\n\"\n\nuse with ParameterizedFunction\n\nusing DifferentialEquations\node = @ode_def foldChangeDetection begin\n    dm = r_m * (i - m)\n    dy = r_y * (p_y * i/m - y)\nend i=>1.0 r_m=>1.0 r_y=>1.0 p_y=>1.0\n\nlatexalign(ode)\n\n# output\n\n\"\\\\begin{align}\\n\\\\frac{dm}{dt} =& r_{m} \\\\cdot (i - m) \\\\\\\\ \\n\\\\frac{dy}{dt} =& r_{y} \\\\cdot (\\\\frac{p_{y} \\\\cdot i}{m} - y) \\\\\\\\ \\n\\\\end{align}\\n\"\n\n\n\n"
},

{
    "location": "functions/latexalign.html#latexalign()-1",
    "page": "latexalign()",
    "title": "latexalign()",
    "category": "section",
    "text": "DocTestSetup = quote\nusing Latexify\nusing DifferentialEquations\nendlatexalignDocTestSetup = nothing"
},

{
    "location": "functions/latexarray.html#",
    "page": "latexarray()",
    "title": "latexarray()",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexarray.html#Latexify.latexarray",
    "page": "latexarray()",
    "title": "Latexify.latexarray",
    "category": "Function",
    "text": "latexarray{T}(arr::AbstractArray{T, 2})\n\nCreate a LaTeX array environment using latexify.\n\nExamples\n\narr = [1 2; 3 4]\nlatexarray(arr)\n# output\n\"\\begin{equation}\n\\left[\n\\begin{array}{cc}\n1 & 2\\\\ \n3 & 4\\\\ \n\\end{array}\n\\right]\n\\end{equation}\n\"\n\n\n\n"
},

{
    "location": "functions/latexarray.html#latexarray()-1",
    "page": "latexarray()",
    "title": "latexarray()",
    "category": "section",
    "text": "DocTestSetup = quote\nusing Latexify\nusing DifferentialEquations\nendlatexarrayDocTestSetup = nothing"
},

{
    "location": "functions/latexoperation.html#",
    "page": "latexoperation()",
    "title": "latexoperation()",
    "category": "page",
    "text": ""
},

{
    "location": "functions/latexoperation.html#Latexify.latexoperation",
    "page": "latexoperation()",
    "title": "Latexify.latexoperation",
    "category": "Function",
    "text": "latexoperation(ex::Expr, prevOp::AbstractArray)\n\nTranslate a simple operation given by ex to LaTeX maths syntax. This uses the information about the previous operations to deside if a parenthesis is needed.\n\n\n\n"
},

{
    "location": "functions/latexoperation.html#latexoperation()-1",
    "page": "latexoperation()",
    "title": "latexoperation()",
    "category": "section",
    "text": "This function is not exported.DocTestSetup = quote\nusing Latexify\nusing DifferentialEquations\nendLatexify.latexoperationDocTestSetup = nothing"
},

]}
