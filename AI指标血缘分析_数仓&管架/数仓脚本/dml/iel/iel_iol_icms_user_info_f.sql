: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_user_info_f
CreateDate: 20260113
FileName:   ${iel_data_path}/icms_user_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t1.updatedate,chr(13),''),chr(10),'') as updatedate
,replace(replace(t1.skinpath,chr(13),''),chr(10),'') as skinpath
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.describe4,chr(13),''),chr(10),'') as describe4
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.companytel,chr(13),''),chr(10),'') as companytel
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.loginid,chr(13),''),chr(10),'') as loginid
,replace(replace(t1.password,chr(13),''),chr(10),'') as password
,replace(replace(t1.describe3,chr(13),''),chr(10),'') as describe3
,replace(replace(t1.ntid,chr(13),''),chr(10),'') as ntid
,replace(replace(t1.language,chr(13),''),chr(10),'') as language
,replace(replace(t1.attribute8,chr(13),''),chr(10),'') as attribute8
,birthday
,replace(replace(t1.belongorg,chr(13),''),chr(10),'') as belongorg
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.workbench,chr(13),''),chr(10),'') as workbench
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg
,replace(replace(t1.id1,chr(13),''),chr(10),'') as id1
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,sum2
,replace(replace(t1.position,chr(13),''),chr(10),'') as position
,replace(replace(t1.attribute6,chr(13),''),chr(10),'') as attribute6
,replace(replace(t1.belongteam,chr(13),''),chr(10),'') as belongteam
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.attribute5,chr(13),''),chr(10),'') as attribute5
,replace(replace(t1.describe2,chr(13),''),chr(10),'') as describe2
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.accountid,chr(13),''),chr(10),'') as accountid
,replace(replace(t1.title,chr(13),''),chr(10),'') as title
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.describe1,chr(13),''),chr(10),'') as describe1
,replace(replace(t1.mobiletel,chr(13),''),chr(10),'') as mobiletel
,sum1
,replace(replace(t1.vocationexp,chr(13),''),chr(10),'') as vocationexp
,replace(replace(t1.wfiifmsg,chr(13),''),chr(10),'') as wfiifmsg
,replace(replace(t1.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t1.attribute7,chr(13),''),chr(10),'') as attribute7
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.amlevel,chr(13),''),chr(10),'') as amlevel
,replace(replace(t1.educationexp,chr(13),''),chr(10),'') as educationexp
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t1.educationalbg,chr(13),''),chr(10),'') as educationalbg
,replace(replace(t1.lob,chr(13),''),chr(10),'') as lob
,replace(replace(t1.updatetime,chr(13),''),chr(10),'') as updatetime
,replace(replace(t1.finabrid,chr(13),''),chr(10),'') as finabrid
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.id2,chr(13),''),chr(10),'') as id2
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t1.attribute,chr(13),''),chr(10),'') as attribute
,replace(replace(t1.qualification,chr(13),''),chr(10),'') as qualification
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.familyadd,chr(13),''),chr(10),'') as familyadd
,replace(replace(t1.issynoaorg,chr(13),''),chr(10),'') as issynoaorg

from ${iol_schema}.icms_user_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_user_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
