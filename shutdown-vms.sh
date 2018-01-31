#!/bin/bash
for k in us-central1-a us-central1-b us-central1-f; do
	for i in $(gcloud compute instances list --zones $k| awk 'NR>1 {print $1}'); do
		gcloud compute instances shutdown $i -q --zone "$k" &
	done;
done;
