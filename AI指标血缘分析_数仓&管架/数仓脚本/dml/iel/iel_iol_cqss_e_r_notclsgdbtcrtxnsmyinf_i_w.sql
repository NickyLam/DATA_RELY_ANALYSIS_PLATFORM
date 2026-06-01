: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_notclsgdbtcrtxnsmyinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_notclsgdbtcrtxnsmyinf_w.i.${batch_date}.dat
IF_mark:    i_w
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
,t.rctly_oc_displ_dt as rctly_oc_displ_dt
,t.adcsh_bsn_acc as adcsh_bsn_acc
,t.adcsh_bsn_bal as adcsh_bsn_bal
,t.adcshrctlyocrepydyprd as adcshrctlyocrepydyprd
,t.cur_odue_tamt as cur_odue_tamt
,t.cur_odue_pnp as cur_odue_pnp
,t.odin_adoth as odin_adoth
,t.othrdbtcrtclsyentrnum as othrdbtcrtclsyentrnum
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_notclsgdbtcrtxnsmyinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes