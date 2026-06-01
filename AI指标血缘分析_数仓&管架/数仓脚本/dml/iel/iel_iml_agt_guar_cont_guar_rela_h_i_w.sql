: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_guar_cont_guar_rela_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_guar_cont_guar_rela_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.obj_type,chr(13),''),chr(10),'') as obj_type
,replace(replace(t.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t.guar_id,chr(13),''),chr(10),'') as guar_id
,replace(replace(t.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t.data_src_chn,chr(13),''),chr(10),'') as data_src_chn
,replace(replace(t.other_wat_status,chr(13),''),chr(10),'') as other_wat_status
,replace(replace(t.data_src_type,chr(13),''),chr(10),'') as data_src_type
,replace(replace(t.rela_status_cd,chr(13),''),chr(10),'') as rela_status_cd
,replace(replace(t.matn_flg,chr(13),''),chr(10),'') as matn_flg
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_guar_cont_guar_rela_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_guar_cont_guar_rela_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes