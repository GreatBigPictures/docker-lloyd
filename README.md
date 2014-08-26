# docker-lloyd
*[Lloyd's Coffee House](http://en.wikipedia.org/wiki/Lloyd%27s_Coffee_House)
was the first marine insurance company.*

This tools backs-up Docker [volume containers](http://docs.docker.io/en/latest/use/working_with_volumes/#creating-and-mounting-a-data-volume-container)
and stores them via scp.

To use it, run:

    $ docker run -v /var/run/docker.sock:/docker.sock \
             -v /var/lib/docker/vfs/dir:/var/lib/docker/vfs/dir \
             --volumes-from SSH_VOLUME \
             -e USERNAME=... -e PRIVATE_KEY=... docker-backup-daemon \
              HOST:PATH container-a container-b container-c...

This will run [docker-backup](https://github.com/discordianfish/docker-backup),
gzip and upload a tarball named after the container to the destination.


See [docker-backup](https://github.com/discordianfish/docker-backup) on
how to restore a backup.

The Dockerfile passes command line options to docker-backup by setting the OPTS
environment variable. If you need to override/change those, you can set it on
the command line:

    $ docker run -e OPTS="-addr=/foo/docker.sock" ...
