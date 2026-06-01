: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_shareholder_list_f
CreateDate: 20251216
FileName:   ${iel_data_path}/uxds_shareholder_list.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,held_num
,held_num_res_share
,held_num_unlim_share
,held_ratio
,replace(replace(t1.holder_ctgry,chr(13),''),chr(10),'') as holder_ctgry
,replace(replace(t1.holder_id,chr(13),''),chr(10),'') as holder_id
,replace(replace(t1.holder_name,chr(13),''),chr(10),'') as holder_name
,holder_rank
,replace(replace(t1.holder_type_code,chr(13),''),chr(10),'') as holder_type_code
,is_holder_org
,pledge_num
,publish_date
,replace(replace(t1.share_ctgry,chr(13),''),chr(10),'') as share_ctgry
,share_pledge_frozen_num
,replace(replace(t1.share_type_code,chr(13),''),chr(10),'') as share_type_code
,replace(replace(t1.acting_concert_sign,chr(13),''),chr(10),'') as acting_concert_sign
,replace(replace(t1.top10_holders_rr_expalin,chr(13),''),chr(10),'') as top10_holders_rr_expalin
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,ed
,frozen_num
,isvalid

from ${iol_schema}.uxds_shareholder_list t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_shareholder_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
