: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_tmp_zjbk_inctrctinfo_f
CreateDate: 20250107
FileName:   ${iel_data_path}/icms_tmp_zjbk_inctrctinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.infrectype,chr(13),''),chr(10),'') as infrectype
,replace(replace(t1.contractcode,chr(13),''),chr(10),'') as contractcode
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idnum,chr(13),''),chr(10),'') as idnum
,replace(replace(t1.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
,replace(replace(t1.ctrctcertrelsgmt_updflag,chr(13),''),chr(10),'') as ctrctcertrelsgmt_updflag
,replace(replace(t1.creditlimsgmt_updflag,chr(13),''),chr(10),'') as creditlimsgmt_updflag
,replace(replace(t1.brernm,chr(13),''),chr(10),'') as brernm
,replace(replace(t1.ctrctcertreldata,chr(13),''),chr(10),'') as ctrctcertreldata
,replace(replace(t1.creditlimtype,chr(13),''),chr(10),'') as creditlimtype
,replace(replace(t1.limloopflg,chr(13),''),chr(10),'') as limloopflg
,replace(replace(t1.creditlim,chr(13),''),chr(10),'') as creditlim
,replace(replace(t1.cy,chr(13),''),chr(10),'') as cy
,replace(replace(t1.coneffdate,chr(13),''),chr(10),'') as coneffdate
,replace(replace(t1.conexpdate,chr(13),''),chr(10),'') as conexpdate
,replace(replace(t1.constatus,chr(13),''),chr(10),'') as constatus
,replace(replace(t1.creditrest,chr(13),''),chr(10),'') as creditrest
,replace(replace(t1.creditrestcode,chr(13),''),chr(10),'') as creditrestcode

from ${iol_schema}.icms_tmp_zjbk_inctrctinfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tmp_zjbk_inctrctinfo.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
