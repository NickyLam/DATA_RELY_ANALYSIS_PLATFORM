/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_consmt_fund_sign_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_consmt_fund_sign_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_consmt_fund_sign_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_consmt_fund_sign_dtl(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,intior_flow_num varchar2(100) -- 发起方流水号
    ,cfm_flow_num varchar2(100) -- 确认流水号
    ,appl_dt date -- 申请日期
    ,appl_tm timestamp -- 申请时间
    ,sys_dt date -- 系统日期
    ,cfm_dt date -- 确认日期
    ,tran_cd varchar2(100) -- 交易代码
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_belong_org_id varchar2(100) -- 交易所属机构编号
    ,ta_cd varchar2(30) -- TA代码
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,cust_name varchar2(375) -- 客户名称
    ,cust_abbr varchar2(375) -- 客户简称
    ,fund_acct_id varchar2(100) -- 基金账户编号
    ,seller_id varchar2(100) -- 销售商编号
    ,bank_id varchar2(100) -- 银行编号
    ,cust_id varchar2(100) -- 交易客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_med_id varchar2(100) -- 交易介质编号
    ,gender_cd varchar2(30) -- 性别代码
    ,birth_dt date -- 出生日期
    ,resdnt_addr varchar2(1000) -- 居住地址
    ,zip_cd varchar2(45) -- 邮政编码
    ,tel_num varchar2(60) -- 电话号码
    ,mobile_no varchar2(60) -- 手机号码
    ,e_mail varchar2(500) -- 电子邮箱
    ,memo_comnt varchar2(750) -- 摘要说明
    ,sign_chn_cd varchar2(30) -- 签约渠道代码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,err_cd varchar2(90) -- 错误码
    ,err_info_desc varchar2(1000) -- 错误信息描述
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,accpt_way_cd varchar2(30) -- 受理方式代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_consmt_fund_sign_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_consmt_fund_sign_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_consmt_fund_sign_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_consmt_fund_sign_dtl is '理财签约明细';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.intior_flow_num is '发起方流水号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cfm_flow_num is '确认流水号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.appl_tm is '申请时间';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.sys_dt is '系统日期';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tran_belong_org_id is '交易所属机构编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cert_no is '证件号码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cust_name is '客户名称';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cust_abbr is '客户简称';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.fund_acct_id is '基金账户编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.seller_id is '销售商编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.bank_id is '银行编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tran_med_id is '交易介质编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.gender_cd is '性别代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.birth_dt is '出生日期';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.resdnt_addr is '居住地址';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.zip_cd is '邮政编码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tel_num is '电话号码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.mobile_no is '手机号码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.e_mail is '电子邮箱';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.memo_comnt is '摘要说明';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.sign_chn_cd is '签约渠道代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.err_cd is '错误码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.accpt_way_cd is '受理方式代码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_consmt_fund_sign_dtl.etl_timestamp is 'ETL处理时间戳';
