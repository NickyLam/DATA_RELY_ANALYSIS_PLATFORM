: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_i_r_relatedrepayresponsibility_i
CreateDate: 20250703
FileName:   ${iel_data_path}/cqss_i_r_relatedrepayresponsibility.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.idnt_inf_cgycd,chr(13),''),chr(10),'') as idnt_inf_cgycd
,replace(replace(t1.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t1.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t1.repy_rspl_bnctg,chr(13),''),chr(10),'') as repy_rspl_bnctg
,cr_ln_dstr_dt
,cr_ln_exdat
,replace(replace(t1.rel_repy_rsplpsn_tp,chr(13),''),chr(10),'') as rel_repy_rsplpsn_tp
,rel_repy_rspl_qot
,replace(replace(t1.ccycd,chr(13),''),chr(10),'') as ccycd
,cr_lnpp_bal
,replace(replace(t1.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,replace(replace(t1.dbtcr_acc_tp,chr(13),''),chr(10),'') as dbtcr_acc_tp
,replace(replace(t1.cr_ln_repy_st,chr(13),''),chr(10),'') as cr_ln_repy_st
,cr_ln_odue_cnu_monum
,vld_codt
,annttn_and_sttmnt_num
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,crt_dt_tm
,replace(replace(t1.grnt_ctr_id,chr(13),''),chr(10),'') as grnt_ctr_id

from ${iol_schema}.cqss_i_r_relatedrepayresponsibility t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_relatedrepayresponsibility.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
