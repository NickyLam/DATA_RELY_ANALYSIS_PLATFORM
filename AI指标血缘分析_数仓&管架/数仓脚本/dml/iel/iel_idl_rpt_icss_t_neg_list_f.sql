: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_neg_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_neg_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.negativetype,chr(13),''),chr(10),'') as negativetype
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t1.outlisttime,chr(13),''),chr(10),'') as outlisttime
 from iol.icss_t_neg_list T1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_neg_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes