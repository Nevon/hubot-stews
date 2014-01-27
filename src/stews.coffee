# Description:
#   Get today's stews from Hos Frank.
#
# Commands:
#   hubot youtube me <query> - Searches YouTube for the query and returns the video embed link.
cheerio = require "cheerio"
iconvlite = require "iconv-lite"

module.exports = (robot) ->
  robot.respond /(hos frank|franks)/i, (msg) ->
    robot.http("http://www.aptit.se/0909/index/products/productsved.asp?x=1&SupplierID=105")
      .get() (err, res, body) ->
        if res.statusCode is 200
          $ = cheerio.load(body)
          stews = (iconvlite.decode($(stew).text(), 'utf-8') for stew in $("#category_895 .txtb").toArray())

          response = ""

          if stews.length is 0
            response += "Sorry, but I couldn't find any stews today."
          else
            response = "Dagens grytor:\n"
            response += "  "+stew+"\n" for stew in stews 

        msg.reply response