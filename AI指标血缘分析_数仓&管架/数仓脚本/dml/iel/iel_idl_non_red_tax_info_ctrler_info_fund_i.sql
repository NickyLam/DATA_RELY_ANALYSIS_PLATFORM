: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_non_red_tax_info_ctrler_info_fund_i
CreateDate: 20241230
FileName:   ${iel_data_path}/non_red_tax_info_ctrler_info_fund.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.acc_type,chr(13),''),chr(10),'') as acc_type
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,trans_date
,replace(replace(t1.full_name,chr(13),''),chr(10),'') as full_name
,replace(replace(t1.family_name,chr(13),''),chr(10),'') as family_name
,replace(replace(t1.first_name,chr(13),''),chr(10),'') as first_name
,replace(replace(t1.control_region_code,chr(13),''),chr(10),'') as control_region_code
,birthday
,replace(replace(t1.resident_tax_type,chr(13),''),chr(10),'') as resident_tax_type
,replace(replace(t1.born_nation,chr(13),''),chr(10),'') as born_nation
,replace(replace(t1.english_present_address,chr(13),''),chr(10),'') as english_present_address
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd

from ${idl_schema}.non_red_tax_info_ctrler_info_fund t1
where etl_dt = to_date('${batch_date}','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/non_red_tax_info_ctrler_info_fund.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes