/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_collate_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_collate_apply
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_collate_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_collate_apply(
    client_no varchar2(16) -- 客户编号
    ,file_path varchar2(200) -- 文件路径
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,channel varchar2(10) -- 渠道
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,settle_branch varchar2(12) -- 清算机构
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_collate_apply to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_collate_apply to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_collate_apply to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_collate_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_collate_apply is '对账申请登记簙';
comment on column ${iol_schema}.ncbs_rb_collate_apply.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_collate_apply.file_path is '文件路径';
comment on column ${iol_schema}.ncbs_rb_collate_apply.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_collate_apply.company is '法人';
comment on column ${iol_schema}.ncbs_rb_collate_apply.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_collate_apply.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_collate_apply.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_collate_apply.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_collate_apply.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_collate_apply.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_collate_apply.settle_branch is '清算机构';
comment on column ${iol_schema}.ncbs_rb_collate_apply.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_collate_apply.etl_timestamp is 'ETL处理时间戳';
