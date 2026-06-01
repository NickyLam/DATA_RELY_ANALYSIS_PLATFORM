: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_tot_and_splt_col_rela_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_tot_and_splt_col_rela_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.parent_asset_id,chr(13),''),chr(10),'') as parent_asset_id
,replace(replace(t.sub_asset_id,chr(13),''),chr(10),'') as sub_asset_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.sup_chain_sys_merchd_id,chr(13),''),chr(10),'') as sup_chain_sys_merchd_id
,replace(replace(t.invtry_id,chr(13),''),chr(10),'') as invtry_id
,replace(replace(t.inpwn_id,chr(13),''),chr(10),'') as inpwn_id
,replace(replace(t.guar_contr_no,chr(13),''),chr(10),'') as guar_contr_no
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ast_tot_and_splt_col_rela t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_tot_and_splt_col_rela_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes