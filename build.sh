#!/bin/bash

cwd=`pwd`
cd public/system/products/photos/000/000
rm -rf *

for((i = 1;i<=20; i++))
do
	if [ ${i} -lt 10 ]; then
		mkdir 00${i}
		mkdir 00${i}/original
		mkdir 00${i}/small
		mkdir 00${i}/large
		cp ${cwd}/product.png 00${i}/original/
		cp ${cwd}/product_small.png 00${i}/small/product.png
		cp ${cwd}/product_large.png 00${i}/large/product.png
	else
		mkdir 0${i}
		mkdir 0${i}/original
		mkdir 0${i}/small
		mkdir 0${i}/large
		cp ${cwd}/product.png 0${i}/original/
		cp ${cwd}/product_small.png 0${i}/small/product.png
		cp ${cwd}/product_large.png 0${i}/large/product.png
	fi
done

cd ${cwd}

rake db:reset
rake db:populate
rake db:test:prepare
