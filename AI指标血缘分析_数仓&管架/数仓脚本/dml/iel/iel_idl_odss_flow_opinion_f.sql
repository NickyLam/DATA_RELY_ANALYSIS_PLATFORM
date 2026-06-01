: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_flow_opinion_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_flow_opinion_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select serialno
   ,opinionno
   ,objecttype
   ,objectno
   ,customerid
   ,customername
   ,businesscurrency
   ,businesssum
   ,termyear
   ,termmonth
   ,termday
   ,baseratetype
   ,ratefloattype
   ,ratefloat
   ,bailcurrency
   ,businessrate
   ,bailratio
   ,bailsum
   ,pdgratio
   ,pdgsum
   ,baserate
   ,phasechoice
   ,phaseopinion
   ,phaseopinion1
   ,phaseopinion2
   ,phaseopinion3
   ,inputorg
   ,inputuser
   ,inputtime
   ,updateuser
   ,updatetime
   ,approveflag
   ,approvephaseno
   ,provisioninfo
   ,condition3
   ,conditionflag3
   ,reasoncode1
   ,reasoncode2
   ,holdbalance
   ,adjustratetype
   ,returnperiod
   ,returntype
   ,ratemode
   ,loanterm
   ,mainreturntype
   ,classifyresulteleven
   ,totalsum
   ,maturity
   ,classifyresult
   ,phaseopinion4
   ,ratedescribe
   ,cycleratio
   ,condition2
   ,conditionflag2
   ,condition1
   ,conditionflag1
   ,gaincyc
   ,gainamount
   ,violationinfo
   ,reasoncode3
   ,approveuserid
   ,approvedate
   ,phaseopinion5
   ,attribute1
   ,attribute2
   ,attribute3
   ,remark1
   ,rateopinion
   ,classify
   ,evaluateadvice
   ,groupname
   ,groupbusinesssum
   ,enttype
   ,probjecttype
   ,customerbusinesssum
   ,customertotalsum
   ,relativation
   ,businesstype
   ,attribute
   ,guarantytype
   ,phaseopinion6
   ,phaseopinion7
   ,isshowphaseopinion3
from ${idl_schema}.odss_flow_opinion
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_flow_opinion_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes