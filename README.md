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

```
BIN=$(docker volume create) &&
    SBIN=$(docker volume create) &&
    SUDO=$(docker volume create) &&
    docker run --interactive --tty --rm wildwarehouse/container-injector:0.0.0 \
        --bin ${BIN} \
        --sbin ${SBIN} \
        --sudo ${SUDO} \
        --name hello \
        --container alpine:3.4 echo hello to the \${@} &&
    docker run --interactive --tty --rm --volume ${BIN}:/usr/local/bin:ro --volume ${SBIN}:/usr/local/sbin:ro --volume ${SUDO}:/etc/sudoers.do:ro wildwarehouse/alpine:0.0.0 hello world
```