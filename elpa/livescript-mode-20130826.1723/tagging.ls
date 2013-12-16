fs = require "fs"
ls = require "LiveScript"
u = require "underscore"

global import (require "prelude-ls")

code = fs.readFileSync process.argv[2], "utf8"
code = ls.ast code

or-f = (f, g) -> (x) -> f(x) or g(x)
not-f = (f) -> (x) -> not f(x)

branch = or-f u.isObject, u.isArray
leaf = not-f branch

each = (node) ->
    if node.constructor == ls.ast.Assign and node.right.constructor == ls.ast.Fun
        console.log node.left.line, node.left.value, "(", (map (.value), node.right.params).join(","), ")"
    else if node.constructor == ls.ast.Class
        console.log node.title.head.line, node.title.head.value,".", (map (.key.name), node.title.tails).join(".")
        node.fun.body.traverse-children ->
            if it.constructor == ls.ast.Prop
                console.log it.val.line, it.key.name, it.val.params

# ~/LiveScript/src/ast.ls

code.traverse-children each
