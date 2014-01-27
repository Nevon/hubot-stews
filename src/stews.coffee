# Description:
#   Get today's stews from Hos Frank.
#
# Configuration:
#   None
#
# Dependencies:
#   "cheerio": "1.13.x"
#   "iconv-lite": "*"
#
# Commands:
#   hubot hos frank|franks|gryta|grytor - Fetches today's stews from Hos Frank for you
#
# Author:
#   Nevon
cheerio = require "cheerio"
iconvlite = require "iconv-lite"

module.exports = (robot) ->
  robot.respond /(?:hos\s)?frank(?:s?)|^gryt(?:a|or)(?:.?)+/i, (msg) ->
    robot.http("http://www.aptit.se/0909/index/products/productsved.asp?x=1&SupplierID=105")
      .encoding("binary")
      .get() (err, res, body) ->
        if res.statusCode is 200
          body = iconvlite.decode(body, "iso88591")
          $ = cheerio.load(body)
          stews = ($(stew).text() for stew in $("#category_895 .txtb").toArray())

          response = ""

          if stews.length is 0
            response += "Sorry, but I couldn't find any stews today."
          else
            response = "Dagens grytor:\n"
            response += "  "+stew+"\n" for stew in stews 

        msg.reply response