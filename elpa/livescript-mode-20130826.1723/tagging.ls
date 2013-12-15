fs = require "fs"
ls = require "LiveScript"
u = require "underscore"

global import (require "prelude-ls")

code = fs.readFileSync process.argv[2], "utf8"
console.log JSON.stringify ls.ast(code), null, 2
