: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_prd_p2p_subj_matt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_prd_p2p_subj_matt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(merch_id,chr(10),''),chr(13),'') as merch_id
      ,replace(replace(brw_id,chr(10),''),chr(13),'') as brw_id
      ,replace(replace(product_id,chr(10),''),chr(13),'') as product_id
      ,replace(replace(prd_typ,chr(10),''),chr(13),'') as prd_typ
      ,replace(replace(claim_tfr_subj_matt,chr(10),''),chr(13),'') as claim_tfr_subj_matt
      ,tender_st_dt
      ,tender_end_dt
      ,repay_dt
      ,replace(replace(prd_num,chr(10),''),chr(13),'') as prd_num
      ,replace(replace(bid_seq_num,chr(10),''),chr(13),'') as bid_seq_num
      ,replace(replace(name,chr(10),''),chr(13),'') as name
      ,replace(replace(brf,chr(10),''),chr(13),'') as brf
      ,replace(replace(int_mode,chr(10),''),chr(13),'') as int_mode
      ,replace(replace(memo,chr(10),''),chr(13),'') as memo
      ,replace(replace(open_seq_num,chr(10),''),chr(13),'') as open_seq_num
      ,replace(replace(brwer_iden_typ,chr(10),''),chr(13),'') as brwer_iden_typ
      ,replace(replace(brwer_iden_num,chr(10),''),chr(13),'') as brwer_iden_num
      ,replace(replace(brwer_acct,chr(10),''),chr(13),'') as brwer_acct
      ,replace(replace(brwer_name,chr(10),''),chr(13),'') as brwer_name
      ,replace(replace(num,chr(10),''),chr(13),'') as num
      ,replace(replace(bnk_nm,chr(10),''),chr(13),'') as bnk_nm
      ,replace(replace(pled_id,chr(10),''),chr(13),'') as pled_id
      ,replace(replace(brwer_pled_desc,chr(10),''),chr(13),'') as brwer_pled_desc
      ,replace(replace(repay_mode,chr(10),''),chr(13),'') as repay_mode
      ,replace(replace(annl_rate,chr(10),''),chr(13),'') as annl_rate
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,total_subj_matt_amt
      ,term
      ,brwer_amt
      ,replace(replace(aprv_pass_dt,chr(10),''),chr(13),'') as aprv_pass_dt
      ,lowt_bid_amt
      ,highest_bid_amt
      ,replace(replace(dd_status,chr(10),''),chr(13),'') as dd_status
      ,replace(replace(subj_matt_status,chr(10),''),chr(13),'') as subj_matt_status
      ,setup_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_prd_p2p_subj_matt_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_prd_p2p_subj_matt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes