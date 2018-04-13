## sharedb-server-query

ShareDB server-query plugin. It allows to subscribe to named server-defined queries. It does not deny arbitrary client queries, so use additional middleware to restrict access.


### Install

With [npm](https://npmjs.org) do:

```
npm install sharedb-server-query
```


### Usage

On the server:
```js
require('sharedb-server-query')(backend);

// Add server queries  

// function addServerQuery accept
// 'collection' - collection name
// 'queryName'  - name of query
// 'cb' - function that accepts 'params' and runned in 'req' context
// and returns a query-object or throws error

backend.addServerQuery('items', 'main', function(params) {
    return { type: 'public' };
});

backend.addServerQuery('items', 'myItems', function(params) {
    return { ownerId: this.agent.userId };
});

backend.addServerQuery('items', 'byType', function(params) {

// ++++++++++++++++++++++++++++
// Should check params here!!!!
// it's a security issue
// ++++++++++++++++++++++++++++

    return { type: params.type };
});

```

Using queries in derby/racer:

```js
  // function serverQuery accepts 3 arguments:
  // 'collection' - collection name (should match one from addServerQuery)
  // 'queryName' - name of query (should match one from addServerQuery)
  // 'params' - object with query-params

  derby.use(require('sharedb-server-query/racer'));

  //...
  
  var query = model.serverQuery('items', 'byType', {
    type: 'global'
  });

  model.subscribe(query, function(){
    page.render('home');
  });
```

What is still allowed:
```js

// You still can use one-item fetch/subscriptions
var itemId = params.itemId

var item = model.at('items.'+itemId);

model.subscribe(item,  function(){
  //...
});

// Or just
model.subscribe('items.' + itemId,  function(){
  //...
});
```
