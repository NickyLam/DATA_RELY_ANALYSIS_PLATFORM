: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_cbec_acct_stl_tot_f
CreateDate: 20250604
FileName:   ${iel_data_path}/evt_cbec_acct_stl_tot.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tot_mon,chr(13),''),chr(10),'') as tot_mon
,acm_abmt
,acm_remit_out

from ${iml_schema}.evt_cbec_acct_stl_tot t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cbec_acct_stl_tot.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
