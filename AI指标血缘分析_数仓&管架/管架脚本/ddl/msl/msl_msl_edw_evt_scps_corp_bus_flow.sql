/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_evt_scps_corp_bus_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_evt_scps_corp_bus_flow
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_evt_scps_corp_bus_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_evt_scps_corp_bus_flow(
    etl_dt date
    ,evt_id varchar2(250)
    ,lp_id varchar2(100)
    ,task_no varchar2(100)
    ,ova_flow_num varchar2(100)
    ,cust_open_acct_dt date
    ,org_id varchar2(100)
    ,teller_id varchar2(100)
    ,open_acct_status_cd varchar2(30)
    ,temp_acct_valid_dt date
    ,super_corp_name varchar2(500)
    ,super_director_cert_type_cd varchar2(60)
    ,super_director_cert_no varchar2(60)
    ,depositr_name varchar2(500)
    ,pre_proc_id varchar2(100)
    ,fst_proof_doc_type_cd varchar2(60)
    ,fst_proof_doc_id varchar2(100)
    ,fst_proof_doc_exp_dt date
    ,fst_cert_type_cd varchar2(30)
    ,bus_flow_set varchar2(60)
    ,sign_mobile_no varchar2(60)
    ,bkcp_seal_way_cd varchar2(60)
    ,post_addr_desc varchar2(500)
    ,bkcp_zip_cd varchar2(60)
    ,bkcp_cotas varchar2(500)
    ,bkcp_phone_num varchar2(60)
    ,bkcp_check_entry_way_cd varchar2(60)
    ,bkcp_check_entry_ped_cd varchar2(60)
    ,y_acm_lmt number(30,2)
    ,daily_accum_lmt number(30,2)
    ,daily_accum_cnt number(10)
    ,basic_serv_appl_type_cd varchar2(60)
    ,verify_type_cd varchar2(60)
    ,checker_seq_num varchar2(60)
    ,cap_verify_teller_id varchar2(100)
    ,legal_rep_mobile_no varchar2(60)
    ,legal_rep_fixline_tel_num varchar2(60)
    ,fin_princ_name varchar2(500)
    ,fin_princ_mobile_no varchar2(60)
    ,fin_princ_fixline_tel_num varchar2(60)
    ,org_name varchar2(500)
    ,org_addr varchar2(500)
    ,legal_rep_name varchar2(500)
    ,main_acct_id varchar2(100)
    ,corp_stop_pay_status_cd varchar2(100)
    ,acct_id varchar2(100)
    ,cust_id varchar2(100)
    ,cust_name varchar2(500)
    ,corp_acct_char_cd varchar2(30)
    ,visit_serv_flg number(30,2)
    ,apprv_way_cd varchar2(30)
    ,acct_actv_idf_cd varchar2(30)
    ,corp_bus_type_cd varchar2(30)
    ,share_seal_flg varchar2(10)
    ,back_check_flg varchar2(10)
    ,agent_flg varchar2(10)
    ,agent_name varchar2(500)
    ,agent_cert_type varchar2(30)
    ,agent_cert_no varchar2(60)
    ,agent_tel_num varchar2(60)
    ,agent_cert_vp date
    ,corp_proc_status_cd varchar2(30)
    ,cust_clos_acct_dt date
    ,double_remote_flg varchar2(10)
    ,open_acct_chn_id varchar2(100)
    ,check_teller_id varchar2(100)
    ,blip_batch_no varchar2(60)
    ,apprv_flg varchar2(10)
    ,rg_cd varchar2(30)
    ,rgst_cap_curr_cd varchar2(30)
    ,super_lp_org_cd varchar2(30)
    ,super_director_corp_post_type_cd varchar2(30)
    ,recd_type_cd varchar2(30)
    ,backup_cmplt_flg varchar2(10)
    ,pass_rapvrfction_flg varchar2(10)
    ,bus_lics_found_dt date
    ,acct_name varchar2(500)
    ,rgst_addr varchar2(500)
    ,work_addr varchar2(500)
    ,mang_range_descb varchar2(1000)
    ,dist_cd varchar2(30)
    ,rgst_cap number(30,2)
    ,legal_rep_cert_no varchar2(60)
    ,legal_rep_cert_type_cd varchar2(60)
    ,acct_open_acct_lics_apprv_num varchar2(100)
    ,depositr_cate_cd varchar2(30)
    ,cust_mgr_teller_id varchar2(100)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_evt_scps_corp_bus_flow to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_evt_scps_corp_bus_flow is '对公业务表';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.evt_id is '事件编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.task_no is '任务号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.ova_flow_num is '全局流水号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.cust_open_acct_dt is '客户开户日期';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.org_id is '机构编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.teller_id is '柜员编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.open_acct_status_cd is '开户状态代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.temp_acct_valid_dt is '临时户有效日期';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.super_corp_name is '上级单位名称';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.super_director_cert_type_cd is '上级主管证件类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.super_director_cert_no is '上级主管证件号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.depositr_name is '存款人名称';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.pre_proc_id is '预受理编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.fst_proof_doc_type_cd is '第一证明文件类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.fst_proof_doc_id is '第一证明文件编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.fst_proof_doc_exp_dt is '第一证明文件到期日期';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.fst_cert_type_cd is '第一证件类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bus_flow_set is '业务流程设置';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.sign_mobile_no is '签约手机号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bkcp_seal_way_cd is '银企验印方式代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.post_addr_desc is '邮寄地址描述';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bkcp_zip_cd is '银企邮政编码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bkcp_cotas is '银企联系人';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bkcp_phone_num is '银企联系电话号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bkcp_check_entry_way_cd is '银企对账方式代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bkcp_check_entry_ped_cd is '银企对账周期代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.y_acm_lmt is '年累计限额';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.daily_accum_lmt is '日累计限额';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.daily_accum_cnt is '日累计笔数';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.basic_serv_appl_type_cd is '基本服务申请类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.verify_type_cd is '查证类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.checker_seq_num is '查证人序号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.cap_verify_teller_id is '资金查证柜员编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.legal_rep_mobile_no is '法定代表人手机号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.legal_rep_fixline_tel_num is '法定代表人固定电话号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.fin_princ_name is '财务负责人名称';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.fin_princ_mobile_no is '财务负责人手机号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.fin_princ_fixline_tel_num is '财务负责人固定电话号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.org_name is '机构名称';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.org_addr is '机构地址';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.legal_rep_name is '法定代表人名称';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.main_acct_id is '主账户编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.corp_stop_pay_status_cd is '对公止付状态代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.acct_id is '账户编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.cust_id is '客户编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.cust_name is '客户名称';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.corp_acct_char_cd is '对公账户性质代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.visit_serv_flg is '上门服务标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.apprv_way_cd is '核准方式代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.acct_actv_idf_cd is '账户激活标识代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.corp_bus_type_cd is '对公业务类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.share_seal_flg is '共用验印标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.back_check_flg is '倒验标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.agent_flg is '代理标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.agent_name is '代理人姓名';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.agent_cert_type is '代理人证件类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.agent_cert_no is '代理人证件号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.agent_tel_num is '	代理人电话号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.agent_cert_vp is '	代理人证件有效期';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.corp_proc_status_cd is '对公处理状态代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.cust_clos_acct_dt is '客户销户日期';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.double_remote_flg is '双异地标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.open_acct_chn_id is '开户渠道编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.check_teller_id is '审核柜员编号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.blip_batch_no is '影像批次号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.apprv_flg is '核准标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.rg_cd is '地区代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.rgst_cap_curr_cd is '注册资金币种代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.super_lp_org_cd is '上级法人机构代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.super_director_corp_post_type_cd is '上级主管单位职务类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.recd_type_cd is '备案类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.backup_cmplt_flg is '事后补扫完成标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.pass_rapvrfction_flg is '经过rpa核查标志';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.bus_lics_found_dt is '营业执照成立日期';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.acct_name is '账户名称';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.rgst_addr is '注册地址';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.work_addr is '办公地址';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.mang_range_descb is '经营范围描述';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.dist_cd is '行政区划代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.rgst_cap is '注册资本';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.legal_rep_cert_no is '法定代表人证件号码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.legal_rep_cert_type_cd is '法定代表人证件类型代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.acct_open_acct_lics_apprv_num is '法定代表人基本存款账户开户许可证核准号';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.depositr_cate_cd is '存款人类别代码';
comment on column ${msl_schema}.msl_edw_evt_scps_corp_bus_flow.cust_mgr_teller_id is '客户经理柜员编号';
