: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_loan_dd_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_loan_dd_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.dd_seq_num,chr(13),''),chr(10),'') as dd_seq_num
,t1.etl_dt as etl_dt
,replace(replace(t1.dd_mode_cd,chr(13),''),chr(10),'') as dd_mode_cd
,replace(replace(t1.dd_acct_id,chr(13),''),chr(10),'') as dd_acct_id
,t1.loan_issue_dt as loan_issue_dt
,replace(replace(t1.dd_org_id,chr(13),''),chr(10),'') as dd_org_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_LOAN_DD_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_LOAN_DD_INFO') as etl_task_name 
from ${idl_schema}.hdws_iml_agt_loan_dd_info t1
where ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'));" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_loan_dd_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes