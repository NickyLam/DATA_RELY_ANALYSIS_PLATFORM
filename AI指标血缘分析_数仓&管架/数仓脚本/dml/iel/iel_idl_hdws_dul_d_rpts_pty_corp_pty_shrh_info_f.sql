: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_corp_pty_shrh_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_shrh_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,shrh_pty_num
,shrh_name
,shrh_typ_cd
,shrh_frame_org_typ_cd
,shrh_loc_cty_cd
,shrh_org_cd
,shrh_oper_licence_id
,shrh_loan_card_num
,corp_promo_econ_cmpnt_cd
,ntr_psn_shrh_iden_typ_cd
,ntr_psn_shrh_iden_num
,shrh_ratio
,share_right_stru_to_dt
,cntri_mode_cd
,cntri_ccy_cd
,cntri_amt
,shrh_valid_flg
,actl_ctrler_flg
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_corp_pty_shrh_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_shrh_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes