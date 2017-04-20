<!--
# Copyright © (C) 2017 Emory Merryman <emory.merryman@gmail.com>
#   This file is part of container-injector.
#
#   container-injector is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   container-injector is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with container-injector.  If not, see <http://www.gnu.org/licenses/>.
-->

# Synopsis
Inject containers with dependencies.

# Usage

## Hello World

This is a simple example.

```
BIN=$(docker volume create) &&
    SBIN=$(docker volume create) &&
    SUDO=$(docker volume create) &&
    docker container run --interactive --tty --rm --volume /var/run/docker.sock:/var/run/docker.sock:ro wildwarehouse/container-injector:0.0.0 \
        --bin ${BIN} \
        --sbin ${SBIN} \
        --sudo ${SUDO} \
        --name hello \
        --container alpine:3.4 echo hello to the &&
    docker container run --interactive --tty --rm --volume ${BIN}:/usr/local/bin:ro --volume ${SBIN}:/usr/local/sbin:ro --volume ${SUDO}:/etc/sudoers.d:ro --volume /var/run/docker.sock:/var/run/docker.sock:ro wildwarehouse/fedora:0.0.0 hello world
    
```

The output of the last command should be 'hello to the world'

The contents of '/usr/local/bin/hello' should be

```
#!/bin/sh
# Copyright © (C) 2017 Emory Merryman <emory.merryman@gmail.com>
#   This file is part of container-injector.
#
#   container-injector is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   container-injector is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with container-injector.  If not, see <http://www.gnu.org/licenses/>.

sudo /usr/local/sbin/hello.sh ${@}
```

This is pretty simple.  It is just using sudo to call another script.

The contents of '/etc/sudoers.d/hello' are

```
#   This file is part of container-injector.
#
#   container-injector is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   container-injector is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with container-injector.  If not, see <http://www.gnu.org/licenses/>.

user ALL=(ALL) NOPASSWD:/usr/local/sbin/hello.shs
```

The contents of '/usr/local/sbin/hello.sh' are

```
#!/bin/sh
# Copyright © (C) 2017 Emory Merryman <emory.merryman@gmail.com>
#   This file is part of container-injector.
#
#   container-injector is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   container-injector is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with container-injector.  If not, see <http://www.gnu.org/licenses/>.

docker container run alpine:3.4 echo hello to the ${@}
```

## ssh-keygen

```
DOT_SSH=$(docker volume create) &&
    BIN=$(docker volume create) &&
    SBIN=$(docker volume create) &&
    SUDO=$(docker volume create) &&
    docker container run --interactive --tty --rm --volume ${DOT_SSH}:/srv wildwarehouse/chown:0.0.0 echo hi &&
    docker container run --interactive --tty --rm --volume /var/run/docker.sock:/var/run/docker.sock:ro wildwarehouse/container-injector:0.0.0 \
        --bin ${BIN} \
        --sbin ${SBIN} \
        --sudo ${SUDO} \
        --name ssh-keygen \
        --container --volume ${DOT_SSH}:/home/user/.ssh bigsummer/ssh-keygen:0.0.0 &&
    docker container run --interactive --tty --rm --volume ${BIN}:/usr/local/bin:ro --volume ${SBIN}:/usr/local/sbin:ro --volume ${SUDO}:/etc/sudoers.d:ro --volume /var/run/docker.sock:/var/run/docker.sock:ro wildwarehouse/fedora:0.0.0 ssh-keygen -f /home/user/.ssh/id_rsa -P "12345" &&
    docker container run --interactive --tty --rm --volume ${DOT_SSH}:/home/user/.ssh:ro wildwarehouse/fedora:0.0.0 cat /home/user/.ssh/id_rsa
```
