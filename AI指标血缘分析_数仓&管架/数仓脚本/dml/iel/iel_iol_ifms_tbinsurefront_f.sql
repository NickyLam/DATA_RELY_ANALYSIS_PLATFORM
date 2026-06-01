: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbinsurefront_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifms_tbinsurefront.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trans_code,chr(13),''),chr(10),'') as trans_code
,replace(replace(t.ta_code,chr(13),''),chr(10),'') as ta_code
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.title_name,chr(13),''),chr(10),'') as title_name
,replace(replace(t.field_name,chr(13),''),chr(10),'') as field_name
,replace(replace(t.input_type,chr(13),''),chr(10),'') as input_type
,replace(replace(t.attr_type,chr(13),''),chr(10),'') as attr_type
,replace(replace(t.spec_type,chr(13),''),chr(10),'') as spec_type
,replace(replace(t.show_value,chr(13),''),chr(10),'') as show_value
,replace(replace(t.fix_value,chr(13),''),chr(10),'') as fix_value
,replace(replace(t.fix_valuename,chr(13),''),chr(10),'') as fix_valuename
,replace(replace(t.required,chr(13),''),chr(10),'') as required
,replace(replace(t.hs_key,chr(13),''),chr(10),'') as hs_key
,replace(replace(t.order_no,chr(13),''),chr(10),'') as order_no
,replace(replace(t.belongtype,chr(13),''),chr(10),'') as belongtype
,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ifms_tbinsurefront t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbinsurefront.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes