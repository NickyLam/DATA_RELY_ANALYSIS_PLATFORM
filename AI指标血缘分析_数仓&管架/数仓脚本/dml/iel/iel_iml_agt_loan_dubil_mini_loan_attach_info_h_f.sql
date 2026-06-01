: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_dubil_mini_loan_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_dubil_mini_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,surp_perds
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.ped_cd,chr(13),''),chr(10),'') as ped_cd
,replace(replace(t1.loan_kind_cd,chr(13),''),chr(10),'') as loan_kind_cd
,eh_issue_deduct_amt
,unpay_nomal_int
,replace(replace(t1.pre_recv_int_flg,chr(13),''),chr(10),'') as pre_recv_int_flg
,ovdue_comp_int
,ovdue_int
,ovdue_pnlt
,ovdue_nomal_pric
,ovdue_acm_rpbl_amt
,ovdue_mgmt_ovdue_pric
,next_term_repay_int_amt
,next_term_rpp_amt
,next_term_rpp_dt
,next_term_repay_int_dt
,replace(replace(t1.modif_post_repay_num_name,chr(13),''),chr(10),'') as modif_post_repay_num_name
,replace(replace(t1.modif_post_repay_num_id,chr(13),''),chr(10),'') as modif_post_repay_num_id
,replace(replace(t1.buy_out_liqd_flg,chr(13),''),chr(10),'') as buy_out_liqd_flg
,wrt_off_in_bs_int
,wrt_off_off_bs_int
,wrtoff_dt
,replace(replace(t1.wrt_off_cate_cd,chr(13),''),chr(10),'') as wrt_off_cate_cd

from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_dubil_mini_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
