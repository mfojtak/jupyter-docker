#!/bin/bash

#rm -rf $IPYTHONDIR
#jupyter nbextension enable --py widgetsnbextension
#ipcluster nbextension enable
#ipython profile create --parallel --profile=mpi_local
#mv /ipcluster_config.py $IPYTHONDIR/profile_mpi_local/ipcluster_config.py
#tensorboard --logdir /data/tb_logs &
#cd theia
#yarn theia start /data --hostname=0.0.0.0 &
code-server /root --auth none /root &
jupyter notebook --allow-root --no-browser --notebook-dir=/root --ip 0.0.0.0 --NotebookApp.base_url=$NB_PREFIX