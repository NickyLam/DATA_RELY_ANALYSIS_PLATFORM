: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_alrdyclsgdbtctnsmyinf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_alrdyclsgdbtctnsmyinf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.astdsp_bsn_acc as astdsp_bsn_acc
    ,t.astdsp_bsn_bal as astdsp_bsn_bal
    ,t.displ_compl_dt as displ_compl_dt
    ,t.clsg_dt as clsg_dt
    ,t.adcsh_bsn_acc as adcsh_bsn_acc
    ,t.adcsh_bsn_bal as adcsh_bsn_bal
    ,t.othrdbtcrtclsyentrnum as othrdbtcrtclsyentrnum
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_alrdyclsgdbtctnsmyinf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_alrdyclsgdbtctnsmyinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes