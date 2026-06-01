: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_auth_user_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_auth_user_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(user_id,chr(10),''),chr(13),'') as user_id
,replace(replace(user_name,chr(10),''),chr(13),'') as user_name
,replace(replace(i_id,chr(10),''),chr(13),'') as i_id
,replace(replace(email,chr(10),''),chr(13),'') as email
,replace(replace(tel_num,chr(10),''),chr(13),'') as tel_num
,replace(replace(mobile_num,chr(10),''),chr(13),'') as mobile_num
,replace(replace(employee_card_no,chr(10),''),chr(13),'') as employee_card_no
,replace(replace(full_chinese_spell,chr(10),''),chr(13),'') as full_chinese_spell
,replace(replace(password,chr(10),''),chr(13),'') as password
,replace(replace(account,chr(10),''),chr(13),'') as account
,replace(replace(birth_day,chr(10),''),chr(13),'') as birth_day
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(head_chinese_spell,chr(10),''),chr(13),'') as head_chinese_spell
,replace(replace(create_time,chr(10),''),chr(13),'') as create_time
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(is_first_login,chr(10),''),chr(13),'') as is_first_login
,replace(replace(pwd_update_date,chr(10),''),chr(13),'') as pwd_update_date
,replace(replace(input_pwd_error_times,chr(10),''),chr(13),'') as input_pwd_error_times
,replace(replace(password_history,chr(10),''),chr(13),'') as password_history
,replace(replace(state,chr(10),''),chr(13),'') as state
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(qq_number,chr(10),''),chr(13),'') as qq_number
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_auth_user
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_auth_user_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes