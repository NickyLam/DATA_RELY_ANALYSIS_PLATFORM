: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cabs_utblbrcd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/utblbrcd.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(rtrim(brchno),chr(13),''),chr(10),'')  as brchno
,replace(replace(rtrim(brchna),chr(13),''),chr(10),'')  as brchna
,replace(replace(rtrim(brchlv),chr(13),''),chr(10),'')  as brchlv
,replace(replace(rtrim(nodebr),chr(13),''),chr(10),'')  as nodebr
,replace(replace(rtrim(centtg),chr(13),''),chr(10),'')  as centtg
 from idl.cabs_utblbrcd where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/utblbrcd.txt" \
        charset=zhs16gbk
        safe=yes
