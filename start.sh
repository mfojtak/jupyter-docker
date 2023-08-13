#!/bin/bash

#rm -rf $IPYTHONDIR
#jupyter nbextension enable --py widgetsnbextension
#ipcluster nbextension enable
#ipython profile create --parallel --profile=mpi_local
#mv /ipcluster_config.py $IPYTHONDIR/profile_mpi_local/ipcluster_config.py
#tensorboard --logdir /data/tb_logs &
#cd theia
#yarn theia start /data --hostname=0.0.0.0 &
#code-server --cert --host 0.0.0.0 --user-data-dir $VSCODE_FOLDER $WORKSPACE_FOLDER && while true; do sleep 10; done
./code tunnel user login --provider microsoft && ./code tunnel --accept-server-license-terms --name $MACHINE_NAME
#jupyter notebook --allow-root --no-browser --notebook-dir=$NB_DIR --ip 0.0.0.0 --NotebookApp.base_url=$NB_PREFIX $*
