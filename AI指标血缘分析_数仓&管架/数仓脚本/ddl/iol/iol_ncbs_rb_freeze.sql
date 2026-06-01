/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_freeze
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_freeze
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_freeze purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_freeze(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,restraint_type varchar2(3) -- 限制类型
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,freeze_status varchar2(1) -- 冻结状态
    ,full_freeze_ind varchar2(1) -- 全额冻结标志
    ,narrative varchar2(400) -- 摘要
    ,program_id varchar2(20) -- 交易代码
    ,res_priority varchar2(2) -- 冻结级别
    ,res_seq_no varchar2(50) -- 限制编号
    ,source_module varchar2(3) -- 源模块
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,pledged_amt number(17,2) -- 限制金额
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
grant select on ${iol_schema}.ncbs_rb_freeze to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_freeze to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_freeze to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_freeze to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_freeze is '账户冻结表';
comment on column ${iol_schema}.ncbs_rb_freeze.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_freeze.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_freeze.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_freeze.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_freeze.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_freeze.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_freeze.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_freeze.company is '法人';
comment on column ${iol_schema}.ncbs_rb_freeze.freeze_status is '冻结状态';
comment on column ${iol_schema}.ncbs_rb_freeze.full_freeze_ind is '全额冻结标志';
comment on column ${iol_schema}.ncbs_rb_freeze.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_freeze.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rb_freeze.res_priority is '冻结级别';
comment on column ${iol_schema}.ncbs_rb_freeze.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_freeze.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_freeze.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_freeze.pledged_amt is '限制金额';
comment on column ${iol_schema}.ncbs_rb_freeze.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_freeze.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_freeze.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_freeze.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_freeze.etl_timestamp is 'ETL处理时间戳';
