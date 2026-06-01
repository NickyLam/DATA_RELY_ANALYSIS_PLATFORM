: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_ybnsrzzssbb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_ybnsrzzssbb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.skssqq,chr(13),''),chr(10),'') as skssqq
,replace(replace(t.skssqz,chr(13),''),chr(10),'') as skssqz
,replace(replace(t.sbrq,chr(13),''),chr(10),'') as sbrq
,t.ewblxh as ewblxh
,replace(replace(t.lmc,chr(13),''),chr(10),'') as lmc
,t.asysljsxse as asysljsxse
,t.yshwxse as yshwxse
,t.yslwxse as yslwxse
,t.sysl_nsjctzxse as sysl_nsjctzxse
,t.ajybfjsxse as ajybfjsxse
,t.jybf_nsjctzxse as jybf_nsjctzxse
,t.mdtbfckxse as mdtbfckxse
,t.msxse as msxse
,t.mshwxse as mshwxse
,t.mslwxse as mslwxse
,t.xxse as xxse
,t.jxse as jxse
,t.sqldse as sqldse
,t.jxsezc as jxsezc
,t.mdtytse as mdtytse
,t.sysl_nsjcybjse as sysl_nsjcybjse
,t.ydksehj as ydksehj
,t.sjdkse as sjdkse
,t.ynse as ynse
,t.qmldse as qmldse
,t.jybf_ynse as jybf_ynse
,t.jybf_nsjcybjse as jybf_nsjcybjse
,t.ynsejze as ynsejze
,t.ynsehj as ynsehj
,t.qcwjse as qcwjse
,t.ssckkjzyjkstse as ssckkjzyjkstse
,t.bqyjse as bqyjse
,t.fcyjse as fcyjse
,t.ckkjzyjksyjse as ckkjzyjksyjse
,t.bqjnsqynse as bqjnsqynse
,t.bqjnqjse as bqjnqjse
,t.qmwjse as qmwjse
,t.qmwjse_qjse as qmwjse_qjse
,t.bqybtse as bqybtse
,t.jzjtsjtse as jzjtsjtse
,t.qcwjcbse as qcwjcbse
,t.bqrkcbse as bqrkcbse
,t.qmwjcbse as qmwjcbse
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_ybnsrzzssbb t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_ybnsrzzssbb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes