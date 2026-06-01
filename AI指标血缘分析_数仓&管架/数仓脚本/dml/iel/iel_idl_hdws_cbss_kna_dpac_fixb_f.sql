: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_kna_dpac_fixb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_kna_dpac_fixb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.acctid
,t1.termcd
,t1.matudt
,t1.autdtg
,t1.autdct
,t1.etddam
,t1.dfltam
,t1.dfltal
,t1.rldfam
,t1.oncebk
,t1.oncead
,t1.oncedf
,t1.bdacct
,t1.busitp
,t1.aldrdt
,t1.cntrrt
,t1.cntrno
,t1.pyinfg
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_kna_dpac_fixb t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_kna_dpac_fixb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes