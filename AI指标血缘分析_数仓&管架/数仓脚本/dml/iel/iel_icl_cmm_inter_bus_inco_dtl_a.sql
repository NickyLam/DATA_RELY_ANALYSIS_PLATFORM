: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_inter_bus_inco_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_inter_bus_inco_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t1.tran_dt as tran_dt
,t1.acct_dt as acct_dt
,replace(replace(t1.amort_flow_num,chr(13),''),chr(10),'') as amort_flow_num
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bus_acct_id,chr(13),''),chr(10),'') as bus_acct_id
,replace(replace(t1.intnal_acct_id,chr(13),''),chr(10),'') as intnal_acct_id
,replace(replace(t1.intnal_acct_name,chr(13),''),chr(10),'') as intnal_acct_name
,replace(replace(t1.intnal_main_acct_id,chr(13),''),chr(10),'') as intnal_main_acct_id
,replace(replace(t1.tran_main_acct_id,chr(13),''),chr(10),'') as tran_main_acct_id
,replace(replace(t1.tran_sub_acct_id,chr(13),''),chr(10),'') as tran_sub_acct_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.charge_cd,chr(13),''),chr(10),'') as charge_cd
,replace(replace(t1.charge_name,chr(13),''),chr(10),'') as charge_name
,replace(replace(t1.charge_cate_cd,chr(13),''),chr(10),'') as charge_cate_cd
,replace(replace(t1.amort_flg,chr(13),''),chr(10),'') as amort_flg
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,t1.recvbl_comm_fee_amt as recvbl_comm_fee_amt
,replace(replace(t1.tran_remark_info,chr(13),''),chr(10),'') as tran_remark_info
,t1.at_amt as at_amt
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.charge_doc_num,chr(13),''),chr(10),'') as charge_doc_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,t1.tax_amt as tax_amt
,t1.amort_start_dt as amort_start_dt
,t1.amort_end_dt as amort_end_dt
,t1.acm_amort_amt as acm_amort_amt
,t1.amorted_tot_amt as amorted_tot_amt
,replace(replace(t1.charge_flow_num,chr(13),''),chr(10),'') as charge_flow_num
,charge_dt
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
from ${icl_schema}.cmm_inter_bus_inco_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_inter_bus_inco_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes