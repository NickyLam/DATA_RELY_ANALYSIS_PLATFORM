: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_knb_ocac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_knb_ocac.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t.opiasq,chr(13),''),chr(10),'') as opiasq
,replace(replace(t.opensq,chr(13),''),chr(10),'') as opensq
,replace(replace(t.opactp,chr(13),''),chr(10),'') as opactp
,replace(replace(t.opbrno,chr(13),''),chr(10),'') as opbrno
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t.clossq,chr(13),''),chr(10),'') as clossq
,replace(replace(t.clactp,chr(13),''),chr(10),'') as clactp
from ${iol_schema}.cbss_knb_ocac t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_knb_ocac.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes