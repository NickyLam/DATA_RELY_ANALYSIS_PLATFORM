: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_loan_dun_info_01_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_loan_dun_info_01.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dun_rec_seq_num,chr(13),''),chr(10),'') as dun_rec_seq_num
,t1.etl_dt as etl_dt 
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id 
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id 
,replace(replace(t1.dun_rec_typ_cd,chr(13),''),chr(10),'') as dun_rec_typ_cd 
,replace(replace(t1.dun_acti_cd,chr(13),''),chr(10),'') as dun_acti_cd 
,t1.dun_dt as dun_dt 
,replace(replace(t1.dun_resu_cd,chr(13),''),chr(10),'') as dun_resu_cd 
,t1.promi_repay_amt as promi_repay_amt 
,t1.promi_repay_dt as promi_repay_dt 
,replace(replace(t1.dun_info_memo,chr(13),''),chr(10),'') as dun_info_memo 
,t1.dun_crea_tm as dun_crea_tm 
,t1.dun_final_modif_tm as dun_final_modif_tm 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
from ${idl_schema}.hdws_dul_d_rpts_agt_loan_dun_info_01 t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_loan_dun_info_01.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes