: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_abs_amt_dtl_splt_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_abs_amt_dtl_splt_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.agt_id as agt_id
,t1.lp_id as lp_id
,t1.asset_amt_dtl_seq_num as asset_amt_dtl_seq_num
,t1.asset_bag_cont_dtl_seq_num as asset_bag_cont_dtl_seq_num
,t1.cust_id as cust_id
,t1.amt_type_cd as amt_type_cd
,t1.paybl_bank_int_amt as paybl_bank_int_amt
,t1.loan_surp_amt as loan_surp_amt
,t1.redem_paybl_cntpty_int as redem_paybl_cntpty_int
,t1.redem_surp_cntpty_int as redem_surp_cntpty_int
,t1.pkg_tran_in_suspd_crdt_acct_amt as pkg_tran_in_suspd_crdt_acct_amt
,t1.final_modif_dt as final_modif_dt
,t1.tran_tm as tran_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark

from ${idl_schema}.oass_agt_abs_amt_dtl_splt_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_abs_amt_dtl_splt_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
