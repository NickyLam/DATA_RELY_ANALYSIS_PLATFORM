: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_loanaccountinfo_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_loanaccountinfo_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.acc_id,chr(13),''),chr(10),'') as acc_id
,replace(replace(t.dbtcr_acc_tp,chr(13),''),chr(10),'') as dbtcr_acc_tp
,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t.acc_idr,chr(13),''),chr(10),'') as acc_idr
,t.crg_agrm_id as crg_agrm_id
,replace(replace(t.idvdbtcr_bnctg_sbdvsn,chr(13),''),chr(10),'') as idvdbtcr_bnctg_sbdvsn
,t.ftm_estb_dt as ftm_estb_dt
,replace(replace(t.ccycd,chr(13),''),chr(10),'') as ccycd
,t.bnk_lnd_amt as bnk_lnd_amt
,t.acc_crgln as acc_crgln
,t.shr_crgln as shr_crgln
,t.exdat as exdat
,replace(replace(t.rpmd,chr(13),''),chr(10),'') as rpmd
,replace(replace(t.idv_cr_repy_frq,chr(13),''),chr(10),'') as idv_cr_repy_frq
,t.repy_prd_num as repy_prd_num
,replace(replace(t.idv_cr_grtstl,chr(13),''),chr(10),'') as idv_cr_grtstl
,replace(replace(t.ln_dstr_form,chr(13),''),chr(10),'') as ln_dstr_form
,replace(replace(t.jnt_ln_indcd,chr(13),''),chr(10),'') as jnt_ln_indcd
,replace(replace(t.clm_sft_hr_s_repy_st,chr(13),''),chr(10),'') as clm_sft_hr_s_repy_st
,t.dbtcraccbaspinstmdnum as dbtcraccbaspinstmdnum
,replace(replace(t.fyrs_prfmn_strt_yrmo,chr(13),''),chr(10),'') as fyrs_prfmn_strt_yrmo
,replace(replace(t.fyrs_prfmn_ctof_yrmo,chr(13),''),chr(10),'') as fyrs_prfmn_ctof_yrmo
,t.odue_monum as odue_monum
,t.sptxn_num as sptxn_num
,t.spcl_ev_num as spcl_ev_num
,replace(replace(t.rctly24etrsmrstrtyrmo,chr(13),''),chr(10),'') as rctly24etrsmrstrtyrmo
,replace(replace(t.rctly24etrsmorcofyrmo,chr(13),''),chr(10),'') as rctly24etrsmorcofyrmo
,t.annttn_and_sttmnt_num as annttn_and_sttmnt_num
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_i_r_loanaccountinfo t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_loanaccountinfo_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes