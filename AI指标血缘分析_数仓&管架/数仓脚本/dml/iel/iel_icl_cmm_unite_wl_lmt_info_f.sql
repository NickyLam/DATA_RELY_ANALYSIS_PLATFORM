: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_lmt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_unite_wl_lmt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.lmt_rela_appl_id,chr(13),''),chr(10),'') as lmt_rela_appl_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.actv_flg,chr(13),''),chr(10),'') as actv_flg
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,t1.begin_dt as begin_dt
,t1.modif_dt as modif_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,t1.crdt_lmt as crdt_lmt
,t1.occu_crdt_lmt as occu_crdt_lmt
,t1.surp_crdt_lmt as surp_crdt_lmt
,t1.crdt_open_amt as crdt_open_amt
,t1.incr_lmt_lmt as incr_lmt_lmt
from ${icl_schema}.cmm_unite_wl_lmt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_lmt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes