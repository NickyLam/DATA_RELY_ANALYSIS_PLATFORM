: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kdl_wrof_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kdl_wrof_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select DCMTTP
,DCMTNO
,BTCHNO
,DCTPID
,INVODT
,TRANDT
,TRANSQ from IDL.ODSS_KDL_WROF where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kdl_wrof_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes