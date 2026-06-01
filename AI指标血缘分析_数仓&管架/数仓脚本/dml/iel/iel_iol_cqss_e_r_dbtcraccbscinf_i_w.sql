: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_dbtcraccbscinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_dbtcraccbscinf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.dbtcr_acc_id,chr(13),''),chr(10),'') as dbtcr_acc_id
,replace(replace(t.acc_avy_st,chr(13),''),chr(10),'') as acc_avy_st
,replace(replace(t.dbtcr_acc_tp,chr(13),''),chr(10),'') as dbtcr_acc_tp
,replace(replace(t.lnd_ddln,chr(13),''),chr(10),'') as lnd_ddln
,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t.crg_agrm_id,chr(13),''),chr(10),'') as crg_agrm_id
,replace(replace(t.dbtcr_bnctg_lrgclss,chr(13),''),chr(10),'') as dbtcr_bnctg_lrgclss
,replace(replace(t.dbtcr_bnctg_sbdvsn,chr(13),''),chr(10),'') as dbtcr_bnctg_sbdvsn
,t.opnacc_dt as opnacc_dt
,replace(replace(t.ccycd,chr(13),''),chr(10),'') as ccycd
,t.pbc_cr_lnd_amt as pbc_cr_lnd_amt
,t.crgln as crgln
,t.exdat as exdat
,replace(replace(t.entp_cr_grtstl,chr(13),''),chr(10),'') as entp_cr_grtstl
,replace(replace(t.dbtcraccorrepygrntmod,chr(13),''),chr(10),'') as dbtcraccorrepygrntmod
,replace(replace(t.ln_dstr_form,chr(13),''),chr(10),'') as ln_dstr_form
,replace(replace(t.jnt_lnd_idr,chr(13),''),chr(10),'') as jnt_lnd_idr
,t.cls_dt as cls_dt
,t.infrpt_dt as infrpt_dt
,t.repy_prfmn_rcrd_num as repy_prfmn_rcrd_num
,t.sptxn_num as sptxn_num
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_dbtcraccbscinf t 
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6 and etl_dt >= to_date('${batch_date}', 'yyyymmdd') - 6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcraccbscinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes