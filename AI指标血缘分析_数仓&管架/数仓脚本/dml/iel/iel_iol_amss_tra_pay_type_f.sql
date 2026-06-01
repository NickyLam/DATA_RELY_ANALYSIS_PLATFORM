: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_tra_pay_type_f
CreateDate: 20250506
FileName:   ${iel_data_path}/amss_tra_pay_type.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,pay_type_id
,replace(replace(t1.pay_type_name,chr(13),''),chr(10),'') as pay_type_name
,replace(replace(t1.api_code,chr(13),''),chr(10),'') as api_code
,pay_center_id
,data_source
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_user
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,create_time
,update_time
,cost_calculation_rules
,bill_calculation_rules
,deprecated
,priority
,replace(replace(t1.update_emp,chr(13),''),chr(10),'') as update_emp
,fld_n1
,fld_n2
,fld_n3
,fld_n4
,fld_n5
,replace(replace(t1.fld_s1,chr(13),''),chr(10),'') as fld_s1
,replace(replace(t1.fld_s2,chr(13),''),chr(10),'') as fld_s2
,replace(replace(t1.fld_s3,chr(13),''),chr(10),'') as fld_s3
,replace(replace(t1.fld_s4,chr(13),''),chr(10),'') as fld_s4
,replace(replace(t1.fld_s5,chr(13),''),chr(10),'') as fld_s5
,is_allow_activate
,product_type
,replace(replace(t1.pay_accept_org,chr(13),''),chr(10),'') as pay_accept_org

from ${iol_schema}.amss_tra_pay_type t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_tra_pay_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
