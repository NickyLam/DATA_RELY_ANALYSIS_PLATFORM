: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_dmm_cust_loan_ovdue_his_info_f
CreateDate: 20250926
FileName:   ${iel_data_path}/dmm_cust_loan_ovdue_his_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,max_ovdue_day_t
,max_ovdue_day_n
,ovdue_month_cnt

from ${idl_schema}.dmm_cust_loan_ovdue_his_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dmm_cust_loan_ovdue_his_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
