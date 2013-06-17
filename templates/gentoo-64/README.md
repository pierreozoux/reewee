MacBook Pro Model 13inch Mid 2009 5.5

Burn a live CD with Gentoo

Plug it to your Macbook, and at the startup, hold down "c" key.

Be sure the network cable is pluged to your mac.

Enter the following in the macbook terminal :

````
ifconfig
/etc/init.d/sshd start
passwd #enter "ubuntu" twice
````

In your terminal :
````
macbook=(ip you just read)
vi ~/.ssh/known_hosts
scp ~/.ssh/id_dsa.pub root@macbook:/root/
ssh root@macbook
mkdir .ssh
cat id_dsa.pub >> .ssh/authorized_keys
````

check the ssh_ip in your definition.rb

And go!!!

````
./bin/reewee
````

LICENCE

From the Veewee templates
