: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_risk_warning_sign_f
CreateDate: 20251106
FileName:   ${iel_data_path}/icms_risk_warning_sign.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.signlevel,chr(13),''),chr(10),'') as signlevel
,effecttime
,maxoverduedays
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.creditlevel,chr(13),''),chr(10),'') as creditlevel
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.businessname,chr(13),''),chr(10),'') as businessname
,rqrfindate
,canceltime
,replace(replace(t1.monitorcode,chr(13),''),chr(10),'') as monitorcode
,balance
,replace(replace(t1.warningresult,chr(13),''),chr(10),'') as warningresult
,replace(replace(t1.releaseresult,chr(13),''),chr(10),'') as releaseresult
,replace(replace(t1.compaddr,chr(13),''),chr(10),'') as compaddr
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.dealopinion,chr(13),''),chr(10),'') as dealopinion
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.compsize,chr(13),''),chr(10),'') as compsize
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.monitorcontent,chr(13),''),chr(10),'') as monitorcontent
,replace(replace(t1.riskcontrolplan,chr(13),''),chr(10),'') as riskcontrolplan
,replace(replace(t1.compprop,chr(13),''),chr(10),'') as compprop
,replace(replace(t1.isprveconomy,chr(13),''),chr(10),'') as isprveconomy
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.riskdealno,chr(13),''),chr(10),'') as riskdealno
,replace(replace(t1.managerorgid,chr(13),''),chr(10),'') as managerorgid
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.industryname,chr(13),''),chr(10),'') as industryname
,replace(replace(t1.signtype,chr(13),''),chr(10),'') as signtype
,replace(replace(t1.checktaskno,chr(13),''),chr(10),'') as checktaskno
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype
,replace(replace(t1.creditdesc,chr(13),''),chr(10),'') as creditdesc
,releasedate
,updatedate
,accumrepaysum
,replace(replace(t1.monitortaskno,chr(13),''),chr(10),'') as monitortaskno
,effectdate
,replace(replace(t1.signstatus,chr(13),''),chr(10),'') as signstatus
,inputdate
,replace(replace(t1.createtype,chr(13),''),chr(10),'') as createtype
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.effectresult,chr(13),''),chr(10),'') as effectresult
,replace(replace(t1.risklosslevel,chr(13),''),chr(10),'') as risklosslevel
,replace(replace(t1.overduelevel,chr(13),''),chr(10),'') as overduelevel
,dealdate
,infactfindate
,replace(replace(t1.batserialno,chr(13),''),chr(10),'') as batserialno
,term
,replace(replace(t1.manageruserid,chr(13),''),chr(10),'') as manageruserid
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid

from ${iol_schema}.icms_risk_warning_sign t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_risk_warning_sign.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
