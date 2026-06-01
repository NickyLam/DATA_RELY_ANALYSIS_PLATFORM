: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_ln_flow_task_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_ln_flow_task_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select serialno
,objectno
,objecttype
,relativeserialno
,flowno
,flowname
,phaseno
,phasename
,phasetype
,applytype
,userid
,username
,orgid
,orgname
,begintime
,endtime
,phasechoice
,phaseaction
,phaseopinion
,phaseopinion1
,phaseopinion2
,phaseopinion3
,phaseopinion4
,checklistresult
,autodecision
,riskscanresult
,standardtime1
,standardtime2
,costlob
,clientx
,clienty
,width
,heigth
,groupinfo from idl.pirs_f_evt_ln_flow_task where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_ln_flow_task_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes