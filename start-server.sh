#!/bin/bash

cd www
until `nekotools server`; do
	echo 'restarting...'
	sleep 1
done

