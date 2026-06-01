: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_risk_judge_f
CreateDate: 20251110
FileName:   ${iel_data_path}/icms_wyd_risk_judge.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.riskjudgeseq,chr(13),''),chr(10),'') as riskjudgeseq
,applytime
,intfccalltime
,replace(replace(t1.scenetype,chr(13),''),chr(10),'') as scenetype
,replace(replace(t1.stlprdid,chr(13),''),chr(10),'') as stlprdid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.recommender,chr(13),''),chr(10),'') as recommender
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.taxpayerid,chr(13),''),chr(10),'') as taxpayerid
,replace(replace(t1.enterprisename,chr(13),''),chr(10),'') as enterprisename
,replace(replace(t1.regarea,chr(13),''),chr(10),'') as regarea
,replace(replace(t1.regadmarea,chr(13),''),chr(10),'') as regadmarea
,replace(replace(t1.regaddress,chr(13),''),chr(10),'') as regaddress
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.orgbranchcode,chr(13),''),chr(10),'') as orgbranchcode
,replace(replace(t1.socialunitycreditcode,chr(13),''),chr(10),'') as socialunitycreditcode
,replace(replace(t1.busiregisterno,chr(13),''),chr(10),'') as busiregisterno
,replace(replace(t1.wzccif,chr(13),''),chr(10),'') as wzccif
,replace(replace(t1.category,chr(13),''),chr(10),'') as category
,replace(replace(t1.smallcorpiden,chr(13),''),chr(10),'') as smallcorpiden
,registerdate
,replace(replace(t1.operyears,chr(13),''),chr(10),'') as operyears
,replace(replace(t1.staffnumber,chr(13),''),chr(10),'') as staffnumber
,replace(replace(t1.legalname,chr(13),''),chr(10),'') as legalname
,replace(replace(t1.legalcertid,chr(13),''),chr(10),'') as legalcertid
,replace(replace(t1.legalcerttype,chr(13),''),chr(10),'') as legalcerttype
,legalcertexpiredate
,replace(replace(t1.legalsex,chr(13),''),chr(10),'') as legalsex
,replace(replace(t1.legalethnicity,chr(13),''),chr(10),'') as legalethnicity
,replace(replace(t1.legaladdress,chr(13),''),chr(10),'') as legaladdress
,replace(replace(t1.legalnationality,chr(13),''),chr(10),'') as legalnationality
,replace(replace(t1.legalcareer,chr(13),''),chr(10),'') as legalcareer
,legalbirth
,replace(replace(t1.legalphoneno,chr(13),''),chr(10),'') as legalphoneno
,replace(replace(t1.legalbankcard,chr(13),''),chr(10),'') as legalbankcard
,replace(replace(t1.legalmobile,chr(13),''),chr(10),'') as legalmobile
,replace(replace(t1.legalecif,chr(13),''),chr(10),'') as legalecif
,replace(replace(t1.signingenpauthtime,chr(13),''),chr(10),'') as signingenpauthtime
,replace(replace(t1.signingpersonauthtime,chr(13),''),chr(10),'') as signingpersonauthtime
,replace(replace(t1.signingenpauthseq,chr(13),''),chr(10),'') as signingenpauthseq
,replace(replace(t1.signingpersonauthseq,chr(13),''),chr(10),'') as signingpersonauthseq
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,intfccallresptime
,replace(replace(t1.riskresult,chr(13),''),chr(10),'') as riskresult
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate

from ${iol_schema}.icms_wyd_risk_judge t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_risk_judge.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
