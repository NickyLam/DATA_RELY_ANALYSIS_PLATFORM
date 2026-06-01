: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ftps_rpt_loan_other_ftp_info_rpm_i
CreateDate: 20250218
FileName:   ${iel_data_path}/ftps_rpt_loan_other_ftp_info_rpm.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,data_date
,replace(replace(t1.ftp_tp,chr(13),''),chr(10),'') as ftp_tp
,ftp_rate

from ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ftps_rpt_loan_other_ftp_info_rpm.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
