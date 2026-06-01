: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cif_cifs_aid_addr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cif_cifs_aid_addr_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
addrsr
,custno
,addrtp
,addrcn
,addren
,addrst
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
,mailcd
from ${idl_schema}.crms_cif_cifs_aid_addr
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cif_cifs_aid_addr_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes