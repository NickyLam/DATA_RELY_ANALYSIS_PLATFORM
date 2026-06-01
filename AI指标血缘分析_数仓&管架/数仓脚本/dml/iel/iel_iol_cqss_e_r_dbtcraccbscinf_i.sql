: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_dbtcraccbscinf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_dbtcraccbscinf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.dbtcr_acc_id,chr(13),''),chr(10),'') as dbtcr_acc_id
,replace(replace(t1.acc_avy_st,chr(13),''),chr(10),'') as acc_avy_st
,replace(replace(t1.dbtcr_acc_tp,chr(13),''),chr(10),'') as dbtcr_acc_tp
,replace(replace(t1.lnd_ddln,chr(13),''),chr(10),'') as lnd_ddln
,replace(replace(t1.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t1.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t1.crg_agrm_id,chr(13),''),chr(10),'') as crg_agrm_id
,replace(replace(t1.dbtcr_bnctg_lrgclss,chr(13),''),chr(10),'') as dbtcr_bnctg_lrgclss
,replace(replace(t1.dbtcr_bnctg_sbdvsn,chr(13),''),chr(10),'') as dbtcr_bnctg_sbdvsn
,t1.opnacc_dt as opnacc_dt
,replace(replace(t1.ccycd,chr(13),''),chr(10),'') as ccycd
,t1.pbc_cr_lnd_amt as pbc_cr_lnd_amt
,t1.crgln as crgln
,t1.exdat as exdat
,replace(replace(t1.entp_cr_grtstl,chr(13),''),chr(10),'') as entp_cr_grtstl
,replace(replace(t1.dbtcraccorrepygrntmod,chr(13),''),chr(10),'') as dbtcraccorrepygrntmod
,replace(replace(t1.ln_dstr_form,chr(13),''),chr(10),'') as ln_dstr_form
,replace(replace(t1.jnt_lnd_idr,chr(13),''),chr(10),'') as jnt_lnd_idr
,t1.cls_dt as cls_dt
,t1.infrpt_dt as infrpt_dt
,t1.repy_prfmn_rcrd_num as repy_prfmn_rcrd_num
,t1.sptxn_num as sptxn_num
,t1.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_dbtcraccbscinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcraccbscinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes