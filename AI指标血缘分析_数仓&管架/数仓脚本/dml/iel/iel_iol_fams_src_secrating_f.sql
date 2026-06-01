: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_src_secrating_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_src_secrating.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.secratingid,chr(13),''),chr(10),'') as secratingid
,replace(replace(t1.seccode,chr(13),''),chr(10),'') as seccode
,replace(replace(t1.ratingsrc,chr(13),''),chr(10),'') as ratingsrc
,replace(replace(t1.ratingorg,chr(13),''),chr(10),'') as ratingorg
,replace(replace(t1.ratingtype,chr(13),''),chr(10),'') as ratingtype
,replace(replace(t1.ratingsubtype,chr(13),''),chr(10),'') as ratingsubtype
,replace(replace(t1.rating,chr(13),''),chr(10),'') as rating
,t1.pubdate as pubdate
,t1.lstmntdate as lstmntdate
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.ratingmain,chr(13),''),chr(10),'') as ratingmain
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_src_secrating t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_src_secrating.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes