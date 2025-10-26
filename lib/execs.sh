#!/usr/bin/env bash

run_vim_pluginstall() {
  # run vim PlugInstall in background, return pid
  vim -c 'PlugInstall' -c 'qa!' > /dev/null 2>&1 &
  echo $!
}

run_vim_plugclean() {
  vim -c 'PlugClean[!]' -c 'qa!' > /dev/null 2>&1 &
  echo $!
}
