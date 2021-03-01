#!/bin/bash

#dim screen
output=$(redshift -v -P -O 3200K 2>&1)
echo "dimScreen: $output"