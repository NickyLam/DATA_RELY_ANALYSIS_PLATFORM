: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_dubil_assign_h_f
CreateDate: 20250102
FileName:   ${iel_data_path}/ast_dubil_assign_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,loan_assign_bal
,dubil_bal
,splt_col_latest_val
,splt_col_insto_val
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.in_out_tab_flg,chr(13),''),chr(10),'') as in_out_tab_flg
,replace(replace(t1.assign_level_cd,chr(13),''),chr(10),'') as assign_level_cd
,replace(replace(t1.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd

from ${iml_schema}.ast_dubil_assign_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_dubil_assign_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
