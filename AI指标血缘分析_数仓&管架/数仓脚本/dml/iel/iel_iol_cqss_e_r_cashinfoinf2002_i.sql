: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_cashinfoinf2002_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_cashinfoinf2002.i.${batch_date}.dat
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
    ,t.rd_othr_ivs_avy_relcsh as rd_othr_ivs_avy_relcsh
    ,t.ivs_avy_flowcash_sbtl as ivs_avy_flowcash_sbtl
    ,t.acfxat_ast_plc_pycsh as acfxat_ast_plc_pycsh
    ,t.ivs_plc_pycsh as ivs_plc_pycsh
    ,t.py_othr_ivs_avy_cash as py_othr_ivs_avy_cash
    ,t.ivs_avy_cf_out_sbtl as ivs_avy_cf_out_sbtl
    ,t.ivs_avy_gen_cf_netamt as ivs_avy_gen_cf_netamt
    ,t.absrb_ivs_plc_cash as absrb_ivs_plc_cash
    ,t.lnd_plc_rcvd_cash as lnd_plc_rcvd_cash
    ,t.rcvd_othr_fnc_avy_cash as rcvd_othr_fnc_avy_cash
    ,t.fnc_avy_flowcash_sbtl as fnc_avy_flowcash_sbtl
    ,t.repy_dbt_plc_pys_cash as repy_dbt_plc_pys_cash
    ,t.alct_dvdn_pft_cmpn_plc_pycsh as alct_dvdn_pft_cmpn_plc_pycsh
    ,t.py_othr_fnc_avy_rel_cash as py_othr_fnc_avy_rel_cash
    ,t.fnc_avy_cf_out_sbtl as fnc_avy_cf_out_sbtl
    ,t.set_avy_gen_cf_num_netamt as set_avy_gen_cf_num_netamt
    ,t.erch_to_cash_aff as erch_to_cash_aff
    ,t.cash_eqv_ntic_add_amt as cash_eqv_ntic_add_amt
    ,t.net_pft as net_pft
    ,t.acr_ast_dprcnrsrv as acr_ast_dprcnrsrv
    ,t.fix_ast_old as fix_ast_old
    ,t.intgbl_ast_amrz as intgbl_ast_amrz
    ,t.longtrm_ppdex_amrz as longtrm_ppdex_amrz
    ,t.ppdex_rdc as ppdex_rdc
    ,t.pnex_add as pnex_add
    ,t.displ_ast_loss as displ_ast_loss
    ,t.fix_ast_scrp_loss as fix_ast_scrp_loss
    ,t.fncex as fncex
    ,t.ivs_loss as ivs_loss
    ,t.dfr_taxpymt_crnt as dfr_taxpymt_crnt
    ,t.ivnt_s_rdc as ivnt_s_rdc
    ,t.oprg_rcvb_prj_rdc as oprg_rcvb_prj_rdc
    ,t.oprg_pbl_prj_add as oprg_pbl_prj_add
    ,t.othr_oprt_avy_cash_flow as othr_oprt_avy_cash_flow
    ,t.oprt_avy_cf_netamt as oprt_avy_cf_netamt
    ,t.dbt_tfr_for_cptl as dbt_tfr_for_cptl
    ,t.in1yr_exp_cnvrt_cobd as in1yr_exp_cnvrt_cobd
    ,t.fnc_rnt_fix_ast as fnc_rnt_fix_ast
    ,t.othr_not_cash_ivs as othr_not_cash_ivs
    ,t.cash_endofprdbal as cash_endofprdbal
    ,t.cash_bgnprdbal as cash_bgnprdbal
    ,t.cash_eqv_endofprdbal as cash_eqv_endofprdbal
    ,t.cash_eqv_bgnprdbal as cash_eqv_bgnprdbal
    ,t.csheqv_ntic_add_amt as csheqv_ntic_add_amt
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_cashinfoinf2002 t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_cashinfoinf2002.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes