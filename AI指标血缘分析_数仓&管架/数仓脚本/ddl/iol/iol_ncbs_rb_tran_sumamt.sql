/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tran_sumamt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tran_sumamt
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tran_sumamt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_sumamt(
    remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,sum_count number(5) -- 累计转账次数
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,sum_amount number(17,2) -- 金额总和
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
grant select on ${iol_schema}.ncbs_rb_tran_sumamt to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tran_sumamt to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_sumamt to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_sumamt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tran_sumamt is '交易流水金额笔数汇总表';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.sum_count is '累计转账次数';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.sum_amount is '金额总和';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_tran_sumamt.etl_timestamp is 'ETL处理时间戳';
