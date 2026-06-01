: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_s_dic_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_s_dic.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.enname,chr(13),''),chr(10),'') as enname
,replace(replace(t1.cnname,chr(13),''),chr(10),'') as cnname
,replace(replace(t1.opttype,chr(13),''),chr(10),'') as opttype
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.levels,chr(13),''),chr(10),'') as levels
,t1.orderid as orderid
 from iol.rcrs_s_dic T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_s_dic.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes