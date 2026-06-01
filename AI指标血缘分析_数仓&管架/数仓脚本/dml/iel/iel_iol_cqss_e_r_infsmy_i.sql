: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_infsmy_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_infsmy.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.ftm_ext_crln_txn_s_yr,chr(13),''),chr(10),'') as ftm_ext_crln_txn_s_yr
    ,replace(replace(t.ftmextrelrepyrspls_yr,chr(13),''),chr(10),'') as ftmextrelrepyrspls_yr
    ,t.hpncrlntxn_s_inst_num as hpncrlntxn_s_inst_num
    ,t.crnotclsg_ln_inst_num as crnotclsg_ln_inst_num
    ,t.dbtcr_txn_bal as dbtcr_txn_bal
    ,t.berec_s_dbtcr_txn_bal as berec_s_dbtcr_txn_bal
    ,t.fcs_cgy_dbtcr_txn_bal as fcs_cgy_dbtcr_txn_bal
    ,t.bad_cgy_dbtcr_txn_bal as bad_cgy_dbtcr_txn_bal
    ,t.wrnt_txn_bal_bal as wrnt_txn_bal_bal
    ,t.fcs_cgy_wrnt_txn_bal as fcs_cgy_wrnt_txn_bal
    ,t.bad_cgy_wrnt_txn_bal as bad_cgy_wrnt_txn_bal
    ,t.noncr_tnac_num as noncr_tnac_num
    ,t.ow_tax_rcrd_num as ow_tax_rcrd_num
    ,t.cvl_jdgmt_rcrd_num as cvl_jdgmt_rcrd_num
    ,t.efrcexe_rcrd_num as efrcexe_rcrd_num
    ,t.admn_pnsh_rcrd_num as admn_pnsh_rcrd_num
    ,t.notclsgwrttclsentrnum as notclsgwrttclsentrnum
    ,t.alrdyclsgwtclsentrnum as alrdyclsgwtclsentrnum
    ,t.dbtcrtxnrelrrspltpnum as dbtcrtxnrelrrspltpnum
    ,t.wrnttxnrelryrspltpnum as wrnttxnrelryrspltpnum
    ,t.hist_lby_mo_num as hist_lby_mo_num
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_infsmy t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_infsmy.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes