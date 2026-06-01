: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_cont_addit_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_cont_addit_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.asset_pool_agt_cont_id,chr(13),''),chr(10),'') as asset_pool_agt_cont_id
,replace(replace(t1.nl_bus_flg,chr(13),''),chr(10),'') as nl_bus_flg
,ocup_pool_water_level_amt
,asset_pool_agt_sign_tm
,replace(replace(t1.curr_brwer_flg,chr(13),''),chr(10),'') as curr_brwer_flg
,replace(replace(t1.aldy_sign_pool_fin_agt_flg,chr(13),''),chr(10),'') as aldy_sign_pool_fin_agt_flg
,replace(replace(t1.asset_pool_higt_lmt_guar_cont_id,chr(13),''),chr(10),'') as asset_pool_higt_lmt_guar_cont_id

from ${iml_schema}.agt_loan_cont_addit_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_cont_addit_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
