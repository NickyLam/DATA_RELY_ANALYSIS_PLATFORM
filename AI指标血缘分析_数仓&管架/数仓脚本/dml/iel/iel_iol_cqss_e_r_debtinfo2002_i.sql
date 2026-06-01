: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_debtinfo2002_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_debtinfo2002.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.ccy_fnds as ccy_fnds
    ,t.shrttm_ivs as shrttm_ivs
    ,t.rcvb_bl as rcvb_bl
    ,t.rbdn as rbdn
    ,t.recint as recint
    ,t.rcvb as rcvb
    ,t.ohrv as ohrv
    ,t.prpy_accval as prpy_accval
    ,t.ftrs_mrgn as ftrs_mrgn
    ,t.rcvb_alwc_amt as rcvb_alwc_amt
    ,t.rcvb_eptrb as rcvb_eptrb
    ,t.ivnt as ivnt
    ,t.ivnt_ori_mtrl as ivnt_ori_mtrl
    ,t.ivnt_mdupartcl as ivnt_mdupartcl
    ,t.ppdex as ppdex
    ,t.pndg_lqud_ast_net_loss as pndg_lqud_ast_net_loss
    ,t.in1yr_exps_longtrm_clm_ivs as in1yr_exps_longtrm_clm_ivs
    ,t.othr_lqud_ast as othr_lqud_ast
    ,t.lqud_ast_tot as lqud_ast_tot
    ,t.ltemivs as ltemivs
    ,t.ltmeyis as ltmeyis
    ,t.longtrm_clm_ivs as longtrm_clm_ivs
    ,t.mrg_prmg as mrg_prmg
    ,t.ltemivs_tot as ltemivs_tot
    ,t.fix_ast_ori_prc as fix_ast_ori_prc
    ,t.acm_dprcn as acm_dprcn
    ,t.fix_ast_netval as fix_ast_netval
    ,t.fix_ast_val_dprcnrsrv as fix_ast_val_dprcnrsrv
    ,t.fix_ast_netamt as fix_ast_netamt
    ,t.fix_atcln as fix_atcln
    ,t.prj_dnc as prj_dnc
    ,t.ucpt as ucpt
    ,t.pndg_fix_ast_net_loss as pndg_fix_ast_net_loss
    ,t.fix_ast_tot as fix_ast_tot
    ,t.intgbl_ast as intgbl_ast
    ,t.land_use_wght as land_use_wght
    ,t.dfr_ast as dfr_ast
    ,t.fix_ast_fix as fix_ast_fix
    ,t.fix_ast_chg_expn as fix_ast_chg_expn
    ,t.othr_longtrm_ast as othr_longtrm_ast
    ,t.spcl_qsi_rsrv_dnc as spcl_qsi_rsrv_dnc
    ,t.intgbl_and_othrast_tot as intgbl_and_othrast_tot
    ,t.dfr_taxpymt_brw_itm as dfr_taxpymt_brw_itm
    ,t.ast_tot as ast_tot
    ,t.shrttm_lnd as shrttm_lnd
    ,t.pbl_bl as pbl_bl
    ,t.pbl_accval as pbl_accval
    ,t.riav_accval as riav_accval
    ,t.pbl_wage as pbl_wage
    ,t.pbl_wlfr_fee as pbl_wlfr_fee
    ,t.pblpft as pblpft
    ,t.acrtax as acrtax
    ,t.othr_pymt_amt as othr_pymt_amt
    ,t.otpl as otpl
    ,t.pnex as pnex
    ,t.frcst_lby as frcst_lby
    ,t.in1yr_exps_longtrm_lby as in1yr_exps_longtrm_lby
    ,t.othr_lqud_lby as othr_lqud_lby
    ,t.lqud_lby_tot as lqud_lby_tot
    ,t.longtrm_lnd as longtrm_lnd
    ,t.pbl_bond as pbl_bond
    ,t.longtrm_pybl as longtrm_pybl
    ,t.spcl_pybl as spcl_pybl
    ,t.othr_longtrm_lby as othr_longtrm_lby
    ,t.spcl_qsi_rsrv_fnd as spcl_qsi_rsrv_fnd
    ,t.longtrm_lby_tot as longtrm_lby_tot
    ,t.dfr_taxpymt_crnt as dfr_taxpymt_crnt
    ,t.lby_tot as lby_tot
    ,t.less_num_shrh_rght as less_num_shrh_rght
    ,t.arcptl as arcptl
    ,t.cty_cptl as cty_cptl
    ,t.colltvt_cptl as colltvt_cptl
    ,t.lglpsn_cptl as lglpsn_cptl
    ,t.nal_lglpsn_cptl as nal_lglpsn_cptl
    ,t.colltvt_lglpsn_cptl as colltvt_lglpsn_cptl
    ,t.idv_cptl as idv_cptl
    ,t.frgnmrch_cptl as frgnmrch_cptl
    ,t.cptrsv as cptrsv
    ,t.splrsv as splrsv
    ,t.lgl_pblc as lgl_pblc
    ,t.pbwlf_gld as pbwlf_gld
    ,t.splmt_lqud_cptl as splmt_lqud_cptl
    ,t.not_cfms_ivs_loss as not_cfms_ivs_loss
    ,t.uspt as uspt
    ,t.frncy_rpt_cnvr_difamt as frncy_rpt_cnvr_difamt
    ,t.owr_rght_tot as owr_rght_tot
    ,t.lby_and_owr_rght_tot as lby_and_owr_rght_tot
    ,t.crt_dt_tm as crt_dt_tm
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
from iol.cqss_e_r_debtinfo2002 t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_debtinfo2002.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes