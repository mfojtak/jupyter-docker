#!/bin/bash

#rm -rf $IPYTHONDIR
#jupyter nbextension enable --py widgetsnbextension
#ipcluster nbextension enable
#ipython profile create --parallel --profile=mpi_local
#mv /ipcluster_config.py $IPYTHONDIR/profile_mpi_local/ipcluster_config.py
#tensorboard --logdir /data/tb_logs &
#cd theia
#yarn theia start /data --hostname=0.0.0.0 &
code-server --auth none --host 0.0.0.0 --user-data-dir $VSCODE_FOLDER $WORKSPACE_FOLDER &
jupyter notebook --allow-root --no-browser --notebook-dir=$NB_DIR --ip 0.0.0.0 --NotebookApp.base_url=$NB_PREFIX $*
