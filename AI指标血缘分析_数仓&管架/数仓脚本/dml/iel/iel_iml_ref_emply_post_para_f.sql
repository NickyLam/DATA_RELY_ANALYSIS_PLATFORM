: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_emply_post_para_f
CreateDate: 20240110
FileName:   ${iel_data_path}/ref_emply_post_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.post_id,chr(13),''),chr(10),'') as post_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.post_name,chr(13),''),chr(10),'') as post_name
,replace(replace(t1.post_cate_id,chr(13),''),chr(10),'') as post_cate_id
,replace(replace(t1.start_use_status_flg,chr(13),''),chr(10),'') as start_use_status_flg
,create_dt
,update_dt
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.ref_emply_post_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_emply_post_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
