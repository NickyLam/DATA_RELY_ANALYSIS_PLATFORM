: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_loan_repay_princ_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_loan_repay_princ_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.repay_princ_cust_no,chr(13),''),chr(10),'') as repay_princ_cust_no
,replace(replace(t1.repay_princ_name,chr(13),''),chr(10),'') as repay_princ_name
,replace(replace(t1.repay_princ_cert_type,chr(13),''),chr(10),'') as repay_princ_cert_type
,replace(replace(t1.repay_princ_cert_no,chr(13),''),chr(10),'') as repay_princ_cert_no
,replace(replace(t1.repay_princ_idti_type_cd,chr(13),''),chr(10),'') as repay_princ_idti_type_cd
,replace(replace(t1.repay_princ_type_cd,chr(13),''),chr(10),'') as repay_princ_type_cd
from ${icl_schema}.cmm_loan_repay_princ_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_loan_repay_princ_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes