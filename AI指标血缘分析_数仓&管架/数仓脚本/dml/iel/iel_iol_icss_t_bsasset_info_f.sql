: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_bsasset_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_bsasset_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
,t.businesssum as businesssum
,replace(replace(t.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate
from ${iol_schema}.icss_t_bsasset_info t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_bsasset_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes