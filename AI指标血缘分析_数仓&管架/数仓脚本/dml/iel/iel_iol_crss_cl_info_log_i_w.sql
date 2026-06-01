: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_cl_info_log_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_cl_info_log_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(logid,chr(10),''),chr(13),'') as logid
,replace(replace(lineid,chr(10),''),chr(13),'') as lineid
,replace(replace(cltypeid,chr(10),''),chr(13),'') as cltypeid
,replace(replace(cltypename,chr(10),''),chr(13),'') as cltypename
,replace(replace(applyserialno,chr(10),''),chr(13),'') as applyserialno
,replace(replace(approveserialno,chr(10),''),chr(13),'') as approveserialno
,replace(replace(bcserialno,chr(10),''),chr(13),'') as bcserialno
,replace(replace(linecontractno,chr(10),''),chr(13),'') as linecontractno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(linesum1,chr(10),''),chr(13),'') as linesum1
,replace(replace(linesum2,chr(10),''),chr(13),'') as linesum2
,replace(replace(linesum3,chr(10),''),chr(13),'') as linesum3
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(lineeffdate,chr(10),''),chr(13),'') as lineeffdate
,replace(replace(lineeffflag,chr(10),''),chr(13),'') as lineeffflag
,replace(replace(putoutdeadline,chr(10),''),chr(13),'') as putoutdeadline
,replace(replace(maturitydeadline,chr(10),''),chr(13),'') as maturitydeadline
,replace(replace(rotative,chr(10),''),chr(13),'') as rotative
,replace(replace(approvalpolicy,chr(10),''),chr(13),'') as approvalpolicy
,replace(replace(freezeflag,chr(10),''),chr(13),'') as freezeflag
,replace(replace(recentcheck,chr(10),''),chr(13),'') as recentcheck
,replace(replace(recentcheckstatus,chr(10),''),chr(13),'') as recentcheckstatus
,replace(replace(checkresult,chr(10),''),chr(13),'') as checkresult
,replace(replace(overflowtype,chr(10),''),chr(13),'') as overflowtype
,replace(replace(inputuser,chr(10),''),chr(13),'') as inputuser
,replace(replace(inputorg,chr(10),''),chr(13),'') as inputorg
,replace(replace(inputtime,chr(10),''),chr(13),'') as inputtime
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(begindate,chr(10),''),chr(13),'') as begindate
,replace(replace(enddate,chr(10),''),chr(13),'') as enddate
,replace(replace(parentid,chr(10),''),chr(13),'') as parentid
,replace(replace(useorgid,chr(10),''),chr(13),'') as useorgid
,replace(replace(useorgname,chr(10),''),chr(13),'') as useorgname
,replace(replace(bailratio,chr(10),''),chr(13),'') as bailratio
,replace(replace(businesstype,chr(10),''),chr(13),'') as businesstype
,replace(replace(usedsum,chr(10),''),chr(13),'') as usedsum
,replace(replace(usablesum,chr(10),''),chr(13),'') as usablesum
,replace(replace(calculatetime,chr(10),''),chr(13),'') as calculatetime
,replace(replace(loguser,chr(10),''),chr(13),'') as loguser
,replace(replace(logorg,chr(10),''),chr(13),'') as logorg
,replace(replace(logtime,chr(10),''),chr(13),'') as logtime
,replace(replace(logaction,chr(10),''),chr(13),'') as logaction
,replace(replace(logobjecttype,chr(10),''),chr(13),'') as logobjecttype
,replace(replace(grouplineid,chr(10),''),chr(13),'') as grouplineid
,replace(replace(subbalance,chr(10),''),chr(13),'') as subbalance
,replace(replace(maturity,chr(10),''),chr(13),'') as maturity
,replace(replace(guarantytype,chr(10),''),chr(13),'') as guarantytype
,replace(replace(ifexclusivecredit,chr(10),''),chr(13),'') as ifexclusivecredit
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(iscontrolledbyzj,chr(10),''),chr(13),'') as iscontrolledbyzj
,replace(replace(onlineamount,chr(10),''),chr(13),'') as onlineamount
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_cl_info_log 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_cl_info_log_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes