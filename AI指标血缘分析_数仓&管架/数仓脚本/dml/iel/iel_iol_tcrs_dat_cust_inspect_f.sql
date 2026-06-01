: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_dat_cust_inspect_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_dat_cust_inspect.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.identity_no,chr(13),''),chr(10),'') as identity_no
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.business_type,chr(13),''),chr(10),'') as business_type
,replace(replace(t.check_result,chr(13),''),chr(10),'') as check_result
,replace(replace(t.issue_office,chr(13),''),chr(10),'') as issue_office
,replace(replace(t.photo_name,chr(13),''),chr(10),'') as photo_name
,replace(replace(t.photo_file,chr(13),''),chr(10),'') as photo_file
,replace(replace(t.check_channel,chr(13),''),chr(10),'') as check_channel
,replace(replace(t.tlr_no,chr(13),''),chr(10),'') as tlr_no
,replace(replace(t.brc_no,chr(13),''),chr(10),'') as brc_no
,replace(replace(t.tran_nbr,chr(13),''),chr(10),'') as tran_nbr
,replace(replace(t.tran_date,chr(13),''),chr(10),'') as tran_date
,replace(replace(t.work_date,chr(13),''),chr(10),'') as work_date
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_dat_cust_inspect t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_dat_cust_inspect.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes