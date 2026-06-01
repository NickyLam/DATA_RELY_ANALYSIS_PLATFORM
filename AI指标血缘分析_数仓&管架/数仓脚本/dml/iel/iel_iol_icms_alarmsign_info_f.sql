: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_alarmsign_info_f
CreateDate: 20251106
FileName:   ${iel_data_path}/icms_alarmsign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.signid,chr(13),''),chr(10),'') as signid
,inputdate
,replace(replace(t1.signtitle,chr(13),''),chr(10),'') as signtitle
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.signdescribe,chr(13),''),chr(10),'') as signdescribe
,replace(replace(t1.optionvalue,chr(13),''),chr(10),'') as optionvalue
,replace(replace(t1.signclass,chr(13),''),chr(10),'') as signclass
,replace(replace(t1.signname,chr(13),''),chr(10),'') as signname
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.signtype,chr(13),''),chr(10),'') as signtype
,replace(replace(t1.signlevel,chr(13),''),chr(10),'') as signlevel
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.isratechangecondition,chr(13),''),chr(10),'') as isratechangecondition
,replace(replace(t1.signoptiontype,chr(13),''),chr(10),'') as signoptiontype
,replace(replace(t1.thresholdvalue,chr(13),''),chr(10),'') as thresholdvalue
,replace(replace(t1.signobjecttype,chr(13),''),chr(10),'') as signobjecttype
,replace(replace(t1.judgment,chr(13),''),chr(10),'') as judgment
,updatedate
,replace(replace(t1.signcusytomertype,chr(13),''),chr(10),'') as signcusytomertype
,replace(replace(t1.triggertimes,chr(13),''),chr(10),'') as triggertimes
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.alertinfosource,chr(13),''),chr(10),'') as alertinfosource

from ${iol_schema}.icms_alarmsign_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_alarmsign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
