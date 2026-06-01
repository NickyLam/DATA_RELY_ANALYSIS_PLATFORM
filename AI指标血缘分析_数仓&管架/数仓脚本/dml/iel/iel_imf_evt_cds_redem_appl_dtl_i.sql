: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_cds_redem_appl_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_cds_redem_appl_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.issue_year,chr(13),''),chr(10),'') as issue_year
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_dt as tran_dt
,t1.redem_int_rat as redem_int_rat
,replace(replace(t1.tran_redem_status_cd,chr(13),''),chr(10),'') as tran_redem_status_cd
,replace(replace(t1.pd_prod_cate_cd,chr(13),''),chr(10),'') as pd_prod_cate_cd
,t1.redem_dt as redem_dt
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,t1.appl_dt as appl_dt
,replace(replace(t1.applit_name,chr(13),''),chr(10),'') as applit_name
,replace(replace(t1.apv_form_id,chr(13),''),chr(10),'') as apv_form_id
from ${iml_schema}.evt_cds_redem_appl_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cds_redem_appl_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes