: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_fcs_list_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_fcs_list_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,TRANBR
,TRANUS
,FORETP
,FOSBTP
,PROJTG
,BYCRCY
,BYACCT
,BYSUBC
,BYCSEX
,BYEXRT
,BYTREX
,BYTRAM
,INBYPR
,SLCRCY
,SLACCT
,SLSUBC
,SLCSEX
,SLEXRT
,SLTREX
,SLTRAM
,MIDDCY
,MIDDAM
,INSLPR
,CUSTNO
,CUSTNA
,PRFPOT
,NATNTY
,IDTFTP
,IDTFNO
,BJTIME
,BUSITP
,BYSLTG
,TRANST
,ISRETN from IDL.ODSS_FCS_LIST where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_fcs_list_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes