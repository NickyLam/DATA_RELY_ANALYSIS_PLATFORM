/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_sub_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_sub_acct_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_sub_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_sub_acct_info(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,inc_exp_ind varchar2(1) -- 收支标志
    ,min_sub_status varchar2(1) -- 主子状态
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,priority varchar2(20) -- 优先级
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,create_date date -- 创建日期
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,upper_base_acct_no varchar2(50) -- 上级账户（组主账户）
    ,upper_internal_key number(15) -- 组主账户内部键
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
grant select on ${iol_schema}.ncbs_rb_pcp_sub_acct_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_sub_acct_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_sub_acct_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_sub_acct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_sub_acct_info is '资金池账户组子账户信息表';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.inc_exp_ind is '收支标志';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.min_sub_status is '主子状态';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.priority is '优先级';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.create_date is '创建日期';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.upper_base_acct_no is '上级账户（组主账户）';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.upper_internal_key is '组主账户内部键';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_sub_acct_info.etl_timestamp is 'ETL处理时间戳';
