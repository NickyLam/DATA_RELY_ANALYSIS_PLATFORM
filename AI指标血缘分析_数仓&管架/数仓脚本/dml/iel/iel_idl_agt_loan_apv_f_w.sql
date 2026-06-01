: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_loan_apv_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_apv_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.apv_flow_num
,t1.rela_appl_flow_num
,t1.happ_dt
,t1.party_id
,t1.bus_breed_id
,t1.happ_type_cd
,t1.bank_fin_tot
,t1.curr_cd
,t1.apv_amt
,t1.tenor_mon
,t1.loan_usage_descb
,t1.oper_org_id
,t1.oper_teller_id
,t1.oper_dt
,t1.rgst_org_id
,t1.rgst_teller_id
,t1.rgst_dt
,t1.modif_dt
,t1.reply_type_cd
,t1.circl_flg
,t1.apved_dt
,t1.lmt_circl_flg
,t1.effect_flg
,t1.loan_tenor
,t1.attach_rgst_flg
,t1.turn_crdt_flg
,t1.matn_flg
,t1.host_bk_name
,t1.patip_loan_bank_name
,t1.agent_bank_name
,t1.agent_patip_loan_flg
,t1.final_jud_pass_dt
,t1.crdt_rg_cd
,t1.invo_estate_fin_flg
,t1.invo_gover_class_fin_flg
,t1.consm_serv_class_fin_flg
,t1.br_build_ifin_flg
,t1.green_crdt_fin_flg
,t1.class_crdt_flg
,t1.reply_id
,t1.final_apv_opinion
,t1.final_apv_opinion_2
,t1.low_risk_bus_type_cd
,t1.risk_type_cd
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_loan_apv t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_apv_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes