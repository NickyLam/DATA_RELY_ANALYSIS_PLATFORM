: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amls_t00_user_i
CreateDate: 20241118
FileName:   ${iel_data_path}/amls_t00_user.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.organkey,chr(13),''),chr(10),'') as organkey
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.isbuildin,chr(13),''),chr(10),'') as isbuildin
,replace(replace(t1.isadmin,chr(13),''),chr(10),'') as isadmin
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.postalcode,chr(13),''),chr(10),'') as postalcode
,replace(replace(t1.emailaddress,chr(13),''),chr(10),'') as emailaddress
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.mobilephone,chr(13),''),chr(10),'') as mobilephone
,replace(replace(t1.des,chr(13),''),chr(10),'') as des
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.birth,chr(13),''),chr(10),'') as birth
,replace(replace(t1.education,chr(13),''),chr(10),'') as education
,replace(replace(t1.isnewuser,chr(13),''),chr(10),'') as isnewuser
,replace(replace(t1.position,chr(13),''),chr(10),'') as position
,replace(replace(t1.postitle,chr(13),''),chr(10),'') as postitle
,replace(replace(t1.worklevel,chr(13),''),chr(10),'') as worklevel
,replace(replace(t1.political,chr(13),''),chr(10),'') as political
,replace(replace(t1.indate,chr(13),''),chr(10),'') as indate
,replace(replace(t1.stafcode,chr(13),''),chr(10),'') as stafcode
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.modifydate,chr(13),''),chr(10),'') as modifydate
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.color,chr(13),''),chr(10),'') as color
,replace(replace(t1.indextemplate,chr(13),''),chr(10),'') as indextemplate
,wrongpassword
,replace(replace(t1.defgroupkey,chr(13),''),chr(10),'') as defgroupkey
,replace(replace(t1.template_id,chr(13),''),chr(10),'') as template_id
,replace(replace(t1.template_name,chr(13),''),chr(10),'') as template_name
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.realname,chr(13),''),chr(10),'') as realname
,replace(replace(t1.password,chr(13),''),chr(10),'') as password

from ${iol_schema}.amls_t00_user t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t00_user.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
