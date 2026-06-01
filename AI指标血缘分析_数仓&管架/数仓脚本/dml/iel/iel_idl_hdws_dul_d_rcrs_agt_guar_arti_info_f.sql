: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rcrs_agt_guar_arti_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rcrs_agt_guar_arti_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
coll_id
,etl_dt
,last_update_dt
,req_cmpst_right_seq
,guar_status_cd
,guar_arti_typ_cd
,pled_comm
,owns_pers_id
,owns_pers_name
,ccy_cd
,coll_val
,ghb_cfm_val
,impa_val
,reg_dt
,reg_org_cd
,oper_org_id
,arti_rcv_dt
,impa_rate
,pled_est_ccy_cd
,pled_est_val
,est_dt
,est_org_name
,est_org_org_org_cd
,est_org_reg_org_name
,impa_name
,impa_iden_typ_cd
,impa_iden_num
,flow_impa_flg
,purch_insur_flg
,coll_name
,coll_owns_typ_cd
,owns_cert_typ
,owns_cert_num
,owns_reg_org
,est_mode_cd
,asse
,est_due_day
,hight_impa_rate
,pled_store_loc
,equi_disp_flg
,lease_flg
,coll_rent
,lease_start_day
,lease_due_day
,lease_situ_comm
,annl_rent
,reg_flg
,reg_due_dt
,reg_term_corp_cd
,reg_term
,reg
,notl_flg
,notl_cert_id
,notl_org
,notr
,notz_dt
,keep_pers
,com_pers_cust_nbr
,com_pers_name
,com_pers_cert_typ
,com_pers_cert_num
,com_pers_cont_loc
,regu_flg
,regu_situ_desc
,intk_status_cd
,intk_dt
,upda_dt
,data_src_cd
,del_flg
,etl_task_name
,guar_dt
,guar_pers_one_name
,guar_pers_two_name
,off_stl_flg
,off_stl_stdt
,right_cert_name
,right_cert_reg_num
,right_cert_valid_due_dt
,reg_org_name
from ${idl_schema}.hdws_dul_d_rcrs_agt_guar_arti_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rcrs_agt_guar_arti_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes