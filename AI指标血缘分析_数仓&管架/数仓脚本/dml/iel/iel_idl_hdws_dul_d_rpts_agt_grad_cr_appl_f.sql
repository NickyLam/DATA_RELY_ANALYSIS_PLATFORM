: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_grad_cr_appl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_grad_cr_appl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
appl_id
,etl_dt
,appl_dt
,lmt_eff_dt
,lmt_expi_dt
,prd_id
,pty_id
,appl_amt
,aprv_amt
,ccy_cd
,aprv_status_cd
,loan_usage_cd
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_agt_grad_cr_appl
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_grad_cr_appl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes