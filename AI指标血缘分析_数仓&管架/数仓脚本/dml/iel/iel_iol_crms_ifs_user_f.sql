: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crms_ifs_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifs_user.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.userpswd,chr(13),''),chr(10),'') as userpswd
,replace(replace(t1.usercode,chr(13),''),chr(10),'') as usercode
,replace(replace(t1.brid,chr(13),''),chr(10),'') as brid
,replace(replace(t1.roleid,chr(13),''),chr(10),'') as roleid
,replace(replace(t1.staid,chr(13),''),chr(10),'') as staid
,replace(replace(t1.photofileid,chr(13),''),chr(10),'') as photofileid
,replace(replace(t1.department,chr(13),''),chr(10),'') as department
,replace(replace(t1.position,chr(13),''),chr(10),'') as position
,replace(replace(t1.userbid,chr(13),''),chr(10),'') as userbid
,replace(replace(t1.truststatus,chr(13),''),chr(10),'') as truststatus
,replace(replace(t1.trustmode,chr(13),''),chr(10),'') as trustmode
,t1.truststartdt as truststartdt
,t1.trustclosedt as trustclosedt
,replace(replace(t1.uservalidstatus,chr(13),''),chr(10),'') as uservalidstatus
,replace(replace(t1.userstatus,chr(13),''),chr(10),'') as userstatus
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,t1.birthday as birthday
,replace(replace(t1.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t1.education,chr(13),''),chr(10),'') as education
,replace(replace(t1.officephone,chr(13),''),chr(10),'') as officephone
,replace(replace(t1.homephone,chr(13),''),chr(10),'') as homephone
,replace(replace(t1.mobilephone,chr(13),''),chr(10),'') as mobilephone
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.emailpswd,chr(13),''),chr(10),'') as emailpswd
,replace(replace(t1.privateemail,chr(13),''),chr(10),'') as privateemail
,replace(replace(t1.privateemailsmtp,chr(13),''),chr(10),'') as privateemailsmtp
,replace(replace(t1.privateemailuser,chr(13),''),chr(10),'') as privateemailuser
,replace(replace(t1.privateemailpswd,chr(13),''),chr(10),'') as privateemailpswd
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certcode,chr(13),''),chr(10),'') as certcode
,t1.empdate as empdate
,replace(replace(t1.userlockstatus,chr(13),''),chr(10),'') as userlockstatus
,t1.lockdt as lockdt
,replace(replace(t1.userloginstatus,chr(13),''),chr(10),'') as userloginstatus
,replace(replace(t1.lastinvalidloginid,chr(13),''),chr(10),'') as lastinvalidloginid
,replace(replace(t1.lastvalidloginid,chr(13),''),chr(10),'') as lastvalidloginid
,t1.invalidlogintime as invalidlogintime
,t1.invalidlogindt as invalidlogindt
,t1.updatepswddt as updatepswddt
,replace(replace(t1.enableflag,chr(13),''),chr(10),'') as enableflag
,t1.enabledt as enabledt
,replace(replace(t1.smssign,chr(13),''),chr(10),'') as smssign
,replace(replace(t1.emailsign,chr(13),''),chr(10),'') as emailsign
,replace(replace(t1.ispresetup,chr(13),''),chr(10),'') as ispresetup
,replace(replace(t1.skinname,chr(13),''),chr(10),'') as skinname
,replace(replace(t1.pendids,chr(13),''),chr(10),'') as pendids
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.userdesc,chr(13),''),chr(10),'') as userdesc
,t1.createdt as createdt
,replace(replace(t1.createuserid,chr(13),''),chr(10),'') as createuserid
,t1.lastupdatedt as lastupdatedt
,replace(replace(t1.lastupdateuserid,chr(13),''),chr(10),'') as lastupdateuserid
,replace(replace(t1.subbankid,chr(13),''),chr(10),'') as subbankid
,t1.recycleflag as recycleflag
,t1.recycledt as recycledt
,replace(replace(t1.recycleuserid,chr(13),''),chr(10),'') as recycleuserid
,replace(replace(t1.userpyname,chr(13),''),chr(10),'') as userpyname
,replace(replace(t1.isprocm,chr(13),''),chr(10),'') as isprocm
,replace(replace(t1.techtitle,chr(13),''),chr(10),'') as techtitle
,replace(replace(t1.birthyear,chr(13),''),chr(10),'') as birthyear
,replace(replace(t1.birthmonday,chr(13),''),chr(10),'') as birthmonday
,t1.lastlogindt as lastlogindt
,replace(replace(t1.lastinvalidip,chr(13),''),chr(10),'') as lastinvalidip
,replace(replace(t1.lastvalidip,chr(13),''),chr(10),'') as lastvalidip
,replace(replace(t1.university,chr(13),''),chr(10),'') as university
,replace(replace(t1.userlevel,chr(13),''),chr(10),'') as userlevel
,replace(replace(t1.specialty,chr(13),''),chr(10),'') as specialty
,replace(replace(t1.lastcheck,chr(13),''),chr(10),'') as lastcheck
,t1.cmbcdate as cmbcdate
,replace(replace(t1.certflag,chr(13),''),chr(10),'') as certflag
,replace(replace(t1.qualityflag,chr(13),''),chr(10),'') as qualityflag
,replace(replace(t1.traindesc,chr(13),''),chr(10),'') as traindesc
,replace(replace(t1.employcode,chr(13),''),chr(10),'') as employcode
,replace(replace(t1.rolegroup,chr(13),''),chr(10),'') as rolegroup
,replace(replace(t1.roledept,chr(13),''),chr(10),'') as roledept
,replace(replace(t1.mageorg,chr(13),''),chr(10),'') as mageorg
,replace(replace(t1.subbrid,chr(13),''),chr(10),'') as subbrid
,t1.pactbeginym as pactbeginym
,t1.pactendym as pactendym
,replace(replace(t1.astinfo,chr(13),''),chr(10),'') as astinfo
,replace(replace(t1.fileid,chr(13),''),chr(10),'') as fileid
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno
,t1.updatedate as updatedate
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
from iol.crms_ifs_user t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crms_ifs_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes