/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_agt_wl_appl_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_agt_wl_appl_basic_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_agt_wl_appl_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_agt_wl_appl_basic_info(
    etl_dt date -- 数据日期   
    ,appl_id varchar2(60) -- 申请编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,init_appl_id varchar2(60) -- 原申请编号   
    ,cust_id varchar2(60) -- 客户编号   
    ,open_acct_bank_name varchar2(500) -- 开户银行名称   
    ,bank_card_num varchar2(60) -- 银行卡号   
    ,cust_name varchar2(100) -- 客户名称   
    ,open_acct_bind_mobile_no varchar2(60) -- 开户绑定手机号码   
    ,co_org_id varchar2(60) -- 合作机构编号   
    ,prod_id varchar2(60) -- 产品编号   
    ,prod_cls_id varchar2(60) -- 产品分类编号   
    ,appl_chn_id varchar2(60) -- 申请渠道编号   
    ,crdt_appl_id varchar2(60) -- 授信申请编号   
    ,repay_num varchar2(60) -- 还款账号   
    ,curr_cd varchar2(10) -- 币种代码   
    ,appl_lmt number(30,2) -- 申请额度   
    ,appl_int_rat number(18,8) -- 申请利率   
    ,appl_tm timestamp -- 申请时间   
    ,appl_tenor number(10) -- 申请期限   
    ,repay_day varchar2(10) -- 还款日   
    ,grace_days number(10) -- 宽限天数   
    ,loan_dir_cd varchar2(10) -- 贷款投向代码   
    ,repay_way_cd varchar2(10) -- 还款方式代码   
    ,appl_status_cd varchar2(10) -- 申请状态代码   
    ,check_status_cd varchar2(10) -- 审核状态代码   
    ,coprator_acct_id varchar2(60) -- 合作商户编号   
    ,taxpayer_idtfy_num varchar2(100) -- 纳税人识别号   
    ,tran_flow_num varchar2(100) -- 交易流水号   
    ,user_group_id varchar2(60) -- 用户组编号   
    ,co_proj_id varchar2(60) -- 合作项目编号   
    ,org_co_id varchar2(60) -- 机构合作编号   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_agt_wl_appl_basic_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_agt_wl_appl_basic_info is '网贷申请基本信息';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.appl_id is '申请编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.lp_id is '法人编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.init_appl_id is '原申请编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.cust_id is '客户编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.open_acct_bank_name is '开户银行名称';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.bank_card_num is '银行卡号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.cust_name is '客户名称';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.open_acct_bind_mobile_no is '开户绑定手机号码';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.co_org_id is '合作机构编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.prod_id is '产品编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.prod_cls_id is '产品分类编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.appl_chn_id is '申请渠道编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.crdt_appl_id is '授信申请编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.repay_num is '还款账号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.appl_lmt is '申请额度';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.appl_int_rat is '申请利率';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.appl_tm is '申请时间';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.appl_tenor is '申请期限';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.repay_day is '还款日';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.grace_days is '宽限天数';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.loan_dir_cd is '贷款投向代码';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.appl_status_cd is '申请状态代码';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.check_status_cd is '审核状态代码';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.coprator_acct_id is '合作商户编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.taxpayer_idtfy_num is '纳税人识别号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.user_group_id is '用户组编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.co_proj_id is '合作项目编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.org_co_id is '机构合作编号';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.create_dt is '创建日期';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.update_dt is '更新日期';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.id_mark is '删除标识';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.job_cd is '任务代码';
comment on column ${idl_schema}.aml_agt_wl_appl_basic_info.etl_timestamp is '数据处理时间';