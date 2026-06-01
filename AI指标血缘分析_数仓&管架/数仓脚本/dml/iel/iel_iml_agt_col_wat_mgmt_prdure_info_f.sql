: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_col_wat_mgmt_prdure_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_col_wat_mgmt_prdure_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.wat_temp_borwer_name,chr(13),''),chr(10),'') as wat_temp_borwer_name
,replace(replace(t1.wat_temp_ex_renew_rs_cd,chr(13),''),chr(10),'') as wat_temp_ex_renew_rs_cd
,replace(replace(t1.wat_temp_ex_renew_spec_rs,chr(13),''),chr(10),'') as wat_temp_ex_renew_spec_rs
,wat_expect_rtn_dt
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,oper_dt
,replace(replace(t1.wat_info_happ_chg_flg,chr(13),''),chr(10),'') as wat_info_happ_chg_flg
,replace(replace(t1.wat_info_chg_situ_cd,chr(13),''),chr(10),'') as wat_info_chg_situ_cd
,replace(replace(t1.wat_info_chg_situ_descb,chr(13),''),chr(10),'') as wat_info_chg_situ_descb
,replace(replace(t1.new_right_vouch_id,chr(13),''),chr(10),'') as new_right_vouch_id
,replace(replace(t1.wat_nomal_ex_rs_cd,chr(13),''),chr(10),'') as wat_nomal_ex_rs_cd
,replace(replace(t1.wat_nomal_ex_spec_rs,chr(13),''),chr(10),'') as wat_nomal_ex_spec_rs
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_dt
,update_dt

from ${iml_schema}.agt_col_wat_mgmt_prdure_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_wat_mgmt_prdure_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
