: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_kna_dpac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_kna_dpac.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.acctid
,t1.crcycd
,t1.csextg
,t1.acctna
,t1.brchno
,t1.dtitcd
,t1.debttp
,t1.cuinme
,t1.accstp
,t1.daabtg
,t1.bgindt
,t1.acmldt
,t1.acctst
,t1.accst2
,t1.lwstbl
,t1.instrt
,t1.lsatdt
,t1.lstrdt
,t1.lstrsq
,t1.spectp
,t1.opendt
,t1.optrsq
,t1.closdt
,t1.cltrsq
,t1.sleptg
,t1.acustg
,t1.cairtg
,t1.yirate
,t1.obrchn
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_kna_dpac t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_kna_dpac.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes