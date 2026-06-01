: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_inac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_inac.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t.dtitcd,chr(13),''),chr(10),'') as dtitcd
,replace(replace(t.blncdn,chr(13),''),chr(10),'') as blncdn
,replace(replace(t.acctst,chr(13),''),chr(10),'') as acctst
,replace(replace(t.lstrdt,chr(13),''),chr(10),'') as lstrdt
,replace(replace(t.lstrsq,chr(13),''),chr(10),'') as lstrsq
,replace(replace(t.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t.optrsq,chr(13),''),chr(10),'') as optrsq
,replace(replace(t.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t.cltrsq,chr(13),''),chr(10),'') as cltrsq
,replace(replace(t.ioflag,chr(13),''),chr(10),'') as ioflag
,replace(replace(t.serial,chr(13),''),chr(10),'') as serial
,replace(replace(t.spectg,chr(13),''),chr(10),'') as spectg
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_inac t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_inac.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes