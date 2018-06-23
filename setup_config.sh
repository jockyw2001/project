PROJ_ROOT=$PWD

if [ "$#" != "1" ]; then
    echo "usage: $0 configs/config.chip"
fi
if [ -e configs ]; then
    echo PROJ_ROOT = $PROJ_ROOT > configs/current.configs
    echo CONFIG_NAME = config_module_list.mk >> configs/current.configs
    echo SOURCE_MK = ../sdk/sdk.mk >> configs/current.configs
    cat $1 >> configs/current.configs
else
    echo "can't found configs directory!"
fi

cat configs/current.configs
