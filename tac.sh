#!/bin/bash
FILES=$1/*
echo "LET'S GREP"
echo "========================================================"
echo "external domain script inclusion: <script src="
echo "========================================================"
for f in $FILES
do
    IFS=’/_’ read -ra SPLIT <<< "$f"
    domain=${SPLIT[2]}
    counter=$(echo $domain | tr -cd '.' | wc -c)
    if [ $counter -eq '1' ]
    then
      domaintop=$domain
    else
      domaintop=$(echo "$domain" | sed 's/^[^\.]*\.//')
    fi
    result1=`grep -a "<script src=\"http://" $f | grep -v "<script src=\"http://$domain" | grep -v "<script src=\"http://.*$domaintop/" | grep -vE "oss\.maxcdn\.com|apis\.google\.com\/js|html5shiv\.googlecode\.com\/svn|html5shim\.googlecode\.com\/svn|ajax\.googleapis\.com\/ajax|code\.jquery\.com\/jquery|maps\.googleapis\.com\/maps\/api\/|maps\.google\.com\/maps\/api|www\.google\.com\/recaptcha\/api\.js|use\.typekit\.net|cdnjs\.cloudflare\.com\/ajax|www\.google\-analytics\.com\/urchin\.js|vjs\.zencdn\.net\/c\/video\.js|www\.flickr\.com\/badge_code_v2\.gne|maps\.google\.com\/maps|maxcdn\.bootstrapcdn\.com|www\.clocklink\.com\/embed\.js|austria\.mid\.ru|static1\.squarespace\.com\/static\/|stats\.wordpress\.com\/e\-201707\.js|weatherandtime\.net\/swfobject\.js|assets\.publishing\.service\.gov\.uk|googlecode\.com\/svn"`
    result2=`grep -a "<script src=\"https://" $f | grep -v "<script src=\"https://$domain" | grep -v "<script src=\"https://.*$domaintop/" | grep -vE "oss\.maxcdn\.com|apis\.google\.com\/js|html5shiv\.googlecode\.com\/svn|html5shim\.googlecode\.com\/svn|ajax\.googleapis\.com\/ajax|code\.jquery\.com\/jquery|maps\.googleapis\.com\/maps\/api\/|maps\.google\.com\/maps\/api|www\.google\.com\/recaptcha\/api\.js|use\.typekit\.net|cdnjs\.cloudflare\.com\/ajax|www\.google\-analytics\.com\/urchin\.js|vjs\.zencdn\.net\/c\/video\.js|www\.flickr\.com\/badge_code_v2\.gne|maps\.google\.com\/maps|maxcdn\.bootstrapcdn\.com|www\.clocklink\.com\/embed\.js|austria\.mid\.ru|static1\.squarespace\.com\/static\/|stats\.wordpress\.com\/e\-201707\.js|weatherandtime\.net\/swfobject\.js|assets\.publishing\.service\.gov\.uk|googlecode\.com\/svn"`
    [ ! -z "$result1" ] && echo -e "HTTP Hit(s) on $domain :\n$result1\n__________________________________"
    [ ! -z "$result2" ] && echo -e "HTTPS Hit(s) on $domain :\n$result2\n__________________________________"
done
echo "========================================================"
echo "hidden iframe"
echo "========================================================"
for f in $FILES
do
    IFS=’/_’ read -ra SPLIT <<< "$f"
    domain=${SPLIT[2]}
    result=`grep -oE "<iframe.*(display: none|visibility: hidden)" $f`
    [ ! -z "$result" ] && echo -e "Hit(s) on $domain :\n$result\n__________________________________"
done
echo "========================================================"
echo "clickfraud JS injection"
echo "========================================================"
for f in $FILES
do
    IFS=’/_’ read -ra SPLIT <<< "$f"
    domain=${SPLIT[2]}
    result=`grep -E "window.a[0-9]{10}|this.a[0-9]{10}" $f`
    [ ! -z "$result" ] && echo -e "Hit(s) on $domain :\n$result\n__________________________________"
done
echo "========================================================"
echo "Joomla qadars injection"
echo "https://malwarebreakdown.com/2017/02/12/thousands-of-compromised-websites-leading-to-fake-flash-player-update-sites-payload-is-qadars-banking-trojan/"
echo "========================================================"
for f in $FILES
do
    IFS=’/_’ read -ra SPLIT <<< "$f"
    domain=${SPLIT[2]}
    result=`grep -E "<script language=JavaScript src=/media/system/js/stat[0-9]{3}\.php" $f`
    [ ! -z "$result" ] && echo -e "Hit(s) on $domain :\n$result\n__________________________________"
done
echo "========================================================"
echo "strange external domain script inclusion attempt: \$('script\[src="
echo "========================================================"
for f in $FILES
do
    IFS=’/_’ read -ra SPLIT <<< "$f"
    domain=${SPLIT[2]}
    result=`grep "('script\[src=" $f`
    [ ! -z "$result" ] && echo -e "Hit(s) on $domain :\n$result\n__________________________________"
done
echo "========================================================"
echo "CLICKY"
echo "========================================================"
for f in $FILES
do
    IFS=’/_’ read -ra SPLIT <<< "$f"
    domain=${SPLIT[2]}
    result=`grep -B 1 -A 9 "clicky_site_ids.push" $f`
    [ ! -z "$result" ] && echo -e "Hit(s) on $domain :\n$result\n__________________________________"
done
echo "========================================================"
echo "shortener URLs"
echo "========================================================"
for f in $FILES
do
    IFS=’/_’ read -ra SPLIT <<< "$f"
    domain=${SPLIT[2]}
    result=`grep -oE ".{7}bit\.ly\/.{7}|http.{0,1}:\/\/goo\.gl\/.{6}|.{7}bitly\.com\/.{7}" $f | grep -v "http://goo.gl/maps/"`
    [ ! -z "$result" ] && echo -e "Hit(s) on $domain :\n$result\n__________________________________"
done
