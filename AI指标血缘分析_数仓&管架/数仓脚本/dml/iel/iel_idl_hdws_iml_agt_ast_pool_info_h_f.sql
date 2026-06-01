: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_ast_pool_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_ast_pool_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.ast_pool_id,chr(13),''),chr(10),'') as ast_pool_id
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.in_pool_loan_bal as in_pool_loan_bal
,replace(replace(t1.in_pool_status_cd,chr(13),''),chr(10),'') as in_pool_status_cd
,replace(replace(t1.assoc_ast_pkg_id,chr(13),''),chr(10),'') as assoc_ast_pkg_id
,t1.tran_price as tran_price
,t1.tran_price_ratio as tran_price_ratio
,replace(replace(t1.reg_emp_id,chr(13),''),chr(10),'') as reg_emp_id
,t1.reg_dt as reg_dt
,NVL2(t1.data_src_cd,'AGT_AST_POOL_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_AST_POOL_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_agt_ast_pool_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_ast_pool_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes