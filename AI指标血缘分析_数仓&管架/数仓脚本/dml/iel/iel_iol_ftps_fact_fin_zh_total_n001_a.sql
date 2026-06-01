: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ftps_fact_fin_zh_total_n001_a
CreateDate: 20240719
FileName:   ${iel_data_path}/ftps_fact_fin_zh_total_n001.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,data_dt
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.currency_code,chr(13),''),chr(10),'') as currency_code
,replace(replace(t1.subject_type,chr(13),''),chr(10),'') as subject_type
,replace(replace(t1.department,chr(13),''),chr(10),'') as department
,replace(replace(t1.fin_group,chr(13),''),chr(10),'') as fin_group
,replace(replace(t1.range_cd,chr(13),''),chr(10),'') as range_cd
,replace(replace(t1.range_name,chr(13),''),chr(10),'') as range_name
,cur_bal
,accbal_month
,accbal_quar
,accbal_year
,final_ftp_accint_day
,final_ftp_accint_month
,final_ftp_accint_quar
,final_ftp_accint_year
,accint_day
,accint_month
,accint_quar
,accint_year
,avgbal_month
,avgbal_year
,t_days
,replace(replace(t1.subject_code,chr(13),''),chr(10),'') as subject_code
,replace(replace(t1.tp_fund,chr(13),''),chr(10),'') as tp_fund
,replace(replace(t1.tp_ftp,chr(13),''),chr(10),'') as tp_ftp

from ${iol_schema}.ftps_fact_fin_zh_total_n001 t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ftps_fact_fin_zh_total_n001.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
