<?php
include_once 'vendor/autoload.php';

use Basho\Riak;
use Basho\Riak\Node;
use Basho\Riak\Command;

$node = (new Node\Builder)
        ->atHost('127.0.0.1')
        ->onPort(8098)
        ->build();

$riak = new Riak([$node]);

$bucket = new Riak\Bucket('testBucket');

$val1 = 1;
$location1 = new Riak\Location('one', $bucket);

$storeCommand1 = (new Command\Builder\StoreObject($riak))
                    ->buildObject($val1)
                    ->atLocation($location1)
                    ->build();
$storeCommand1->execute();

$response1 = (new Command\Builder\FetchObject($riak))
                ->atLocation($location1)
                ->build()
                ->execute();


?>
