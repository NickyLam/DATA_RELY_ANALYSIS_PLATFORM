: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_mybk_supv_cust_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_mybk_supv_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.inst_code
,t1.cert_type
,t1.name
,t1.cert_no
,t1.target_jy_flag2
,t1.target_jy_flag3
,t1.farmer_flag
,t1.bsn_type
,t1.act_cert_type
,t1.act_cert_no
,t1.act_cert_name
,t1.staff_num
,t1.income
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_mybk_supv_cust t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_mybk_supv_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes