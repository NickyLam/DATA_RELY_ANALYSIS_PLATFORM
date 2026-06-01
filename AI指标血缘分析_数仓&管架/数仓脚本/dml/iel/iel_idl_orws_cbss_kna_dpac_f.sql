: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_cbss_kna_dpac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_cbss_kna_dpac.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t.csextg,chr(13),''),chr(10),'') as csextg
,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t.dtitcd,chr(13),''),chr(10),'') as dtitcd
,replace(replace(t.debttp,chr(13),''),chr(10),'') as debttp
,replace(replace(t.cuinme,chr(13),''),chr(10),'') as cuinme
,replace(replace(t.accstp,chr(13),''),chr(10),'') as accstp
,replace(replace(t.daabtg,chr(13),''),chr(10),'') as daabtg
,replace(replace(t.bgindt,chr(13),''),chr(10),'') as bgindt
,replace(replace(t.acmldt,chr(13),''),chr(10),'') as acmldt
,replace(replace(t.acctst,chr(13),''),chr(10),'') as acctst
,replace(replace(t.accst2,chr(13),''),chr(10),'') as accst2
,t.lwstbl as lwstbl
,t.instrt as instrt
,replace(replace(t.lsatdt,chr(13),''),chr(10),'') as lsatdt
,replace(replace(t.lstrdt,chr(13),''),chr(10),'') as lstrdt
,replace(replace(t.lstrsq,chr(13),''),chr(10),'') as lstrsq
,replace(replace(t.spectp,chr(13),''),chr(10),'') as spectp
,replace(replace(t.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t.optrsq,chr(13),''),chr(10),'') as optrsq
,replace(replace(t.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t.cltrsq,chr(13),''),chr(10),'') as cltrsq
,replace(replace(t.sleptg,chr(13),''),chr(10),'') as sleptg
,replace(replace(t.acustg,chr(13),''),chr(10),'') as acustg
,replace(replace(t.cairtg,chr(13),''),chr(10),'') as cairtg
,t.yirate as yirate
,replace(replace(t.obrchn,chr(13),''),chr(10),'') as obrchn
from ${iol_schema}.cbss_kna_dpac t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_cbss_kna_dpac.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes