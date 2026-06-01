: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_a_cus_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_a_cus_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.cus_mobile,chr(13),''),chr(10),'') as cus_mobile
    ,replace(replace(t.cus_home_tel,chr(13),''),chr(10),'') as cus_home_tel
    ,replace(replace(t.cus_corp_name,chr(13),''),chr(10),'') as cus_corp_name
    ,replace(replace(t.cus_corp_tel,chr(13),''),chr(10),'') as cus_corp_tel
    ,replace(replace(t.cus_home_ad,chr(13),''),chr(10),'') as cus_home_ad
    ,replace(replace(t.cus_reg_ad,chr(13),''),chr(10),'') as cus_reg_ad
    ,replace(replace(t.cus_post_ad,chr(13),''),chr(10),'') as cus_post_ad
    ,replace(replace(t.cus_corp_ad,chr(13),''),chr(10),'') as cus_corp_ad
    ,replace(replace(t.cus_email,chr(13),''),chr(10),'') as cus_email
    ,replace(replace(t.emergencontact_name,chr(13),''),chr(10),'') as emergencontact_name
    ,replace(replace(t.emergencontact_id,chr(13),''),chr(10),'') as emergencontact_id
    ,replace(replace(t.emergencontact_mobile,chr(13),''),chr(10),'') as emergencontact_mobile
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_a_cus_info t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_a_cus_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes