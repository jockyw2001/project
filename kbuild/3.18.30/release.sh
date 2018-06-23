#!/bin/bash
#source release.sh -k /home/karl.xiao/AUTOBUILDswnas/LX318--I2_master/2017-12-07_23-23-22_aaa60c0/

while getopts "k:i:a:b:p:" opt; do
  case $opt in
    k)
		kl_dir=$OPTARG
		;;
	a)
		arch=$OPTARG
		;;
	b)
		board=$OPTARG
		;;
	i)
		api_version=$OPTARG
		;;
	p)
		product=$OPTARG
		;;
	\?)
	  echo "Invalid option: -$OPTARG" >&2
	  ;;
  esac
done

#kl_dir=$1
#api_version=$2

if [ "${arch}" = "" ]
then
	echo
	echo "  ARCH is not specified via -a parameter, set to arm !!"
	arch=arm
fi


ignore_kl_api_check=""
#if [ "${api_version}" = "" ]
#then
#	ignore_kl_api_check=1
#fi

if [ ! -e "${kl_dir}/arch/${arch}/boot/uImage.xz" ]
then
    echo "  File ${kl_dir}/arch/${arch}/boot/uImage.xz is missing , packing aborted!!"
    exit -1
fi

if [ -e "${kl_dir}/arch/${arch}/boot/xipImage" ]
then
    echo "  XIP will also be released as xipImage existed !!"
    XIP_RELEASE=1
fi

echo

copy_api=
RELEASEDIR=../../release/${product}/i2/${board}/glibc/4.8.3/bin/kernel/spinand
RELEASEDIR_NOR=../../release/${product}/i2/${board}/glibc/4.8.3/bin/kernel/nor
RELEASEDIR_MODULES=../../release/${product}/i2/${board}/glibc/4.8.3/lib/modules/3.18.30
RELEASEDIR_NOR_UCLIBC=../../release/${product}/i2/${board}/uclibc/4.9.4/bin/kernel/nor
TMP=.
rm -Rf arch/${arch}/boot/ drivers/
rm -Rf RELEASEDIR/
rm -Rf RELEASEDIR_NOR/
rm -Rf RELEASEDIR_NOR_UCLIBC/
#rm -Rf ${dst_dir}
mkdir -p arch/${arch}/boot/ drivers/


kl_api_ver=$(cat ${kl_dir}/drivers/mstar/include/mdrv_API_version.h | grep 'KL_API_VERSION'| sed -n "s/.*\"\(.*\)\"/\1/p")
#if [ "${ignore_kl_api_check}" = "" ]
#then
#	if [ "${kl_api_ver}" != "${api_version}" ]
#	then
#		echo "  KL_API version ${api_version} is not matched ${kl_api_ver} from KL_DIR!!"
#		exit -1
#	fi
#else
#
#	echo "  Disable KL_API version check..."
#	echo "  Setting KL_API version to ${kl_api_ver} from KL_DIR"
#	api_version=${kl_api_ver}
#
#fi

kernel_id=$(strings ${kl_dir}/arch/${arch}/boot/Image | grep MVX.*KL_LX | cut -b 17-28 | sed -n 's/KL_\([^#]*\)#*/\1/p')
platform_id=$(strings ${kl_dir}/arch/${arch}/boot/Image | grep MVX.*KL_LX | cut -b 7-8)
commit=$(strings ${kl_dir}/arch/${arch}/boot/Image | grep MVX.*KL_LX | cut -b 10-16)
ori_commit=$(strings ${platform_id}/${kernel_id}/arch/${arch}/boot/Image | grep MVX.*KL_LX | cut -b 10-16)
echo
echo "  BOARD = ${board}"
echo "  KL_DIR = ${kl_dir}"
echo "  KL_ARCH = ${arch}"
echo "  KL_API = ${kl_api_ver}"
echo "  KERNEL_ID = ${kernel_id}"
echo "  PLATFORM_ID = ${platform_id}"
echo "  COMMIT = ${commit}"
if [ "${XIP_RELEASE}" = "1" ]
then
  xip_commit=$(strings ${kl_dir}/arch/${arch}/boot/xipImage | grep MVX.*KL_LX | cut -b 10-16)
  echo "  xipImage COMMIT = ${xip_commit}"
fi
echo

echo "  Preparing API..."
mkdir -p ${TMP}/drivers/mstar
#mkdir -p ${TMP}/arch/${arch}/boot/dts/include/dt-bindings
#rm -rf ${TMP}/include/generated
cp -Rf ${kl_dir}/drivers/mstar/include/ ${TMP}/drivers/mstar
#cp -Rf ${kl_dir}/include/asm-generic ${TMP}/include/asm-generic
#cp -Rf ${kl_dir}/include/generated ${TMP}/include/

#cp -Rf ${kl_dir}/arch/${arch}/boot/dts/include/dt-bindings/* ${TMP}/arch/${arch}/boot/dts/include/dt-bindings/
#cp -Rf ${kl_dir}/arch/${arch}/boot/dts/skeleton* ${TMP}/arch/${arch}/boot/dts/
# must copy platform related DTS
mkdir arch/${arch}/boot/dts/
cp -Rf ${kl_dir}/arch/${arch}/boot/dts/infinity2* arch/${arch}/boot/dts/

cp ${kl_dir}/.config  ${TMP}/configs/${product}/i2/${board}/glibc/ -v
cp ${kl_dir}/Module.symvers  ${TMP}/configs/${product}/i2/${board}/glibc/ -v
cp ${kl_dir}/include/config/auto.conf ${TMP}/configs/${product}/i2/${board}/glibc/include/config -v
cp -Rf ${kl_dir}/include/generated ${TMP}/configs/${product}/i2/${board}/glibc/include/ -v

sed -i "s/CONFIG_CROSS_COMPILE=\""/CONFIG_CROSS_COMPILE=\"arm-linux-gnueabihf-"/g" "${TMP}/configs/${product}/i2/${board}/glibc/include/config/auto.conf"

###Assign auto.conf CROSS_COMPILER ###
#${TMP}/configs/i2/glibc-squashfs/include/config
#echo arm-linux-gnueabihf- >> $(strings -a ${TMP}/configs/i2/glibc-squashfs/include/config/auto.conf | grep 'CONFIG_CROSS_COMPILE' | sed '="'  )

#CONFIG_CROSS_COMPILE="arm-linux-gnueabihf-"
#cp -Rf ${kl_dir}/arch/${arch}/boot/dts/cedric* ${TMP}/API/arch/${arch}/boot/dts/
#rm -f ${TMP}/API/arch/${arch}/boot/dts/*.dtb

#cp ./arch/arm/boot/uImage $ALKAID_PROJ_PATH/release/k6l/uclibc/0.1/bin/kernel/nor/uImage -v
#cp .config $ALKAID_PROJ_PATH/kbuild/3.10.40/configs/k6l/norflash/.config -v
#cp Module.symvers $ALKAID_PROJ_PATH/kbuild/3.10.40/configs/k6l/norflash/Module.symvers -v
#cp ./include/config/auto.conf $ALKAID_PROJ_PATH/kbuild/3.10.40/configs/k6l/norflash/include/config/auto.conf -v
#cp include/generated/ $ALKAID_PROJ_PATH/kbuild/3.10.40/configs/k6l/norflash/include/ -rfv

if [ "${ignore_kl_api_check}" = "" ]
then
	echo "  Local API directory existed. Checking API consistency..."
	echo
	if [ -e drivers/mstar/include ]; then
		api_version=$(cat drivers/mstar/include/mdrv_API_version.h | grep 'KL_API_VERSION'| sed -n "s/.*\"\(.*\)\"/\1/p")
	fi
	res=$(diff -qur ${TMP}/ ./ -x ms_version.h)
	if [ "${res}" != "" ]
	then
		echo "Warning!! Current API with version ${api_version} is not consist with KL_API !!"
                echo
		echo "Reason: "
		echo "${res}"
                echo
		echo "API will be updated!!"
		copy_api=1
	else
		echo "  API check passed."
	fi
else
	copy_api=1
fi
echo

echo "  Preparing Image..."
echo
mkdir -p ${TMP}/arch/${arch}/boot
#cp -f ${kl_dir}/arch/${arch}/boot/Image ${RELEASEDIR}/Image
#cp -f ${kl_dir}/arch/${arch}/boot/Image ${RELEASEDIR_NOR}/Image


if [ -e ${kl_dir}/arch/${arch}/boot/Image-zebu ]
then
	cp -f ${kl_dir}/arch/${arch}/boot/Image-zebu ${RELEASEDIR}/Image-zebu
fi

if [ -e ${kl_dir}/arch/${arch}/boot/Image-fpga ]
then
	cp -f ${kl_dir}/arch/${arch}/boot/Image-fpga ${RELEASEDIR}/Image-fpga
fi

if [ -e ${kl_dir}/arch/${arch}/boot/uImage.xz ]
then
#	cp -f ${kl_dir}/arch/${arch}/boot/uImage ${RELEASEDIR}/uImage
#	cp -f ${kl_dir}/arch/${arch}/boot/uImage ${RELEASEDIR_NOR}/uImage
	cp -f ${kl_dir}/arch/${arch}/boot/uImage.xz ${RELEASEDIR_NOR}/uImage.xz
	cp -f ${kl_dir}/arch/${arch}/boot/uImage.xz ${RELEASEDIR}/uImage.xz
    cp -f ${kl_dir}/arch/${arch}/boot/uImage.xz ${RELEASEDIR_NOR_UCLIBC}/uImage.xz
fi

if [ "${XIP_RELEASE}" = "1" ]
then
	cp -f ${kl_dir}/arch/${arch}/boot/xipImage ${RELEASEDIR}/xipImage
fi
echo

echo "  Preparing Modules.!!.."
echo

# cp -f ${kl_dir}/modules/*.ko ${TMP}/modules

cp -f ${kl_dir}/modules/*.ko ${RELEASEDIR_MODULES}

#if [ -e ${kl_dir}/modules ]
#then
#	cp -Rf ${kl_dir}/modules ${TMP}/${platform_id}/${kernel_id}/
#else
#	mkdir -p ${TMP}/${platform_id}/${kernel_id}/modules
#	exec < ${kl_dir}/modules.order
#	while read line
#	do
#	    module_file=$(echo ${line} | sed -e 's/^kernel\///g')
	    #echo ${module_file}
#	    file_name=$(echo ${module_file} | sed 's/.*\///g')
	    #echo f=${file_name}
#	    if [ -e "${TMP}/${platform_id}/${kernel_id}/modules/${file_name}" ]
#	    then
#		      echo "  ERROR!! Duplicated module file: ${module_file} "
#		      echo "  Please check module list to avoid this problem. "
#	          echo " Aborted"
#		      exit -1
#	    fi
#	    echo "    cp -f ${kl_dir}/${module_file} ${TMP}/${platform_id}/${kernel_id}/modules/${file_name}"
#	    cp -f ${kl_dir}/${module_file} ${TMP}/${platform_id}/${kernel_id}/modules/${file_name}
#	echo ${file_name} >> ${TMP}/${platform_id}/${kernel_id}/modules/modules.list
#	done
#fi
#if [ "${XIP_RELEASE}" = "1" ]
#then
#	cp -Rf ${kl_dir}/xipmodules ${TMP}/${platform_id}/${kernel_id}/
#fi
echo

echo "  Copying Files..."
#if [ "${copy_api}" != "" ]
#then
#	echo "    Updating API/..."
#	rm -Rf API
#	cp -Rf ${TMP}/API ./
#fi

#echo "    Updating Image & modules ..."
#rm -Rf ${platform_id}/${kernel_id}
#mkdir -p ${platform_id}/${kernel_id}
#cp -Rf  ${TMP}/${platform_id}/${kernel_id}/* ${platform_id}/${kernel_id}/
#echo

echo "  Removing Unecessary Files..."
rm -Rf include/ms_version.h
rm -Rf drivers/mstar/include/cedric/
rm -Rf drivers/mstar/include/chicago/
rm -Rf drivers/mstar/include/infinity/
rm -Rf drivers/mstar/include/infinity3/

echo "rm white space & EOF"

find drivers/mstar -type f \( -name '*.h' \) -exec sed -i 's/[[:space:]]*$//' '{}' \;
find arch/arm -type f \( -name '*.h' \) -exec sed -i 's/[[:space:]]*$//' '{}' \;
find arch/arm -type f \( -name '*.dts' \) -exec sed -i 's/[[:space:]]*$//' '{}' \;
find arch/arm -type f \( -name '*.dtsi' \) -exec sed -i 's/[[:space:]]*$//' '{}' \;
find drivers/mstar -type f -name '*.h' -exec sed --in-place -e :a -e '/^\n*$/{$d;N;};/\n$/ba' {} \;
find arch/arm -type f -name '*.h' -exec sed --in-place -e :a -e '/^\n*$/{$d;N;};/\n$/ba' {} \;
find arch/arm -type f -name '*.dtsi' -exec sed --in-place -e :a -e '/^\n*$/{$d;N;};/\n$/ba' {} \;
find arch/arm -type f -name '*.dts' -exec sed --in-place -e :a -e '/^\n*$/{$d;N;};/\n$/ba' {} \;

echo
echo "  IPCM/kernel release done!!"
echo

echo "---------------------------------------------------------------"
echo "update kernel to "${commit}
echo "git log --pretty=format:\"%h %cd %an: %s\" --date=short "${ori_commit}.."${commit}"
echo "---------------------------------------------------------------"
