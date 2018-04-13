module.exports = (backend) ->
    backend._queries ?= {}
    
    backend.addServerQuery = (collection, queryName, queryFunction) ->
        if not queryFunction.call
            queryFunction = (-> @).bind queryFunction
        @_queries[collection + '.' + queryName] = queryFunction
        
    backend.use 'query', (req, next) ->
        req.queryName = req.query.$queryName
        if req.queryName
            req.queryParams = req.query.$params or {}
            queryFunction = req.backend._queries["#{req.collection}.#{req.queryName}"]
            return next '404: unknown query' unless queryFunction

            try
                req.query = queryFunction.call req, req.queryParams
            catch e
                return next e
        else
            req.queryName = 'client'
            req.queryParams = req.query
        next()
