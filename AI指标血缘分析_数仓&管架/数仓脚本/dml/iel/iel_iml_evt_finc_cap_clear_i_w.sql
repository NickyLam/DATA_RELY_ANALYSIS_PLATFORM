: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_cap_clear_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_cap_clear_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.clear_flow_num,chr(13),''),chr(10),'') as clear_flow_num
,replace(replace(t.clear_seq_num,chr(13),''),chr(10),'') as clear_seq_num
,t.tran_dt as tran_dt
,t.clear_dt as clear_dt
,t.actl_enter_acct_dt as actl_enter_acct_dt
,t.chg_bf_clear_dt as chg_bf_clear_dt
,replace(replace(t.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t.intior_cd,chr(13),''),chr(10),'') as intior_cd
,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.bank_acct_num,chr(13),''),chr(10),'') as bank_acct_num
,replace(replace(t.bank_acct_type_cd,chr(13),''),chr(10),'') as bank_acct_type_cd
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
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
,replace(replace(t.acct_amt_src_type_cd,chr(13),''),chr(10),'') as acct_amt_src_type_cd
,replace(replace(t.cap_cate_cd,chr(13),''),chr(10),'') as cap_cate_cd
,replace(replace(t.pric_prft_cd,chr(13),''),chr(10),'') as pric_prft_cd
,t.cfm_lot as cfm_lot
,t.pric_amt as pric_amt
,t.cfm_prft_amt as cfm_prft_amt
,t.lot_accu_accum as lot_accu_accum
,replace(replace(t.prod_acct_num,chr(13),''),chr(10),'') as prod_acct_num
,replace(replace(t.prod_acct_type_cd,chr(13),''),chr(10),'') as prod_acct_type_cd
,replace(replace(t.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
,replace(replace(t.cap_clear_status_cd,chr(13),''),chr(10),'') as cap_clear_status_cd
,replace(replace(t.init_clear_flow_num,chr(13),''),chr(10),'') as init_clear_flow_num
,replace(replace(t.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t.intfc_proc_flg,chr(13),''),chr(10),'') as intfc_proc_flg
,replace(replace(t.remark_info_1,chr(13),''),chr(10),'') as remark_info_1
,replace(replace(t.remark_info_2,chr(13),''),chr(10),'') as remark_info_2
,replace(replace(t.remark_info_3,chr(13),''),chr(10),'') as remark_info_3
,replace(replace(t.remark_info_4,chr(13),''),chr(10),'') as remark_info_4
,replace(replace(t.remark_info_5,chr(13),''),chr(10),'') as remark_info_5
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.evt_finc_cap_clear t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_cap_clear_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes