: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_sm_user_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_sm_user.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.abledate,chr(13),''),chr(10),'') as abledate
,replace(replace(t1.agreementstatus,chr(13),''),chr(10),'') as agreementstatus
,base_doc_type
,replace(replace(t1.contentlang,chr(13),''),chr(10),'') as contentlang
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.cuserid,chr(13),''),chr(10),'') as cuserid
,dataoriginflag
,replace(replace(t1.disabledate,chr(13),''),chr(10),'') as disabledate
,dr
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,enablestate
,replace(replace(t1.format,chr(13),''),chr(10),'') as format
,replace(replace(t1.identityverifycode,chr(13),''),chr(10),'') as identityverifycode
,replace(replace(t1.isca,chr(13),''),chr(10),'') as isca
,replace(replace(t1.islocked,chr(13),''),chr(10),'') as islocked
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.pk_base_doc,chr(13),''),chr(10),'') as pk_base_doc
,replace(replace(t1.pk_customer,chr(13),''),chr(10),'') as pk_customer
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_supplier,chr(13),''),chr(10),'') as pk_supplier
,replace(replace(t1.pk_usergroupforcreate,chr(13),''),chr(10),'') as pk_usergroupforcreate
,pwderrorcount
,replace(replace(t1.pwdlevelcode,chr(13),''),chr(10),'') as pwdlevelcode
,replace(replace(t1.pwdparam,chr(13),''),chr(10),'') as pwdparam
,replace(replace(t1.secondverify,chr(13),''),chr(10),'') as secondverify
,replace(replace(t1.systype,chr(13),''),chr(10),'') as systype
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.user_code,chr(13),''),chr(10),'') as user_code
,replace(replace(t1.user_code_q,chr(13),''),chr(10),'') as user_code_q
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.user_name2,chr(13),''),chr(10),'') as user_name2
,replace(replace(t1.user_name3,chr(13),''),chr(10),'') as user_name3
,replace(replace(t1.user_name4,chr(13),''),chr(10),'') as user_name4
,replace(replace(t1.user_name5,chr(13),''),chr(10),'') as user_name5
,replace(replace(t1.user_name6,chr(13),''),chr(10),'') as user_name6
,replace(replace(t1.user_note,chr(13),''),chr(10),'') as user_note
,replace(replace(t1.user_password,chr(13),''),chr(10),'') as user_password
,user_type
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_sm_user t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_sm_user.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
