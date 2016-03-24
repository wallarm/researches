<?php
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
for($i=0;$i<256;$i++){
	$k = "KEY-".chr($i);
	$v = "DATA-".$i;
	$redis->set($k, $v);
	if($redis->get($k)!==$v){
		echo "ANML! ".bin2hex(chr($i))."\n";
	}
}
for($i=0;$i<256;$i++){
for($j=0;$j<256;$j++){
        $k = "KEY-".chr($i).chr($j);
        $v = "DATA-".$i.$j;
        $redis->set($k, $v);
        if($redis->get($k)!==$v){
                echo "ANML! ".bin2hex(chr($i).chr($j))."\n";
        }
}}
for($l=0;$l<=256;$l++){
try{
        $k = "KEY-".str_repeat('A',$l*1024*1024);
        $v = "DATA-".$l;
        echo "$l MB probe\n";
        $redis->set($k, $v);
        if($redis->get($k)!==$v){
                echo "ANML! $l\n";
        }
}catch(Exception $e){
        echo 'Caught exception: ',  $e->getMessage(), "\n";
}
}
echo "Done\n";
   // Get the stored data and print it
   #echo "Stored string in redis:: " + jedis.get("tutorial-name");
?>
