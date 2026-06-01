: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_crbckm_f
CreateDate: 20250613
FileName:   ${iel_data_path}/isbs_crbckm.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.merchantid,chr(13),''),chr(10),'') as merchantid
,replace(replace(t1.extkey,chr(13),''),chr(10),'') as extkey
,replace(replace(t1.sellerid,chr(13),''),chr(10),'') as sellerid

from ${iol_schema}.isbs_crbckm t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_crbckm.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
