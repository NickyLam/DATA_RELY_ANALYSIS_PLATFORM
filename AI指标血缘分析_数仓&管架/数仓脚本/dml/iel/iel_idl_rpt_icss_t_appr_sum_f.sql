: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_appr_sum_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_appr_sum.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,t1.lmttotalamt as lmttotalamt
,t1.lmtusedamt as lmtusedamt
,t1.lmttotalck as lmttotalck
,t1.lmtusedck as lmtusedck
 from iol.icss_t_appr_sum T1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_appr_sum.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes