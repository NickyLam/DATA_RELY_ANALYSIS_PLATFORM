/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_gl_hang_head
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_gl_hang_head
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_gl_hang_head purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gl_hang_head(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,hang_seq_no varchar2(50) -- 挂账序列号
    ,client_no varchar2(16) -- 客户编号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_date date -- 交易日期
    ,hang_total_amt number(17,2) -- 挂账总额
    ,hang_bal number(17,2) -- 挂账余额
    ,ccy varchar2(3) -- 币种
    ,hang_status varchar2(1) -- 挂账状态
    ,hang_end_date date -- 挂账到期日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_rb_gl_hang_head to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_gl_hang_head to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_hang_head to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_hang_head to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_gl_hang_head is '挂销账挂账汇总表';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.hang_seq_no is '挂账序列号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.hang_total_amt is '挂账总额';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.hang_bal is '挂账余额';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.hang_status is '挂账状态';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.hang_end_date is '挂账到期日';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.company is '法人';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_gl_hang_head.etl_timestamp is 'ETL处理时间戳';
