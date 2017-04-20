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

dnf update --assumeyes &&
    dnf install --assumeyes dnf-plugins-core &&
     dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
     dnf makecache --assumeyes fast &&
     dnf list docker-ce.x86_64  --showduplicates |sort -r &&
     dnf install --assumeyes docker-ce-17.03.1.ce-1.fc25
