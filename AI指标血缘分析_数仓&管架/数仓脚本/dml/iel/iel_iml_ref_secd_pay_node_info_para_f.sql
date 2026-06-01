: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_secd_pay_node_info_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_secd_pay_node_info_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.node_cd,chr(13),''),chr(10),'') as node_cd
,replace(replace(t1.node_move_status_cd,chr(13),''),chr(10),'') as node_move_status_cd
,replace(replace(t1.node_name,chr(13),''),chr(10),'') as node_name
,replace(replace(t1.node_type_cd,chr(13),''),chr(10),'') as node_type_cd
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.modif_perds,chr(13),''),chr(10),'') as modif_perds
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id

from ${iml_schema}.ref_secd_pay_node_info_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_secd_pay_node_info_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
