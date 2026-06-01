: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_cms_ast_tran_contr_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_cms_ast_tran_contr_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.tfr_contr_id,chr(13),''),chr(10),'') as tfr_contr_id
,'LCT002' as agt_modf 
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.inter_org_num,chr(13),''),chr(10),'') as inter_org_num
,replace(replace(t1.cntrpty_id,chr(13),''),chr(10),'') as cntrpty_id
,replace(replace(t1.cntrpty_name,chr(13),''),chr(10),'') as cntrpty_name
,replace(replace(t1.cms_txn_typ,chr(13),''),chr(10),'') as cms_txn_typ
,replace(replace(t1.txn_ast_typ,chr(13),''),chr(10),'') as txn_ast_typ
,t1.tfr_loan_prcp_total_amt as tfr_loan_prcp_total_amt
,t1.tfr_loan_int_total_amt as tfr_loan_int_total_amt
,t1.tfr_fee as tfr_fee
,t1.tfr_total_prc as tfr_total_prc
,t1.buy_back_rate as buy_back_rate
,t1.tfr_dlv_dt as tfr_dlv_dt
,t1.buy_back_base_dt as buy_back_base_dt
,t1.tfr_contr_start_dt as tfr_contr_start_dt
,t1.tfr_contr_due_dt as tfr_contr_due_dt
,replace(replace(t1.cntrpty_tfr_num,chr(13),''),chr(10),'') as cntrpty_tfr_num
,replace(replace(t1.cntrpty_tfr_acct_num_name,chr(13),''),chr(10),'') as cntrpty_tfr_acct_num_name
,replace(replace(t1.cntrpty_num,chr(13),''),chr(10),'') as cntrpty_num
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_CMS_AST_TRAN_CONTR_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_CMS_AST_TRAN_CONTR_H') as etl_task_name 
from ${idl_schema}.hdws_iml_agt_cms_ast_tran_contr t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_cms_ast_tran_contr_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes