: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ftps_rpt_loan_adiust_ftp_info_rpm_a
CreateDate: 20250305
FileName:   ${iel_data_path}/ftps_rpt_loan_adiust_ftp_info_rpm.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,data_date
,replace(replace(t1.adjust_num,chr(13),''),chr(10),'') as adjust_num
,replace(replace(t1.adjust_name,chr(13),''),chr(10),'') as adjust_name
,replace(replace(t1.pre_object,chr(13),''),chr(10),'') as pre_object
,replace(replace(t1.is_add,chr(13),''),chr(10),'') as is_add
,adjust_ftp_rate

from ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ftps_rpt_loan_adiust_ftp_info_rpm.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
