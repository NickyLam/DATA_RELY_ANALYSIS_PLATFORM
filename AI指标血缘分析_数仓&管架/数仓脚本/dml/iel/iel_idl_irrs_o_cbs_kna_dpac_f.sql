: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_cbs_kna_dpac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_cbs_kna_dpac_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
acctid
,crcycd
,csextg
,acctna
,brchno
,dtitcd
,debttp
,cuinme
,accstp
,daabtg
,bgindt
,acmldt
,acctst
,accst2
,lwstbl
,instrt
,lsatdt
,lstrdt
,lstrsq
,spectp
,opendt
,optrsq
,closdt
,cltrsq
,sleptg
,acustg
from idl.irrs_o_cbs_kna_dpac
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_cbs_kna_dpac_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes