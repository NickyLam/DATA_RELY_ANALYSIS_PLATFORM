: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_lbyhistsmyinf_a
CreateDate: 20240809
FileName:   ${iel_data_path}/cqss_e_r_lbyhistsmyinf.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.mo,chr(13),''),chr(10),'') as mo
    ,t.whl_lby_acc as whl_lby_acc
    ,t.whl_lby_bal as whl_lby_bal
    ,t.fcs_cgy_lby_acc as fcs_cgy_lby_acc
    ,t.fcs_cgy_lby_bal as fcs_cgy_lby_bal
    ,t.bad_cgy_lby_acc as bad_cgy_lby_acc
    ,t.bad_cgy_lby_bal as bad_cgy_lby_bal
    ,t.odue_acc as odue_acc
    ,t.cur_odue_tamt as cur_odue_tamt
    ,t.odue_pnp_acc as odue_pnp_acc
    ,t.cur_odue_pnp as cur_odue_pnp
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_lbyhistsmyinf t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_lbyhistsmyinf.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes