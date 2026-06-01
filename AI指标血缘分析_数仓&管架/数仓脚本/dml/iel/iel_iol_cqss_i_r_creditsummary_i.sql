: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_creditsummary_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_creditsummary.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,t.pbc_digt_iptn as pbc_digt_iptn
    ,t.rel_lo as rel_lo
    ,t.scor_cmnt_num as scor_cmnt_num
    ,t.crln_acc_tot as crln_acc_tot
    ,t.crbn_tp_num as crbn_tp_num
    ,t.be_rec_acc_tot as be_rec_acc_tot
    ,t.be_rec_bal_tot as be_rec_bal_tot
    ,t.be_rec_btp_num as be_rec_btp_num
    ,t.stgdbt_acc as stgdbt_acc
    ,t.stgdbt_bal as stgdbt_bal
    ,t.odue_od_btp_num as odue_od_btp_num
    ,t.rel_repy_rspl_num as rel_repy_rspl_num
    ,t.af_py_btp_num as af_py_btp_num
    ,t.pblc_inf_tp_num as pblc_inf_tp_num
    ,t.lt_enqr_dt as lt_enqr_dt
    ,replace(replace(t.lt_enqr_inst_tp,chr(13),''),chr(10),'') as lt_enqr_inst_tp
    ,replace(replace(t.lt_enqr_inst_cd,chr(13),''),chr(10),'') as lt_enqr_inst_cd
    ,replace(replace(t.lt_enqr_rsn,chr(13),''),chr(10),'') as lt_enqr_rsn
    ,t.lnaprvrcy1emieinstnum as lnaprvrcy1emieinstnum
    ,t.ccarcy1emienqrinstnum as ccarcy1emienqrinstnum
    ,t.lnaprvrcly1emienqrcnt as lnaprvrcly1emienqrcnt
    ,t.ccarcy1eminnrsenqrcnt as ccarcy1eminnrsenqrcnt
    ,t.myslfenqrr1emienqrcnt as myslfenqrr1emienqrcnt
    ,t.pstloanmgtr2yienqrcnt as pstloanmgtr2yienqrcnt
    ,t.wrntquaexmr2yienqrcnt as wrntquaexmr2yienqrcnt
    ,t.apntmrchrner2yienrcnt as apntmrchrner2yienrcnt
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_creditsummary t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_creditsummary.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes