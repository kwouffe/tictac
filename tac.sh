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
    result1=`grep "<script src=\"http://" $f | grep -v "<script src=\"http://$domain" | grep -v "oss.maxcdn.org|apis.google.com/|ajax.googleapis.com|html5shiv.googlecode.com|html5shim.googlecode.com|www.google-analytics.com/urchin.js|maps.googleapis.com|maps.google.com/maps|vjs.zencdn.net"`
    result2=`grep "<script src=\"https://" $f | grep -v "<script src=\"https://$domain" | grep -v "oss.maxcdn.org|apis.google.com/|ajax.googleapis.com|html5shiv.googlecode.com|html5shim.googlecode.com|www.google-analytics.com/urchin.js|maps.googleapis.com|maps.google.com/maps|vjs.zencdn.net"`
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
    result=`grep -E "bit\.ly|goo\.gl|bitly\.com" $f`
    [ ! -z "$result" ] && echo -e "Hit(s) on $domain :\n$result\n__________________________________"
done
