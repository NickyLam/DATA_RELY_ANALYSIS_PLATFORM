: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_evt_finc_cap_clear_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_evt_finc_cap_clear.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.clear_flow_num as clear_flow_num
,t1.clear_seq_num as clear_seq_num
,t1.tran_dt as tran_dt
,t1.clear_dt as clear_dt
,t1.actl_enter_acct_dt as actl_enter_acct_dt
,t1.chg_bf_clear_dt as chg_bf_clear_dt
,t1.flow_num as flow_num
,t1.rela_flow_num as rela_flow_num
,t1.intior_cd as intior_cd
,t1.tran_cd as tran_cd
,t1.bus_cd as bus_cd
,t1.cust_type_cd as cust_type_cd
,t1.intnal_cust_id as intnal_cust_id
,t1.bank_id as bank_id
,t1.cust_id as cust_id
,t1.bank_acct_num as bank_acct_num
,t1.bank_acct_type_cd as bank_acct_type_cd
,t1.tran_chn_cd as tran_chn_cd
,t1.tran_teller_id as tran_teller_id
,t1.termn_id as termn_id
,t1.tran_org_id as tran_org_id
,t1.tran_belong_org_id as tran_belong_org_id
,t1.ta_cd as ta_cd
,t1.prod_id as prod_id
,t1.acct_dir_cd as acct_dir_cd
,t1.clear_amt as clear_amt
,t1.curr_cd as curr_cd
,t1.ec_idf_cd as ec_idf_cd
,t1.unfrz_amt as unfrz_amt
,t1.host_tran_code as host_tran_code
,t1.host_dt as host_dt
,t1.host_flow_num as host_flow_num
,t1.froz_amt as froz_amt
,t1.bal_chk_cfm_cd as bal_chk_cfm_cd
,t1.acct_amt_src_type_cd as acct_amt_src_type_cd
,t1.cap_cate_cd as cap_cate_cd
,t1.pric_prft_cd as pric_prft_cd
,t1.cfm_lot as cfm_lot
,t1.pric_amt as pric_amt
,t1.cfm_prft_amt as cfm_prft_amt
,t1.lot_accu_accum as lot_accu_accum
,t1.prod_acct_num as prod_acct_num
,t1.prod_acct_type_cd as prod_acct_type_cd
,t1.memo_comnt as memo_comnt
,t1.cap_clear_status_cd as cap_clear_status_cd
,t1.init_clear_flow_num as init_clear_flow_num
,t1.return_code as return_code
,t1.err_info_desc as err_info_desc
,t1.intfc_proc_flg as intfc_proc_flg
,t1.remark_info_1 as remark_info_1
,t1.remark_info_2 as remark_info_2
,t1.remark_info_3 as remark_info_3
,t1.remark_info_4 as remark_info_4
,t1.remark_info_5 as remark_info_5
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.evt_id as evt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_evt_finc_cap_clear t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_evt_finc_cap_clear.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
