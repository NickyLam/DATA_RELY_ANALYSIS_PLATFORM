: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_cns_crqt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_cns_crqt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select CRQTNO
,CRCNTP
,CONFTP
,CRQTDT
,CRQTSQ
,CRQTBR
,DPACID
,CARDNO
,LNACID
,PLDGAM
,STPYDT
,STPYSQ
,CRCYCD
,CRDQUT
,ONLNQT
,QTMUDT
,INRTTP
,NMFLRT
,OVFLRT
,CLOSDT
,CLOSSQ
,CLOSTP
,CRQTST
,CNTRNO
,SUBSAC
,FROZAM from IDL.ODSS_CNS_CRQT where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_cns_crqt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes