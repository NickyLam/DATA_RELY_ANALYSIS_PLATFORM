: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_auth_user_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_auth_user.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.user_id as user_id
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,t1.i_id as i_id
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.mobile_num,chr(13),''),chr(10),'') as mobile_num
,replace(replace(t1.employee_card_no,chr(13),''),chr(10),'') as employee_card_no
,replace(replace(t1.full_chinese_spell,chr(13),''),chr(10),'') as full_chinese_spell
,replace(replace(t1.password,chr(13),''),chr(10),'') as password
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.birth_day,chr(13),''),chr(10),'') as birth_day
,t1.flag as flag
,t1.status as status
,replace(replace(t1.head_chinese_spell,chr(13),''),chr(10),'') as head_chinese_spell
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.is_first_login,chr(13),''),chr(10),'') as is_first_login
,replace(replace(t1.pwd_update_date,chr(13),''),chr(10),'') as pwd_update_date
,t1.input_pwd_error_times as input_pwd_error_times
,replace(replace(t1.password_history,chr(13),''),chr(10),'') as password_history
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,t1.update_user as update_user
,replace(replace(t1.qq_number,chr(13),''),chr(10),'') as qq_number

from ${iol_schema}.ibms_ttrd_auth_user t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_auth_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
