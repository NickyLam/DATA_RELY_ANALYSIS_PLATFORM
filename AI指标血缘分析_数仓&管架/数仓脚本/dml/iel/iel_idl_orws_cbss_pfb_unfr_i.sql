: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_cbss_pfb_unfr_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_cbss_pfb_unfr.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.unfrdt,chr(13),''),chr(10),'') as unfrdt
,replace(replace(t1.unfrsq,chr(13),''),chr(10),'') as unfrsq
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.unfrfs,chr(13),''),chr(10),'') as unfrfs
,replace(replace(t1.unidtp,chr(13),''),chr(10),'') as unidtp
,replace(replace(t1.unidno,chr(13),''),chr(10),'') as unidno
,replace(replace(t1.unorgn,chr(13),''),chr(10),'') as unorgn
,replace(replace(t1.uncutp,chr(13),''),chr(10),'') as uncutp
,replace(replace(t1.uncuno,chr(13),''),chr(10),'') as uncuno
,replace(replace(t1.unctp2,chr(13),''),chr(10),'') as unctp2
,replace(replace(t1.uncno2,chr(13),''),chr(10),'') as uncno2
,replace(replace(t1.uncuna,chr(13),''),chr(10),'') as uncuna
,replace(replace(t1.unfrmk,chr(13),''),chr(10),'') as unfrmk
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.frozdt,chr(13),''),chr(10),'') as frozdt
,replace(replace(t1.frozsq,chr(13),''),chr(10),'') as frozsq
,t1.unfram as unfram
,replace(replace(t1.ununa2,chr(13),''),chr(10),'') as ununa2
from ${iol_schema}.cbss_pfb_unfr t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_cbss_pfb_unfr.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes