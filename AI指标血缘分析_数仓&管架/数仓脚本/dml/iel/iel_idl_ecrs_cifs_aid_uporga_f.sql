: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_cifs_aid_uporga_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_cifs_aid_uporga_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
upogno
,custno
,upogcn
,regitp
,regino
,orgacd
,credno
,inbddt
,inbdus
,lsmtdt
,lsmtus
,prfd01
,prfd02
,prfd03
from idl.ecrs_cifs_aid_uporga
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_cifs_aid_uporga_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes