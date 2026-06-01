/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_lm_limit_cumulative_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail(
    card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,limit_num number(5) -- 累计笔数
    ,total_key varchar2(30) -- 累计额度编号
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,limit_amt number(17,2) -- 累计额度金额
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
grant select on ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail is '限额额度累计信息明细表';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.limit_num is '累计笔数';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.total_key is '累计额度编号';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.limit_amt is '累计额度金额';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_lm_limit_cumulative_detail.etl_timestamp is 'ETL处理时间戳';
