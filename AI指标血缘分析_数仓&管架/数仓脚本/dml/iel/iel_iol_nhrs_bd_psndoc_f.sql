: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_bd_psndoc_f
CreateDate: 20251222
FileName:   ${iel_data_path}/nhrs_bd_psndoc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.birthdate,chr(13),''),chr(10),'') as birthdate
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dataoriginflag
,replace(replace(t1.def1,chr(13),''),chr(10),'') as def1
,replace(replace(t1.def10,chr(13),''),chr(10),'') as def10
,replace(replace(t1.def11,chr(13),''),chr(10),'') as def11
,replace(replace(t1.def12,chr(13),''),chr(10),'') as def12
,replace(replace(t1.def13,chr(13),''),chr(10),'') as def13
,replace(replace(t1.def14,chr(13),''),chr(10),'') as def14
,replace(replace(t1.def15,chr(13),''),chr(10),'') as def15
,replace(replace(t1.def16,chr(13),''),chr(10),'') as def16
,replace(replace(t1.def17,chr(13),''),chr(10),'') as def17
,replace(replace(t1.def18,chr(13),''),chr(10),'') as def18
,replace(replace(t1.def19,chr(13),''),chr(10),'') as def19
,replace(replace(t1.def2,chr(13),''),chr(10),'') as def2
,replace(replace(t1.def20,chr(13),''),chr(10),'') as def20
,replace(replace(t1.def3,chr(13),''),chr(10),'') as def3
,replace(replace(t1.def4,chr(13),''),chr(10),'') as def4
,replace(replace(t1.def5,chr(13),''),chr(10),'') as def5
,replace(replace(t1.def6,chr(13),''),chr(10),'') as def6
,replace(replace(t1.def7,chr(13),''),chr(10),'') as def7
,replace(replace(t1.def8,chr(13),''),chr(10),'') as def8
,replace(replace(t1.def9,chr(13),''),chr(10),'') as def9
,dr
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,enablestate
,replace(replace(t1.homephone,chr(13),''),chr(10),'') as homephone
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,idtype
,replace(replace(t1.isshopassist,chr(13),''),chr(10),'') as isshopassist
,replace(replace(t1.joinworkdate,chr(13),''),chr(10),'') as joinworkdate
,replace(replace(t1.mnecode,chr(13),''),chr(10),'') as mnecode
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.name2,chr(13),''),chr(10),'') as name2
,replace(replace(t1.name3,chr(13),''),chr(10),'') as name3
,replace(replace(t1.name4,chr(13),''),chr(10),'') as name4
,replace(replace(t1.name5,chr(13),''),chr(10),'') as name5
,replace(replace(t1.name6,chr(13),''),chr(10),'') as name6
,replace(replace(t1.officephone,chr(13),''),chr(10),'') as officephone
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,sex
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.usedname,chr(13),''),chr(10),'') as usedname
,replace(replace(t1.bloodtype,chr(13),''),chr(10),'') as bloodtype
,replace(replace(t1.censusaddr,chr(13),''),chr(10),'') as censusaddr
,replace(replace(t1.characterrpr,chr(13),''),chr(10),'') as characterrpr
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.die_date,chr(13),''),chr(10),'') as die_date
,replace(replace(t1.die_remark,chr(13),''),chr(10),'') as die_remark
,replace(replace(t1.edu,chr(13),''),chr(10),'') as edu
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.fileaddress,chr(13),''),chr(10),'') as fileaddress
,replace(replace(t1.health,chr(13),''),chr(10),'') as health
,replace(replace(t1.ishiskeypsn,chr(13),''),chr(10),'') as ishiskeypsn
,replace(replace(t1.joinpolitydate,chr(13),''),chr(10),'') as joinpolitydate
,replace(replace(t1.marital,chr(13),''),chr(10),'') as marital
,replace(replace(t1.marriagedate,chr(13),''),chr(10),'') as marriagedate
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality
,replace(replace(t1.nativeplace,chr(13),''),chr(10),'') as nativeplace
,replace(replace(t1.penelauth,chr(13),''),chr(10),'') as penelauth
,replace(replace(t1.permanreside,chr(13),''),chr(10),'') as permanreside
,replace(replace(t1.photo,chr(13),''),chr(10),'') as photo
,replace(replace(t1.pk_degree,chr(13),''),chr(10),'') as pk_degree
,replace(replace(t1.pk_hrorg,chr(13),''),chr(10),'') as pk_hrorg
,replace(replace(t1.polity,chr(13),''),chr(10),'') as polity
,replace(replace(t1.postalcode,chr(13),''),chr(10),'') as postalcode
,replace(replace(t1.previewphoto,chr(13),''),chr(10),'') as previewphoto
,replace(replace(t1.prof,chr(13),''),chr(10),'') as prof
,replace(replace(t1.retiredate,chr(13),''),chr(10),'') as retiredate
,replace(replace(t1.secret_email,chr(13),''),chr(10),'') as secret_email
,replace(replace(t1.shortname,chr(13),''),chr(10),'') as shortname
,replace(replace(t1.titletechpost,chr(13),''),chr(10),'') as titletechpost
,replace(replace(t1.glbdef1,chr(13),''),chr(10),'') as glbdef1
,replace(replace(t1.glbdef2,chr(13),''),chr(10),'') as glbdef2
,replace(replace(t1.glbdef3,chr(13),''),chr(10),'') as glbdef3
,replace(replace(t1.glbdef4,chr(13),''),chr(10),'') as glbdef4
,replace(replace(t1.glbdef5,chr(13),''),chr(10),'') as glbdef5
,replace(replace(t1.glbdef6,chr(13),''),chr(10),'') as glbdef6
,replace(replace(t1.glbdef7,chr(13),''),chr(10),'') as glbdef7
,replace(replace(t1.glbdef8,chr(13),''),chr(10),'') as glbdef8
,replace(replace(t1.glbdef9,chr(13),''),chr(10),'') as glbdef9
,glbdef10
,replace(replace(t1.glbdef11,chr(13),''),chr(10),'') as glbdef11
,replace(replace(t1.glbdef12,chr(13),''),chr(10),'') as glbdef12
,replace(replace(t1.glbdef13,chr(13),''),chr(10),'') as glbdef13
,replace(replace(t1.glbdef14,chr(13),''),chr(10),'') as glbdef14
,replace(replace(t1.glbdef15,chr(13),''),chr(10),'') as glbdef15
,replace(replace(t1.glbdef16,chr(13),''),chr(10),'') as glbdef16
,glbdef17
,replace(replace(t1.glbdef18,chr(13),''),chr(10),'') as glbdef18
,replace(replace(t1.glbdef19,chr(13),''),chr(10),'') as glbdef19
,replace(replace(t1.glbdef20,chr(13),''),chr(10),'') as glbdef20
,glbdef21
,replace(replace(t1.glbdef22,chr(13),''),chr(10),'') as glbdef22
,replace(replace(t1.glbdef23,chr(13),''),chr(10),'') as glbdef23
,glbdef24
,glbdef25
,glbdef26
,replace(replace(t1.glbdef27,chr(13),''),chr(10),'') as glbdef27
,replace(replace(t1.glbdef28,chr(13),''),chr(10),'') as glbdef28
,replace(replace(t1.glbdef29,chr(13),''),chr(10),'') as glbdef29
,replace(replace(t1.glbdef30,chr(13),''),chr(10),'') as glbdef30
,replace(replace(t1.glbdef31,chr(13),''),chr(10),'') as glbdef31
,replace(replace(t1.glbdef32,chr(13),''),chr(10),'') as glbdef32
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.glbdef40,chr(13),''),chr(10),'') as glbdef40

from ${iol_schema}.nhrs_bd_psndoc t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_bd_psndoc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
