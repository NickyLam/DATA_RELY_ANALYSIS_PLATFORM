: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_profitinfo2007_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_profitinfo2007.i.${batch_date}.dat
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
    ,t.oprg_incm as oprg_incm
    ,t.oprg_cost as oprg_cost
    ,t.btschrg as btschrg
    ,t.sale_eps as sale_eps
    ,t.mtex as mtex
    ,t.fncex as fncex
    ,t.ammls as ammls
    ,t.frval_chg_ntincm as frval_chg_ntincm
    ,t.ivs_netincm as ivs_netincm
    ,t.ascent_jnvnts_ivs_pft as ascent_jnvnts_ivs_pft
    ,t.oprg_pft as oprg_pft
    ,t.nonoprgincm as nonoprgincm
    ,t.nopex as nopex
    ,t.non_lqud_ast_loss as non_lqud_ast_loss
    ,t.pft_tamt as pft_tamt
    ,t.incmtax_eps as incmtax_eps
    ,t.net_pft as net_pft
    ,t.bsc_eps as bsc_eps
    ,t.dut_eps as dut_eps
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_profitinfo2007 t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_profitinfo2007.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes