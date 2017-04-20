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

checkit(){
    if [ ! ${1} ]
    then
        echo ${@} &&
            exit ${2}
    fi
}
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --sudo)
                checkit [ -z "${SUDO}" ] 64 Multiple sudo&&
                    SUDO=${2} &&
                    shift 2
            ;;
            --bin)
                checkit [ -z "${BIN}" ] 65 Multiple bin &&
                    BIN=${2} &&
                    shift 2
            ;;
            --sbin)
                checkit [ -z "${SBIN}" ] 66 Multiple sbin &&
                    SBIN=${2} &&
                    shift 2
            ;;
            --container)
                ([ -z "${CONTAINER}" ] || (echo Multiple container && exit 67)) &&
                    shift &&
                    docker container rm $(docker container create ${@}) &&
                    CONTAINER=${@} &&
                    shift ${#}
            ;;
            --name)
                ([ -z "${NAME}" ] || (echo Multiple name && exit 68)) &&
                    NAME=${2} &&
                    shift 2
            ;;
        esac
    done &&
    ([ ! -z "${SUDO}" ] || (echo sudo is not specified && exit 69)) &&
    ([ ! -z "${BIN}" ] || (echo bin is not specified && exit 70)) &&
    ([ ! -z "${SBIN}" ] || (echo sbin is not specified && exit 71)) &&
    ([ ! -z "${CONTAINER}" ] || (echo container is not specified && exit 72)) &&
    ([ ! -z "${NAME}" ] || (echo name is not specified && exit 73)) &&
    sed -e "s#\${NAME}#${NAME}#" /opt/docker/bin.sh | docker run --interactive --rm --volume ${BIN}:/usr/local/bin --workdir /usr/local/bin alpine:3.4 tee ${NAME} &&
    docker run --interactive --rm --volume ${BIN}:/usr/local/bin --workdir /usr/local/bin alpine:3.4 chmod 0555 ${NAME} &&
    echo SED1 "s#\${NAME}#${NAME}#" &&
    echo SED2 "s#\${CONTAINER}##" &&
    sed -e "s#\${NAME}#${NAME}#" -e "s#\${CONTAINER}#${CONTAINER[*]}#" /opt/docker/sbin.sh | docker run --interactive --rm --volume ${SBIN}:/usr/local/sbin --workdir /usr/local/sbin alpine:3.4 tee ${NAME}.sh &&
    docker run --interactive --rm --volume ${SBIN}:/usr/local/sbin --workdir /usr/local/sbin alpine:3.4 chmod 0500 ${NAME}.sh &&
    sed -e "s#\${NAME}#${NAME}#" /opt/docker/sudo | docker run --interactive --rm --volume ${SUDO}:/etc/sudoers.d --workdir /etc/sudoers.d alpine:3.4 tee ${NAME} &&
    docker run --interactive --rm --volume ${SUDO}:/etc/sudoers.d --workdir /etc/sudoers.d alpine:3.4 chmod 0444 ${NAME}