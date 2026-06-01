: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_dbtcraccrepyprfmninf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_dbtcraccrepyprfmninf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,t.infrpt_dt as infrpt_dt
    ,t.bal as bal
    ,t.bal_chg_dt as bal_chg_dt
    ,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
    ,t.lv5cl_afm_dt as lv5cl_afm_dt
    ,t.rctlyocact_repydy_prd as rctlyocact_repydy_prd
    ,t.rctlyoc_act_repy_tamt as rctlyoc_act_repy_tamt
    ,replace(replace(t.rctly_oc_repy_form,chr(13),''),chr(10),'') as rctly_oc_repy_form
    ,t.rctly_oc_aptrpy_dt as rctly_oc_aptrpy_dt
    ,t.rctly_oc_repy_tamt as rctly_oc_repy_tamt
    ,t.cur_odue_tamt as cur_odue_tamt
    ,t.cur_odue_pnp as cur_odue_pnp
    ,t.dbtcr_acc_odue_monum as dbtcr_acc_odue_monum
    ,t.srpls_repy_monum as srpls_repy_monum
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_dbtcraccrepyprfmninf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcraccrepyprfmninf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes