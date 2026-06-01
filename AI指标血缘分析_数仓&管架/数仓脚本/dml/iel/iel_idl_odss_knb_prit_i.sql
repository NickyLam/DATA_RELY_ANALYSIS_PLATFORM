: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_knb_prit_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_knb_prit_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,BILLSQ
,BILLTP
,ACCTNO
,BRCHNO
,PRCSCD
,TRANSQ
,AMNTCD
,TRANAM
,SMRYCD
,DSCRTX
,DRACNO
,DRACNA
,CRACNO
,CRACNA
,PRINFO
,LASTUS
,PRITCT from IDL.ODSS_KNB_PRIT where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_knb_prit_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes