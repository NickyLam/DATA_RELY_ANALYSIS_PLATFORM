: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kns_cmdd_pyin_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kns_cmdd_pyin_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,PYINSQ
,TRANSQ
,TRANBR
,TRANTP
,CRCYCD
,TRANAM
,ININID
,ACCTBR
,ACCTID
,ACCTNO
,SUBSAC
,DTITCD
,INPYTP
,STDATE
,EDDATE
,ACMLBL
,INSTRT
,INRTTP
,SCHLPV
,HOLIDY
,CORRTG
,BKFNST
,CALCFG from IDL.ODSS_KNS_CMDD_PYIN where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kns_cmdd_pyin_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes