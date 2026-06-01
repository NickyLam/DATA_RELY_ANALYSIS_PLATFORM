: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_cbss_kcs_bkol_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_cbss_kcs_bkol.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}', 'yyyymmdd') as etl_dt
,replace(replace(t1.olacct,chr(13),''),chr(10),'') as olacct
,t1.onlnbl as onlnbl
,replace(replace(t1.indate,chr(13),''),chr(10),'') as indate
,replace(replace(t1.dldate,chr(13),''),chr(10),'') as dldate
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.intrsq,chr(13),''),chr(10),'') as intrsq
from ${iol_schema}.cbss_kcs_bkol t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_cbss_kcs_bkol.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes