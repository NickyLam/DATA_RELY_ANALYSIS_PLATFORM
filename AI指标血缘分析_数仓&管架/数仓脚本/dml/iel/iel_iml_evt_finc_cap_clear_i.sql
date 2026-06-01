: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_cap_clear_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_cap_clear.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.clear_flow_num,chr(13),''),chr(10),'') as clear_flow_num 
,replace(replace(t1.clear_seq_num,chr(13),''),chr(10),'') as clear_seq_num 
,t1.tran_dt as tran_dt 
,t1.clear_dt as clear_dt 
,t1.actl_enter_acct_dt as actl_enter_acct_dt 
,t1.chg_bf_clear_dt as chg_bf_clear_dt 
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num 
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num 
,replace(replace(t1.intior_cd,chr(13),''),chr(10),'') as intior_cd 
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd 
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd 
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd 
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id 
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.bank_acct_num,chr(13),''),chr(10),'') as bank_acct_num 
,replace(replace(t1.bank_acct_type_cd,chr(13),''),chr(10),'') as bank_acct_type_cd 
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd 
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id 
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id 
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id 
,replace(replace(t1.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id 
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.acct_dir_cd,chr(13),''),chr(10),'') as acct_dir_cd 
,t1.clear_amt as clear_amt 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd 
,t1.unfrz_amt as unfrz_amt 
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code 
,t1.host_dt as host_dt 
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num 
,t1.froz_amt as froz_amt 
,replace(replace(t1.bal_chk_cfm_cd,chr(13),''),chr(10),'') as bal_chk_cfm_cd 
,replace(replace(t1.acct_amt_src_type_cd,chr(13),''),chr(10),'') as acct_amt_src_type_cd 
,replace(replace(t1.cap_cate_cd,chr(13),''),chr(10),'') as cap_cate_cd 
,replace(replace(t1.pric_prft_cd,chr(13),''),chr(10),'') as pric_prft_cd 
,t1.cfm_lot as cfm_lot 
,t1.pric_amt as pric_amt 
,t1.cfm_prft_amt as cfm_prft_amt 
,t1.lot_accu_accum as lot_accu_accum 
,replace(replace(t1.prod_acct_num,chr(13),''),chr(10),'') as prod_acct_num 
,replace(replace(t1.prod_acct_type_cd,chr(13),''),chr(10),'') as prod_acct_type_cd 
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt 
,replace(replace(t1.cap_clear_status_cd,chr(13),''),chr(10),'') as cap_clear_status_cd 
,replace(replace(t1.init_clear_flow_num,chr(13),''),chr(10),'') as init_clear_flow_num 
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code 
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc 
,replace(replace(t1.intfc_proc_flg,chr(13),''),chr(10),'') as intfc_proc_flg 
,replace(replace(t1.remark_info_1,chr(13),''),chr(10),'') as remark_info_1 
,replace(replace(t1.remark_info_2,chr(13),''),chr(10),'') as remark_info_2 
,replace(replace(t1.remark_info_3,chr(13),''),chr(10),'') as remark_info_3 
,replace(replace(t1.remark_info_4,chr(13),''),chr(10),'') as remark_info_4 
,replace(replace(t1.remark_info_5,chr(13),''),chr(10),'') as remark_info_5 
from ${iml_schema}.evt_finc_cap_clear t1 
where t1.clear_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_cap_clear.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes