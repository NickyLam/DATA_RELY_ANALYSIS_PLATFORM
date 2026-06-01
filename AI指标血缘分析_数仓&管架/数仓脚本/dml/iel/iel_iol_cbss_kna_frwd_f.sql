: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_frwd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_frwd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t.cyovdt,chr(13),''),chr(10),'') as cyovdt
,replace(replace(t.cyovsq,chr(13),''),chr(10),'') as cyovsq
,t.cytlam as cytlam
,t.cyprin as cyprin
,t.cyinst as cyinst
,replace(replace(t.rttrdt,chr(13),''),chr(10),'') as rttrdt
,replace(replace(t.rttrsq,chr(13),''),chr(10),'') as rttrsq
,replace(replace(t.dtitcd,chr(13),''),chr(10),'') as dtitcd
,replace(replace(t.toacct,chr(13),''),chr(10),'') as toacct
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t.erortx,chr(13),''),chr(10),'') as erortx
,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_frwd t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_frwd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes