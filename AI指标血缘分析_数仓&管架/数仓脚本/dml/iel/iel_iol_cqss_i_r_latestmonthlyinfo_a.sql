: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_latestmonthlyinfo_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_latestmonthlyinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.mo,chr(13),''),chr(10),'') as mo
    ,replace(replace(t.dbtcr_acc_st,chr(13),''),chr(10),'') as dbtcr_acc_st
    ,t.dbtcr_acba as dbtcr_acba
    ,t.usd_lmt as usd_lmt
    ,t.notisugsbigasinstmbal as notisugsbigasinstmbal
    ,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
    ,t.srpls_repy_prd as srpls_repy_prd
    ,t.setl_repydy as setl_repydy
    ,t.tm_shldrepymt_amt as tm_shldrepymt_amt
    ,t.tm_act_repy_amt as tm_act_repy_amt
    ,t.rctlyocact_repydy_prd as rctlyocact_repydy_prd
    ,t.cur_odue_prd as cur_odue_prd
    ,t.cur_odue_tamt as cur_odue_tamt
    ,t.odue31to60dynotretpnp as odue31to60dynotretpnp
    ,t.odue61to90dynotretpnp as odue61to90dynotretpnp
    ,t.odue91toohednotretpnp as odue91toohednotretpnp
    ,t.odueohedyabv_ntpa_bal as odueohedyabv_ntpa_bal
    ,t.od_ohedy_abv_ntpa_bal as od_ohedy_abv_ntpa_bal
    ,t.rctly6etrsmoavgus_lmt as rctly6etrsmoavgus_lmt
    ,t.rctly6etrsmoavgod_bal as rctly6etrsmoavgod_bal
    ,t.max_us_lmt as max_us_lmt
    ,t.max_od_bal as max_od_bal
    ,t.rpt_dt as rpt_dt
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_latestmonthlyinfo t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_latestmonthlyinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes