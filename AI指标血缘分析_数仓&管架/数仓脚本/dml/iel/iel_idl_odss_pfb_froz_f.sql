: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_pfb_froz_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_pfb_froz_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select FROZDT
,FROZSQ
,SORTNO
,TRANSQ
,FRSPTP
,SUSBTP
,STATUS
,ACCTNO
,SUBSAC
,ACCTNA
,REFRAM
,CUFRAM
,MATUDT
,IDTFTP
,IDTFNO
,REMKTX
,EXORGN
,EXIDTP
,EXIDNO
,EIDTP2
,EIDNO2
,EXUSNA
,EXUNA2
,USERID
,BRCHNO
,SERVTP from IDL.ODSS_PFB_FROZ where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_pfb_froz_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes