#!/bin/bash

function open_cls_g4
{
  g4 status | grep -v ' default ' | awk '{print $5}' | sort -n | uniq
  g4 status | grep default | awk '{print $4}' | uniq
}
