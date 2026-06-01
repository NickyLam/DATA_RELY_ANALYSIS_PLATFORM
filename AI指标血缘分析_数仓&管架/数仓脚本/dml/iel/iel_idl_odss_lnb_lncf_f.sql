: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lnb_lncf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lnb_lncf_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select LNCFNO
,ACCTID
,LNCFNA
,BRCHNO
,PRODCD
,DTITCD
,LOANCN
,DPACNO
,INPYAC
,CMITAC
,CMDPAC
,LOANTP
,CRCNTP
,COACID
,TERMCD
,DISBDT
,DISBSQ
,MATUDT
,PRLNTG
,UNPRDT
,CRCYCD
,INITAM
,CLCPTG
,CLINTG
,RMCODE
,RPCODE
,LNRTTP
,FLOART
,NPFLRT
,INRTDT
,NXINDT
,CNTRIR
,OVDUIR
,RETNFS
,IPCODE
,NXIPDT
,VLSLDT
,AZCODE
,NXISDT
,TORPTM
,CURRTM
,EPPYAM
,INDDRT
,IDMUDT
,CLOSDT
,CLOSSQ
,TAXSTG
,DSCRTX
,CMSQNO
,OVDUDT
,WNGPCD
,INDSTG
,HDINTG
,HDINDT
,HDINSQ
,LNCFST
,LSLNST
,DEVLTG
,CNTRTP
,REINST
,RETNDT
,ENPDTP
,ENPDOP
,ENPDAM
,LNPPCD
,CUSTMG
,FEESTP
,FEESAM
,ISPLAN
,FINATP
,LNUSTP
,CNSGAM
,HXDLFG from IDL.ODSS_LNB_LNCF where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lnb_lncf_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes