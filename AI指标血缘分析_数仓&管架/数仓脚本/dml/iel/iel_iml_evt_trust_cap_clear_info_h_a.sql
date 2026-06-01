: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_trust_cap_clear_info_h_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_trust_cap_clear_info_h.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.start_dt as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.clear_flow_num,chr(13),''),chr(10),'') as clear_flow_num
,t.tran_dt as tran_dt
,t.clear_dt as clear_dt
,t.actl_enter_acct_dt as actl_enter_acct_dt
,t.bf_actl_enter_acct_dt as bf_actl_enter_acct_dt
,replace(replace(t.cfm_flow_num,chr(13),''),chr(10),'') as cfm_flow_num
,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t.intior_cd,chr(13),''),chr(10),'') as intior_cd
,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.bank_acct_type_cd,chr(13),''),chr(10),'') as bank_acct_type_cd
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t.acct_dir_cd,chr(13),''),chr(10),'') as acct_dir_cd
,t.clear_amt as clear_amt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,t.unfrz_amt as unfrz_amt
,replace(replace(t.host_tran_code,chr(13),''),chr(10),'') as host_tran_code
,t.host_dt as host_dt
,replace(replace(t.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,t.froz_amt as froz_amt
,replace(replace(t.bal_chk_cfm_cd,chr(13),''),chr(10),'') as bal_chk_cfm_cd
,replace(replace(t.cap_cate_cd,chr(13),''),chr(10),'') as cap_cate_cd
,replace(replace(t.pric_prft_flg,chr(13),''),chr(10),'') as pric_prft_flg
,t.cfm_lot as cfm_lot
,t.pric as pric
,replace(replace(t.prod_acct_num,chr(13),''),chr(10),'') as prod_acct_num
,replace(replace(t.prod_acct_type_cd,chr(13),''),chr(10),'') as prod_acct_type_cd
,replace(replace(t.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.init_clear_flow_num,chr(13),''),chr(10),'') as init_clear_flow_num
,replace(replace(t.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t.intfc_proc_flg_cd,chr(13),''),chr(10),'') as intfc_proc_flg_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_trust_cap_clear_info_h t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_trust_cap_clear_info_h.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes