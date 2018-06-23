#exp: ./release.sh -k ~/k6l/kernel/ -l glibc -n 4.7.2 -c k6 -b 257C -p nvr -f nand
while getopts "k:l:n:c:b:p:f:" opt; do
  case $opt in
    k)
		KERNEL_DIR=$OPTARG
		;;
	l)
		C_LIB_TYPE=$OPTARG
		;;
	n)
		TOOL_VER=$OPTARG
		;;
	c)
		CHIP_NAME=$OPTARG
		;;
	b)
		BOARD_NAME=$OPTARG
		;;
	p)
		PRODUCT=$OPTARG
		;;
	f)
		FLASH_TYPE=$OPTARG
		;;
	\?)
	  echo "Invalid option: -$OPTARG" >&2
	  ;;
  esac
done
cp ${KERNEL_DIR}/arch/arm/boot/uImage ../../release/${PRODUCT}/${CHIP_NAME}/${BOARD_NAME}/${C_LIB_TYPE}/${TOOL_VER}/bin/kernel/${FLASH_TYPE}/uImage -v
cp ${KERNEL_DIR}/.config ./configs/${PRODUCT}/${CHIP_NAME}/${BOARD_NAME}/${C_LIB_TYPE}/.config -v
cp ${KERNEL_DIR}/Module.symvers ./configs/${PRODUCT}/${CHIP_NAME}/${BOARD_NAME}/${C_LIB_TYPE}/Module.symvers -v
cp ${KERNEL_DIR}/include/config/auto.conf ./configs/${PRODUCT}/${CHIP_NAME}/${BOARD_NAME}/${C_LIB_TYPE}/include/config/auto.conf -v
cp ${KERNEL_DIR}/include/generated/ ./configs/${PRODUCT}/${CHIP_NAME}/${BOARD_NAME}/${C_LIB_TYPE}/include/ -rfv
