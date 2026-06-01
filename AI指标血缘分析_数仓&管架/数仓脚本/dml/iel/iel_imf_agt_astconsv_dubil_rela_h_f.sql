: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_astconsv_dubil_rela_h_f
CreateDate: 20240903
FileName:   ${iel_data_path}/agt_astconsv_dubil_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.ths_tm_asset_cls_cd,chr(13),''),chr(10),'') as ths_tm_asset_cls_cd
,replace(replace(t1.aldy_cmplt_flg,chr(13),''),chr(10),'') as aldy_cmplt_flg
,replace(replace(t1.disp_plan_and_prog_descb,chr(13),''),chr(10),'') as disp_plan_and_prog_descb
,replace(replace(t1.on_acct_seq_num,chr(13),''),chr(10),'') as on_acct_seq_num
,derate_bf_pric_tot
,derate_pric
,derate_provi_comp_int
,derate_provi_int
,derate_provi_pnlt
,derate_ovdue_pric
,derate_int_rat
,derate_actl_owe_comp_int
,derate_actl_owe_int
,derate_actl_owe_pnlt
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.last_asset_cls_cd,chr(13),''),chr(10),'') as last_asset_cls_cd
,replace(replace(t1.asset_descb,chr(13),''),chr(10),'') as asset_descb
,replace(replace(t1.core_sucs_return_rest_flg,chr(13),''),chr(10),'') as core_sucs_return_rest_flg
,replace(replace(t1.core_return_rest,chr(13),''),chr(10),'') as core_return_rest
,ths_return_post_acct_recl_amt
,ths_return_bf_acct_recv_amt
,acm_return_amt
,replace(replace(t1.revs_status_cd,chr(13),''),chr(10),'') as revs_status_cd
,assign_tran_price
,assign_tran_fst_price
,assign_tran_acct_recvbl_price
,wrt_off_adv_fee
,replace(replace(t1.suit_prog_descb,chr(13),''),chr(10),'') as suit_prog_descb
,rgst_dt
,replace(replace(t1.rgst_belong_org_id,chr(13),''),chr(10),'') as rgst_belong_org_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.agt_astconsv_dubil_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_astconsv_dubil_rela_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
