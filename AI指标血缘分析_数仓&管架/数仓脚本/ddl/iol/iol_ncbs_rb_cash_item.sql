/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cash_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cash_item
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cash_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cash_item(
    cash_item varchar2(10) -- 现金项目
    ,cash_item_desc varchar2(50) -- 现金项目描述
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,libra_op_time number(15) -- libra执行次数
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_cash_item to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cash_item to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cash_item to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cash_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cash_item is '现金项目定义';
comment on column ${iol_schema}.ncbs_rb_cash_item.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_rb_cash_item.cash_item_desc is '现金项目描述';
comment on column ${iol_schema}.ncbs_rb_cash_item.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cash_item.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_cash_item.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_cash_item.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_cash_item.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_cash_item.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_cash_item.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_cash_item.etl_timestamp is 'ETL处理时间戳';
