/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_acct_rgst_mobile_no_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_acct_rgst_mobile_no_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_acct_rgst_mobile_no_h(
    mobile_no varchar2(60) -- 手机号码
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,acct_num varchar2(100) -- 账号
    ,acct_name varchar2(300) -- 账户名称
    ,acct_num_rgst_attr_cd varchar2(10) -- 账号注册属性代码
    ,onl_bank_sys_open_bank_no varchar2(60) -- 网银系统开户行行号
    ,acct_open_bank_no varchar2(60) -- 账户开户行行号
    ,acct_clear_bank_no varchar2(60) -- 账户清算行行号
    ,rgst_tm timestamp -- 登记时间
    ,mobile_no_status_cd varchar2(10) -- 手机号状态代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_acct_rgst_mobile_no_h to ${icl_schema};
grant select on ${iml_schema}.ref_acct_rgst_mobile_no_h to ${idl_schema};
grant select on ${iml_schema}.ref_acct_rgst_mobile_no_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_acct_rgst_mobile_no_h is '客户账户注册手机号历史';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.mobile_no is '手机号码';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.cert_no is '证件号码';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.acct_num is '账号';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.acct_name is '账户名称';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.acct_num_rgst_attr_cd is '账号注册属性代码';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.onl_bank_sys_open_bank_no is '网银系统开户行行号';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.acct_open_bank_no is '账户开户行行号';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.acct_clear_bank_no is '账户清算行行号';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.rgst_tm is '登记时间';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.mobile_no_status_cd is '手机号状态代码';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_acct_rgst_mobile_no_h.etl_timestamp is 'ETL处理时间戳';
