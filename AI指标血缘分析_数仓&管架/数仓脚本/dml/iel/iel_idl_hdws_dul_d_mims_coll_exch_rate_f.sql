: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_exch_rate_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_exch_rate.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.convt_rmb_exch_rate as convt_rmb_exch_rate
,t1.stati_dt as stati_dt
from ${idl_schema}.hdws_dul_d_mims_coll_exch_rate t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_exch_rate.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes