: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_elec_chn_tran_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_elec_chn_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.ova_chn_flow_num,chr(13),''),chr(10),'') as ova_chn_flow_num
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.sorc_sys_flow_num,chr(13),''),chr(10),'') as sorc_sys_flow_num
,replace(replace(t1.osb_tran_flow_num,chr(13),''),chr(10),'') as osb_tran_flow_num
,replace(replace(t1.rela_timing_task_id,chr(13),''),chr(10),'') as rela_timing_task_id
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,t1.core_tran_dt as core_tran_dt
,replace(replace(t1.tran_type_code,chr(13),''),chr(10),'') as tran_type_code
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.tran_acct_name,chr(13),''),chr(10),'') as tran_acct_name
,t1.tran_amt as tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.elec_chn_user_id,chr(13),''),chr(10),'') as elec_chn_user_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.termn_ip_addr,chr(13),''),chr(10),'') as termn_ip_addr
,t1.tran_comm_fee as tran_comm_fee
,replace(replace(t1.termn_mac_addr,chr(13),''),chr(10),'') as termn_mac_addr
,replace(replace(t1.termn_equip_model,chr(13),''),chr(10),'') as termn_equip_model
,replace(replace(t1.termn_equip_id,chr(13),''),chr(10),'') as termn_equip_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_open_bank_num,chr(13),''),chr(10),'') as cntpty_acct_open_bank_num
,replace(replace(t1.cntpty_acct_open_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_name
,replace(replace(t1.cntpty_acct_prov_cd,chr(13),''),chr(10),'') as cntpty_acct_prov_cd
,replace(replace(t1.cntpty_acct_city_cd,chr(13),''),chr(10),'') as cntpty_acct_city_cd
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.memo_descb,chr(13),''),chr(10),'') as memo_descb
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.camp_emply_id,chr(13),''),chr(10),'') as camp_emply_id
,replace(replace(t1.olbk_tran_src_cd,chr(13),''),chr(10),'') as olbk_tran_src_cd
from ${icl_schema}.cmm_elec_chn_tran_dtl t1
where t1.etl_dt >= to_date('20220601','yyyymmdd') AND t1.etl_dt <= to_date('20220630','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_elec_chn_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes