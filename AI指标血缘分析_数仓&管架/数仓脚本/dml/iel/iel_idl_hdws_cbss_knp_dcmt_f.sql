: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_knp_dcmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_knp_dcmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.dcmttp
,t1.dcmtna
,t1.dcsmna
,t1.dcmtkd
,t1.dcmtfs
,t1.dcmtlt
,t1.btchlt
,t1.btchno
,t1.ebdcnm
,t1.setltp
,t1.selfdc
,t1.csbxtg
,t1.saletg
,t1.brchct
,t1.secuty
,t1.dctptp
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_knp_dcmt t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_knp_dcmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes