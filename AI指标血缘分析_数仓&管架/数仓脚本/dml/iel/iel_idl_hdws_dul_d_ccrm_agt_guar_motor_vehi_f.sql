: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_motor_vehi_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_motor_vehi.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
coll_id
,etl_dt
,vehic_typ_cd
,vehic_brand
,frm_num
,engi_num
,plt_nbr
,drive_lics_num
,vehic_use_prop_cd
,steer_mile
,make_dt
,purch_dt
,purch_price
,data_src_cd
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_motor_vehi
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_motor_vehi.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes