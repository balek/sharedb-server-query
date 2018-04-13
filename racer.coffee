module.exports = (racer) ->
    racer.Model::serverQuery = (collection, $queryName, $params) ->
        @query collection, { $queryName, $params }
