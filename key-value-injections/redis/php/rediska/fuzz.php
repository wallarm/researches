<?php
require("Rediska/library/Rediska.php");
 $options = array(
   'servers'   => array(
     array('host' => '127.0.0.1', 'port' => 6379)
   )
 );
$redis = new Rediska($options);

for($i=0;$i<256;$i++){
	$k = new Rediska_Key("KEY-".chr($i));
	$v = "DATA-".$i;
	$k->setValue($v);
	if($k->getValue()!==$v){
		echo "ANML! ".bin2hex(chr($i))."\n";
	}
}
for($i=0;$i<256;$i++){
for($j=0;$j<256;$j++){
        $k = new Rediska_Key("KEY-".chr($i).chr($j));
        $v = "DATA-".$i.$j;
        $k->setValue($v);
        if($k->getValue()!==$v){
                echo "ANML! ".bin2hex(chr($i).chr($j))."\n";
        }
}}

echo "Done\n";
   // Get the stored data and print it
   #echo "Stored string in redis:: " + jedis.get("tutorial-name");
?>
