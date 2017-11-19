<?php echo doctype('html5'); ?>
<html>
	<head>
	<link rel="shortcut icon"	href="web/images/favicon.ico" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<base href="<?php echo $base_url; ?>">
	<?php foreach ($cssfilelist as $cssfile)
		 echo link_tag($cssfile); ?>
	<link rel="icon" type="image/png" href="web/images/favicon.png" />
	<!--[if IE]><link rel="shortcut icon" type="image/x-icon" href="web/images/favicon.ico" /><![endif]-->

	<title><?php echo $title ?></title>
	</head>
<body>		
