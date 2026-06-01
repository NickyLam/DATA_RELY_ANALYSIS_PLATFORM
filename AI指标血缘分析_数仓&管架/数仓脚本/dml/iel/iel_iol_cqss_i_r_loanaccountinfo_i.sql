: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_loanaccountinfo_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_loanaccountinfo.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.acc_id,chr(13),''),chr(10),'') as acc_id
,replace(replace(t1.dbtcr_acc_tp,chr(13),''),chr(10),'') as dbtcr_acc_tp
,replace(replace(t1.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t1.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t1.acc_idr,chr(13),''),chr(10),'') as acc_idr
,t1.crg_agrm_id as crg_agrm_id
,replace(replace(t1.idvdbtcr_bnctg_sbdvsn,chr(13),''),chr(10),'') as idvdbtcr_bnctg_sbdvsn
,t1.ftm_estb_dt as ftm_estb_dt
,replace(replace(t1.ccycd,chr(13),''),chr(10),'') as ccycd
,t1.bnk_lnd_amt as bnk_lnd_amt
,t1.acc_crgln as acc_crgln
,t1.shr_crgln as shr_crgln
,t1.exdat as exdat
,replace(replace(t1.rpmd,chr(13),''),chr(10),'') as rpmd
,replace(replace(t1.idv_cr_repy_frq,chr(13),''),chr(10),'') as idv_cr_repy_frq
,t1.repy_prd_num as repy_prd_num
,replace(replace(t1.idv_cr_grtstl,chr(13),''),chr(10),'') as idv_cr_grtstl
,replace(replace(t1.ln_dstr_form,chr(13),''),chr(10),'') as ln_dstr_form
,replace(replace(t1.jnt_ln_indcd,chr(13),''),chr(10),'') as jnt_ln_indcd
,replace(replace(t1.clm_sft_hr_s_repy_st,chr(13),''),chr(10),'') as clm_sft_hr_s_repy_st
,t1.dbtcraccbaspinstmdnum as dbtcraccbaspinstmdnum
,replace(replace(t1.fyrs_prfmn_strt_yrmo,chr(13),''),chr(10),'') as fyrs_prfmn_strt_yrmo
,replace(replace(t1.fyrs_prfmn_ctof_yrmo,chr(13),''),chr(10),'') as fyrs_prfmn_ctof_yrmo
,t1.odue_monum as odue_monum
,t1.sptxn_num as sptxn_num
,t1.spcl_ev_num as spcl_ev_num
,replace(replace(t1.rctly24etrsmrstrtyrmo,chr(13),''),chr(10),'') as rctly24etrsmrstrtyrmo
,replace(replace(t1.rctly24etrsmorcofyrmo,chr(13),''),chr(10),'') as rctly24etrsmorcofyrmo
,t1.annttn_and_sttmnt_num as annttn_and_sttmnt_num
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t1.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_i_r_loanaccountinfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_loanaccountinfo.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes