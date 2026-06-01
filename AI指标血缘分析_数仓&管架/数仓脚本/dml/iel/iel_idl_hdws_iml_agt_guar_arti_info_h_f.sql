: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_guar_arti_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_guar_arti_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,t1.req_cmpst_right_seq as req_cmpst_right_seq
,replace(replace(t1.guar_status_cd,chr(13),''),chr(10),'') as guar_status_cd
,replace(replace(t1.guar_arti_typ_cd,chr(13),''),chr(10),'') as guar_arti_typ_cd
,replace(replace(t1.pled_comm,chr(13),''),chr(10),'') as pled_comm
,replace(replace(t1.owns_pers_id,chr(13),''),chr(10),'') as owns_pers_id
,replace(replace(t1.owns_pers_name,chr(13),''),chr(10),'') as owns_pers_name
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.coll_val as coll_val
,t1.ghb_cfm_val as ghb_cfm_val
,t1.impa_val as impa_val
,t1.reg_dt as reg_dt
,replace(replace(t1.reg_org_cd,chr(13),''),chr(10),'') as reg_org_cd
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,t1.arti_rcv_dt as arti_rcv_dt
,t1.impa_rate as impa_rate
,replace(replace(t1.pled_est_ccy_cd,chr(13),''),chr(10),'') as pled_est_ccy_cd
,t1.pled_est_val as pled_est_val
,t1.est_dt as est_dt
,replace(replace(t1.est_org_name,chr(13),''),chr(10),'') as est_org_name
,replace(replace(t1.est_org_org_org_cd,chr(13),''),chr(10),'') as est_org_org_org_cd
,replace(replace(t1.est_org_reg_org_name,chr(13),''),chr(10),'') as est_org_reg_org_name
,replace(replace(t1.impa_name,chr(13),''),chr(10),'') as impa_name
,replace(replace(t1.impa_iden_typ_cd,chr(13),''),chr(10),'') as impa_iden_typ_cd
,replace(replace(t1.impa_iden_num,chr(13),''),chr(10),'') as impa_iden_num
,replace(replace(t1.flow_impa_flg,chr(13),''),chr(10),'') as flow_impa_flg
,replace(replace(t1.purch_insur_flg,chr(13),''),chr(10),'') as purch_insur_flg
,replace(replace(t1.coll_name,chr(13),''),chr(10),'') as coll_name
,replace(replace(t1.coll_owns_typ_cd,chr(13),''),chr(10),'') as coll_owns_typ_cd
,replace(replace(t1.owns_cert_typ,chr(13),''),chr(10),'') as owns_cert_typ
,replace(replace(t1.owns_cert_num,chr(13),''),chr(10),'') as owns_cert_num
,replace(replace(t1.owns_reg_org,chr(13),''),chr(10),'') as owns_reg_org
,replace(replace(t1.est_mode_cd,chr(13),''),chr(10),'') as est_mode_cd
,replace(replace(t1.asse,chr(13),''),chr(10),'') as asse
,t1.est_due_day as est_due_day
,t1.hight_impa_rate as hight_impa_rate
,replace(replace(t1.pled_store_loc,chr(13),''),chr(10),'') as pled_store_loc
,replace(replace(t1.equi_disp_flg,chr(13),''),chr(10),'') as equi_disp_flg
,replace(replace(t1.lease_flg,chr(13),''),chr(10),'') as lease_flg
,replace(replace(t1.coll_rent,chr(13),''),chr(10),'') as coll_rent
,t1.lease_start_day as lease_start_day
,t1.lease_due_day as lease_due_day
,replace(replace(t1.lease_situ_comm,chr(13),''),chr(10),'') as lease_situ_comm
,t1.annl_rent as annl_rent
,replace(replace(t1.reg_flg,chr(13),''),chr(10),'') as reg_flg
,t1.reg_due_dt as reg_due_dt
,replace(replace(t1.reg_term_corp_cd,chr(13),''),chr(10),'') as reg_term_corp_cd
,t1.reg_term as reg_term
,replace(replace(t1.reg,chr(13),''),chr(10),'') as reg
,replace(replace(t1.notl_flg,chr(13),''),chr(10),'') as notl_flg
,replace(replace(t1.notl_cert_id,chr(13),''),chr(10),'') as notl_cert_id
,replace(replace(t1.notl_org,chr(13),''),chr(10),'') as notl_org
,replace(replace(t1.notr,chr(13),''),chr(10),'') as notr
,t1.notz_dt as notz_dt
,replace(replace(t1.keep_pers,chr(13),''),chr(10),'') as keep_pers
,replace(replace(t1.com_pers_cust_nbr,chr(13),''),chr(10),'') as com_pers_cust_nbr
,replace(replace(t1.com_pers_name,chr(13),''),chr(10),'') as com_pers_name
,replace(replace(t1.com_pers_cert_typ,chr(13),''),chr(10),'') as com_pers_cert_typ
,replace(replace(t1.com_pers_cert_num,chr(13),''),chr(10),'') as com_pers_cert_num
,replace(replace(t1.com_pers_cont_loc,chr(13),''),chr(10),'') as com_pers_cont_loc
,replace(replace(t1.regu_flg,chr(13),''),chr(10),'') as regu_flg
,replace(replace(t1.regu_situ_desc,chr(13),''),chr(10),'') as regu_situ_desc
,replace(replace(t1.intk_status_cd,chr(13),''),chr(10),'') as intk_status_cd
,t1.intk_dt as intk_dt
,t1.upda_dt as upda_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_GUAR_ARTI_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_GUAR_ARTI_INFO_H') as etl_task_name 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,t1.guar_dt as guar_dt
,replace(replace(t1.guar_pers_one_name,chr(13),''),chr(10),'') as guar_pers_one_name
,replace(replace(t1.guar_pers_two_name,chr(13),''),chr(10),'') as guar_pers_two_name
,replace(replace(t1.off_stl_flg,chr(13),''),chr(10),'') as off_stl_flg
,t1.off_stl_stdt as off_stl_stdt
,replace(replace(t1.right_cert_name,chr(13),''),chr(10),'') as right_cert_name
,replace(replace(t1.right_cert_reg_num,chr(13),''),chr(10),'') as right_cert_reg_num
,t1.right_cert_valid_due_dt as right_cert_valid_due_dt
,replace(replace(t1.reg_org_name,chr(13),''),chr(10),'') as reg_org_name
,replace(replace(t1.keep_flag,chr(13),''),chr(10),'') as keep_flag
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
from ${idl_schema}.hdws_iml_agt_guar_arti_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_guar_arti_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes