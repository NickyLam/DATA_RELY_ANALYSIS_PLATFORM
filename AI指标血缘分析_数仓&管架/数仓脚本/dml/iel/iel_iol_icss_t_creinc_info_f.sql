: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_creinc_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_creinc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t.increaseway,chr(13),''),chr(10),'') as increaseway
,replace(replace(t.ishxcustomer,chr(13),''),chr(10),'') as ishxcustomer
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
from ${iol_schema}.icss_t_creinc_info t 
where t.etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_creinc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes