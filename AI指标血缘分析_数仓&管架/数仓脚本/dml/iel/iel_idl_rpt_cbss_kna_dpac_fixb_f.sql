: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kna_dpac_fixb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kna_dpac_fixb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t1.termcd,chr(13),''),chr(10),'') as termcd
,replace(replace(t1.matudt,chr(13),''),chr(10),'') as matudt
,replace(replace(t1.autdtg,chr(13),''),chr(10),'') as autdtg
,t1.autdct as autdct
,t1.etddam as etddam
,t1.dfltam as dfltam
,t1.dfltal as dfltal
,t1.rldfam as rldfam
,t1.oncebk as oncebk
,t1.oncead as oncead
,t1.oncedf as oncedf
,replace(replace(t1.bdacct,chr(13),''),chr(10),'') as bdacct
,replace(replace(t1.busitp,chr(13),''),chr(10),'') as busitp
,replace(replace(t1.aldrdt,chr(13),''),chr(10),'') as aldrdt
,t1.cntrrt as cntrrt
,replace(replace(t1.cntrno,chr(13),''),chr(10),'') as cntrno
,replace(replace(t1.pyinfg,chr(13),''),chr(10),'') as pyinfg
 from iol.cbss_kna_dpac_fixb T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kna_dpac_fixb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes