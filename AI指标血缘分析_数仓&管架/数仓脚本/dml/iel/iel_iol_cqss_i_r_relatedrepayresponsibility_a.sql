: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_relatedrepayresponsibility_a
CreateDate: 20241115
FileName:   ${iel_data_path}/cqss_i_r_relatedrepayresponsibility.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.idnt_inf_cgycd,chr(13),''),chr(10),'') as idnt_inf_cgycd
    ,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
    ,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
    ,replace(replace(t.repy_rspl_bnctg,chr(13),''),chr(10),'') as repy_rspl_bnctg
    ,t.cr_ln_dstr_dt as cr_ln_dstr_dt
    ,t.cr_ln_exdat as cr_ln_exdat
    ,replace(replace(t.rel_repy_rsplpsn_tp,chr(13),''),chr(10),'') as rel_repy_rsplpsn_tp
    ,t.rel_repy_rspl_qot as rel_repy_rspl_qot
    ,replace(replace(t.ccycd,chr(13),''),chr(10),'') as ccycd
    ,t.cr_lnpp_bal as cr_lnpp_bal
    ,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
    ,replace(replace(t.dbtcr_acc_tp,chr(13),''),chr(10),'') as dbtcr_acc_tp
    ,replace(replace(t.cr_ln_repy_st,chr(13),''),chr(10),'') as cr_ln_repy_st
    ,t.cr_ln_odue_cnu_monum as cr_ln_odue_cnu_monum
    ,t.vld_codt as vld_codt
    ,t.annttn_and_sttmnt_num as annttn_and_sttmnt_num
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
    ,replace(replace(t.grnt_ctr_id,chr(13),''),chr(10),'') as grnt_ctr_id
from iol.cqss_i_r_relatedrepayresponsibility t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_relatedrepayresponsibility.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes