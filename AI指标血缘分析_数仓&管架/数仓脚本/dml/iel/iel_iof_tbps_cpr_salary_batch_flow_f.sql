: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_tbps_cpr_salary_batch_flow_f
CreateDate: 20251105
FileName:   ${iel_data_path}/tbps_cpr_salary_batch_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sbf_batchno,chr(13),''),chr(10),'') as sbf_batchno
,replace(replace(t1.sbf_trade_flowno,chr(13),''),chr(10),'') as sbf_trade_flowno
,replace(replace(t1.sbf_month,chr(13),''),chr(10),'') as sbf_month
,replace(replace(t1.sbf_ecifno,chr(13),''),chr(10),'') as sbf_ecifno
,replace(replace(t1.sbf_userno,chr(13),''),chr(10),'') as sbf_userno
,replace(replace(t1.sbf_username,chr(13),''),chr(10),'') as sbf_username
,replace(replace(t1.sbf_payeracno,chr(13),''),chr(10),'') as sbf_payeracno
,replace(replace(t1.sbf_payeracname,chr(13),''),chr(10),'') as sbf_payeracname
,replace(replace(t1.sbf_currency,chr(13),''),chr(10),'') as sbf_currency
,sbf_totalcount
,sbf_totalamount
,replace(replace(t1.sbf_uploadfilename,chr(13),''),chr(10),'') as sbf_uploadfilename
,replace(replace(t1.sbf_filename,chr(13),''),chr(10),'') as sbf_filename
,replace(replace(t1.sbf_orderflag,chr(13),''),chr(10),'') as sbf_orderflag
,replace(replace(t1.sbf_batchstyle,chr(13),''),chr(10),'') as sbf_batchstyle
,replace(replace(t1.sbf_sysflag,chr(13),''),chr(10),'') as sbf_sysflag
,replace(replace(t1.sbf_transdate,chr(13),''),chr(10),'') as sbf_transdate
,replace(replace(t1.sbf_transtime,chr(13),''),chr(10),'') as sbf_transtime
,replace(replace(t1.sbf_processendtime,chr(13),''),chr(10),'') as sbf_processendtime
,replace(replace(t1.sbf_timerrule,chr(13),''),chr(10),'') as sbf_timerrule
,sbf_successcount
,sbf_successamount
,sbf_failcount
,sbf_failamount
,replace(replace(t1.sbf_remark,chr(13),''),chr(10),'') as sbf_remark
,replace(replace(t1.sbf_batchstate,chr(13),''),chr(10),'') as sbf_batchstate
,replace(replace(t1.sbf_returncode,chr(13),''),chr(10),'') as sbf_returncode
,replace(replace(t1.sbf_returnmsg,chr(13),''),chr(10),'') as sbf_returnmsg
,replace(replace(t1.sbf_hostremark,chr(13),''),chr(10),'') as sbf_hostremark
,replace(replace(t1.sbf_hostbatchno,chr(13),''),chr(10),'') as sbf_hostbatchno
,replace(replace(t1.sbf_showflag,chr(13),''),chr(10),'') as sbf_showflag
,replace(replace(t1.sbf_parentlogno,chr(13),''),chr(10),'') as sbf_parentlogno

from ${iol_schema}.tbps_cpr_salary_batch_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbps_cpr_salary_batch_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
