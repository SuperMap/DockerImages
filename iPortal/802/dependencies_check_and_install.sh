#!/bin/bash

# ---------------------------------------------------------------------
# SuperMapiPortal8C prerequisite Libs install/uninstall script
# This script is is only suitable for Redhat、CentOS、Suse and Ubuntu platforms
# lastmodified: 2016/03/15
# ---------------------------------------------------------------------
#
SCRIPT_VERSION=1.0_20160324
INSTALL_PATH=$PWD
LICENSE_SUPPORT_PATH=$INSTALL_PATH/SuperMap_License/Support
GLIBC_PATH=$LICENSE_SUPPORT_PATH/32bit_lib_for_iServer/glibc
OPENGL_PATH=$LICENSE_SUPPORT_PATH/32bit_lib_for_iServer/OpenGL
OTHERS_PATH=$LICENSE_SUPPORT_PATH/32bit_lib_for_iServer/others
X11_PATH=$LICENSE_SUPPORT_PATH/32bit_lib_for_iServer/X11
LIBC6_I386_FOR_UBUNTU=$X11_PATH/for_ubuntu

UGO_THIRD_LIB_PATH=$INSTALL_PATH/objectsjava/third_lib
LIB_X11_X86_64=$UGO_THIRD_LIB_PATH/X11_x86_64
UGO_THIRD_LIB_PATH_FOR_UBUNTU=$UGO_THIRD_LIB_PATH/for_ubuntu

current_osinfo_file=/proc/version
is_suse=`grep -c 'SUSE' $current_osinfo_file` 
is_redhat=`grep -c 'Red *Hat' $current_osinfo_file` 
is_ubuntu=`grep -c 'Ubuntu' $current_osinfo_file` 

is_bit64=`grep -c 'x86_64' $current_osinfo_file`
if [ $is_bit64 -eq 0 ];then
	is_bit64=`uname -a | grep -c 'x86_64'`
fi

os_version=0

is_always_yes=1

#the automatic platform detection can't work normally in docker container environment
#the user may specify platform through the options, such as "-u option" ubuntu platform, redhat platform "-r" option
judge_always_yes_and_platform()
{
	if [ $# -eq 0 ]; then
		return 
	fi
	
	options=$1
	y_exist=`echo $options | grep -c 'y'`
	if [ $y_exist -gt 0 ]; then
		is_always_yes=0
	fi
	
	#used to specify the redhat and centos platform
	r_exist=`echo $options | grep -c 'r'`
	#used to specify the centos platform
	s_exist=`echo $options | grep -c 's'`
	#used to specify the ubuntu platform
	u_exist=`echo $options | grep -c 'u'`
	if [ $r_exist -gt 0 ]; then
		is_redhat=1
		is_suse=0
		is_ubuntu=0
		return
	fi
		
	if [ $s_exist -gt 0 ]; then
		is_suse=1
		is_redhat=0
		is_ubuntu=0
		return
	fi
		
	if [ $u_exist -gt 0 ]; then
		is_ubuntu=1
		is_redhat=0
		is_suse=0
		return
	fi
}

# get key input
getKey()
{
	savedstty=`stty -g`
	stty -echo
	stty raw
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $savedstty
}

# judge user input
yesorno()
{
	echo "[y/Y:yes, n/N:no]"
	while [ 1 ]
	do
		cmd=`getKey`
		case $cmd in	
			y|Y)
				echo $cmd
				return 0
				;;		
			n|N)
				echo $cmd
				return 1
				;;		
			*)
				continue
				;;		
		esac
	done
}


main_uninstall_in_ubuntu()
{
	msg="Do you want to uninstall libc6-i386 libs ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libc6_i386=$?

	if [ $uninstall_libc6_i386 -eq 0 ]
	then
		is_libc6_i3861_exists=`dpkg -l | grep libc6-i386 | grep -c 'libc6-i386'`
		if [ $is_libc6_i3861_exists -gt 0 ]; then
			echo "Unistalling libc6-i386 libs..."
			sudo dpkg -P libc6-i386
		fi
		echo "Uninstall libc6-i386 finished."
		printf "\n"
	fi
	
	
	msg="Do you want to uninstall libxtst6 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libxtst6=$?
	
	if [ $uninstall_libxtst6 -eq 0 ]
	then
		is_libxtst6_exists=`dpkg -l | grep libxtst6 | grep -c 'libxtst6'`
		if [ $is_libxtst6_exists -gt 0 ]; then
			echo "Unistalling libxtst6 lib..."
			sudo dpkg -P libxtst6
		fi
		echo "Uninstall libxtst6 finished."
		printf "\n"
	fi
	
	#uninstall libxi6
	#libxi6 is need by libxext6,so need uninstall libxext6 first
	msg="Do you want to uninstall libxi6 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libxi6=$?
	
	if [ $uninstall_libxi6 -eq 0 ]
	then
		is_libxi6_exists=`dpkg -l | grep libxi6 | grep -c 'libxi6'`
		if [ $is_libxi6_exists -gt 0 ]; then
			echo "Unistalling libxi6 lib..."
			sudo dpkg -P libxi6
		fi
		echo "Uninstall libxi6 finished."
		printf "\n"
	fi
	
	#uninstall libxext6
	#libxext6 is need by libxtst6,so need uninstall libxtst6 first
	msg="Do you want to uninstall libxext6 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libxext6=$?
	
	if [ $uninstall_libxext6 -eq 0 ]
	then
		is_libxext6_exists=`dpkg -l | grep libxext6 | grep -c 'libxext6'`
		if [ $is_libxext6_exists -gt 0 ]; then
			echo "Unistalling libxext6 lib..."
			sudo dpkg -P libxext6
		fi
		echo "Uninstall libxext6 finished."
		printf "\n"
	fi
	
	#uninstall x11-common
	#x11-common is need by libxtst6,so need uninstall libxtst6 first
	msg="Do you want to uninstall x11-common lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_x11_common=$?
	
	if [ $uninstall_x11_common -eq 0 ]
	then
		is_x11_common_exists=`dpkg -l | grep x11-common | grep -c 'x11-common'`
		if [ $is_x11_common_exists -gt 0 ]; then
			echo "Unistalling x11-common lib..."
			sudo dpkg -P x11-common
		fi
		echo "Uninstall x11-common finished."
		printf "\n"
	fi

	msg="Do you want to uninstall libxrender1 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libxrender1=$?
	
	if [ $uninstall_libxrender1 -eq 0 ]
	then
		is_libxrender1_exists=`dpkg -l | grep libxrender1 | grep -c 'libxrender1'`
		if [ $is_libxrender1_exists -gt 0 ]; then
			echo "Unistalling libxrender1 lib..."
			sudo dpkg -P libxrender1
		fi
		echo "Uninstall libxrender1 finished."
		printf "\n"
	fi
	
	
	#uninstall libx11-6 
	#libx11-6 is need by libxtst6,libxi6,libxrender1,libxext6,so need uninstall them first
	msg="Do you want to uninstall libx11-6  lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libx11_6=$?
	
	if [ $uninstall_libx11_6 -eq 0 ]
	then
		is_libx11_6_exists=`dpkg -l | grep libx11-6 | grep -c 'libx11-6'`
		if [ $is_libx11_6_exists -gt 0 ]; then
			echo "Unistalling libx11-6  lib..."
			sudo dpkg -P libx11-6
		fi
		echo "Uninstall libx11-6 finished."
		printf "\n"
	fi
	
	#uninstall libx11-data 
	#libx11-data is need by libx11-6,so need uninstall libx11-6 first
	msg="Do you want to uninstall libx11-data  lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libx11_data=$?
	
	if [ $uninstall_libx11_data -eq 0 ]
	then
		is_libx11_data_exists=`dpkg -l | grep libx11-data | grep -c 'libx11-data'`
		if [ $is_libx11_data_exists -gt 0 ]; then
			echo "Unistalling libx11-data  lib..."
			sudo dpkg -P libx11-data
		fi
		echo "Uninstall libx11-data finished."
		printf "\n"
	fi
	
	
	#uninstall libxcb1 
	#libxcb1 is need by libx11-6,so need uninstall libx11-6 first 
	msg="Do you want to uninstall libxcb1 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libxcb1=$?
	
	if [ $uninstall_libxcb1 -eq 0 ]
	then
		is_libxcb1_exists=`dpkg -l | grep libxcb1 | grep -c 'libxcb1'`
		if [ $is_libxcb1_exists -gt 0 ]; then
			echo "Unistalling libxcb1 lib..."
			sudo dpkg -P libxcb1
		fi
		echo "Uninstall libxcb1 finished."
		printf "\n"
	fi
	
	#uninstall libxdmcp6 
	#libxdmcp6 is need by libxcb1,so need uninstall libxcb1 first 
	msg="Do you want to uninstall libxdmcp6 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libxdmcp6=$?
	
	if [ $uninstall_libxdmcp6 -eq 0 ]
	then
		is_libxdmcp6_exists=`dpkg -l | grep libxdmcp6 | grep -c 'libxdmcp6'`
		if [ $is_libxdmcp6_exists -gt 0 ]; then
			echo "Unistalling libxdmcp6 lib..."
			sudo dpkg -P libxdmcp6
		fi
		echo "Uninstall libxdmcp6 finished."
		printf "\n"
	fi
	
	
	#uninstall libxau6 
	#libxau6 is need by libxcb1,so need uninstall libxcb1 first 
	msg="Do you want to uninstall libxau6 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libxau6=$?
	
	if [ $uninstall_libxau6 -eq 0 ]
	then
		is_libxtst6_exists=`dpkg -l | grep libxau6 | grep -c 'libxau6'`
		if [ $is_libxtst6_exists -gt 0 ]; then
			echo "Unistalling libxau6 lib..."
			sudo dpkg -P libxau6
		fi
		echo "Uninstall libxau6 finished."
		printf "\n"
	fi
	
	
	msg="Do you want to uninstall libgomp1 lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libgomp1=$?
	
	if [ $uninstall_libgomp1 -eq 0 ]
	then
		is_libgomp1_exists=`dpkg -l | grep libgomp1 | grep -c 'libgomp1'`
		if [ $is_libgomp1_exists -gt 0 ]; then
			echo "Unistalling libgomp1 lib..."
			sudo dpkg -P libgomp1
		fi
		echo "Uninstall libgomp1 finished."
		printf "\n"
	fi
	
	msg="Do you want to uninstall gcc-5-base  lib ?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_gcc_5_base=$?
	
	
	if [ $uninstall_gcc_5_base -eq 0 ]
	then
		is_gcc_5_base_exists=`dpkg -l | grep gcc-5-base | grep -c 'gcc-5-base'`
		if [ $is_gcc_5_base_exists -gt 0 ]; then
			echo "Unistalling gcc-5-base lib..."
			sudo dpkg -P gcc-5-base
		fi
		echo "Uninstall gcc-5-base finished."
		printf "\n"
	fi
	
}

yesornot_conside_alawys_yes()
{
	ensure_msg="$1"
	go_on_or_not=1
	
	if [ $is_always_yes -eq 1 ]; then 
		echo "$ensure_msg"
		yesorno
		if [ $? -eq 0 ]; then
			go_on_or_not=0
		fi
	else
		go_on_or_not=0
	fi
	
	return $go_on_or_not
}

main_uninstall_in_redhat_centos_suse()
{
	msg="Do you want to uninstall libX11_x86_64 libs in $LIB_X11_X86_64?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libX11_x86_64=$?
	
	if [ $uninstall_libX11_x86_64 -eq 0 ]
	then
		echo "Unistalling libX11_x86_64 libs..."
		rpm -e --nodeps libX11-1.6.0-6.el6.x86_64
		rpm -e --nodeps libX11-common-1.6.0-6.el6.noarch
		rpm -e --nodeps libxcb-1.9.1-3.el6.x86_64
		rpm -e --nodeps libXau-1.0.6-4.el6.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	
	msg="Do you want to uninstall libgomp_x86_64 in $UGO_THIRD_LIB_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libgomp_x86_64=$?
	
	if [ $uninstall_libgomp_x86_64 -eq 0 ]
	then
		echo "Unistalling libgomp_x86_64..."
		rpm -e --nodeps libgomp-4.4.7-16.el6.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	
	msg="Do you want to uninstall libpng12_x86_64 in $UGO_THIRD_LIB_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libpng12_x86_64=$?
	
	if [ $uninstall_libpng12_x86_64 -eq 0 ]
	then
		echo "Unistalling libpng12_x86_64..."
		rpm -e --nodeps libpng12-0-1.2.44-7.1.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	
	msg="Do you want to uninstall libXtst_x86_64 in $UGO_THIRD_LIB_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libXtst_x86_64=$?

	if [ $uninstall_libXtst_x86_64 -eq 0 ]
	then
		echo "Unistalling libXtst_x86_64..."
		rpm -e --nodeps libXtst-1.2.2-2.1.el6.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	
	
	msg="Do you want to uninstall libXi_x86_64 in $UGO_THIRD_LIB_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libXi_x86_64=$?
	
	if [ $uninstall_libXi_x86_64 -eq 0 ]
	then
		echo "Unistalling libXi_x86_64..."
		rpm -e --nodeps libXi-1.7.2-2.2.el6.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	
	msg="Do you want to uninstall libXext_x86_64 in $UGO_THIRD_LIB_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libXext_x86_64=$?
	
	if [ $uninstall_libXext_x86_64 -eq 0 ]
	then
		echo "Unistalling libXext_x86_64..."
		rpm -e --nodeps libXext-1.3.2-2.1.el6.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	
	msg="Do you want to uninstall libXrender_x86_64 in $UGO_THIRD_LIB_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_libXrender_x86_64=$?
	
	if [ $uninstall_libXrender_x86_64 -eq 0 ]
	then
		echo "Unistalling libXrender_x86_64..."
		rpm -e --nodeps libXrender-0.9.8-2.1.el6.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	
	msg="Do you want to uninstall other libs in $OTHERS_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_other_libs=$?
	
	if [ $uninstall_other_libs -eq 0 ]
	then
		echo "Unistalling other libs..."
		rpm -e --nodeps libXi6-32bit-1.3-1.9.x86_64
		rpm -e --nodeps libcom_err2-32bit-1.41.11-1.11.x86_64
		rpm -e --nodeps keyutils-libs-32bit-1.3-1.9.x86_64
		rpm -e --nodeps krb5-32bit-1.8.1-4.3.x86_64
		rpm -e --nodeps libdb-4_5-32bit-4.5.20-99.13.x86_64
		rpm -e --nodeps libidn-32bit-1.15-4.1.x86_64
		rpm -e --nodeps cyrus-sasl-32bit-2.1.23-11.1.x86_64
		rm -rf /usr/lib/libpng12.so.0
		rm -rf /usr/lib/libjpeg.so.62
		echo "Uninstall finished."
		printf "\n"
	fi

	msg="Do you want to uninstall freeglut-32bit in $OPENGL_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_freeglut_32bit=$?
	
	if [ $uninstall_freeglut_32bit -eq 0 ]
	then	
		echo "Unistalling freeglut-32bit..."
		rpm -e --nodeps libdrm-32bit-2.4.21-1.2.x86_64
		rpm -e --nodeps Mesa-32bit-7.8.2-1.3.x86_64
		rpm -e --nodeps freeglut-32bit-090301-8.1.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi

	msg="Do you want to uninstall X11-32bit in $X11_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_x11_32bit=$?
	
	if [ $uninstall_x11_32bit -eq 0 ]
	then	
		echo "Unistalling X11-32bit..."
# uninstall xorg-x11-libs-32bit-7.5-3.15.x86_64.rpm
		rpm -e --nodeps xorg-x11-libs-32bit-7.5-3.15.x86_64

		# uninstall xorg-x11-libxkbfile-32bit-7.5-1.9.x86_64.rpm
		rpm -e --nodeps xorg-x11-libxkbfile-32bit-7.5-1.9.x86_64

		# uninstall xorg-x11-libfontenc-32bit-7.5-1.9.x86_64.rpm
		rpm -e --nodeps xorg-x11-libfontenc-32bit-7.5-1.9.x86_64

		# uninstall fontconfig-32bit-2.8.0-7.1.x86_64.rpm
		rpm -e --nodeps fontconfig-32bit-2.8.0-7.1.x86_64
		rpm -e --nodeps libexpat1-32bit-2.0.1-98.1.x86_64
		rpm -e --nodeps libfreetype6-32bit-2.3.12-6.3.x86_64
		rpm -e --nodeps zlib-32bit-1.2.3-141.1.x86_64

		# uninstall xorg-x11-libXrender-32bit-7.5-1.9.x86_64.rpm
		rpm -e --nodeps xorg-x11-libXrender-32bit-7.5-1.9.x86_64

		# uninstall xorg-x11-libXprintUtil-32bit-7.5-1.10.x86_64.rpm
		rpm -e --nodeps xorg-x11-libXprintUtil-32bit-7.5-1.10.x86_64

		# uninstall xorg-x11-libXpm-32bit-7.5-1.9.x86_64.rpm
		rpm -e --nodeps xorg-x11-libXpm-32bit-7.5-1.9.x86_64

		# uninstall xorg-x11-libXp-32bit-7.5-1.9.x86_64.rpm
		rpm -e --nodeps xorg-x11-libXp-32bit-7.5-1.9.x86_64	

		# uninstall xorg-x11-libXmu-32bit-7.5-1.9.x86_64.rpm
		rpm -e --nodeps xorg-x11-libXmu-32bit-7.5-1.9.x86_64
		rpm -e --nodeps xorg-x11-libXt-32bit-7.5-1.10.x86_64
		rpm -e --nodeps xorg-x11-libSM-32bit-7.5-1.11.x86_64
		rpm -e --nodeps xorg-x11-libICE-32bit-7.5-1.9.x86_64
		rpm -e --nodeps libuuid1-32bit-2.17.2-5.3.x86_64
# uninstall xorg-x11-libs-32bit-7.5-3.15.x86_64.rpm

		# install xorg-x11-libXfixes-32bit-7.5-1.9.x86_64.rpm
		rpm -e --nodeps xorg-x11-libXfixes-32bit-7.5-1.9.x86_64

		# install libXext
		rpm -e --nodeps xorg-x11-libXext-32bit-7.5-1.10.x86_64

		# install libX11
		rpm -e --nodeps xorg-x11-libXau-32bit-7.5-1.9.x86_64
		rpm -e --nodeps xorg-x11-libxcb-32bit-7.5-3.1.x86_64	
		rpm -e --nodeps xorg-x11-libX11-32bit-7.5-1.23.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi

	msg="Do you want to uninstall glibc-32bit in $GLIBC_PATH?"
	yesornot_conside_alawys_yes "$msg"
	uninstall_glibc_32bit=$?
	
	
	if [ $uninstall_glibc_32bit -eq 0 ]
	then
		echo "Uninstalling glibc-32bit..."
		rpm -e --nodeps libstdc++45-32bit-4.5.0_20100604-1.12.x86_64
		rpm -e --nodeps libgcc45-32bit-4.5.0_20100604-1.12.x86_64
		rpm -e --nodeps glibc-locale-32bit-2.11.2-2.4.x86_64
		rpm -e --nodeps glibc-32bit-2.11.2-2.4.x86_64
		echo "Uninstall finished."
		printf "\n"
	fi
	printf "\n"
	echo "Unistall finished."

}



# Use to uninstall RPMs from SuperMapiPortal8C
main_uninstall()
{
	if [ $is_suse -gt 0 ] || [ $is_redhat -gt 0 ]; then
		echo "Info: The following will unload iPortal8C dependent libraries."
		printf "\n"
		echo "Info: Please confirm  whether the library must be removed one by one "
		printf "\n"
		main_uninstall_in_redhat_centos_suse 
	else
		echo "Info: The following will unload iPortal8C dependent libraries."
		printf "\n"
		echo "Info: Please confirm  whether the library must be removed one by one "
		printf "\n"
		main_uninstall_in_ubuntu
	fi
}

install_libpng12()
{
	echo "There is no libpng12_x86_64 needed by SuperMapiPortal8C in the OS,and will install it automatically."
	cd $UGO_THIRD_LIB_PATH
	
	echo "Installing libpng12_x86_64..."
	if [ $is_suse > 1 ]; then
		#suse
		rpm -ivh libpng12-0-1.2.44-7.1.x86_64.rpm
		echo "Install finished."
		printf "\n"
	elif [ $is_redhat > 1 ]; then
		#redhat,centos
		rpm -ivh libpng-1.2.10-17.el5_8.x86_64.rpm
		echo "Install finished."
		printf "\n"
	fi
}


# Use to check other libs such as libjpeg
Others_check_and_install()
{
	echo "Checking other libs..."	

	# check libXi6
	cd /usr/lib	
	libXi6=libXi.so.6
	if [ ! -f $libXi6 ]
	then
		echo "There is no libXi6 needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $OTHERS_PATH
		echo "Installing libXi6..."
		rpm -ivh libXi6-32bit-1.3-1.9.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libXi6 is available"
	fi


	# check krb
	cd /usr/lib	
	libkrb5=libkrb5.so.3
	if [ ! -f $libkrb5 ]
	then
		echo "There is no libkrb5 needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $OTHERS_PATH
		echo "Installing libkrb5..."
		rpm -ivh keyutils-libs-32bit-1.3-1.9.x86_64.rpm
		rpm -ivh libcom_err2-32bit-1.41.11-1.11.x86_64.rpm
		rpm -ivh krb5-32bit-1.8.1-4.3.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libkrb5 is available"
	fi		
	
	# check sasl
	cd /usr/lib	
	libsasl=libsasl2.so.2
	if [ ! -f $libsasl ]
	then
		echo "There is no libsasl needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $OTHERS_PATH
		echo "Installing libsasl..."
		rpm -ivh libdb-4_5-32bit-4.5.20-99.13.x86_64.rpm
		rpm -ivh cyrus-sasl-32bit-2.1.23-11.1.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libsasl is available"
	fi		
	
	# check idn
	cd /usr/lib	
	libidn=libidn.so.11

	if [ ! -f $libidn ]
	then
		echo "There is no libidn needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $OTHERS_PATH
		echo "Installing libidn..."
		rpm -ivh libidn-32bit-1.15-4.1.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libidn is available"
	fi		

	#下面这些库被UGO依赖，如没有安装，则加载UGO的libWrapj.so失败
	
	# check libX11_x86_64
	cd /usr/lib64
	libX11_x86_64=libX11.so.6

	if [ ! -f $libX11_x86_64 ]
	then
		echo "There is no libX11_x86_64 needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $LIB_X11_X86_64
		echo "Installing libX11_x86_64..."
		#libX11.so.6依赖libXau,libxcb,libc以及libdl库。所以需要先安装被依赖的库
		rpm -ivh libXau-1.0.6-4.el6.x86_64.rpm
		rpm -ivh libxcb-1.9.1-3.el6.x86_64.rpm
		rpm -ivh libX11-common-1.6.0-6.el6.noarch.rpm
		rpm -ivh libX11-1.6.0-6.el6.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libX11_x86_64 is available"
	fi		
	
	# check libgomp_x86_64
	cd /usr/lib64
	libgomp_x86_64=libgomp.so.1

	if [ ! -f $libgomp_x86_64 ]
	then
		echo "There is no libgomp_x86_64 needed by SuperMapiPortal8C in the OS ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH
		echo "Installing libgomp_x86_64..."
		rpm -ivh libgomp-4.4.7-16.el6.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libgomp_x86_64 is available"
	fi
	
	# check libpng12_x86_64
	cd /usr/lib64
	libpng12_x86_64=libpng12.so.0

	if [ ! -f $libpng12_x86_64 ]
	then
		install_libpng12
	else
		echo "libpng12_x86_64 is available"
	fi
	
	# check libXext_x86_64
	
	cd /usr/lib64
	libXext_x86_64=libXext.so.6

	if [ ! -f $libXext_x86_64 ]
	then
		echo "There is no libXext_x86_64 needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH
		echo "Installing libXext_x86_64..."
		rpm -ivh libXext-1.3.2-2.1.el6.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libXext_x86_64 is available"
	fi
	
	# check libXi_x86_64
	# libXext_x86_64被libXi_X86_64依赖，故libXi_X86_64必须要在libXext_x86_64之后安装
	cd /usr/lib64
	libXi_x86_64=libXi.so.6

	if [ ! -f $libXi_x86_64 ]
	then
		echo "There is no libXi_x86_64 needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH
		echo "Installing libXext_x86_64..."
		rpm -ivh libXi-1.7.2-2.2.el6.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libXi_x86_64 is available"
	fi
	
	
	# check libXtst_x86_64
	cd /usr/lib64
	libXtst_x86_64=libXtst.so.6

	if [ ! -f $libXtst_x86_64 ]
	then
		echo "There is no libXtst_x86_64 needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH
		echo "Installing libXtst_x86_64..."
		rpm -ivh libXtst-1.2.2-2.1.el6.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libXtst_x86_64 is available"
	fi
	
	# check libXrender_x86_64
	cd /usr/lib64
	libXrender_x86_64=libXrender.so.1

	if [ ! -f $libXrender_x86_64 ]
	then
		echo "There is no libXrender_x86_64 needed by SuperMapiPortal8C in the OS,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH
		echo "Installing libXrender_x86_64..."
		rpm -ivh libXrender-0.9.8-2.1.el6.x86_64.rpm
		echo "Install finished."
		printf "\n"
	else
		echo "libXrender_x86_64 is available"
	fi
	
	echo "Check finished: other libs is available."
}

# Use to install OpenGL-32bit
OpenGL_install()
{
	echo "There is no freeglut-32bit needed by SuperMapiPortal8C in the OS,and will install it automatically."
	echo "Installing freeglut-32bit..."
	cd $OPENGL_PATH
	rpm -ivh libdrm-32bit-2.4.21-1.2.x86_64.rpm
	rpm -ivh Mesa-32bit-7.8.2-1.3.x86_64.rpm
	rpm -ivh freeglut-32bit-090301-8.1.x86_64.rpm
	cd $INSTALL_PATH
	echo "Install finished."	
}

# Use to check that is libGL.so(32bit) libGLU.so(32bit) in the OS.
OpenGL_check()
{
	echo "Checking freeglut-32bit..."
	cd /usr/lib
	# libGL=libGL.so
	libGLU=libGLU.so.1
	if [ -f $libGLU ]
	then
		echo "Check finished: freeglut-32bit is available."
		cd $INSTALL_PATH
		return 0	
	else
		echo "Check finished: there is no freeglut-32bit in the OS."
		cd $INSTALL_PATH
		return 1
	fi
}

# Use to install X11-32bit
X11_install()
{
	echo "There is no X11-32bit needed by SuperMapiPortal8C in the OS."
	echo "Installing X11-32bit..."
	cd $X11_PATH
	# install libX11
	rpm -ivh xorg-x11-libXau-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libxcb-32bit-7.5-3.1.x86_64.rpm	
	rpm -ivh xorg-x11-libX11-32bit-7.5-1.23.x86_64.rpm

	# install libXext
	rpm -ivh xorg-x11-libXext-32bit-7.5-1.10.x86_64.rpm

# install xorg-x11-libs-32bit-7.5-3.15.x86_64.rpm
	# install xorg-x11-libXfixes-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libXfixes-32bit-7.5-1.9.x86_64.rpm

	# install xorg-x11-libXmu-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh libuuid1-32bit-2.17.2-5.3.x86_64.rpm
	rpm -ivh xorg-x11-libICE-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libSM-32bit-7.5-1.11.x86_64.rpm
	rpm -ivh xorg-x11-libXt-32bit-7.5-1.10.x86_64.rpm
	rpm -ivh xorg-x11-libXmu-32bit-7.5-1.9.x86_64.rpm

	# install xorg-x11-libXp-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libXp-32bit-7.5-1.9.x86_64.rpm	

	# install xorg-x11-libXpm-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libXpm-32bit-7.5-1.9.x86_64.rpm

	# install xorg-x11-libXprintUtil-32bit-7.5-1.10.x86_64.rpm
	rpm -ivh xorg-x11-libXprintUtil-32bit-7.5-1.10.x86_64.rpm

	# install xorg-x11-libXrender-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libXrender-32bit-7.5-1.9.x86_64.rpm
	
	# install fontconfig-32bit-2.8.0-7.1.x86_64.rpm
	rpm -ivh zlib-32bit-1.2.3-141.1.x86_64.rpm
	rpm -ivh libfreetype6-32bit-2.3.12-6.3.x86_64.rpm
	rpm -ivh libexpat1-32bit-2.0.1-98.1.x86_64.rpm
	rpm -ivh fontconfig-32bit-2.8.0-7.1.x86_64.rpm

	# install xorg-x11-libfontenc-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libfontenc-32bit-7.5-1.9.x86_64.rpm

	# install xorg-x11-libxkbfile-32bit-7.5-1.9.x86_64.rpm
	rpm -ivh xorg-x11-libxkbfile-32bit-7.5-1.9.x86_64.rpm

	rpm -ivh xorg-x11-libs-32bit-7.5-3.15.x86_64.rpm
# finish xorg-x11-libs-32bit-7.5-3.15.x86_64.rpm
	cd $INSTALL_PATH
	echo "Install finished."
}

# Use to check is X11-32bit in the OS. 
X11_check()
{
	echo "Checking X11-32bit in the OS..."
	cd /usr/lib
	libX11=libX11.so.6
	if [ -f $libX11 ] 
	then
		cd $INSTALL_PATH
		echo "Check finished: X11-32bit is available."
		return 0
	else 
		cd $INSTALL_PATH
		echo "Check finished: there is no X11-32bit in the OS."
		return 1
	fi
}

# Install ld-linux.so(glibc-32bit)
ld_linux_install()
{
	echo "There is no glibc-32bit needed by SuperMapiPortal8C in the OS."
	echo "Installing glibc-32bit..."
	cd $GLIBC_PATH
	rpm -ivh glibc-32bit-2.11.2-2.4.x86_64.rpm
	rpm -ivh glibc-locale-32bit-2.11.2-2.4.x86_64.rpm
	rpm -ivh libgcc45-32bit-4.5.0_20100604-1.12.x86_64.rpm
	rpm -ivh libstdc++45-32bit-4.5.0_20100604-1.12.x86_64.rpm
	echo "Install finished."
	cd $INSTALL_PATH
}

# Use to check that is ld-linux.so.2(32bit) in the OS.
# glibc
ld_linux_check()
{
	echo "Checking glibc-32bit in the OS..."
	cd /lib
	ld_linux=ld-linux.so*
	if [ -f $ld_linux ] 
	then
		cd $INSTALL_PATH
		echo "Check finished: glibc-32bit is available."
		return 0
	else 
		cd $INSTALL_PATH
		echo "Check finished: there is no glibc-32bit in the OS."
		return 1
	fi
}

rpm_check_and_install_64bit()
{
	ld_linux_check
	if [ $? -eq 1 ]
	then
		ld_linux_install
	fi
	X11_check
	if [ $? -eq 1 ]
	then
		X11_install	
	fi
	OpenGL_check	
	if [ $? -eq 1 ]
	then
		OpenGL_install
	fi	

	Others_check_and_install
	printf "\n"
	echo "Check finished."
}

rpm_check_suse_64bit()
{
	echo "The OS is openSUSE-64bit."
	rpm_check_and_install_64bit
}

dpkg_check_ubuntu_64bit()
{
	echo "The OS is Ubuntu 64bit"
	echo "Now checking the prerequisite debs..."
	
	#install libc6-i386
	#libc6-i386 is needed by aksusbd-i386 which is used for license check 
	
	is_libc6_i386_exists=`dpkg -l | grep libc6-i386 | grep -c 'libc6-i386'`
	if [ $is_libc6_i386_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libc6_i386 is available"
	else
		echo "There is no libc6_i386 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $LIBC6_I386_FOR_UBUNTU
		echo "Installing libc6_i386 now ..."
		#libc6-i386 need libc6:amd64 ,whose version may not be consistent libc6-i386_2.15,so need  force-depends-version option
		sudo dpkg --force-depends-version -i libc6-i386_2.15-0ubuntu10.13_amd64.deb
		echo "Install finished."
		printf "\n"
		
	fi
	
	#install libxdmcp6
	#libxdmcp6 is needed by libxau6 and libxcb1 
	
	is_libxdmcp6_exists=`dpkg -l | grep libxdmcp6 | grep -c 'libxdmcp6'`
	if [ $is_libxdmcp6_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libxdmcp6 is available"
	else
		echo "There is no libxdmcp6 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libxdmcp6 now ..."
		sudo dpkg --force-depends-version -i libxdmcp6_1.1.0-4_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
	
	#install libxau6
	#libxau6 is needed by libxcb1
	
	is_libxau6_exists=`dpkg -l | grep libxau6 | grep -c 'libxau6'`
	if [ $is_libxau6_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libxau6 is available"
	else
		echo "There is no libxau6 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libxau6 now ..."
		sudo dpkg --force-depends-version -i libxau6_1.0.6-4_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
	
	#install libxcb1
	#libxcb1 is needed by libx11-6
	
	is_libxcb1_exists=`dpkg -l | grep libxcb1 | grep -c 'libxcb1'`
	if [ $is_libxcb1_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libxcb1 is available"
	else
		echo "There is no libxcb1 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libxcb1 now ..."
		sudo dpkg --force-depends-version -i libxcb1_1.8.1-1ubuntu0.2_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
	
	
	#install libx11-data
	#libx11-data is needed by libx11-6
	
	is_libx11_data_exists=`dpkg -l | grep libx11-data | grep -c 'libx11-data'`
	if [ $is_libx11_data_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libx11-data is available"
	else
		echo "There is no libx11-data in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libx11-data now ..."
		sudo dpkg --force-depends-version -i libx11-data_1.4.99.1-0ubuntu2.3_all.deb
		echo "Install finished."
		printf "\n"
	fi
	
	#install libx11-6
	#libx11-6 is needed by libxi6
	
	is_libx11_6_exists=`dpkg -l | grep libx11-6 | grep -c 'libx11-6'`
	if [ $is_libx11_6_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libx11-6 is available"
	else
		echo "There is no libx11-6 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libx11-6 now ..."
		sudo dpkg --force-depends-version -i libx11-6_1.4.99.1-0ubuntu2.3_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
	
	#install libxext6
	#libxext6 is needed by libxi6
	
	is_libxext6_exists=`dpkg -l | grep libxext6 | grep -c 'libxext6'`
	if [ $is_libxext6_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libxext6 is available"
	else
		echo "There is no libxext6 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libxext6 now ..."
		sudo dpkg --force-depends-version -i libxext6_1.3.0-3ubuntu0.2_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
	
	
	#install libxi6
	#libxi6 is needed by libWrapj which is the engine of iServer8C
	
	is_libxi6_exists=`dpkg -l | grep libxi6 | grep -c 'libxi6'`
	if [ $is_libxi6_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libxi6 is available"
	else
		echo "There is no libxi6 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libxi6 now ..."
		sudo dpkg --force-depends-version -i libxi6_1.7.1.901-1ubuntu1-precise3_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
	
	
	#install gcc-5-base
	#gcc-5-base is needed by libgomp1
	
	is_gcc_5_base_exists=`dpkg -l | grep gcc-5-base | grep -c 'gcc-5-base'`
	if [ $is_gcc_5_base_exists -gt 0 ]; then
		# use for iServer license check 
		echo "gcc-5-base is available"
	else
		echo "There is no gcc-5-base in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing gcc-5-base now ..."
		sudo dpkg --force-depends-version -i gcc-5-base_5.2.1-22ubuntu2_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
	
	#install libgomp1
	#libgomp1 is needed by libWrapj which is the engine of iServer8C
	
	is_libgomp1_exists=`dpkg -l | grep libgomp1 | grep -c 'libgomp1'`
	if [ $is_libgomp1_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libgomp1 is available"
	else
		echo "There is no libgomp1 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libgomp1 now ..."
		sudo dpkg --force-depends-version -i libgomp1_5.2.1-22ubuntu2_amd64.deb 
		echo "Install finished."
		printf "\n"
	fi

	#install x11-common
	#x11-common is needed by libxtst6 and libxrender1
	
	is_x11_common_exists=`dpkg -l | grep x11-common | grep -c 'x11-common'`
	if [ $is_x11_common_exists -gt 0 ]; then
		# use for iServer license check 
		echo "x11-common is available"
	else
		echo "There is no x11-common in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing x11-common now ..."
		sudo dpkg --force-depends-version -i x11-common_7.7+7ubuntu4_all.deb
		echo "Install finished."
		printf "\n"
	fi
	
	
	#install libxtst6
	#libxtst6 is needed by libWrapj which is the engine of iServer8C
	
	is_libxtst6_exists=`dpkg -l | grep libxtst6 | grep -c 'libxtst6'`
	if [ $is_libxtst6_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libxtst6 is available"
	else
		echo "There is no libxtst6 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libxtst6 now ..."
		sudo dpkg --force-depends-version -i libxtst6_1.2.2-1_amd64.deb 
		echo "Install finished."
		printf "\n"
	fi
	
	
	#install libxrender1
	#libxrender1 is needed by libmawt of xawt in jre
	
	is_libxrender1_exists=`dpkg -l | grep libxrender1 | grep -c 'libxrender1'`
	if [ $is_libxrender1_exists -gt 0 ]; then
		# use for iServer license check 
		echo "libxrender1 is available"
	else
		echo "There is no libxrender1 in the OS ,which is needed by SuperMapiPortal8C ,and will install it automatically."
		cd $UGO_THIRD_LIB_PATH_FOR_UBUNTU
		echo "Installing libxrender1 now ..."
		sudo dpkg --force-depends-version -i libxrender1_0.9.6-2ubuntu0.2_amd64.deb
		echo "Install finished."
		printf "\n"
	fi
}

rpm_check_suse_32bit()
{
	echo "The OS is openSUSE-32bit."
	echo "Now checking the prerequisite RPMs..."
	printf "\n"
	rpm_check_and_install_64bit
}

rpm_check_redhat_64bit()
{
	echo "The OS is Red Hat-64bit"
	rpm_check_and_install_64bit
}

rpm_check_redhat_32bit()
{
	echo "The OS is Red Hat-32bit."
	echo "Now checking the prerequisite RPMs..."
	printf "\n"
	rpm_check_and_install_64bit
}

deb_download_info()
{
	count=`dpkg -l | grep -c '$1'`
	if [ $count -gt 0 ]
	then
		echo $1" is available."
		printf "\n"
		return 0 
	else
		echo "Make sure "$1" in the OS."
		echo "You can get the deb from the CD or Internet(eg. http://packages.ubuntu.com/search)"
		printf "\n"
		return 1 
	fi
}

rpm_download_info()
{
	
	count=`rpm -qa | grep -c '$1'`
	if [ $count -gt 0 ]
	then
		echo $1" is available."
		printf "\n"
		return 0 
	else
		echo "Make sure "$1" in the OS."
		echo "You can get the rpm from the CD or Internet(eg. http://rpmfind.net/linux/rpm2html)"
		printf "\n"
		return 1 
	fi
}

deb_download()
{
	echo "Warn: the debs built in the iPortal8C is not suitable for the current operating system ,Because the version are not compatible"
	printf "\n"
	echo "Info: please download the debs from CD or Internet(eg. http://packages.ubuntu.com/search),and install them manually"
	printf "\n"
	
	deb_download_info "libc6-i386"
	deb_download_info "gcc-5-base"
	deb_download_info "libgomp1"
	deb_download_info "libxi6"
	deb_download_info "x11-common"
	deb_download_info "libxtst6"
	deb_download_info "libxrender1"
	
}

rpm_download()
{
	echo "Warn: the RPMs built in the iPortal8C is not suitable for the current operating system ,Because the version are not compatible"
	printf "\n"
	echo "Info: please download the RPMs from the web site http://rpmfind.net/linux/rpm2html ,and install them manually"
	printf "\n"
	echo "1. need glibc-32bit"
	rpm_download_info "glibc-32bit"
	rpm_download_info "glibc-local-32bit"
	rpm_download_info "libgcc45-32bit"
	rpm_download_info "libstdc++45-32bit"

	echo "2.need X11"
	rpm_download_info "fontconfig-32bit"
	rpm_download_info "libexpat1-32bit"
	rpm_download_info "libfreetype6-32bit"
	rpm_download_info "libuuid1-32bit"
	rpm_download_info "xorg-x11-libfontenc-32bit"
	rpm_download_info "xorg-x11-libICE-32bit"
	rpm_download_info "xorg-x11-libs-32bit"
	rpm_download_info "xorg-x11-libSM-32bit"
	rpm_download_info "xorg-x11-libX11-32bit"
	rpm_download_info "xorg-x11-libXau-32bit"
	rpm_download_info "xorg-x11-libxcb-32bit"
	rpm_download_info "xorg-x11-libXext-32bit"
	rpm_download_info "xorg-x11-libXfixes-32bit"
	rpm_download_info "xorg-x11-libxkbfile-32bit"
	rpm_download_info "xorg-x11-libXmu-32bit"
	rpm_download_info "xorg-x11-libXp-32bit"
	rpm_download_info "xorg-x11-libXpm-32bit"
	rpm_download_info "xorg-x11-libXprintUtil-32bit"
	rpm_download_info "xorg-x11-libXrender-32bit"
	rpm_download_info "xorg-x11-libXt-32bit"
	rpm_download_info "zlib-32bit"

	echo "3.need freeglut"
	rpm_download_info "libdrm-32bit"
	rpm_download_info "Mesa-32bit"
	rpm_download_info "freeglut-32bit"

	echo "4.need others rpms as bellow"
	
	rpm_download_info "cyrus-sasl-32bit"
	rpm_download_info "keyutils-libs-32bit"
	rpm_download_info "krb5-32bit"
	rpm_download_info "libcom_err2-32bit"
	rpm_download_info "libdb-4_5-32bit"
	rpm_download_info "libidn-32bit"
	rpm_download_info "libXi6-32bit"

	rpm_download_info "libpng12.so.0"
	rpm_download_info "libjpeg.so.62"
}


get_redhat_version_by_issue()
{
	
	#一般情况下，应该返回类似信息：CentOS release 6.5 (Final)
	cat_issue_msg=`cat /etc/issue`
	is_redhat_num_exists=`echo $cat_issue_msg | grep -c 'release '` 
	if [ ${is_redhat_num_exists} == 0 ];then
		os_version=0
		return 0
	else
		os_version=`echo $cat_issue_msg | sed 's/^.*release[[:space:]]//g'`
		os_version=`echo $os_version | sed 's/[[:space:]].*$//g'`
		return 0
		
	fi
}

get_suse_version_by_issue()
{
	#一般情况下，应该返回类似信息：Welcome to openSUSE 13.1 "Bottle" - Kernel 
	cat_issue_msg=`cat /etc/issue`
	is_suse_num_exists=`echo $cat_issue_msg | grep -c 'SUSE '` 
	if [ $is_suse_num_exists == 0 ]; then
		os_version=`echo $cat_issue_msg | sed 's/^.*SUSE[[:space:]]//g'`
		os_version=`echo $os_version | sed 's/[[:space:]].*$//g'`
		return $os_version
	else
		return $os_version_not_found
	fi

}

get_ubuntu_version_by_issue()
{
	#一般情况下，应该返回类似信息：Ubuntu 14.04.4 LTS \n \l
	cat_issue_msg=`cat /etc/issue`
	is_suse_num_exists=`echo $cat_issue_msg | grep -c 'Ubuntu '` 
	if [ $is_suse_num_exists -eq 0 ]; then
		os_version=`echo $cat_issue_msg | sed 's/^.*Ubuntu[[:space:]]//g'`
		os_version=`echo $os_version | sed 's/[[:space:]].*$//g'`
		return $os_version
	else
		return $os_version_not_found
	fi

}

# Get the OS version by cat /etc/issue 
get_os_version_by_issue()
{	
	if [ $is_redhat -gt 0 ]; then
		echo "Debug: Get redhat version by issue"
		get_redhat_version_by_issue
		return 0
	elif [ $is_suse -gt 0 ]; then
		echo "Debug: Get suse version by issue"
		get_suse_version_by_issue
		return 0
	else
		echo "Debug: Get ubuntu version by issue"
		get_ubuntu_version_by_issue
		return 0
	fi

}

# Check whether there is a lsb_release command
lsb_release_command_exist(){
	which lsb_release > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		# lsb_release exist 
		return 0
	else
		return 1
	fi
}


# Check whether there is a bc command
bc_command_exist(){
	which bc > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		# bc exist 
		return 0
	else
		return 1
	fi
}

get_os_version()
{
	
	#优先用lsb_release命令获取发行版本信息，但是某些干净的系统中可能没有安装该命令,所以先判断下
	lsb_release_command_exist
	if [ $? -eq 0 ]; then
		# lsb_release exist 
		os_version=`lsb_release -r | sed 's/Release:[[:space:]]//g'`
		return 0
	else
		get_os_version_by_issue
		return 0
	fi
}

#Check whether the OS main version number and small version number meet the requirements
check_os_version_main_sub_versions()
{
	main_version_temp=$1
	sub_version_temp=$2
	lowest_main_version_temp=$3
	lowest_sub_version_temp=$4
	if [ $main_version_temp -gt $lowest_main_version_temp ]
	then
		return 0
	elif [ $main_version_temp -eq $lowest_main_version_temp ]
	then
		if [ $sub_version_temp -ge $lowest_sub_version_temp ]
		then
			return 0
		else 
			# sub_version < $lowest_ubuntu_sub_version
			return 1
		fi
	#$main_version < $lowest_ubuntu_main_version
	else
		return 1
	fi
	
	
}

# Check whether the current version of the operating system can meet the requirements of the script
check_os_version()
{
	get_os_version
	echo "Debug: os_version is $os_version"
	printf "\n"
	bc_command_exist
	if [ $? -eq 0 ];then
		#command bc exist
		is_bc_command_exist=0
	else
		is_bc_command_exist=1
	fi
	
	needConfirmManually=1
	
	#When get os version returns 0 or bc command does not exist .
	#In this case ,The user is needed to check manually wheather the version of the operating system meet the requirements of the script
	
	if [ "$os_version" == "0" ]||[ $is_bc_command_exist -eq 1 ]; then
		needConfirmManually=0
	fi
	
	if [ $needConfirmManually -eq 0 ]; then
		# failed to get os_version ,The user manual to confirm
		confirm_msg=""
		if [ $is_redhat -gt 0 ];then
			confirm_msg="Please make sure the Redhat version is 5.5 or higher"
		else
			#may be suse or ubuntu 
			if [ $is_suse -gt 0 ];then
				confirm_msg="Please make sure the SUSE version is 10.3 or higher"
			else
				confirm_msg="Please make sure the Ubuntu version is 14.04 or higher"
			fi
		fi
		
		yesornot_conside_alawys_yes "$confirm_msg"
		install_go_on=$?
		if [ $install_go_on -eq 1 ];then
			# cancel the installation
			return 1
		else
			# Platform version meet the requirements Through the way of manual confirmation
			return 0
		fi
	fi
	
	main_version=`echo $os_version |  sed 's/\.[0-9]*//g'`
	sub_version=`echo $os_version |  sed 's/[0-9]*\.//g'`
	# string to num 
	main_version=`echo "$main_version" | bc`
	sub_version=`echo "$sub_version" | bc`
	
	#now to check the os_version 
	lowest_suse_main_version=10
	lowest_suse_sub_version=3
	
	lowest_redhat_main_version=5
	lowest_redhat_sub_version=5
	
	lowest_ubuntu_main_version=14
	lowest_ubuntu_sub_version=4
	
	
	if [ $is_suse -gt 0 ]; then
		check_os_version_main_sub_versions $main_version $sub_version $lowest_suse_main_version $lowest_suse_sub_version
		if [ $? -eq 0 ];then
		return 0
		fi
	fi
	
	if [ $is_redhat -gt 0 ]; then
		check_os_version_main_sub_versions $main_version $sub_version $lowest_redhat_main_version $lowest_redhat_sub_version
		if [ $? -eq 0 ];then
		return 0
		fi
	fi
	
	if [ $is_ubuntu -gt 0 ]; then
		check_os_version_main_sub_versions $main_version $sub_version $lowest_ubuntu_main_version $lowest_ubuntu_sub_version
		if [ $? -eq 0 ];then
		return 0
		fi
	fi
	
	return 1
}

main_install()
{
	printf "\n"
	echo "SuperMapiPortal8C Installation Instructions."
	printf "\n"
	echo "Info: This script is only suitable for Redhat、CentOS、Suse and Ubuntu platforms "
	printf "\n"
	
	check_os_version
	if [ $? -eq 1 ]
	then
		if [ $is_ubuntu -gt 0 ]; then
			deb_download 
		else
			rpm_download
		fi
		return 
	fi

	if [ $is_bit64 -eq 0 ]
	then
		echo "Warn: SuperMapiPortal8C only supports x86_64 Linux operating systems "
		return 1
	fi
	
	if [ $is_suse -gt 0 ]
	then
		# check_64bit
		# bit_result=$?
		
		if [ $bit_result -eq 64 ]
		then
			rpm_check_suse_64bit
		else
			rpm_check_suse_32bit
		fi
	elif [ $is_redhat -gt 0 ]
	then
		if [ $bit_result -eq 64 ]
		then
			rpm_check_redhat_64bit
		else
			rpm_check_redhat_32bit
		fi
	else
		dpkg_check_ubuntu_64bit
	fi
}

if [ $is_bit64 -eq 0 ]
then
	echo "The script is for 64bit."
	exit 0
fi
case "$1" in
	install)
		# discard fisrt argument
		shift
		judge_always_yes_and_platform $@
		main_install 
		exit 0
		;;
	uninst)
		# discard fisrt argument
		shift
		judge_always_yes_and_platform $@
		main_uninstall 
		exit 1 
		;;
	*)
		echo "dependencies_check_and_install version $SCRIPT_VERSION"
		echo "Copyright (C) 2000-2017 - SuperMap, Inc."
		echo "This program may be freely redistributed under the terms of the GNU GPL"
		printf "\n"
		echo "Usage: dependencies_check_and_install [command] [options]"
		printf "\n"
		
		echo "Commands:"
		echo "install      Install the dependent libraries"
		echo "uninst       Uninstall the dependent libraries:"
		printf "\n"
		
		echo "Options:"
		echo "-y      Don't remind, select yes always"
		echo "-r      Don't  detect running environment automatically, but specific the environment as Redhat platform"
		echo "-s      Don't  detect running environment automatically, but specific the environment as Suse platform"
		echo "-u      Don't  detect running environment automatically, but specific the environment as Ubuntu platform"

		exit 2 
		;;
esac
