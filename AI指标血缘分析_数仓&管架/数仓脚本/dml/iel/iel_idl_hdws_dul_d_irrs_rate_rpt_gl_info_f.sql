: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_irrs_rate_rpt_gl_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_irrs_rate_rpt_gl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_char(etl_dt,'YYYY-MM-DD') as etl_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.prd_typ_cd,chr(13),''),chr(10),'') as prd_typ_cd
,t1.int_income as int_income
,t1.int_cost as int_cost
,t1.day_avg_bal as day_avg_bal
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.acct_dt,chr(13),''),chr(10),'') as acct_dt
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
from ${idl_schema}.hdws_dul_d_irrs_rate_rpt_gl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_irrs_rate_rpt_gl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes