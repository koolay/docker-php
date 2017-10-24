<?php
/**
 * Default configuration for Xhgui
 */
return array(
    'debug' => false,
    'mode' => getenv('XHGUI_MODE') ?: 'development',
    // Can be either mongodb or file.
    /*
    'save.handler' => 'file',
    'save.handler.filename' => dirname(__DIR__) . '/cache/' . 'xhgui.data.' . microtime(true) . '_' . substr(md5($url), 0, 6),
    */
    'save.handler' => 'mongodb',
    // Needed for file save handler. Beware of file locking. You can adujst this file path
    // to reduce locking problems (eg uniqid, time ...)
    //'save.handler.filename' => __DIR__.'/../data/xhgui_'.date('Ymd').'.dat',
    'db.host' => getenv('XHGUI_MONGODB_URI') ?: 'mongodb://127.0.0.1:27017',
    'db.db' => 'xhprof',
    // Allows you to pass additional options like replicaSet to MongoClient.
    // 'username', 'password' and 'db' (where the user is added)
    'db.options' => array(),
    'templates.path' => dirname(__DIR__) . '/src/templates',
    'date.format' => 'M jS H:i:s',
    'detail.count' => 6,
    'page.limit' => 25,
    // Profile 1 in 100 requests.
    // You can return true to profile every request.
    'profiler.enable' => function() {
        $rate = getenv('XHGUI_RATE') ?: 100;
        return rand(1, $rate) === 42;
    },
    'profiler.simple_url' => function($url) {
        return preg_replace('/\=\d+/', '', $url);
    }
);