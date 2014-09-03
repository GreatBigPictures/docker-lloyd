# docker-lloyd
*[Lloyd's Coffee House](http://en.wikipedia.org/wiki/Lloyd%27s_Coffee_House)
was the first marine insurance company.*

This tool backs-up and restores Docker [volume containers](http://docs.docker.io/en/latest/use/working_with_volumes/#creating-and-mounting-a-data-volume-container)
and stores them via SSH.

To use it, first generate an SSH keypair in a volume container:

	$ docker run -v /root/.ssh --name backups_ssh busybox:latest true

	$ docker run -it -v /root/.ssh --volumes-from backups_ssh \
		--entrypoint /bin/bash \
		--name lloyd_setup greatbigpictures/docker-lloyd:latest

	$ ssh-keygen -b4096 -C <key_name> -f /root/.ssh/<key_file>
	$ ssh-copy-id -i /root/.ssh/<key_file> <user@backup-host>

then run:

    $ docker run -v /var/run/docker.sock:/docker.sock \
             -v /var/lib/docker/vfs/dir:/var/lib/docker/vfs/dir \
             --volumes-from backups_ssh \
             -e REMOTE_DIR=... -e PRIVATE_KEY=<key_file> -e USER_HOST=<user@host> \
             greatbigpictures/docker-lloyd:latest store \
             container-a container-b container-c...

This will run [docker-backup](https://github.com/discordianfish/docker-backup),
gzip and upload a tarball named after the container to the destination.


To restore a backup, run:

    $ docker run -v /var/run/docker.sock:/docker.sock \
             -v /var/lib/docker/vfs/dir:/var/lib/docker/vfs/dir \
             --volumes-from backups_ssh \
             -e REMOTE_DIR=... -e PRIVATE_KEY=<key_file> -e USER_HOST=<user@host> \
             greatbigpictures/docker-lloyd:latest restore \
             container-a container-b container-c...

Note: The volume container's image must be present on the host before restoring.


The Dockerfile passes command line options to docker-backup by setting the OPTS
environment variable. If you need to override/change those, you can set it on
the command line:

    $ docker run -e OPTS="-addr=/foo/docker.sock" ...
