: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_wyd_putout_apply_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_putout_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.brno,chr(13),''),chr(10),'') as brno
,replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
,replace(replace(t1.corpname,chr(13),''),chr(10),'') as corpname
,replace(replace(t1.regarea,chr(13),''),chr(10),'') as regarea
,replace(replace(t1.regadmarea,chr(13),''),chr(10),'') as regadmarea
,replace(replace(t1.regaddress,chr(13),''),chr(10),'') as regaddress
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.orgcode,chr(13),''),chr(10),'') as orgcode
,replace(replace(t1.regtype,chr(13),''),chr(10),'') as regtype
,replace(replace(t1.regnumber,chr(13),''),chr(10),'') as regnumber
,replace(replace(t1.taxnumber,chr(13),''),chr(10),'') as taxnumber
,replace(replace(t1.socialunifiedcreditcode,chr(13),''),chr(10),'') as socialunifiedcreditcode
,replace(replace(t1.category,chr(13),''),chr(10),'') as category
,replace(replace(t1.busscale,chr(13),''),chr(10),'') as busscale
,replace(replace(t1.smallcorpiden,chr(13),''),chr(10),'') as smallcorpiden
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality
,replace(replace(t1.career,chr(13),''),chr(10),'') as career
,replace(replace(t1.birth,chr(13),''),chr(10),'') as birth
,replace(replace(t1.telno,chr(13),''),chr(10),'') as telno
,replace(replace(t1.phoneno,chr(13),''),chr(10),'') as phoneno
,pactamt
,lnrate
,replace(replace(t1.apparea,chr(13),''),chr(10),'') as apparea
,replace(replace(t1.appuse,chr(13),''),chr(10),'') as appuse
,replace(replace(t1.termmon,chr(13),''),chr(10),'') as termmon
,replace(replace(t1.voutype,chr(13),''),chr(10),'') as voutype
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.paytype,chr(13),''),chr(10),'') as paytype
,replace(replace(t1.payday,chr(13),''),chr(10),'') as payday
,replace(replace(t1.merchantno,chr(13),''),chr(10),'') as merchantno
,replace(replace(t1.busilicenseid,chr(13),''),chr(10),'') as busilicenseid
,replace(replace(t1.busilicenseexpiredate,chr(13),''),chr(10),'') as busilicenseexpiredate
,replace(replace(t1.registerdate,chr(13),''),chr(10),'') as registerdate
,replace(replace(t1.operatinglife,chr(13),''),chr(10),'') as operatinglife
,replace(replace(t1.staffnumber,chr(13),''),chr(10),'') as staffnumber
,replace(replace(t1.needrefuse,chr(13),''),chr(10),'') as needrefuse
,replace(replace(t1.legalbankcard,chr(13),''),chr(10),'') as legalbankcard
,replace(replace(t1.legalmobile,chr(13),''),chr(10),'') as legalmobile
,quotamod
,replace(replace(t1.custlevel,chr(13),''),chr(10),'') as custlevel
,replace(replace(t1.loannum,chr(13),''),chr(10),'') as loannum
,replace(replace(t1.enterprisecerttype,chr(13),''),chr(10),'') as enterprisecerttype
,enterprisecertendtime
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid
,signingenpauthtime
,signingpersonauthtime
,replace(replace(t1.signingenpauthseq,chr(13),''),chr(10),'') as signingenpauthseq
,replace(replace(t1.signingpersonauthseq,chr(13),''),chr(10),'') as signingpersonauthseq
,replace(replace(t1.loantype,chr(13),''),chr(10),'') as loantype
,replace(replace(t1.loanacctno,chr(13),''),chr(10),'') as loanacctno
,replace(replace(t1.guarantytype,chr(13),''),chr(10),'') as guarantytype
,replace(replace(t1.guarantyorgname,chr(13),''),chr(10),'') as guarantyorgname
,replace(replace(t1.guarantycerttype,chr(13),''),chr(10),'') as guarantycerttype
,replace(replace(t1.guarantycertno,chr(13),''),chr(10),'') as guarantycertno
,guarantypercent
,replace(replace(t1.effectivedate,chr(13),''),chr(10),'') as effectivedate
,replace(replace(t1.expiredate,chr(13),''),chr(10),'') as expiredate
,replace(replace(t1.appointdate,chr(13),''),chr(10),'') as appointdate
,replace(replace(t1.transstatus,chr(13),''),chr(10),'') as transstatus
,replace(replace(t1.mybankaffiliateflag,chr(13),''),chr(10),'') as mybankaffiliateflag
,replace(replace(t1.zhengxincheckresult,chr(13),''),chr(10),'') as zhengxincheckresult
,replace(replace(t1.gongancheckresult,chr(13),''),chr(10),'') as gongancheckresult
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.manageuserid,chr(13),''),chr(10),'') as manageuserid
,replace(replace(t1.manageorgid,chr(13),''),chr(10),'') as manageorgid
,applytime
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,fkreleasetime
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.zzm,chr(13),''),chr(10),'') as zzm
,replace(replace(t1.entscale,chr(13),''),chr(10),'') as entscale

from ${iol_schema}.icms_wyd_putout_apply t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_putout_apply.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
