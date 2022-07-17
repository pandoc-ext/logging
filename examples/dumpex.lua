local logging = require 'logging'

local function output(value)
    io.stderr:write(value .. '\n')
end

output(logging.dump(nil))
output(logging.dump(1))
output(logging.dump(false))
output(logging.dump('string'))
output(logging.dump('Here’s a non-ASCII character.'))
output(logging.dump({}))
output(logging.dump({1, 2, 3}))
output(logging.dump({a=1, b=2, c=3}))
output(logging.dump({a=1, b=2, c=3, 4, 5}))
output(logging.dump({a=1, b=2, c=3, 4, 5, 6, 7, 8, 9, 10}))
output(logging.dump({a=1, b=2, c=3, 4, 5, 6, 7, 8, 9, 10, 11}))
output(logging.dump({1, 2, {3, 4, {a=1, b=2, c=3, d=4, e=5, f=6}}}))
