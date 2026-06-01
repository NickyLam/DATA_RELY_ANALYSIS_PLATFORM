: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lns_lncf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lns_lncf_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select CMSQNO
,RECVDT
,RECVTM
,DISBDT
,DISBSQ
,LNCFNO
,ITEMCD
,LOANTP
,LOANCN
,CUSTNO
,RECVAC
,SUBSAC
,DPACNO
,INPYAC
,CMITAC
,CMDPAC
,TRANBR
,BRCHNO
,MATUDT
,TERMCD
,CRCYCD
,INITAM
,CLCPTG
,CLINTG
,RPCODE
,LNRTTP
,FLOART
,NPFLRT
,CNTRIR
,OVDUIR
,RETNFS
,IPCODE
,AZCODE
,TORPTM
,INDDRT
,IDMUDT
,WNGPCD
,LNCMTG
,LNCMTP
,TRANST
,CMSBAC
,CNTRTP
,CUSTMG
,REINST
,LNPPCD
,ENPDTP
,ENPDOP
,ENPDAM
,RETNDT
,PRODCD
,FEESTP
,FEESAM
,LNUSTP
,HDINTG
,ISPLAN
,FINATP
,CNSGAM
,INDSTG
,CNTRNO from IDL.ODSS_LNS_LNCF where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lns_lncf_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes