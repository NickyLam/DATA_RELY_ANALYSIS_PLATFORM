: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_non_red_tax_info_mtbl_fund_a1
CreateDate: 20180529
FileName:   ${iel_data_path}/non_red_tax_info_mtbl_fund.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,acc_type
,account
,trans_date
,client_type
,resident_tax_type
,resident_inst_type
,english_name
,inst_nation
,inst_address
,english_inst_address
,chinese_name
,english_family_name
,english_first_name
,born_nation
,english_present_address
,present_nation
,present_address
,job_cd
from ${idl_schema}.non_red_tax_info_mtbl_fund t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/non_red_tax_info_mtbl_fund.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes