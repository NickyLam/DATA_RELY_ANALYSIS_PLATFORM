: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kns_tran_glob_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kns_tran_glob.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.globsq,chr(13),''),chr(10),'') as globsq
,replace(replace(t1.trsqno,chr(13),''),chr(10),'') as trsqno
 from iol.cbss_kns_tran_glob T1
where to_char(trandt)= '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kns_tran_glob.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes