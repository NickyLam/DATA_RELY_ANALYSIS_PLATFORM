/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_user
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_user(
    branch varchar2(12) -- 机构编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,profit_center varchar2(20) -- 利润中心
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,application_user_flag varchar2(1) -- 是否应用柜员
    ,auth_level varchar2(1) -- 授权级别
    ,company varchar2(20) -- 法人
    ,department varchar2(6) -- 部门
    ,eod_sod_enabled_flag varchar2(1) -- 是否批处理用户
    ,inter_branch_cl varchar2(1) -- 是否贷款业务机构
    ,inter_branch_ind varchar2(1) -- 是否为内部银行
    ,role_id varchar2(200) -- 角色
    ,source_type varchar2(6) -- 渠道编号
    ,tbook varchar2(2) -- 账薄
    ,user_desc varchar2(50) -- 柜员描述信息
    ,user_lang varchar2(3) -- 柜员语言
    ,user_level varchar2(1) -- 柜员级别
    ,user_name varchar2(200) -- 柜员名称
    ,user_type varchar2(20) -- 柜员类别
    ,check_date date -- 检查日期
    ,make_date date -- 柜员创建日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,creation_user_id varchar2(8) -- 创建柜员
    ,account_status varchar2(1) -- 柜员状态a:有效,d:删除
    ,user_sub_type varchar2(2) -- 柜员细类
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_fm_user to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_user to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_user to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_user is '核心柜员信息表';
comment on column ${iol_schema}.ncbs_fm_user.branch is '机构编号';
comment on column ${iol_schema}.ncbs_fm_user.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_fm_user.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_fm_user.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_fm_user.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_fm_user.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_fm_user.application_user_flag is '是否应用柜员';
comment on column ${iol_schema}.ncbs_fm_user.auth_level is '授权级别';
comment on column ${iol_schema}.ncbs_fm_user.company is '法人';
comment on column ${iol_schema}.ncbs_fm_user.department is '部门';
comment on column ${iol_schema}.ncbs_fm_user.eod_sod_enabled_flag is '是否批处理用户';
comment on column ${iol_schema}.ncbs_fm_user.inter_branch_cl is '是否贷款业务机构';
comment on column ${iol_schema}.ncbs_fm_user.inter_branch_ind is '是否为内部银行';
comment on column ${iol_schema}.ncbs_fm_user.role_id is '角色';
comment on column ${iol_schema}.ncbs_fm_user.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_fm_user.tbook is '账薄';
comment on column ${iol_schema}.ncbs_fm_user.user_desc is '柜员描述信息';
comment on column ${iol_schema}.ncbs_fm_user.user_lang is '柜员语言';
comment on column ${iol_schema}.ncbs_fm_user.user_level is '柜员级别';
comment on column ${iol_schema}.ncbs_fm_user.user_name is '柜员名称';
comment on column ${iol_schema}.ncbs_fm_user.user_type is '柜员类别';
comment on column ${iol_schema}.ncbs_fm_user.check_date is '检查日期';
comment on column ${iol_schema}.ncbs_fm_user.make_date is '柜员创建日期';
comment on column ${iol_schema}.ncbs_fm_user.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_user.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_fm_user.creation_user_id is '创建柜员';
comment on column ${iol_schema}.ncbs_fm_user.account_status is '柜员状态a:有效,d:删除';
comment on column ${iol_schema}.ncbs_fm_user.user_sub_type is '柜员细类';
comment on column ${iol_schema}.ncbs_fm_user.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_user.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_user.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_user.etl_timestamp is 'ETL处理时间戳';
