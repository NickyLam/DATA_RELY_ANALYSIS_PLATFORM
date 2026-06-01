: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_val_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_val_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd
,t.estim_dt as estim_dt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.exch_rat as exch_rat
,t.ext_estim_exp_dt as ext_estim_exp_dt
,replace(replace(t.ext_estim_org_id,chr(13),''),chr(10),'') as ext_estim_org_id
,replace(replace(t.ext_estim_method_cd,chr(13),''),chr(10),'') as ext_estim_method_cd
,t.ext_pre_estim_val as ext_pre_estim_val
,t.ext_formal_estim_dt as ext_formal_estim_dt
,t.ext_estim_val as ext_estim_val
,t.intnal_estim_val as intnal_estim_val
,t.appl_estim_cfm_val as appl_estim_cfm_val
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,t.hxb_cfm_val as hxb_cfm_val
,t.estim_idtfy_dt as estim_idtfy_dt
,t.ext_pa_estim_val as ext_pa_estim_val
,t.intnal_pa_estim_val as intnal_pa_estim_val
,t.hxb_pa_cfm_val as hxb_pa_cfm_val
,replace(replace(t.pa_flow_id,chr(13),''),chr(10),'') as pa_flow_id
,replace(replace(t.evltion_status_cd,chr(13),''),chr(10),'') as evltion_status_cd
,replace(replace(t.froz_flg,chr(13),''),chr(10),'') as froz_flg
,t.insto_col_val as insto_col_val
,replace(replace(t.insto_org_id,chr(13),''),chr(10),'') as insto_org_id
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ast_col_val_info_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_val_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes