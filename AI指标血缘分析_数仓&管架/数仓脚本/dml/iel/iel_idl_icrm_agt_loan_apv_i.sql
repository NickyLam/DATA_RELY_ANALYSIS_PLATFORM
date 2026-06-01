: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_agt_loan_apv_i
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_agt_loan_apv.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select agt_id
,lp_id
,apv_flow_num
,rela_appl_flow_num
,happ_dt
,party_id
,bus_breed_id
,happ_type_cd
,bank_fin_tot
,curr_cd
,apv_amt
,tenor_mon
,loan_usage_descb
,oper_org_id
,oper_teller_id
,oper_dt
,rgst_org_id
,rgst_teller_id
,rgst_dt
,modif_dt
,reply_type_cd
,circl_flg
,apved_dt
,lmt_circl_flg
,effect_flg
,loan_tenor
,attach_rgst_flg
,turn_crdt_flg
,matn_flg
,host_bk_name
,patip_loan_bank_name
,agent_bank_name
,agent_patip_loan_flg
,final_jud_pass_dt
,crdt_rg_cd
,invo_estate_fin_flg
,invo_gover_class_fin_flg
,consm_serv_class_fin_flg
,br_build_ifin_flg
,green_crdt_fin_flg
,class_crdt_flg
,reply_id
,final_apv_opinion
,final_apv_opinion_2
,etl_dt
,job_cd from idl.icrm_agt_loan_apv where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_agt_loan_apv.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes