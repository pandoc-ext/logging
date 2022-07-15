local logging = require 'logging'

function Para(para)
    logging.info('para', para)
    logging.info('para.content', para.content)
    logging.info('para.content[1]', para.content[1])
    logging.info('para.content[1].text', para.content[1].text)
end
