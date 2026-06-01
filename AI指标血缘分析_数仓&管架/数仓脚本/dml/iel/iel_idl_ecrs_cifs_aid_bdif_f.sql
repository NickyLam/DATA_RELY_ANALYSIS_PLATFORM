: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_cifs_aid_bdif_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_cifs_aid_bdif_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
bdifsr
,custno
,adname
,certtp
,certno
,brthdt
,gender
,isbkus
,lcbkid
,mngrtp
,patmjb
,joindt
,joinyr
,workyr
,shsttg
,status
,remark
,inbddt
,inbdus
,lsmtdt
,lsmtus
,prfd01
,prfd02
,prfd03
,prfd04
,prfd05
from idl.ecrs_cifs_aid_bdif
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_cifs_aid_bdif_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes