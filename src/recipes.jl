# Much of this is copied/adapted from RecipesBase.jl. Cred to everyone who has
# worked on that package!

const _debug_recipes = Bool[false]
function debug(v::Bool = true)
    _debug_recipes[1] = v
end

# check for flags as part of the `-->` expression
function _is_arrow_tuple(expr::Expr)
    expr.head == :tuple && !isempty(expr.args) &&
        isa(expr.args[1], Expr) &&
        expr.args[1].head == :(-->)
end

function _equals_symbol(arg::Symbol, sym::Symbol)
    arg == sym
end
function _equals_symbol(arg::Expr, sym::Symbol) #not sure this method is necessary anymore on 0.7
    arg.head == :quote && arg.args[1] == sym
end
function _equals_symbol(arg::QuoteNode, sym::Symbol)
    arg.value == sym
end
_equals_symbol(x, sym::Symbol) = false

function create_kw_body(func_signature::Expr)
    # get the arg list, stripping out any keyword parameters into a
    # bunch of get!(kw, key, value) lines
    func_signature.head == :where && return create_kw_body(func_signature.args[1])
    args = func_signature.args[2:end]
    kw_body = Expr(:block)
    kw_dict = Dict{Symbol, Any}()
    if isa(args[1], Expr) && args[1].head == :parameters
        for kwpair in args[1].args
            k, v = kwpair.args
            if isa(k, Expr) && k.head == :(::)
                k = k.args[1]
                @warn("Type annotations on keyword arguments not currently supported in recipes. Type information has been discarded")
            end
            push!(kw_body.args, :($k = kwargs[$(Meta.quot(k))]))
            if v == :nothing
                kw_dict[k] = nothing
            else
                kw_dict[k] = v isa QuoteNode ? v.value : v
            end
        end
        args = args[2:end]
    end
    args, kw_body, kw_dict
end

# build an apply_recipe function header from the recipe function header
function get_function_def(func_signature::Expr, args::Vector)
    front = func_signature.args[1]
    kwarg_expr = Expr(:parameters, Expr(:..., esc(:kwargs)))
    if func_signature.head == :where
        Expr(:where, get_function_def(front, args), esc.(func_signature.args[2:end])...)
    elseif func_signature.head == :call
        #= func = Expr(:call, :(Latexify.apply_recipe), esc.(args)..., Expr(:parameters, :kwargs)) =#
        func = Expr(:call, :(Latexify.apply_recipe), kwarg_expr, esc.(args)...)
        if isa(front, Expr) && front.head == :curly
            Expr(:where, func, esc.(front.args[2:end])...)
        else
            func
        end
    else
        throw(RecipeException("Expected `func_signature = ...` with func_signature as a call or where Expr... got: $func_signature"))
    end
end

# process the body of the recipe recursively.
# when we see the series macro, we split that block off:
    # let
    #   d2 = copy(d)
    #   <process_recipe_body on d2>
    #   RecipeData(d2, block_return)
    # end
# and we push this block onto the series_blocks list.
# then at the end we push the main body onto the series list
function process_recipe_body!(expr::Expr)
    operation = QuoteNode(:none)
    for (i,e) in enumerate(expr.args)
        if isa(e,Expr)

            # process trailing flags, like:
            #   a --> b, :force
            force = false
            if _is_arrow_tuple(e)
                for flag in e.args
                    if _equals_symbol(flag, :force)
                        force = true
                    end
                end
                e = e.args[1]
            end

            if e.head == :(:=)
                force = true
                e.head = :(-->)
            end

            # we are going to recursively swap out `a --> b, flags...` commands
            # note: this means "x may become 5"
            if e.head == :(-->)
                k, v = e.args
                if isa(k, Symbol)
                    if k == :operation
                        operation = v
                        expr.args[i] = nothing
                        continue
                    end
                    k = QuoteNode(k)
                end

                set_expr = if force
                    :(kwargs[$k] = $v)
                else
                    :(haskey(kwargs, $k) || (kwargs[$k] = $v))
                end

                quiet = false
                expr.args[i] = set_expr

            elseif e.head != :call
                # we want to recursively replace the arrows, but not inside function calls
                # as this might include things like Dict(1=>2)
                process_recipe_body!(e)
            end

            if  e.head == :return
                if e.args[1] isa Expr
                    if e.args[1] isa Tuple
                        e.args[1] = :(($(e.args[1]), kwargs))
                    else
                        e.args[1] = :((($(e.args[1]),), kwargs))
                    end
                else
                    e.args[1] = :((($(e.args[1]),), kwargs))
                end
            end
        end
    end
    return operation
end

macro latexrecipe(funcexpr)
    func_signature, func_body = funcexpr.args

    if !(funcexpr.head in (:(=), :function))
        throw(RecipeException("Must wrap a valid function call!"))
    end

    if !(isa(func_signature, Expr) && func_signature.head in (:call, :where))
        throw(RecipeException("Expected `func_signature = ...` with func_signature as a call or where Expr... got: $func_signature"))
    end

    if length(func_signature.args) < 2
        throw(RecipeException("Missing function arguments... need something to dispatch on!"))
    end

    args, kw_body, kw_dict = create_kw_body(func_signature)
    func = get_function_def(func_signature, args)
    operation = process_recipe_body!(func_body)

    # now build a function definition for apply_recipe
    funcdef = Expr(:function, func, esc(quote
        if Latexify._debug_recipes[1]
            println("apply_recipe args: ", $args)
        end
        kwargs = merge($kw_dict, kwargs)

        $kw_body
        $func_body
    end))

    getopdef = Expr(:(=), copy(func), esc(operation))
    signature = getopdef.args[1]
    while Meta.isexpr(signature, :where)
        # Get through any layers of `where`
        signature = signature.args[1]
    end
    signature.args[1] = :(Latexify._getoperation)

    return Expr(:block, funcdef, getopdef)
end

