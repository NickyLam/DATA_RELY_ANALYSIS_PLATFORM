: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ref_emply_post_para_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ref_emply_post_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.post_name as post_name
,t1.post_cate_id as post_cate_id
,t1.start_use_status_flg as start_use_status_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.post_id as post_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ref_emply_post_para t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ref_emply_post_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
