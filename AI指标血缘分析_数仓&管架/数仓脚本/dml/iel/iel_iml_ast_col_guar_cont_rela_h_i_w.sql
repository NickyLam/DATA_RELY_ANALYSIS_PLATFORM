: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_guar_cont_rela_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_guar_cont_rela_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,replace(replace(t.loan_stage_cd,chr(13),''),chr(10),'') as loan_stage_cd
,t.guar_amt as guar_amt
,replace(replace(t.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,replace(replace(t.effect_status_cd,chr(13),''),chr(10),'') as effect_status_cd
,replace(replace(t.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd
,replace(replace(t.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,t.setup_dt as setup_dt
,replace(replace(t.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ast_col_guar_cont_rela_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_guar_cont_rela_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes