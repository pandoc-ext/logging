local logging = require 'logging'

if #arg > 0 then
    logging.setloglevel(tonumber(arg[1]) or 0)
end

logging.temp('loglevel is', logging.loglevel, '(this is always output)')
logging.error('this is output if loglevel >= -1')
logging.warning('this is output if loglevel >= 0')
logging.info('this is output if loglevel >= 1')
logging.debug('this is output if loglevel >= 2')
logging.debug2('this is output if loglevel >= 3')

logging.temp('args', 'are', 'automatically', 'separated', 'with',
             'spaces and a newline is added if necessary')
logging.temp('args can be of any type, e.g.', {maps='like', this='one'},
             'or', {'lists', 'like', 'this', 'one'})
logging.temp('if an arg is too long it will be output on multiple lines',
             {'aardvark', 'bison', 'camel', 'dingo', 'echnidna'}, 'like this')
