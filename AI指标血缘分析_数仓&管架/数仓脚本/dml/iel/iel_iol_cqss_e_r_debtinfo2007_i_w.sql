: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_debtinfo2007_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_debtinfo2007_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
,t.ccy_fnds as ccy_fnds
,t.tdfnast as tdfnast
,t.rcvb_bl as rcvb_bl
,t.rcvb as rcvb
,t.prpy_accval as prpy_accval
,t.recint as recint
,t.rbdn as rbdn
,t.ohrv as ohrv
,t.ivnt as ivnt
,t.in1yr_exps_non_lqud_ast as in1yr_exps_non_lqud_ast
,t.othr_lqud_ast as othr_lqud_ast
,t.lqud_ast_tot as lqud_ast_tot
,t.csls_fast as csls_fast
,t.heldtmatinvm as heldtmatinvm
,t.ltmeyis as ltmeyis
,t.longtrm_rcvb as longtrm_rcvb
,t.ivs_prp_rlest as ivs_prp_rlest
,t.fix_ast as fix_ast
,t.ucpt as ucpt
,t.prj_dnc as prj_dnc
,t.fix_atcln as fix_atcln
,t.pd_prp_blgc_ast as pd_prp_blgc_ast
,t.oil_ast as oil_ast
,t.intgbl_ast as intgbl_ast
,t.dvlp_expn as dvlp_expn
,t.gdwl as gdwl
,t.longtrm_ppdex as longtrm_ppdex
,t.dfr_incmtax_ast as dfr_incmtax_ast
,t.othr_non_lqud_ast as othr_non_lqud_ast
,t.non_lqud_ast_tot as non_lqud_ast_tot
,t.ast_tot as ast_tot
,t.shrttm_lnd as shrttm_lnd
,t.fncastheldforlby as fncastheldforlby
,t.pbl_bl as pbl_bl
,t.pbl_accval as pbl_accval
,t.riav_accval as riav_accval
,t.plit as plit
,t.empewageexpn as empewageexpn
,t.ptxf as ptxf
,t.pbl_dvdn as pbl_dvdn
,t.othr_pl as othr_pl
,t.in1yr_exps_non_lqud_lby as in1yr_exps_non_lqud_lby
,t.othr_lqud_lby as othr_lqud_lby
,t.lqud_lby_tot as lqud_lby_tot
,t.longtrm_lnd as longtrm_lnd
,t.pbl_bond as pbl_bond
,t.longtrm_pybl as longtrm_pybl
,t.spcl_pybl as spcl_pybl
,t.frcst_lby as frcst_lby
,t.dfr_incmtax_lby as dfr_incmtax_lby
,t.othr_non_lqud_lby as othr_non_lqud_lby
,t.non_lqud_lby_tot as non_lqud_lby_tot
,t.lby_tot as lby_tot
,t.arcptl as arcptl
,t.cptrsv as cptrsv
,t.sub_trrstk as sub_trrstk
,t.splrsv as splrsv
,t.uspt as uspt
,t.owr_rght_tot as owr_rght_tot
,t.lby_and_owr_rght_tot as lby_and_owr_rght_tot
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_debtinfo2007 t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_debtinfo2007_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes