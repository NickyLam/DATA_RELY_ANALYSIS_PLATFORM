: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kna_dpac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kna_dpac_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select ACCTID
,CRCYCD
,CSEXTG
,ACCTNA
,BRCHNO
,DTITCD
,DEBTTP
,CUINME
,ACCSTP
,DAABTG
,BGINDT
,ACMLDT
,ACCTST
,ACCST2
,LWSTBL
,INSTRT
,LSATDT
,LSTRDT
,LSTRSQ
,SPECTP
,OPENDT
,OPTRSQ
,CLOSDT
,CLTRSQ
,SLEPTG
,ACUSTG from IDL.ODSS_KNA_DPAC where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kna_dpac_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes