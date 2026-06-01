/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_appl_info
CreateDate: 20250312
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_cmm_unite_wl_appl_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_cmm_unite_wl_appl_info(
etl_dt date --ETL处理日期
,lp_id varchar2(60) --法人编号
,loan_appl_flow_num varchar2(100) --贷款申请流水号
,partner_appl_flow_num varchar2(250) --合作方申请流水号
,prod_id varchar2(100) --产品编号
,prod_name varchar2(750) --产品名称
,belong_org_id varchar2(60) --所属机构编号
,cust_id varchar2(100) --客户编号
,cust_name varchar2(750) --客户姓名
,cert_type_cd varchar2(10) --证件类型代码
,cert_id varchar2(100) --证件编号
,cont_num varchar2(60) --联系号码
,hxb_blklist_flg varchar2(10) --我行黑名单标志
,crdtc_que_flg varchar2(10) --征信查询标志
,score_val number(10) --评分分值
,anti_fraud_check_flg varchar2(10) --反欺诈校验标志
,solv_rating_flg varchar2(10) --偿债能力评级标志
,partner_apv_rest_flg varchar2(10) --合作方审批结果标志
,other_acp_lmt_flg varchar2(10) --其他花呗额度标志
,appl_dt date --申请日期
,appl_amt number(30,2) --申请金额
,apv_start_tm timestamp(6) --审批开始时间
,apv_status_cd varchar2(60) --审批状态代码
,apv_amt number(38,8) --审批金额
,apv_end_tm timestamp(6) --审批结束时间
,final_jud_end_tm timestamp(6) --终审结束时间
,advise_sucs_flg varchar2(10) --通知成功标志
,refuse_rs varchar2(3000) --拒绝原因
,rela_appl_flow_num varchar2(150) --关联申请流水号
,custs_mang_lab_pbc_cali varchar2(150) --客群经营标签_人行口径
,custs_mang_lab_bank_supv_cali varchar2(150) --客群经营标签_银监口径
,job_cd varchar2(10) --任务代码
,etl_timestamp timestamp(6) --etl处理时间戳

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_cmm_unite_wl_appl_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_cmm_unite_wl_appl_info is '联合网贷申请信息';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.lp_id is '法人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.loan_appl_flow_num is '贷款申请流水号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.partner_appl_flow_num is '合作方申请流水号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.prod_id is '产品编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.prod_name is '产品名称';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.cust_id is '客户编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.cust_name is '客户姓名';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.cert_id is '证件编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.cont_num is '联系号码';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.hxb_blklist_flg is '我行黑名单标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.crdtc_que_flg is '征信查询标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.score_val is '评分分值';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.anti_fraud_check_flg is '反欺诈校验标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.solv_rating_flg is '偿债能力评级标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.partner_apv_rest_flg is '合作方审批结果标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.other_acp_lmt_flg is '其他花呗额度标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.appl_dt is '申请日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.appl_amt is '申请金额';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.apv_start_tm is '审批开始时间';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.apv_status_cd is '审批状态代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.apv_amt is '审批金额';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.apv_end_tm is '审批结束时间';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.final_jud_end_tm is '终审结束时间';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.advise_sucs_flg is '通知成功标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.refuse_rs is '拒绝原因';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.rela_appl_flow_num is '关联申请流水号';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.custs_mang_lab_pbc_cali is '客群经营标签_人行口径';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.custs_mang_lab_bank_supv_cali is '客群经营标签_银监口径';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.job_cd is '任务代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_appl_info.etl_timestamp is 'etl处理时间戳';

