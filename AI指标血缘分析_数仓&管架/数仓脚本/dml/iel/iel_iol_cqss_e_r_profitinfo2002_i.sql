: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_profitinfo2002_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_profitinfo2002.i.${batch_date}.dat
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
    ,t.mainbsn_incm as mainbsn_incm
    ,t.exprt_pd_sale_incm as exprt_pd_sale_incm
    ,t.impr_pd_sale_incm as impr_pd_sale_incm
    ,t.sale_dcn_with_dct as sale_dcn_with_dct
    ,t.mainbsn_incm_netamt as mainbsn_incm_netamt
    ,t.mainbsn_cost as mainbsn_cost
    ,t.exprt_pd_sale_cost as exprt_pd_sale_cost
    ,t.mainbsn_tax_and_apd as mainbsn_tax_and_apd
    ,t.oprt_eps as oprt_eps
    ,t.othr_bcs as othr_bcs
    ,t.dfr_pft as dfr_pft
    ,t.prch_agnt_incm as prch_agnt_incm
    ,t.oicm as oicm
    ,t.mainbsn_pft as mainbsn_pft
    ,t.othr_bsn_pft as othr_bsn_pft
    ,t.oprg_eps as oprg_eps
    ,t.mtex as mtex
    ,t.fncex as fncex
    ,t.orexp as orexp
    ,t.oprg_pft as oprg_pft
    ,t.ispt as ispt
    ,t.ftrs_pft as ftrs_pft
    ,t.alwc_incm as alwc_incm
    ,t.alwc_bfr_ls_entp_incm as alwc_bfr_ls_entp_incm
    ,t.nonoprgincm as nonoprgincm
    ,t.displ_fix_ast_netincm as displ_fix_ast_netincm
    ,t.non_mntr_txn_pft as non_mntr_txn_pft
    ,t.sell_intgbl_ast_pft as sell_intgbl_ast_pft
    ,t.fine_net_incm as fine_net_incm
    ,t.othr_pft as othr_pft
    ,t.use_bfr_ys_sal_mkpft as use_bfr_ys_sal_mkpft
    ,t.nopex as nopex
    ,t.displ_fix_ast_netls as displ_fix_ast_netls
    ,t.dbt_regrp_loss as dbt_regrp_loss
    ,t.fine_expn as fine_expn
    ,t.dntn_expn as dntn_expn
    ,t.othexp as othexp
    ,t.crrov_icl_num_wage_bag as crrov_icl_num_wage_bag
    ,t.pft_tamt as pft_tamt
    ,t.incmtax as incmtax
    ,t.less_shrh_pftandloss as less_shrh_pftandloss
    ,t.not_cfm_ivs_loss as not_cfm_ivs_loss
    ,t.net_pft as net_pft
    ,t.begofyr_uspt as begofyr_uspt
    ,t.splrsv_recloss as splrsv_recloss
    ,t.othr_adj_fctr as othr_adj_fctr
    ,t.dstr_pft as dstr_pft
    ,t.idv_use_pft as idv_use_pft
    ,t.splmt_lqud_cptl as splmt_lqud_cptl
    ,t.rtrv_lgl_splrsv as rtrv_lgl_splrsv
    ,t.rtrv_lgl_pbwlf_gld as rtrv_lgl_pbwlf_gld
    ,t.exta_wk_rwd_wlf_fnd as exta_wk_rwd_wlf_fnd
    ,t.rtrv_rsrv_fnd as rtrv_rsrv_fnd
    ,t.rtrv_entp_dvlp_fnd as rtrv_entp_dvlp_fnd
    ,t.pft_ret_ivs as pft_ret_ivs
    ,t.othr_dstr_pft as othr_dstr_pft
    ,t.avl_ivsr_alct_pft as avl_ivsr_alct_pft
    ,t.pbl_prshr_dvdn as pbl_prshr_dvdn
    ,t.rtrv_rndm_splrsv as rtrv_rndm_splrsv
    ,t.pbl_ord_shr_dvdn as pbl_ord_shr_dvdn
    ,t.tfr_mk_cptl_ord_shr_dvdn as tfr_mk_cptl_ord_shr_dvdn
    ,t.othr_avl_ivsr_alct_pft as othr_avl_ivsr_alct_pft
    ,t.uspt as uspt
    ,t.afr_anul_tax_bfr_pft_rmnls as afr_anul_tax_bfr_pft_rmnls
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_profitinfo2002 t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_profitinfo2002.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes