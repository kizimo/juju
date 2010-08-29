<?php
	// Juju Login and Registration Scripts
	// by D. Brad Talton Jr.
	// (c) 2010 by PathosEthos LLC

	// gets and sets details for the client list
	$username = $_REQUEST['email']; // this is the unique key that defines a client
	$password = $_REQUEST['pass']; // in the database, this is hashed with sha1
	
	$pathToClientList = "./ClientList.csv";
	
	
	// ACTUAL SCRIPT EXECUTION
	loadData();
	if($_REQUEST['action'] == "register") // registration
	{
		// attempt a registration
		$success = addClient($username,$password,$_REQUEST['first'],$_REQUEST['last'],$_REQUEST['company']);
		if($success == TRUE)
		{
			echo "<xml result='0' ></xml>"; // client's new login level
			writeData(); // save to disk
		}
		echo "<xml result='-1'></xml>"; // failed to register
	}
	else // assume login if no action is specified
	{
		echo "<xml result='" . checkLogin($username,$password) . "' ></xml>";
	}
	
	
	
/*	
 * 	JUJU API
 *	
 *	loadData() - Opens the CSV and reads out all data
 *	checkLogin($email, $pass) - Returns the permissions for a user if they exist, or -1 otherwise
 *  writeData() - Writes out all open entries to the file. Fails if no entries exist
 *	addClient($email, $newpass, $first, $last, $company) - Adds a new entry to the client list
 */	
	
	function loadData()
	{
		global $allClients, $pathToClientList;
		
		$fh = fopen($pathToClientList, 'r');
    	$theData = fread($fh, filesize($pathToClientList));
    	fclose($fh);
    	
    	// explode by newlines
    	$entries = explode("\n",$theData);
    	foreach($entries as $entry) // for each string
    	{
    		// explode by tabs
    		$values = explode(",",$entry);
    		
    		// create the client object
    		$client = array();
    		$client['email'] = $values[0];
    		$client['password'] = $values[1];
    		$client['first'] = $values[2];
    		$client['last'] = $values[3];
    		$client['company'] = $values[4];
    		$client['permissions'] = $values[5];
			if($values[6])
			{
				$client['expiration'] = $values[6];
			}
			else 
			{
				$client['expiration'] = date("n/j/Y"); 
			}
    		// into the hash table by their email
    		$allClients[$client['email']] = $client; 
    	}
	}
	
	function checkLogin($email, $pass)
	{
		global $allClients;
		$today = date("n/j/Y"); 
		
		if(isset($allClients[$email]))
		{
			if(($allClients[$email]["password"] == sha1($pass)) && ($allClients[$email]["expiration"] >= $today))
			{
				return $allClients[$email]['permissions'] . "' first='{$allClients[$email]['first']}' last='{$allClients[$email]['last']}' company='{$allClients[$email]['company']}" ;
			}
		}
		return 0;
	}	
	
	function writeData()
	{
		global $allClients, $pathToClientList;
		
		// bail out if we haven't loaded
		if(count($allClients) == 0)
		{
			return FALSE;
		}
		
		$outfile = "";
    	
    	// explode by newlines
    	$entries = explode("\n",$theData);
    	foreach($allClients as $client) // for each string
    	{
    		if($outfile !== "")
    		{
    			$outfile .= "\n"; // new line for a new entry
    		}
    		
    		// create the client object
    		$outfile .= $client['email'] . ",";
    		$outfile .= $client['password'] . ",";
    		$outfile .= $client['first'] . ",";
    		$outfile .= $client['last'] . ",";
    		$outfile .= $client['company'] . ",";
    		$outfile .= $client['permissions'];
    	}
    	
    	// write to the file
		$fh = fopen($pathToClientList, 'w');
    	$theData = fwrite($fh, $outfile);
    	fclose($fh);
    	return TRUE;
	}
	
	function addClient($email, $newpass, $first, $last, $company)
	{
		global $allClients;
		
		if(array_key_exists($email,$allClients) == TRUE)
		{
			return FALSE; // can't create this user -- he is already registered
		}
		// new object
		$client = array();
		
		// add data
   		$client['email'] = $email;
   		$client['password'] = sha1($newpass);
   		$client['first'] = $first;
   		$client['last'] = $last;
   		$client['company'] = $company;
   		$client['permissions'] = 0;
   		
   		// insert into array
   		$allClients[$email] = $client;
   		
   		// return true
   		return TRUE;
	}
	

?>