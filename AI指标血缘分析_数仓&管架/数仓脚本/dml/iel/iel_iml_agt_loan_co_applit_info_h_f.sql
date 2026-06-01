: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_co_applit_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_co_applit_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name
,replace(replace(t1.applit_cust_id,chr(13),''),chr(10),'') as applit_cust_id
,replace(replace(t1.applit_cust_name,chr(13),''),chr(10),'') as applit_cust_name
,t1.eqty_tprop_ratio as eqty_tprop_ratio
,t1.debt_tprop_ratio as debt_tprop_ratio
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,t1.rgst_tm as rgst_tm
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,t1.update_tm as update_tm
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.and_main_debit_ps_rela_type_cd,chr(13),''),chr(10),'') as and_main_debit_ps_rela_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_loan_co_applit_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_co_applit_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes