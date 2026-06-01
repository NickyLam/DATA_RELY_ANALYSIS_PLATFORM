: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_loan_provi_dtl_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_loan_provi_dtl_m.i_${batch_date}.dat
IF_mark:    i_m
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dbill_id,chr(13),''),chr(10),'') as dbill_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,t1.accrued_dt as accrued_dt
,replace(replace(t1.bal_ord_nbr,chr(13),''),chr(10),'') as bal_ord_nbr
,replace(replace(t1.loan_stmt_typ_cd,chr(13),''),chr(10),'') as loan_stmt_typ_cd
,replace(replace(t1.bal_cmpnt_typ_cd,chr(13),''),chr(10),'') as bal_cmpnt_typ_cd
,t1.rcva_int as rcva_int
,t1.last_bal as last_bal
,t1.intr_rcva_int as intr_rcva_int
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,NVL2(t1.data_src_cd,'AGT_LOAN_PROVI_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_LOAN_PROVI_DTL') as etl_task_name
from ${idl_schema}.hdws_iml_agt_loan_provi_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'mm');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_loan_provi_dtl_m.i_${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes