: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_cashbasicinf2002_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_cashbasicinf2002.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.fnrpt_prj_id,chr(13),''),chr(10),'') as fnrpt_prj_id
    ,replace(replace(t.bsmgt_inst_tp,chr(13),''),chr(10),'') as bsmgt_inst_tp
    ,replace(replace(t.bsmgt_insid,chr(13),''),chr(10),'') as bsmgt_insid
    ,replace(replace(t.yr_yyyy,chr(13),''),chr(10),'') as yr_yyyy
    ,replace(replace(t.rpt_tp,chr(13),''),chr(10),'') as rpt_tp
    ,replace(replace(t.rptfrmtp_sbdvsn,chr(13),''),chr(10),'') as rptfrmtp_sbdvsn
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_cashbasicinf2002 t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_cashbasicinf2002.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes