: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_non_red_tax_info_mtbl_fund_i
CreateDate: 20241230
FileName:   ${iel_data_path}/non_red_tax_info_mtbl_fund.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.acc_type,chr(13),''),chr(10),'') as acc_type
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,trans_date
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.resident_tax_type,chr(13),''),chr(10),'') as resident_tax_type
,replace(replace(t1.resident_inst_type,chr(13),''),chr(10),'') as resident_inst_type
,replace(replace(t1.english_name,chr(13),''),chr(10),'') as english_name
,replace(replace(t1.inst_nation,chr(13),''),chr(10),'') as inst_nation
,replace(replace(t1.inst_address,chr(13),''),chr(10),'') as inst_address
,replace(replace(t1.english_inst_address,chr(13),''),chr(10),'') as english_inst_address
,replace(replace(t1.chinese_name,chr(13),''),chr(10),'') as chinese_name
,replace(replace(t1.english_family_name,chr(13),''),chr(10),'') as english_family_name
,replace(replace(t1.english_first_name,chr(13),''),chr(10),'') as english_first_name
,replace(replace(t1.born_nation,chr(13),''),chr(10),'') as born_nation
,replace(replace(t1.english_present_address,chr(13),''),chr(10),'') as english_present_address
,replace(replace(t1.present_nation,chr(13),''),chr(10),'') as present_nation
,replace(replace(t1.present_address,chr(13),''),chr(10),'') as present_address
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd

from ${idl_schema}.non_red_tax_info_mtbl_fund t1
where etl_dt = to_date('${batch_date}','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/non_red_tax_info_mtbl_fund.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes