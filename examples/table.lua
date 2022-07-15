local utils = require 'pandoc.utils'

local logging = require 'logging'

function Table(table)
    local caption = table.caption
    if caption then
        logging.temp('caption', utils.stringify(caption))
    end

    local head = table.head
    for i, row in ipairs(head.rows) do
        for j, cell in ipairs(row.cells) do
            logging.temp(string.format('head.row[%d].cell[%d]', i, j), cell)
        end
    end
end
