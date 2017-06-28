#!/usr/bin/env bash

exec_array=()
exec_count=0
for so_file in $1/build/intermediates/cmake/debug/obj/armeabi/*.so; do
    if test -f $so_file; then
        echo "adb push $so_file /data/local/tmp"
        adb push $so_file /data/local/tmp
        if [[ "$so_file" =~ "unittest" ]]; then
            exec_array[exec_count++]="/data/local/tmp/${so_file##*/}"
            echo "adb shell chmod 775 /data/local/tmp/${so_file##*/}"
            adb shell chmod 775 /data/local/tmp/${so_file##*/}
        fi
    fi
done

for exec_file in $exec_array; do
    echo "start unittest: $exec_file"
    adb shell "LD_LIBRARY_PATH=/data/local/tmp $exec_file"
done
