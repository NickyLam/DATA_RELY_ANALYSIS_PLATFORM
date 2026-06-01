: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_pty_txn_anlz_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_pty_txn_anlz.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.mon,chr(13),''),chr(10),'') as mon
,t1.mon_drw_amt as mon_drw_amt
,t1.mon_dep_amt as mon_dep_amt
,t1.qtr_dep_amt as qtr_dep_amt
,t1.qtr_drw_amt as qtr_drw_amt
,t1.annu_dep_amt as annu_dep_amt
,t1.annu_drw_amt as annu_drw_amt
,t1.large_txn_cnt as large_txn_cnt
from ${idl_schema}.hdws_dul_d_ccrm_pty_txn_anlz t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_pty_txn_anlz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes