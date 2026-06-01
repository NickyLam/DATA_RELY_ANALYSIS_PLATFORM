: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_acpt_draft_info_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_acpt_draft_info_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.drawe_cust_nbr,chr(13),''),chr(10),'') as drawe_cust_nbr
,replace(replace(t1.drawe_name,chr(13),''),chr(10),'') as drawe_name
,replace(replace(t1.proc_org_num,chr(13),''),chr(10),'') as proc_org_num
,replace(replace(t1.bil_num,chr(13),''),chr(10),'') as bil_num
,replace(replace(t1.drawe_acct_num,chr(13),''),chr(10),'') as drawe_acct_num
,t1.par_amt as par_amt
,t1.draw_day as draw_day
,t1.due_day as due_day
,t1.term as term
,t1.marg_ratio as marg_ratio
,t1.margin_amt as margin_amt
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,replace(replace(t1.payee_acct_num,chr(13),''),chr(10),'') as payee_acct_num
,replace(replace(t1.payee_acct_num_blng_row,chr(13),''),chr(10),'') as payee_acct_num_blng_row
,replace(replace(t1.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t1.bil_status,chr(13),''),chr(10),'') as bil_status
from ${idl_schema}.hdws_dul_d_ccrm_acpt_draft_info_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_acpt_draft_info_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes