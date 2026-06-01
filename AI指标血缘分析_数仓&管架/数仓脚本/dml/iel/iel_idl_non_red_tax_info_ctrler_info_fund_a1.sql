: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_non_red_tax_info_ctrler_info_fund_a1
CreateDate: 20180529
FileName:   ${iel_data_path}/non_red_tax_info_ctrler_info_fund.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,acc_type
,account
,trans_date
,full_name
,family_name
,first_name
,control_region_code
,birthday
,resident_tax_type
,born_nation
,english_present_address
,job_cd
from ${idl_schema}.non_red_tax_info_ctrler_info_fund t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/non_red_tax_info_ctrler_info_fund.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes