/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_refac_loan_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_refac_loan_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_refac_loan_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_refac_loan_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,level1_batch_pkg_id varchar2(60) -- 一级批次包编号
    ,level1_batch_pkg_name varchar2(250) -- 一级批次包名称
    ,level2_batch_pkg_id varchar2(60) -- 二级批次包编号
    ,level2_batch_pkg_name varchar2(250) -- 二级批次包名称
    ,dubil_id varchar2(60) -- 借据编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(250) -- 客户名称
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,refac_indus_type_cd varchar2(10) -- 支小再行业类型代码
    ,loan_type_cd varchar2(10) -- 贷款类型代码
    ,corp_size_cd varchar2(10) -- 企业规模代码
    ,corp_number varchar2(30) -- 企业人数
    ,last_year_bus_inco varchar2(60) -- 上年末营业收入
    ,corp_asset_tot number(18,6) -- 企业资产总额
    ,mang_main_name varchar2(250) -- 经营主体名称
    ,mang_main_crdt_cd_descb varchar2(60) -- 经营主体信用代码描述
    ,check_sheet_flg varchar2(10) -- 报账标志
    ,backup_dubil_flg varchar2(10) -- 后补借据标志
    ,loan_usage_descb varchar2(250) -- 贷款用途描述
    ,remark varchar2(2000) -- 备注
    ,pbc_doc_num varchar2(500) -- 人行文件文号
    ,pbc_doc_name varchar2(250) -- 人行文件名称
    ,pbc_doc_doc_day date -- 人行文件发文日
    ,pbc_lmt number(30,2) -- 人行额度
    ,appl_tm date -- 申请时间
    ,applit_id varchar2(100) -- 申请人编号
    ,appl_org_id varchar2(100) -- 申请机构编号
    ,appl_type_cd varchar2(100) -- 申请类型代码
    ,refac_status_cd varchar2(10) -- 支小再状态代码
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,batch_pkg_status_cd varchar2(30) -- 批次包状态代码
    ,refac_amt number(30,2) -- 再贷款金额
    ,surp_lmt number(30,2) -- 剩余额度
    ,refac_cont_id varchar2(100) -- 再贷款合同编号
    ,refac_distr_dt date -- 再贷款发放日期
    ,refac_exp_dt date -- 再贷款到期日期
    ,actl_loan_distr_dt date -- 实际贷款发放日期
    ,actl_loan_termnt_dt date -- 实际贷款终止日期
    ,refac_distr_mode_descb varchar2(100) -- 再贷款发放模式描述
    ,refac_kind_descb varchar2(100) -- 再贷款种类描述
    ,use_int_rat number(18,9) -- 使用利率
    ,int_accr_way_descb varchar2(100) -- 计息方式描述
    ,belong_land_pbc_fin_inst_code varchar2(250) -- 所属地人民银行金融机构编码
    ,belong_land_pbc_name varchar2(250) -- 所属地人民银行名称
    ,belong_land_pbc_corp_princ_name varchar2(250) -- 所属地人民银行单位负责人姓名
    ,corp_phone_num varchar2(60) -- 单位联系电话号码
    ,corp_addr varchar2(250) -- 单位地址
    ,org_name varchar2(100) -- 机构名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,pbc_pay_acct_id varchar2(100) -- 人行付款账户编号
    ,pbc_cred_rht_type_descb varchar2(100) -- 人民银行债权类型描述
    ,pmo_type_cd varchar2(500) -- 抵质押物类型代码
    ,pmo_cont_id varchar2(60) -- 抵质押物合同编号
    ,pmo_amt_evltion number(30,2) -- 抵质押物金额估值
    ,pmo_amt_evltion_tot number(30,2) -- 抵质押物金额估值汇总
    ,cred_rht_bal number(30,2) -- 债权余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_refac_loan_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_refac_loan_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_refac_loan_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_refac_loan_attach_info is '支小再贷款补充信息';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.level1_batch_pkg_id is '一级批次包编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.level1_batch_pkg_name is '一级批次包名称';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.level2_batch_pkg_id is '二级批次包编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.level2_batch_pkg_name is '二级批次包名称';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.indus_type_cd is '行业类型代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_indus_type_cd is '支小再行业类型代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.loan_type_cd is '贷款类型代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.corp_size_cd is '企业规模代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.corp_number is '企业人数';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.last_year_bus_inco is '上年末营业收入';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.corp_asset_tot is '企业资产总额';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.mang_main_name is '经营主体名称';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.mang_main_crdt_cd_descb is '经营主体信用代码描述';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.check_sheet_flg is '报账标志';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.backup_dubil_flg is '后补借据标志';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.loan_usage_descb is '贷款用途描述';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.remark is '备注';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pbc_doc_num is '人行文件文号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pbc_doc_name is '人行文件名称';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pbc_doc_doc_day is '人行文件发文日';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pbc_lmt is '人行额度';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.appl_tm is '申请时间';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.applit_id is '申请人编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.appl_org_id is '申请机构编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.appl_type_cd is '申请类型代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_status_cd is '支小再状态代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.apv_status_cd is '审批状态代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.batch_pkg_status_cd is '批次包状态代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_amt is '再贷款金额';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.surp_lmt is '剩余额度';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_cont_id is '再贷款合同编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_distr_dt is '再贷款发放日期';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_exp_dt is '再贷款到期日期';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.actl_loan_distr_dt is '实际贷款发放日期';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.actl_loan_termnt_dt is '实际贷款终止日期';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_distr_mode_descb is '再贷款发放模式描述';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.refac_kind_descb is '再贷款种类描述';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.use_int_rat is '使用利率';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.int_accr_way_descb is '计息方式描述';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.belong_land_pbc_fin_inst_code is '所属地人民银行金融机构编码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.belong_land_pbc_name is '所属地人民银行名称';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.belong_land_pbc_corp_princ_name is '所属地人民银行单位负责人姓名';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.corp_phone_num is '单位联系电话号码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.corp_addr is '单位地址';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.org_name is '机构名称';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.recvbl_acct_id is '收款账户编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pbc_pay_acct_id is '人行付款账户编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pbc_cred_rht_type_descb is '人民银行债权类型描述';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pmo_type_cd is '抵质押物类型代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pmo_cont_id is '抵质押物合同编号';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pmo_amt_evltion is '抵质押物金额估值';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.pmo_amt_evltion_tot is '抵质押物金额估值汇总';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.cred_rht_bal is '债权余额';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_refac_loan_attach_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_refac_loan_attach_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_refac_loan_attach_info.etl_timestamp is 'ETL处理时间戳';
