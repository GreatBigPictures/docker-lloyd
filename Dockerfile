FROM fish/docker-backup
MAINTAINER Michael Goodness <mgood@gbpinc.com>

RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y

ADD run /docker-backup/

VOLUME /mnt/keydir
ENTRYPOINT [ "./run" ]
