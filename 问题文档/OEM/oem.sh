#!/bin/bash

usage() {
  echo "$0 brand product company
brand:   Chinese
product: English or Pinyin
company: Chinese
"
  exit
}

if [ $# -ne 3 ]; then
  usage
fi

brand_src='希云'
product_src='cSphere'
company_src='云栈科技（北京）有限公司'

brand_src_unicode='\&#x5E0C;\&#x4E91;'
company_src_unicode='\&#x4E91;\&#x6808;\&#x79D1;\&#x6280;\&#xFF08;\&#x5317;\&#x4EAC;\&#xFF09;\&#x6709;\&#x9650;\&#x516C;\&#x53F8;'

brand_dst=$1
product_dst=$2
company_dst=$3

tr2unicode() {
  echo -n "$1"|iconv -t unicode|
  hexdump |sed -e 's/feff //' -e 's/00000..//' |
  tr -d '\n' |tr 'a-z' 'A-Z'|tr -s ' '|sed 's/ $//'|
  sed 's/ /;\\\&#x/g' |sed -e 's/^;//' -e 's/$/;/'
}

brand_dst_unicode=$(tr2unicode "$brand_dst")
company_dst_unicode=$(tr2unicode "$company_dst")

for i in $(find frontend -type f); do
  echo $i
  sed -i -e "s/${brand_src}/${brand_dst}/g" \
  -e "s/${product_src}/${product_dst}/g" \
  -e "s/${company_src}/${company_dst}/g" \
  -e "s/${brand_src_unicode}/${brand_dst_unicode}/g" \
  -e "s/${company_src_unicode}/${company_dst_unicode}/g" $i
done
