: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_tk_management_data_detail_a
CreateDate: 20250724
FileName:   ${iel_data_path}/icms_tk_management_data_detail.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.messageserialno,chr(13),''),chr(10),'') as messageserialno
,replace(replace(t1.field1,chr(13),''),chr(10),'') as field1
,replace(replace(t1.field2,chr(13),''),chr(10),'') as field2
,replace(replace(t1.field3,chr(13),''),chr(10),'') as field3
,replace(replace(t1.field4,chr(13),''),chr(10),'') as field4
,replace(replace(t1.field5,chr(13),''),chr(10),'') as field5
,replace(replace(t1.field6,chr(13),''),chr(10),'') as field6
,replace(replace(t1.field7,chr(13),''),chr(10),'') as field7
,replace(replace(t1.field8,chr(13),''),chr(10),'') as field8
,replace(replace(t1.field9,chr(13),''),chr(10),'') as field9
,replace(replace(t1.field10,chr(13),''),chr(10),'') as field10
,replace(replace(t1.field11,chr(13),''),chr(10),'') as field11
,replace(replace(t1.field12,chr(13),''),chr(10),'') as field12
,replace(replace(t1.field13,chr(13),''),chr(10),'') as field13
,replace(replace(t1.field14,chr(13),''),chr(10),'') as field14
,replace(replace(t1.field15,chr(13),''),chr(10),'') as field15
,replace(replace(t1.field16,chr(13),''),chr(10),'') as field16
,replace(replace(t1.field17,chr(13),''),chr(10),'') as field17
,replace(replace(t1.field18,chr(13),''),chr(10),'') as field18
,replace(replace(t1.field19,chr(13),''),chr(10),'') as field19
,replace(replace(t1.field20,chr(13),''),chr(10),'') as field20
,inputdate

from ${iol_schema}.icms_tk_management_data_detail t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tk_management_data_detail.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
