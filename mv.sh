#!/bin/bash

# 处理空格换行问题
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

#function readFile() {
#    for file in $(ls)
#
#    do
#        if test -d ${file}
#        then
#            cd ${file}
#            readFile ${file}
#            cd..
#        else
#            #  echo $file
#            newfile=`echo $file | sed 's/【瑞客论 坛 www.ruike1.com】//g'`
#            echo $newfile
#            mv $file $newfile
#        fi
#    done
#}

#function setDir() {
#    if test -d $1
#        then
#            echo $1
#            cd $1
#            readFile
#            cd ..
#        else
#            cd $(dirname $1)
#            local name=$(basename $1)
#            newfile=`echo $name | sed 's/【瑞客论 坛 www.ruike1.com】//g'`
#            echo '修改文件夹名称'
#            mv $name $newfile
#        fi
#}

#local param=$1
#if [ -z "$1" ]
#then
#    param="./"
#    echo "empty string: $param"
#else
#    param=$1
#fi
#if test -d $param
#then
#    setDir $param
#elif test -f $param
#then
#    setDir $param
#    exit 1
#else
#    echo "Neither folder nor file!!!"
#    exit 1
#fi

function scandir() {
    local cur_dir parent_dir workdir
    workdir=$1
    cd ${workdir}
    if [ ${workdir} = "/" ]
    then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi

    for dirlist in $(ls ${cur_dir})
    do
        if test -d ${dirlist}; then
            cd ${dirlist}
            scandir ${cur_dir}/${dirlist}
            cd ..
        else
            for file in $(ls)
            do
                newfile=`echo $file | sed 's/【瑞客论坛 www.ruike1.com】//g'`
                echo $newfile
                mv $file $newfile
            done
        fi
    done
}

if test -d $1
then
    scandir $1
elif test -f $1
then
    echo "you input a file but not a directory,pls reinput and try again"
    exit 1
else
    echo "the Directory isn't exist which you input,pls input a new one!!"
    exit 1
fi

IFS=$SAVEIFS
