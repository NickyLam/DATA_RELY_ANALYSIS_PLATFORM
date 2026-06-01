: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_cashinfoinf2007_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_cashinfoinf2007.i.${batch_date}.dat
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
    ,t.rtpd_and_prd_lbrsvc_cash as rtpd_and_prd_lbrsvc_cash
    ,t.rcvd_taxfee_ret as rcvd_taxfee_ret
    ,t.rdothr_wth_optavy_cash as rdothr_wth_optavy_cash
    ,t.oprt_avy_flwcsh_sbtl as oprt_avy_flwcsh_sbtl
    ,t.prch_cdty_acptsvc_pycsh as prch_cdty_acptsvc_pycsh
    ,t.pygv_wkrs_forwkrs_pycsh as pygv_wkrs_forwkrs_pycsh
    ,t.py_et_taxfee as py_et_taxfee
    ,t.py_othr_oprt_avy_cash as py_othr_oprt_avy_cash
    ,t.oprt_avy_cf_out_sbtl as oprt_avy_cf_out_sbtl
    ,t.oprt_avy_gen_cf_netamt as oprt_avy_gen_cf_netamt
    ,t.wtd_ivsplc_rcvsch as wtd_ivsplc_rcvsch
    ,t.obis_icpl_rcvsch as obis_icpl_rcvsch
    ,t.dpl_ast_plc_cash as dpl_ast_plc_cash
    ,t.dpl_subs_oprgcl_cshntat as dpl_subs_oprgcl_cshntat
    ,t.rd_othr_ivs_avy_relcsh as rd_othr_ivs_avy_relcsh
    ,t.ivs_avy_flowcash_sbtl as ivs_avy_flowcash_sbtl
    ,t.acfxat_ast_plc_pycsh as acfxat_ast_plc_pycsh
    ,t.ivs_plc_pycsh as ivs_plc_pycsh
    ,t.obtn_subs_oprg_pyt_cshntat as obtn_subs_oprg_pyt_cshntat
    ,t.py_othr_ivs_avy_cash as py_othr_ivs_avy_cash
    ,t.ivs_avy_cf_out_sbtl as ivs_avy_cf_out_sbtl
    ,t.ivs_avy_gen_cf_netamt as ivs_avy_gen_cf_netamt
    ,t.absrb_ivs_plc_cash as absrb_ivs_plc_cash
    ,t.obtn_lnd_rcvds_cash as obtn_lnd_rcvds_cash
    ,t.rcvd_othr_fnc_avy_cash as rcvd_othr_fnc_avy_cash
    ,t.fnc_avy_flowcash_sbtl as fnc_avy_flowcash_sbtl
    ,t.repy_dbt_plc_pys_cash as repy_dbt_plc_pys_cash
    ,t.alct_dvdn_pft_cmpn_plc_pycsh as alct_dvdn_pft_cmpn_plc_pycsh
    ,t.py_othr_fnc_avy_cash as py_othr_fnc_avy_cash
    ,t.fnc_avy_cf_out_sbtl as fnc_avy_cf_out_sbtl
    ,t.set_avy_gen_cf_netamt as set_avy_gen_cf_netamt
    ,t.erch_csh_and_csheqv_aff as erch_csh_and_csheqv_aff
    ,t.casheqv_add_amt as casheqv_add_amt
    ,t.bop_casheqv_bal as bop_casheqv_bal
    ,t.eop_casheqv_bal as eop_casheqv_bal
    ,t.net_pft as net_pft
    ,t.ast_dprcnrsrv as ast_dprcnrsrv
    ,t.ast_dprcn as ast_dprcn
    ,t.intgbl_ast_amrz as intgbl_ast_amrz
    ,t.longtrm_ppdex_amrz as longtrm_ppdex_amrz
    ,t.ppdex_rdc as ppdex_rdc
    ,t.pnex_add as pnex_add
    ,t.displ_ast_loss as displ_ast_loss
    ,t.fix_ast_scrp_loss as fix_ast_scrp_loss
    ,t.fairval_chg_loss as fairval_chg_loss
    ,t.fncex as fncex
    ,t.ivs_loss as ivs_loss
    ,t.dfr_incmtax_ast_rdc as dfr_incmtax_ast_rdc
    ,t.dfr_incmtax_lby_add as dfr_incmtax_lby_add
    ,t.ivnts_rdc as ivnts_rdc
    ,t.oprg_rcvb_prjs_rdc as oprg_rcvb_prjs_rdc
    ,t.oprg_pbl_prjs_add as oprg_pbl_prjs_add
    ,t.othr_oprt_avy_cash_flow as othr_oprt_avy_cash_flow
    ,t.oprt_avy_cf_netamt as oprt_avy_cf_netamt
    ,t.dbt_tfr_for_cptl as dbt_tfr_for_cptl
    ,t.in1yr_exps_cnvrt_cobd as in1yr_exps_cnvrt_cobd
    ,t.fnc_rnt_fix_ast as fnc_rnt_fix_ast
    ,t.cash_endofprdbal as cash_endofprdbal
    ,t.cash_bgnprdbal as cash_bgnprdbal
    ,t.cash_eqvs_endofprdbal as cash_eqvs_endofprdbal
    ,t.cash_eqvs_bgnprdbal as cash_eqvs_bgnprdbal
    ,t.csheqv_ntic_add_amt as csheqv_ntic_add_amt
    ,t.othr_not_cash_ivs as othr_not_cash_ivs
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_cashinfoinf2007 t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_cashinfoinf2007.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes