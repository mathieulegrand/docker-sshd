
# Prerequisites

Generate the keys:
```ShellSession
$ mkdir -p etc/ssh
$ ssh-keygen -A -f .
$ ssh-keygen -b 4096 -f limited-key -N ''
```

# Build the image

To build the docker image: `docker build .`.

To run the docker container using image id XXXXXXXX:
`docker run -p 2222:22 -dit XXXXXXXXXXX`

To connect to a running docker instance YYYYYYYY:
`docker exec -it YYYYYYYYYY ash`

Example content for `~/.ssh/config`:

```ssh-config
Host test
	Hostname localhost
	User limited
	Port 2222
	IdentityFile /path/to/limited-key

Host host-via-test
	Hostname remote-host
	User someuser
	Port 22
	ProxyCommand ssh test exec nc %h %p
```

```ShellSession
$ ssh test
Connection to localhost closed by remote host.
Connection to localhost closed.

$ ssh host-via-test
user@remote-host's password:
```
