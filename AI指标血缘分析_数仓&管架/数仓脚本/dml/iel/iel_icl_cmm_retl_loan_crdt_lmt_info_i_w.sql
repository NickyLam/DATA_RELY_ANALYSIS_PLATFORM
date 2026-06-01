: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_crdt_lmt_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_retl_loan_crdt_lmt_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t.lmt_appl_flow_num,chr(13),''),chr(10),'') as lmt_appl_flow_num
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t.actv_flg,chr(13),''),chr(10),'') as actv_flg
,replace(replace(t.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name
,replace(replace(t.tenor,chr(13),''),chr(10),'') as tenor
,t.begin_dt as begin_dt
,t.exp_dt as exp_dt
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,t.crdt_lmt as crdt_lmt
,t.occu_crdt_lmt as occu_crdt_lmt
,t.surp_crdt_lmt as surp_crdt_lmt
,t.crdt_open_amt as crdt_open_amt
from ${icl_schema}.cmm_retl_loan_crdt_lmt_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_crdt_lmt_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes