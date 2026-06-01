: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_dpac_fixb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_dpac_fixb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t.termcd,chr(13),''),chr(10),'') as termcd
,replace(replace(t.matudt,chr(13),''),chr(10),'') as matudt
,replace(replace(t.autdtg,chr(13),''),chr(10),'') as autdtg
,t.autdct as autdct
,t.etddam as etddam
,t.dfltam as dfltam
,t.dfltal as dfltal
,t.rldfam as rldfam
,t.oncebk as oncebk
,t.oncead as oncead
,t.oncedf as oncedf
,replace(replace(t.bdacct,chr(13),''),chr(10),'') as bdacct
,replace(replace(t.busitp,chr(13),''),chr(10),'') as busitp
,replace(replace(t.aldrdt,chr(13),''),chr(10),'') as aldrdt
,t.cntrrt as cntrrt
,replace(replace(t.cntrno,chr(13),''),chr(10),'') as cntrno
,replace(replace(t.pyinfg,chr(13),''),chr(10),'') as pyinfg
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_dpac_fixb t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_dpac_fixb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes