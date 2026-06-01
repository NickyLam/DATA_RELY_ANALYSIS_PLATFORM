: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_loan_dun_info_02_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_loan_dun_info_02.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(dun_rec_seq_num,chr(10),''),chr(13),'') as dun_rec_seq_num
      ,etl_dt
      ,replace(replace(loan_acct_id,chr(10),''),chr(13),'') as loan_acct_id
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(dun_rec_typ_cd,chr(10),''),chr(13),'') as dun_rec_typ_cd
      ,replace(replace(dun_acti_cd,chr(10),''),chr(13),'') as dun_acti_cd
      ,dun_dt
      ,replace(replace(dun_resu_cd,chr(10),''),chr(13),'') as dun_resu_cd
      ,promi_repay_amt
      ,promi_repay_dt
      ,replace(replace(dun_info_memo,chr(10),''),chr(13),'') as dun_info_memo
      ,dun_crea_tm
      ,dun_final_modif_tm
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_loan_dun_info_02 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_loan_dun_info_02.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes