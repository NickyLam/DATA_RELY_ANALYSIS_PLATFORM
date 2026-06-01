: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_agt_loan_spec_repay_pla_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_agt_loan_spec_repay_pla.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,t1.etl_dt as etl_dt
,t1.ord_nbr as ord_nbr
,replace(replace(t1.tail_repay_type_cd,chr(13),''),chr(10),'') as tail_repay_type_cd
,t1.repay_dt as repay_dt
,replace(replace(t1.sfc_repay_flg,chr(13),''),chr(10),'') as sfc_repay_flg
,t1.repay_amt as repay_amt
,replace(replace(t1.repay_acct_num,chr(13),''),chr(10),'') as repay_acct_num
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_dul_d_pcrs_agt_loan_spec_repay_pla t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_agt_loan_spec_repay_pla.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes