: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ifcs_froz_stop_pay_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ifcs_froz_stop_pay_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.froz_dt,chr(13),''),chr(10),'') as froz_dt
,replace(replace(t1.froz_flow_num,chr(13),''),chr(10),'') as froz_flow_num
,t1.seq_num as seq_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.rec_type,chr(13),''),chr(10),'') as rec_type
,replace(replace(t1.bus_type,chr(13),''),chr(10),'') as bus_type
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.dep_prod_sub_acct_id,chr(13),''),chr(10),'') as dep_prod_sub_acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,t1.appl_froz_amt as appl_froz_amt
,t1.surp_froz_amt as surp_froz_amt
,replace(replace(t1.froz_end_dt,chr(13),''),chr(10),'') as froz_end_dt
,replace(replace(t1.proof_type,chr(13),''),chr(10),'') as proof_type
,replace(replace(t1.proof_id,chr(13),''),chr(10),'') as proof_id
,replace(replace(t1.froz_rs,chr(13),''),chr(10),'') as froz_rs
,replace(replace(t1.exec_org_cd,chr(13),''),chr(10),'') as exec_org_cd
,replace(replace(t1.exec_cert_type_01,chr(13),''),chr(10),'') as exec_cert_type_01
,replace(replace(t1.exec_cert_no_01,chr(13),''),chr(10),'') as exec_cert_no_01
,replace(replace(t1.exec_cert_type_02,chr(13),''),chr(10),'') as exec_cert_type_02
,replace(replace(t1.exec_cert_no_02,chr(13),''),chr(10),'') as exec_cert_no_02
,replace(replace(t1.exec_ps_01,chr(13),''),chr(10),'') as exec_ps_01
,replace(replace(t1.exec_ps_02,chr(13),''),chr(10),'') as exec_ps_02
,replace(replace(t1.operr_no,chr(13),''),chr(10),'') as operr_no
,replace(replace(t1.tran_org,chr(13),''),chr(10),'') as tran_org
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.froz_tm,chr(13),''),chr(10),'') as froz_tm
,replace(replace(t1.law_enforce_type,chr(13),''),chr(10),'') as law_enforce_type
,replace(replace(t1.law_enforce_name,chr(13),''),chr(10),'') as law_enforce_name
,replace(replace(t1.deduct_doc_type,chr(13),''),chr(10),'') as deduct_doc_type
,replace(replace(t1.deduct_doc_code,chr(13),''),chr(10),'') as deduct_doc_code
 from iol.ifcs_froz_stop_pay_rgst_b T1
where froz_dt='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ifcs_froz_stop_pay_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes