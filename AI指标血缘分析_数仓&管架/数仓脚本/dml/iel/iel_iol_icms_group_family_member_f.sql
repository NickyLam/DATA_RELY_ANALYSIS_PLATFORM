: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_group_family_member_f
CreateDate: 20240906
FileName:   ${iel_data_path}/icms_group_family_member.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.memberid,chr(13),''),chr(10),'') as memberid
,replace(replace(t1.groupid,chr(13),''),chr(10),'') as groupid
,replace(replace(t1.oldmembertype,chr(13),''),chr(10),'') as oldmembertype
,replace(replace(t1.membercustomerid,chr(13),''),chr(10),'') as membercustomerid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.membername,chr(13),''),chr(10),'') as membername
,replace(replace(t1.membercertid,chr(13),''),chr(10),'') as membercertid
,replace(replace(t1.membercerttype,chr(13),''),chr(10),'') as membercerttype
,replace(replace(t1.reviseflag,chr(13),''),chr(10),'') as reviseflag
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,inputdate
,replace(replace(t1.parentrelationtype,chr(13),''),chr(10),'') as parentrelationtype
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.parentmemberid,chr(13),''),chr(10),'') as parentmemberid
,replace(replace(t1.versionseq,chr(13),''),chr(10),'') as versionseq
,replace(replace(t1.oldparentrelationtype,chr(13),''),chr(10),'') as oldparentrelationtype
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.joinreason,chr(13),''),chr(10),'') as joinreason
,replace(replace(t1.membertype,chr(13),''),chr(10),'') as membertype
,oldsharevalue
,updatedate
,replace(replace(t1.oldmembercustomerid,chr(13),''),chr(10),'') as oldmembercustomerid
,replace(replace(t1.oldmembername,chr(13),''),chr(10),'') as oldmembername
,sharevalue
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid

from ${iol_schema}.icms_group_family_member t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_group_family_member.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
