/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_group_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_group_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_group_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_group_def(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_group_status varchar2(1) -- 账户组状态
    ,both_part_nature varchar2(1) -- 收支属性
    ,charge_way varchar2(1) -- 收费方式
    ,company varchar2(20) -- 法人
    ,group_ccy varchar2(10) -- 币种组
    ,group_name varchar2(50) -- 账户组名称
    ,main_agreement_id varchar2(50) -- 主协议协议号
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,upper_group_id varchar2(30) -- 上级组id
    ,create_date date -- 创建日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,charge_amt number(17,2) -- 收费金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_pcp_group_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_group_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_group_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_group_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_group_def is '资金池账户组定义表';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.acct_group_status is '账户组状态';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.both_part_nature is '收支属性';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.charge_way is '收费方式';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.group_ccy is '币种组';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.group_name is '账户组名称';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.main_agreement_id is '主协议协议号';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.upper_group_id is '上级组id';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.create_date is '创建日期';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.charge_amt is '收费金额';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_group_def.etl_timestamp is 'ETL处理时间戳';
