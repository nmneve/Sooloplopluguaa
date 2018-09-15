# Description:
#   Wikipedia Public API
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot wiki <query> - Returns the first Wikipedia articles matching the search <query>
#   hubot search <query> - Returns the first 5 Wikipedia articles matching the search <query>
#   hubot describe <article> - Returns a one-line description about <article>
#
# Author:
#   Justin

WIKI_API_URL = "https://en.wikipedia.org/w/api.php"
WIKI_EN_URL = "https://en.wikipedia.org/wiki"

module.exports = (robot) ->
    robot.respond /wiki (.+)/i, id: "wikipedia", (res) ->
        search = res.match[1].trim()
        params =
            action: "opensearch"
            format: "json"
            limit: 1
            search: search

        wikiRequest res, params, (object) ->
            if object[1].length is 0
                res.reply "No articles were found using search query: \"#{search}\". Try a different query."
                return

            for article in object[1]
                message =
                    text: "#{article}: #{createURL(article)}"
                    unfurl_links: false

                res.send message

    robot.respond /search (.+)/i, id: "wikipedia.search", (res) ->
        search = res.match[1].trim()
        params =
            action: "opensearch"
            format: "json"
            limit: 5
            search: search

        wikiRequest res, params, (object) ->
            if object[1].length is 0
                res.reply "No articles were found using search query: \"#{search}\". Try a different query."
                return

            for article in object[1]
                message =
                    text: "#{article}: #{createURL(article)}"
                    unfurl_links: false

                res.send message


    robot.respond /describe (.+)/i, id: "wikipedia.summary", (res) ->
        target = res.match[1].trim()
        params =
            action: "query"
            exintro: true
            explaintext: true
            format: "json"
            redirects: true
            prop: "extracts"
            titles: target

        wikiRequest res, params, (object) ->
            for id, article of object.query.pages
                if id is "-1"
                    res.reply "The article you have entered (\"#{target}\") does not exist. Try a different article."
                    return

                if article.extract is ""
                    summary = "No summary available"
                else
                    summary = article.extract.split(". ")[0..1].join ". "

                res.send "#{article.title}: #{summary}."
                return

createURL = (title) ->
    "#{WIKI_EN_URL}/#{encodeURIComponent(title)}"

wikiRequest = (res, params = {}, handler) ->
    res.http(WIKI_API_URL)
        .query(params)
        .get() (err, httpRes, body) ->
            if err
                res.reply "An error occurred while attempting to process your request: #{err}"
                return robot.logger.error err

            handler JSON.parse(body)