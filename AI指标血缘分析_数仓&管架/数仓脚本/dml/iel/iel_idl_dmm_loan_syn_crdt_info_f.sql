: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_dmm_loan_syn_crdt_info_f
CreateDate: 20250528
FileName:   ${iel_data_path}/dmm_loan_syn_crdt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}', 'yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_src_idf,chr(13),''),chr(10),'') as sys_src_idf
,replace(replace(t1.crdt_id,chr(13),''),chr(10),'') as crdt_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.lmt_bus_flg,chr(13),''),chr(10),'') as lmt_bus_flg
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd
,t1.happ_dt as happ_dt
,replace(replace(t1.lmt_bus_curr_cd,chr(13),''),chr(10),'') as lmt_bus_curr_cd
,t1.crdt_lmt as crdt_lmt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,t1.tenor_mon as tenor_mon
,t1.lmt_bus_begin_day as lmt_bus_begin_day
,t1.lmt_bus_exp_day as lmt_bus_exp_day
,replace(replace(t1.is_circl_lmt,chr(13),''),chr(10),'') as is_circl_lmt
,replace(replace(t1.risk_type_lmt,chr(13),''),chr(10),'') as risk_type_lmt
,replace(replace(t1.loan_dir_indus,chr(13),''),chr(10),'') as loan_dir_indus
,replace(replace(t1.usage,chr(13),''),chr(10),'') as usage
,replace(replace(t1.main_guar_way,chr(13),''),chr(10),'') as main_guar_way
,replace(replace(t1.apv_status,chr(13),''),chr(10),'') as apv_status
,replace(replace(t1.oper_org,chr(13),''),chr(10),'') as oper_org
,t1.oper_dt as oper_dt
,replace(replace(t1.rgstrat,chr(13),''),chr(10),'') as rgstrat
,replace(replace(t1.rgst_org,chr(13),''),chr(10),'') as rgst_org
,t1.rgst_dt as rgst_dt
,replace(replace(t1.updater,chr(13),''),chr(10),'') as updater
,replace(replace(t1.update_org,chr(13),''),chr(10),'') as update_org
,t1.update_dt as update_dt
,replace(replace(t1.belong_strip_line,chr(13),''),chr(10),'') as belong_strip_line
,replace(replace(t1.loan_usage,chr(13),''),chr(10),'') as loan_usage
,t1.lmt_open_amt as lmt_open_amt
,replace(replace(t1.guar_lon_flg,chr(13),''),chr(10),'') as guar_lon_flg
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.sub_prod_name,chr(13),''),chr(10),'') as sub_prod_name

from ${idl_schema}.dmm_loan_syn_crdt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dmm_loan_syn_crdt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes