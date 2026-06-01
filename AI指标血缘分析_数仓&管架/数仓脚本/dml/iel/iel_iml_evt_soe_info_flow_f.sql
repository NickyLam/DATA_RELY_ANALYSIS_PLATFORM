: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_soe_info_flow_f
CreateDate: 20221229
FileName:   ${iel_data_path}/evt_soe_info_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,tran_dt
,replace(replace(t1.soe_tran_status_cd,chr(13),''),chr(10),'') as soe_tran_status_cd
,replace(replace(t1.soe_tran_type_cd,chr(13),''),chr(10),'') as soe_tran_type_cd
,replace(replace(t1.bank_flow_num,chr(13),''),chr(10),'') as bank_flow_num
,replace(replace(t1.soe_bus_type_cd,chr(13),''),chr(10),'') as soe_bus_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.attach_cert_no,chr(13),''),chr(10),'') as attach_cert_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.soe_cap_attr_cd,chr(13),''),chr(10),'') as soe_cap_attr_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,soe_amt
,replace(replace(t1.soe_cny_acct_id,chr(13),''),chr(10),'') as soe_cny_acct_id
,replace(replace(t1.soe_cap_modal_cd,chr(13),''),chr(10),'') as soe_cap_modal_cd
,replace(replace(t1.indv_fx_acct_id,chr(13),''),chr(10),'') as indv_fx_acct_id
,replace(replace(t1.bus_trast_src_cd,chr(13),''),chr(10),'') as bus_trast_src_cd
,bus_trast_tm
,replace(replace(t1.input_rs_cd,chr(13),''),chr(10),'') as input_rs_cd
,replace(replace(t1.input_comnt,chr(13),''),chr(10),'') as input_comnt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.rtn_rcpt_bank_flow_num,chr(13),''),chr(10),'') as rtn_rcpt_bank_flow_num
,ths_soe_usd_amt
,tyr_soe_usd_surp_lmt
,replace(replace(t1.indv_main_cls_status_cd,chr(13),''),chr(10),'') as indv_main_cls_status_cd
,issue_dt
,exp_dt
,replace(replace(t1.issue_rs,chr(13),''),chr(10),'') as issue_rs
,replace(replace(t1.issue_rs_cd,chr(13),''),chr(10),'') as issue_rs_cd
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.init_node,chr(13),''),chr(10),'') as init_node
,replace(replace(t1.acpt_node,chr(13),''),chr(10),'') as acpt_node
,send_tm
,replace(replace(t1.msg_id,chr(13),''),chr(10),'') as msg_id
,replace(replace(t1.tran_info_desc,chr(13),''),chr(10),'') as tran_info_desc
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.sorc_sys_flow_num,chr(13),''),chr(10),'') as sorc_sys_flow_num
,replace(replace(t1.modif_rs_cd,chr(13),''),chr(10),'') as modif_rs_cd

from ${iml_schema}.evt_soe_info_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_soe_info_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
