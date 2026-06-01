: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_notclsgdbtcrtxnsmyinf_a1
CreateDate: 20250704
FileName:   ${iel_data_path}/cqss_e_r_notclsgdbtcrtxnsmyinf.i.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,astdsp_bsn_acc
,astdsp_bsn_bal
,rctly_oc_displ_dt
,adcsh_bsn_acc
,adcsh_bsn_bal
,adcshrctlyocrepydyprd
,cur_odue_tamt
,cur_odue_pnp
,odin_adoth
,othrdbtcrtclsyentrnum
,crt_dt_tm

from ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_notclsgdbtcrtxnsmyinf.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
