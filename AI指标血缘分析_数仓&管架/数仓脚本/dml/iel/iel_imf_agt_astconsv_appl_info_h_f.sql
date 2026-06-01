: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_astconsv_appl_info_h_f
CreateDate: 20240906
FileName:   ${iel_data_path}/agt_astconsv_appl_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.ths_tm_asset_cls_cd,chr(13),''),chr(10),'') as ths_tm_asset_cls_cd
,replace(replace(t1.appl_rs_descb,chr(13),''),chr(10),'') as appl_rs_descb
,derate_bf_pric_sum
,derate_bf_adv_fee_sum
,derate_bf_comp_int_sum
,derate_bf_pnlt_sum
,derate_bf_int_sum
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,dubil_qtty
,replace(replace(t1.brwer_resv_recs_flg,chr(13),''),chr(10),'') as brwer_resv_recs_flg
,replace(replace(t1.guartor_resv_recs_flg,chr(13),''),chr(10),'') as guartor_resv_recs_flg
,replace(replace(t1.exist_propty_flg,chr(13),''),chr(10),'') as exist_propty_flg
,replace(replace(t1.asset_descb,chr(13),''),chr(10),'') as asset_descb
,replace(replace(t1.obj_type_cd,chr(13),''),chr(10),'') as obj_type_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,ths_tm_tran_pric_sum
,ths_tm_tran_int_sum
,ths_tm_comp_int_sum
,ths_tm_pnlt_sum
,ths_tm_tran_adv_fee_sum
,oper_dt
,replace(replace(t1.oper_belong_org_id,chr(13),''),chr(10),'') as oper_belong_org_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,ths_return_post_acct_recl_amt
,ths_return_bf_acct_recv_amt
,ths_tm_return_amt
,last_acm_return_amt
,acm_return_amt
,fst_return_amt
,rtn_suit_fee_cosdetn
,replace(replace(t1.wrt_off_type_cd,chr(13),''),chr(10),'') as wrt_off_type_cd
,replace(replace(t1.acct_recvbl_acct_id,chr(13),''),chr(10),'') as acct_recvbl_acct_id
,replace(replace(t1.acct_recvbl_acct_name,chr(13),''),chr(10),'') as acct_recvbl_acct_name
,acct_recvbl_amt
,replace(replace(t1.tran_plat_cd,chr(13),''),chr(10),'') as tran_plat_cd
,replace(replace(t1.tran_cont_id,chr(13),''),chr(10),'') as tran_cont_id
,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd
,tran_price
,real_tran_cosdetn
,replace(replace(t1.tran_return_acct_id,chr(13),''),chr(10),'') as tran_return_acct_id
,replace(replace(t1.tran_return_acct_name,chr(13),''),chr(10),'') as tran_return_acct_name
,replace(replace(t1.inside_acct_open_org_id,chr(13),''),chr(10),'') as inside_acct_open_org_id
,rgst_dt
,replace(replace(t1.rgst_belong_org_id,chr(13),''),chr(10),'') as rgst_belong_org_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.agt_astconsv_appl_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_astconsv_appl_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
