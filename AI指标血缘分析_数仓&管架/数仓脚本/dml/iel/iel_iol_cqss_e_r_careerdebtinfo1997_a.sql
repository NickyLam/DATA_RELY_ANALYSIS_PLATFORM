: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_careerdebtinfo1997_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_careerdebtinfo1997.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,t.cash as cash
    ,t.bk_dp as bk_dp
    ,t.rcvb_bl as rcvb_bl
    ,t.rcvb as rcvb
    ,t.prpy_accval as prpy_accval
    ,t.othr_rv as othr_rv
    ,t.mtrl as mtrl
    ,t.fsh_prdt as fsh_prdt
    ,t.ext_ivs as ext_ivs
    ,t.fix_ast as fix_ast
    ,t.intgbl_ast as intgbl_ast
    ,t.ast_tot as ast_tot
    ,t.out_fee as out_fee
    ,t.out_spclfnd as out_spclfnd
    ,t.spclfnd_expn as spclfnd_expn
    ,t.crer_expn as crer_expn
    ,t.oprt_expn as oprt_expn
    ,t.cost_eps as cost_eps
    ,t.sale_tax as sale_tax
    ,t.tnov_supr_expn as tnov_supr_expn
    ,t.to_aflt_unit_alwc as to_aflt_unit_alwc
    ,t.crrov_slfnc_nfrstr as crrov_slfnc_nfrstr
    ,t.expn_tot as expn_tot
    ,t.ast_dt_cgy_tot as ast_dt_cgy_tot
    ,t.dbt_fud as dbt_fud
    ,t.pbl_bl as pbl_bl
    ,t.pbl_accval as pbl_accval
    ,t.riav_accval as riav_accval
    ,t.otpl as otpl
    ,t.pbl_bdgt_amt as pbl_bdgt_amt
    ,t.pbl_fnc_spclacc_amt as pbl_fnc_spclacc_amt
    ,t.acrtax as acrtax
    ,t.lby_tot as lby_tot
    ,t.crer_fnd as crer_fnd
    ,t.com_fnd as com_fnd
    ,t.ivs_fnd as ivs_fnd
    ,t.fix_fnd as fix_fnd
    ,t.spclpps_fnd as spclpps_fnd
    ,t.crer_srpls as crer_srpls
    ,t.oprt_srpls as oprt_srpls
    ,t.netast_tot as netast_tot
    ,t.fnc_alwc_incm as fnc_alwc_incm
    ,t.supr_alwc_incm as supr_alwc_incm
    ,t.into_spclfnd as into_spclfnd
    ,t.crer_incm as crer_incm
    ,t.oprt_incm as oprt_incm
    ,t.aflt_unit_pym as aflt_unit_pym
    ,t.othr_icm as othr_icm
    ,t.incm_tot as incm_tot
    ,t.lby_dt_cgy_tot as lby_dt_cgy_tot
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_careerdebtinfo1997 t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_careerdebtinfo1997.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes