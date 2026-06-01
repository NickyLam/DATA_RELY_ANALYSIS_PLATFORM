: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ifcs_froz_stop_pay_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ifcs_froz_stop_pay_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.froz_dt
,t1.froz_flow_num
,t1.seq_num
,t1.tran_flow_num
,t1.rec_type
,t1.bus_type
,t1.status_cd
,t1.acct_id
,t1.dep_prod_sub_acct_id
,t1.acct_name
,t1.appl_froz_amt
,t1.surp_froz_amt
,t1.froz_end_dt
,t1.proof_type
,t1.proof_id
,t1.froz_rs
,t1.exec_org_cd
,t1.exec_cert_type_01
,t1.exec_cert_no_01
,t1.exec_cert_type_02
,t1.exec_cert_no_02
,t1.exec_ps_01
,t1.exec_ps_02
,t1.operr_no
,t1.tran_org
,t1.chn_cd
,t1.froz_tm
,t1.law_enforce_type
,t1.law_enforce_name
,t1.deduct_doc_type
,t1.deduct_doc_code
,t1.ori_tran_flow
from ${idl_schema}.hdws_ifcs_froz_stop_pay_rgst_b t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ifcs_froz_stop_pay_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes