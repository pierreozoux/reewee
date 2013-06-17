SESSION = {
  :ssh_user 	=> "root",
  :ssh_ip => "macbook",
	:postinstall_files => 
	[     
	  "settings.sh",
	  "architecture_settings.sh",
	  'base.sh',
	  'root.sh',
	  'kernel_config.sh',
	  'kernel.sh',
	  'cron.sh',
	  'syslog.sh',
	  'rEFInd.sh',
	  'reboot.sh',
	  'rubysource-chef.sh',
	  'cleanup.sh'
	]
}
