: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_lmt_resu_receive_f
CreateDate: 20251113
FileName:   ${iel_data_path}/icms_wyd_lmt_resu_receive.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.lmtresuseq,chr(13),''),chr(10),'') as lmtresuseq
,replace(replace(t1.riskjudgeseq,chr(13),''),chr(10),'') as riskjudgeseq
,intfccalltime
,replace(replace(t1.recommender,chr(13),''),chr(10),'') as recommender
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.taxpayerid,chr(13),''),chr(10),'') as taxpayerid
,replace(replace(t1.enterprisename,chr(13),''),chr(10),'') as enterprisename
,replace(replace(t1.wzccif,chr(13),''),chr(10),'') as wzccif
,replace(replace(t1.orgbranchcode,chr(13),''),chr(10),'') as orgbranchcode
,replace(replace(t1.socialunitycreditcode,chr(13),''),chr(10),'') as socialunitycreditcode
,replace(replace(t1.busiregisterno,chr(13),''),chr(10),'') as busiregisterno
,replace(replace(t1.legalname,chr(13),''),chr(10),'') as legalname
,replace(replace(t1.legalmobile,chr(13),''),chr(10),'') as legalmobile
,replace(replace(t1.legalcertid,chr(13),''),chr(10),'') as legalcertid
,replace(replace(t1.legalcerttype,chr(13),''),chr(10),'') as legalcerttype
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,modelquotalmt
,dayrate
,replace(replace(t1.prdterm,chr(13),''),chr(10),'') as prdterm
,replace(replace(t1.custlevel,chr(13),''),chr(10),'') as custlevel
,replace(replace(t1.quotafailrsns,chr(13),''),chr(10),'') as quotafailrsns
,replace(replace(t1.stlprdid,chr(13),''),chr(10),'') as stlprdid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.riskresult,chr(13),''),chr(10),'') as riskresult
,finalloanrate
,finalapplyamount
,finalapplyterm
,replace(replace(t1.risknote,chr(13),''),chr(10),'') as risknote
,replace(replace(t1.riskwarm,chr(13),''),chr(10),'') as riskwarm
,replace(replace(t1.ismoneylaunderlz,chr(13),''),chr(10),'') as ismoneylaunderlz
,replace(replace(t1.refunum,chr(13),''),chr(10),'') as refunum
,updateamount
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.dealstatus,chr(13),''),chr(10),'') as dealstatus
,replace(replace(t1.noncestr,chr(13),''),chr(10),'') as noncestr

from ${iol_schema}.icms_wyd_lmt_resu_receive t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_lmt_resu_receive.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
