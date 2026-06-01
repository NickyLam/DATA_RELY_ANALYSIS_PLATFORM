: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_pl_pcm_printmission_history_i
CreateDate: 20180529
FileName:   ${iel_data_path}/nibs_pl_pcm_printmission_history.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.brno,chr(13),''),chr(10),'') as brno
,replace(replace(t1.idcode,chr(13),''),chr(10),'') as idcode
,replace(replace(t1.busiserialno,chr(13),''),chr(10),'') as busiserialno
,replace(replace(t1.transcode,chr(13),''),chr(10),'') as transcode
,replace(replace(t1.transname,chr(13),''),chr(10),'') as transname
,replace(replace(t1.prooftype,chr(13),''),chr(10),'') as prooftype
,replace(replace(t1.proofnum,chr(13),''),chr(10),'') as proofnum
,replace(replace(t1.sealnum,chr(13),''),chr(10),'') as sealnum
,replace(replace(t1.proofno,chr(13),''),chr(10),'') as proofno
,replace(replace(t1.printtype,chr(13),''),chr(10),'') as printtype
,replace(replace(t1.missionstatus,chr(13),''),chr(10),'') as missionstatus
,replace(replace(t1.printdate,chr(13),''),chr(10),'') as printdate
,replace(replace(t1.teller,chr(13),''),chr(10),'') as teller
,replace(replace(t1.authorize,chr(13),''),chr(10),'') as authorize
,replace(replace(t1.authorg,chr(13),''),chr(10),'') as authorg
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.acctname,chr(13),''),chr(10),'') as acctname
,replace(replace(t1.photobeofre,chr(13),''),chr(10),'') as photobeofre
,replace(replace(t1.photoafter,chr(13),''),chr(10),'') as photoafter
,replace(replace(t1.photocombination,chr(13),''),chr(10),'') as photocombination
,replace(replace(t1.pcmno,chr(13),''),chr(10),'') as pcmno
,replace(replace(t1.idcount,chr(13),''),chr(10),'') as idcount
,replace(replace(t1.changetime,chr(13),''),chr(10),'') as changetime
,replace(replace(t1.changestatus,chr(13),''),chr(10),'') as changestatus
from ${iol_schema}.nibs_pl_pcm_printmission_history t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_pl_pcm_printmission_history.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes