: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psndoc_edu_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_hi_psndoc_edu.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,approveflag
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.certifcode,chr(13),''),chr(10),'') as certifcode
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.degreedate,chr(13),''),chr(10),'') as degreedate
,replace(replace(t1.degreeunit,chr(13),''),chr(10),'') as degreeunit
,dr
,replace(replace(t1.education,chr(13),''),chr(10),'') as education
,replace(replace(t1.educationctifcode,chr(13),''),chr(10),'') as educationctifcode
,edusystem
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.lasteducation,chr(13),''),chr(10),'') as lasteducation
,replace(replace(t1.lastflag,chr(13),''),chr(10),'') as lastflag
,replace(replace(t1.major,chr(13),''),chr(10),'') as major
,replace(replace(t1.majortype,chr(13),''),chr(10),'') as majortype
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.period,chr(13),''),chr(10),'') as period
,replace(replace(t1.pk_degree,chr(13),''),chr(10),'') as pk_degree
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_psndoc_sub,chr(13),''),chr(10),'') as pk_psndoc_sub
,recordnum
,replace(replace(t1.school,chr(13),''),chr(10),'') as school
,replace(replace(t1.schooltype,chr(13),''),chr(10),'') as schooltype
,replace(replace(t1.studymode,chr(13),''),chr(10),'') as studymode
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.glbdef1,chr(13),''),chr(10),'') as glbdef1
,replace(replace(t1.glbdef2,chr(13),''),chr(10),'') as glbdef2
,replace(replace(t1.glbdef3,chr(13),''),chr(10),'') as glbdef3
,replace(replace(t1.glbdef4,chr(13),''),chr(10),'') as glbdef4
,replace(replace(t1.glbdef5,chr(13),''),chr(10),'') as glbdef5
,replace(replace(t1.glbdef6,chr(13),''),chr(10),'') as glbdef6
,replace(replace(t1.glbdef7,chr(13),''),chr(10),'') as glbdef7
,replace(replace(t1.glbdef8,chr(13),''),chr(10),'') as glbdef8

from ${iol_schema}.nhrs_hi_psndoc_edu t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psndoc_edu.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
