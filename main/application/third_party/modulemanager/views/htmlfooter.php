<?php /*	?>
		
	
	<!-- crypter -->
	<!-- <script src="http://crypto-js.googlecode.com/svn/tags/3.1.2/build/rollups/sha1.js"></script>
	  -->	
	
	<!-- EXT -->	
		<?php foreach ($extjslist as $extjslink) { ?>
			<script src="<?php echo ($extjslink); ?>" type="text/javascript"  language="javascript"></script>			
		<?php } ?>
	  
	<!-- LOCAL from Module ###################################################### -->	
		<?php foreach ($modulejsfilelist as $jsfile) { ?>
			<script src="<?php echo ($jsfile); ?>" type="text/javascript"  language="javascript"></script>			
		<?php } ?>
	<!-- LOCAL ###################################################### -->	
		<?php foreach ($mainjsfilelist as $jsfile) { ?>
			<script src="<?php echo ($jsfile); ?>" type="text/javascript"  language="javascript"></script>			
		<?php } ?>

	<?php */	?>
	
	<!-- FOOTER : LOCAL JAVASCRIPTS ###################################################### -->	
		<?php foreach ($jsfilelist as $jsfile) { ?>
			<script src="<?php echo ($jsfile); ?>" type="text/javascript" ></script>			
		<?php } ?>
	</body>	
</html>