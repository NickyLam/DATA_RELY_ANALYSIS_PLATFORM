: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_tel_cntr_detl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_tel_cntr_detl_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cntrno
,sortno
,rvactp
,rvacno
,rvacna
,rvbkno
,rvbkna
,teleno
from ${idl_schema}.crms_cbs_tel_cntr_detl
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_tel_cntr_detl_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes