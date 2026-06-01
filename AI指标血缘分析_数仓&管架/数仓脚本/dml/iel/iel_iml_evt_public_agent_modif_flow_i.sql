: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_public_agent_modif_flow_i
CreateDate: 20250117
FileName:   ${iel_data_path}/evt_public_agent_modif_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.modif_flow_num,chr(13),''),chr(10),'') as modif_flow_num
,modif_dt
,replace(replace(t1.unify_info_que_flow_num,chr(13),''),chr(10),'') as unify_info_que_flow_num
,init_tran_dt
,replace(replace(t1.init_tran_bus_flow_num,chr(13),''),chr(10),'') as init_tran_bus_flow_num
,replace(replace(t1.init_tran_ova_flow_num,chr(13),''),chr(10),'') as init_tran_ova_flow_num
,replace(replace(t1.blip_batch_no,chr(13),''),chr(10),'') as blip_batch_no
,replace(replace(t1.agent_flg,chr(13),''),chr(10),'') as agent_flg
,replace(replace(t1.public_agent_type_cd,chr(13),''),chr(10),'') as public_agent_type_cd
,replace(replace(t1.public_agent_name,chr(13),''),chr(10),'') as public_agent_name
,replace(replace(t1.agent_reason_descb,chr(13),''),chr(10),'') as agent_reason_descb
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cont_num,chr(13),''),chr(10),'') as cont_num
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.career_cd_one,chr(13),''),chr(10),'') as career_cd_one
,replace(replace(t1.career_descb_one,chr(13),''),chr(10),'') as career_descb_one
,replace(replace(t1.career_cd_two,chr(13),''),chr(10),'') as career_cd_two
,replace(replace(t1.career_descb_two,chr(13),''),chr(10),'') as career_descb_two
,replace(replace(t1.career_dtl_comnt,chr(13),''),chr(10),'') as career_dtl_comnt
,replace(replace(t1.cont_addr_prov_cd,chr(13),''),chr(10),'') as cont_addr_prov_cd
,replace(replace(t1.cont_addr_prov_name,chr(13),''),chr(10),'') as cont_addr_prov_name
,replace(replace(t1.cont_addr_city_cd,chr(13),''),chr(10),'') as cont_addr_city_cd
,replace(replace(t1.cont_addr_city_name,chr(13),''),chr(10),'') as cont_addr_city_name
,replace(replace(t1.cont_addr_rg_cd,chr(13),''),chr(10),'') as cont_addr_rg_cd
,replace(replace(t1.cont_addr_rg_name,chr(13),''),chr(10),'') as cont_addr_rg_name
,replace(replace(t1.cont_addr,chr(13),''),chr(10),'') as cont_addr
,replace(replace(t1.licen_issue_autho_addr,chr(13),''),chr(10),'') as licen_issue_autho_addr
,cert_start_dt
,cert_exp_dt
,replace(replace(t1.netw_vrfction_flow_num,chr(13),''),chr(10),'') as netw_vrfction_flow_num
,replace(replace(t1.netw_vrfction_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rest_cd
,replace(replace(t1.netw_vrfction_rule_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rule_rest_cd
,replace(replace(t1.face_recn_rest_cd,chr(13),''),chr(10),'') as face_recn_rest_cd
,replace(replace(t1.face_recn_score,chr(13),''),chr(10),'') as face_recn_score

from ${iml_schema}.evt_public_agent_modif_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_public_agent_modif_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
