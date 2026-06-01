: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_wrntaccbscinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_wrntaccbscinf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.wrnt_acc_id,chr(13),''),chr(10),'') as wrnt_acc_id
,replace(replace(t.wrnt_acc_tp,chr(13),''),chr(10),'') as wrnt_acc_tp
,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t.crg_agrm_id,chr(13),''),chr(10),'') as crg_agrm_id
,replace(replace(t.wrnt_txn_bnctg_sbdvsn,chr(13),''),chr(10),'') as wrnt_txn_bnctg_sbdvsn
,t.ftm_estb_dt as ftm_estb_dt
,replace(replace(t.ccycd,chr(13),''),chr(10),'') as ccycd
,t.bnk_lnd_amt as bnk_lnd_amt
,t.exdat as exdat
,replace(replace(t.anti_grtstl,chr(13),''),chr(10),'') as anti_grtstl
,replace(replace(t.wrntaccothrreygrntmod,chr(13),''),chr(10),'') as wrntaccothrreygrntmod
,t.mrgn_pct as mrgn_pct
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_wrntaccbscinf t 
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6 and etl_dt >= to_date('${batch_date}', 'yyyymmdd') - 6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_wrntaccbscinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes