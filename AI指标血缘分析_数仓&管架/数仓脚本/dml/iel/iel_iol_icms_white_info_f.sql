: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_white_info_f
CreateDate: 20250414
FileName:   ${iel_data_path}/icms_white_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.orgshort,chr(13),''),chr(10),'') as orgshort
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.isbelongterm,chr(13),''),chr(10),'') as isbelongterm
,totolsum
,replace(replace(t1.riskcapitalassesstype,chr(13),''),chr(10),'') as riskcapitalassesstype
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.issinosureaccount,chr(13),''),chr(10),'') as issinosureaccount
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,fixedrate
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t1.sinosurename,chr(13),''),chr(10),'') as sinosurename
,updatedate
,inputdate
,replace(replace(t1.sinosureaccount,chr(13),''),chr(10),'') as sinosureaccount
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,maxloanterm
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,firstpayratio
,replace(replace(t1.isfirstpay,chr(13),''),chr(10),'') as isfirstpay
,replace(replace(t1.adristtype,chr(13),''),chr(10),'') as adristtype
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,maturity
,replace(replace(t1.bypassaccount,chr(13),''),chr(10),'') as bypassaccount
,singleputsum
,replace(replace(t1.iscitecon,chr(13),''),chr(10),'') as iscitecon
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,teamputsum
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.sinosurebillaccount,chr(13),''),chr(10),'') as sinosurebillaccount
,replace(replace(t1.taskstatus,chr(13),''),chr(10),'') as taskstatus
,replace(replace(t1.interestrepaycycle,chr(13),''),chr(10),'') as interestrepaycycle

from ${iol_schema}.icms_white_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_white_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
