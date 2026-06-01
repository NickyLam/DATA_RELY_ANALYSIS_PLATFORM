: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psnjob_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_hi_psnjob.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.assgid as assgid
    ,replace(replace(t.begindate,chr(13),''),chr(10),'') as begindate
    ,replace(replace(t.clerkcode,chr(13),''),chr(10),'') as clerkcode
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,replace(replace(t.deposemode,chr(13),''),chr(10),'') as deposemode
    ,t.dr as dr
    ,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate
    ,replace(replace(t.endflag,chr(13),''),chr(10),'') as endflag
    ,replace(replace(t.ismainjob,chr(13),''),chr(10),'') as ismainjob
    ,replace(replace(t.jobmode,chr(13),''),chr(10),'') as jobmode
    ,replace(replace(t.lastflag,chr(13),''),chr(10),'') as lastflag
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.occupation,chr(13),''),chr(10),'') as occupation
    ,replace(replace(t.oribillpk,chr(13),''),chr(10),'') as oribillpk
    ,replace(replace(t.oribilltype,chr(13),''),chr(10),'') as oribilltype
    ,replace(replace(t.pk_dept,chr(13),''),chr(10),'') as pk_dept
    ,replace(replace(t.pk_dept_v,chr(13),''),chr(10),'') as pk_dept_v
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_hrgroup,chr(13),''),chr(10),'') as pk_hrgroup
    ,replace(replace(t.pk_hrorg,chr(13),''),chr(10),'') as pk_hrorg
    ,replace(replace(t.pk_job,chr(13),''),chr(10),'') as pk_job
    ,replace(replace(t.pk_job_type,chr(13),''),chr(10),'') as pk_job_type
    ,replace(replace(t.pk_jobgrade,chr(13),''),chr(10),'') as pk_jobgrade
    ,replace(replace(t.pk_jobrank,chr(13),''),chr(10),'') as pk_jobrank
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_org_v,chr(13),''),chr(10),'') as pk_org_v
    ,replace(replace(t.pk_post,chr(13),''),chr(10),'') as pk_post
    ,replace(replace(t.pk_postseries,chr(13),''),chr(10),'') as pk_postseries
    ,replace(replace(t.pk_psncl,chr(13),''),chr(10),'') as pk_psncl
    ,replace(replace(t.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
    ,replace(replace(t.pk_psnjob,chr(13),''),chr(10),'') as pk_psnjob
    ,replace(replace(t.pk_psnorg,chr(13),''),chr(10),'') as pk_psnorg
    ,replace(replace(t.poststat,chr(13),''),chr(10),'') as poststat
    ,t.psntype as psntype
    ,t.recordnum as recordnum
    ,replace(replace(t.series,chr(13),''),chr(10),'') as series
    ,t.showorder as showorder
    ,replace(replace(t.trial_flag,chr(13),''),chr(10),'') as trial_flag
    ,t.trial_type as trial_type
    ,t.trnsevent as trnsevent
    ,replace(replace(t.trnsreason,chr(13),''),chr(10),'') as trnsreason
    ,replace(replace(t.trnstype,chr(13),''),chr(10),'') as trnstype
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,replace(replace(t.worktype,chr(13),''),chr(10),'') as worktype
    ,replace(replace(t.jobglbdef1,chr(13),''),chr(10),'') as jobglbdef1
    ,replace(replace(t.jobglbdef2,chr(13),''),chr(10),'') as jobglbdef2
    ,replace(replace(t.jobglbdef3,chr(13),''),chr(10),'') as jobglbdef3
    ,replace(replace(t.jobglbdef4,chr(13),''),chr(10),'') as jobglbdef4
    ,replace(replace(t.jobglbdef5,chr(13),''),chr(10),'') as jobglbdef5
    ,replace(replace(t.jobglbdef6,chr(13),''),chr(10),'') as jobglbdef6
    ,replace(replace(t.jobglbdef9,chr(13),''),chr(10),'') as jobglbdef9
    ,replace(replace(t.jobglbdef7,chr(13),''),chr(10),'') as jobglbdef7
    ,replace(replace(t.jobglbdef8,chr(13),''),chr(10),'') as jobglbdef8
    ,replace(replace(t.jobglbdef10,chr(13),''),chr(10),'') as jobglbdef10
    ,replace(replace(t.jobglbdef11,chr(13),''),chr(10),'') as jobglbdef11
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_hi_psnjob t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psnjob.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes