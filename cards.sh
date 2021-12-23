#!/bin/bash

for i in $(seq -f "%03g" 1 250)
do
	echo -e "2021.12.23    11:13:23\n%$i?\n;$i?\n+$i?\n" | tee -a cards.txt
done
