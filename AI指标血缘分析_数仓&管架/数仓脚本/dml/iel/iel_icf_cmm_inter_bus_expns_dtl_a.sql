: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_inter_bus_expns_dtl_a
CreateDate: 20250619
FileName:   ${iel_data_path}/cmm_inter_bus_expns_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.charge_doc_num,chr(13),''),chr(10),'') as charge_doc_num
,replace(replace(t1.charge_flow_num,chr(13),''),chr(10),'') as charge_flow_num
,acct_dt
,replace(replace(t1.amort_flow_num,chr(13),''),chr(10),'') as amort_flow_num
,amort_start_dt
,amort_end_dt
,charge_dt
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cust_belong_bus_type_cd,chr(13),''),chr(10),'') as cust_belong_bus_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.bus_acct_id,chr(13),''),chr(10),'') as bus_acct_id
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.tran_main_acct_id,chr(13),''),chr(10),'') as tran_main_acct_id
,replace(replace(t1.tran_sub_acct_id,chr(13),''),chr(10),'') as tran_sub_acct_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.amort_flg,chr(13),''),chr(10),'') as amort_flg
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,acm_amort_amt
,amorted_tot_amt
,tran_amt
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
,etl_timestamp

from ${icl_schema}.cmm_inter_bus_expns_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_inter_bus_expns_dtl.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
