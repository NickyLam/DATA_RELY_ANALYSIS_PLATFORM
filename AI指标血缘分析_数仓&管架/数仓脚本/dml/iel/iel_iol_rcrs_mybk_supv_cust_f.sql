: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_mybk_supv_cust_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_mybk_supv_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.inst_code,chr(13),''),chr(10),'') as inst_code
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t.target_jy_flag2,chr(13),''),chr(10),'') as target_jy_flag2
,replace(replace(t.target_jy_flag3,chr(13),''),chr(10),'') as target_jy_flag3
,replace(replace(t.farmer_flag,chr(13),''),chr(10),'') as farmer_flag
,replace(replace(t.bsn_type,chr(13),''),chr(10),'') as bsn_type
,replace(replace(t.act_cert_type,chr(13),''),chr(10),'') as act_cert_type
,replace(replace(t.act_cert_no,chr(13),''),chr(10),'') as act_cert_no
,replace(replace(t.act_cert_name,chr(13),''),chr(10),'') as act_cert_name
,replace(replace(t.staff_num,chr(13),''),chr(10),'') as staff_num
,replace(replace(t.income,chr(13),''),chr(10),'') as income
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.RCRS_MYBK_SUPV_CUST t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_mybk_supv_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes