#!/usr/bin/env bash

mkdir -p miseq-sop
cd miseq-sop
wget --max-redirect=10 "https://mothur.s3.us-east-2.amazonaws.com/data/MiSeqDevelopmentData/StabilityNoMetaG.tar"
tar xvf StabilityNoMetaG.tar
