: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_om_post_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_om_post.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.abortdate,chr(13),''),chr(10),'') as abortdate
    ,replace(replace(t.builddate,chr(13),''),chr(10),'') as builddate
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,t.dr as dr
    ,replace(replace(t.employment,chr(13),''),chr(10),'') as employment
    ,t.enablestate as enablestate
    ,replace(replace(t.innercode,chr(13),''),chr(10),'') as innercode
    ,replace(replace(t.isabort,chr(13),''),chr(10),'') as isabort
    ,replace(replace(t.isdeptrespon,chr(13),''),chr(10),'') as isdeptrespon
    ,replace(replace(t.junior,chr(13),''),chr(10),'') as junior
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.pk_dept,chr(13),''),chr(10),'') as pk_dept
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_job,chr(13),''),chr(10),'') as pk_job
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_post,chr(13),''),chr(10),'') as pk_post
    ,replace(replace(t.pk_postseries,chr(13),''),chr(10),'') as pk_postseries
    ,replace(replace(t.postcode,chr(13),''),chr(10),'') as postcode
    ,replace(replace(t.postname,chr(13),''),chr(10),'') as postname
    ,replace(replace(t.postname2,chr(13),''),chr(10),'') as postname2
    ,replace(replace(t.postname3,chr(13),''),chr(10),'') as postname3
    ,replace(replace(t.postname4,chr(13),''),chr(10),'') as postname4
    ,replace(replace(t.postname5,chr(13),''),chr(10),'') as postname5
    ,replace(replace(t.postname6,chr(13),''),chr(10),'') as postname6
    ,replace(replace(t.reqedu,chr(13),''),chr(10),'') as reqedu
    ,replace(replace(t.reqexp,chr(13),''),chr(10),'') as reqexp
    ,replace(replace(t.reqother,chr(13),''),chr(10),'') as reqother
    ,replace(replace(t.reqpro,chr(13),''),chr(10),'') as reqpro
    ,replace(replace(t.reqsex,chr(13),''),chr(10),'') as reqsex
    ,replace(replace(t.reqworktime,chr(13),''),chr(10),'') as reqworktime
    ,replace(replace(t.reqyold,chr(13),''),chr(10),'') as reqyold
    ,replace(replace(t.seq,chr(13),''),chr(10),'') as seq
    ,replace(replace(t.suporior,chr(13),''),chr(10),'') as suporior
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,replace(replace(t.worksumm,chr(13),''),chr(10),'') as worksumm
    ,replace(replace(t.worktype,chr(13),''),chr(10),'') as worktype
    ,replace(replace(t.hrcanceldate,chr(13),''),chr(10),'') as hrcanceldate
    ,replace(replace(t.hrcanceled,chr(13),''),chr(10),'') as hrcanceled
    ,replace(replace(t.iskeypost,chr(13),''),chr(10),'') as iskeypost
    ,replace(replace(t.isstd,chr(13),''),chr(10),'') as isstd
    ,replace(replace(t.pk_hrorg,chr(13),''),chr(10),'') as pk_hrorg
    ,replace(replace(t.pk_poststd,chr(13),''),chr(10),'') as pk_poststd
    ,replace(replace(t.sealflag,chr(13),''),chr(10),'') as sealflag
    ,t.glbdef1 as glbdef1
    ,t.glbdef2 as glbdef2
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_om_post t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_om_post.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes