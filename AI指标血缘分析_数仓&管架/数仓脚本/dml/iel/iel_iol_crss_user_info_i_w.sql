: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_user_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_user_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(loginid,chr(10),''),chr(13),'') as loginid
,replace(replace(username,chr(10),''),chr(13),'') as username
,replace(replace(password,chr(10),''),chr(13),'') as password
,replace(replace(belongorg,chr(10),''),chr(13),'') as belongorg
,replace(replace(attribute1,chr(10),''),chr(13),'') as attribute1
,replace(replace(attribute2,chr(10),''),chr(13),'') as attribute2
,replace(replace(attribute3,chr(10),''),chr(13),'') as attribute3
,replace(replace(attribute4,chr(10),''),chr(13),'') as attribute4
,replace(replace(attribute5,chr(10),''),chr(13),'') as attribute5
,replace(replace(attribute6,chr(10),''),chr(13),'') as attribute6
,replace(replace(attribute7,chr(10),''),chr(13),'') as attribute7
,replace(replace(attribute8,chr(10),''),chr(13),'') as attribute8
,replace(replace(attribute,chr(10),''),chr(13),'') as attribute
,replace(replace(describe1,chr(10),''),chr(13),'') as describe1
,replace(replace(describe2,chr(10),''),chr(13),'') as describe2
,replace(replace(describe3,chr(10),''),chr(13),'') as describe3
,replace(replace(describe4,chr(10),''),chr(13),'') as describe4
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(certtype,chr(10),''),chr(13),'') as certtype
,replace(replace(certid,chr(10),''),chr(13),'') as certid
,replace(replace(companytel,chr(10),''),chr(13),'') as companytel
,replace(replace(mobiletel,chr(10),''),chr(13),'') as mobiletel
,replace(replace(email,chr(10),''),chr(13),'') as email
,replace(replace(accountid,chr(10),''),chr(13),'') as accountid
,replace(replace(id1,chr(10),''),chr(13),'') as id1
,replace(replace(id2,chr(10),''),chr(13),'') as id2
,replace(replace(sum1,chr(10),''),chr(13),'') as sum1
,replace(replace(sum2,chr(10),''),chr(13),'') as sum2
,replace(replace(inputorg,chr(10),''),chr(13),'') as inputorg
,replace(replace(inputuser,chr(10),''),chr(13),'') as inputuser
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(inputtime,chr(10),''),chr(13),'') as inputtime
,replace(replace(updateuser,chr(10),''),chr(13),'') as updateuser
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(birthday,chr(10),''),chr(13),'') as birthday
,replace(replace(gender,chr(10),''),chr(13),'') as gender
,replace(replace(familyadd,chr(10),''),chr(13),'') as familyadd
,replace(replace(educationalbg,chr(10),''),chr(13),'') as educationalbg
,replace(replace(amlevel,chr(10),''),chr(13),'') as amlevel
,replace(replace(title,chr(10),''),chr(13),'') as title
,replace(replace(educationexp,chr(10),''),chr(13),'') as educationexp
,replace(replace(vocationexp,chr(10),''),chr(13),'') as vocationexp
,replace(replace(position,chr(10),''),chr(13),'') as position
,replace(replace(qualification,chr(10),''),chr(13),'') as qualification
,replace(replace(ntid,chr(10),''),chr(13),'') as ntid
,replace(replace(belongteam,chr(10),''),chr(13),'') as belongteam
,replace(replace(lob,chr(10),''),chr(13),'') as lob
,replace(replace(approvelorg,chr(10),''),chr(13),'') as approvelorg
,replace(replace(isinuse,chr(10),''),chr(13),'') as isinuse
,replace(replace(queryorg,chr(10),''),chr(13),'') as queryorg
,replace(replace(accountorg,chr(10),''),chr(13),'') as accountorg
,replace(replace(employeeid,chr(10),''),chr(13),'') as employeeid
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_user_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_user_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes