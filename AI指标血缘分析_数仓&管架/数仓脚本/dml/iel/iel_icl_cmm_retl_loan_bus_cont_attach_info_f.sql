: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_bus_cont_attach_info_f
CreateDate: 20250102
FileName:   ${iel_data_path}/cmm_retl_loan_bus_cont_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cont_name,chr(13),''),chr(10),'') as cont_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd
,cont_bal
,margin_amt
,rgst_dt
,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'') as loan_usage_descb
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.ocup_open_lmt_risk_type_cd,chr(13),''),chr(10),'') as ocup_open_lmt_risk_type_cd

from ${icl_schema}.cmm_retl_loan_bus_cont_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_bus_cont_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
