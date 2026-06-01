: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_dbtcraccnidrryrsplinf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_dbtcraccnidrryrsplinf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.dbtcr_acc_id,chr(13),''),chr(10),'') as dbtcr_acc_id
    ,replace(replace(t.idnt_inf_cgycd,chr(13),''),chr(10),'') as idnt_inf_cgycd
    ,replace(replace(t.dbtcr_acc_tp,chr(13),''),chr(10),'') as dbtcr_acc_tp
    ,replace(replace(t.rel_repy_rspl_tp,chr(13),''),chr(10),'') as rel_repy_rspl_tp
    ,replace(replace(t.rel_repy_rspl_amt_ccy,chr(13),''),chr(10),'') as rel_repy_rspl_amt_ccy
    ,t.rel_repy_rspl_qot as rel_repy_rspl_qot
    ,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
    ,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
    ,replace(replace(t.repy_rspl_bnctg,chr(13),''),chr(10),'') as repy_rspl_bnctg
    ,replace(replace(t.dbtcrbnctg_sbdvsn,chr(13),''),chr(10),'') as dbtcrbnctg_sbdvsn
    ,t.ftm_estb_dt as ftm_estb_dt
    ,t.exdat as exdat
    ,replace(replace(t.ccycd,chr(13),''),chr(10),'') as ccycd
    ,t.bal as bal
    ,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
    ,t.cur_odue_tamt as cur_odue_tamt
    ,t.cur_odue_pnp as cur_odue_pnp
    ,t.dbtcr_acc_odue_monum as dbtcr_acc_odue_monum
    ,replace(replace(t.cr_ln_repy_st,chr(13),''),chr(10),'') as cr_ln_repy_st
    ,t.srpls_repy_monum as srpls_repy_monum
    ,t.infrpt_dt as infrpt_dt
    ,t.pbc_cr_lnd_amt as pbc_cr_lnd_amt
    ,t.pbc_cr_crline as pbc_cr_crline
    ,replace(replace(t.grnt_ctr_id,chr(13),''),chr(10),'') as grnt_ctr_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_dbtcraccnidrryrsplinf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcraccnidrryrsplinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes