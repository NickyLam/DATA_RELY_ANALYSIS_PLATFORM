: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_total_number_shares_pledged_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_total_number_shares_pledged.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.sec_id,chr(13),''),chr(10),'') as sec_id
,announcement_date
,ed
,replace(replace(t1.holder_name,chr(13),''),chr(10),'') as holder_name
,replace(replace(t1.holder_id,chr(13),''),chr(10),'') as holder_id
,pledge_total_num
,share_held_num
,isvalid

from ${iol_schema}.uxds_total_number_shares_pledged t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_total_number_shares_pledged.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
