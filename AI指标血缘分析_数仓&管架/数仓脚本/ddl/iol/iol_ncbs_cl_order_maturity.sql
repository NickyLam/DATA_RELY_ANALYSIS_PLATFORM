/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_order_maturity
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_order_maturity
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_order_maturity purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_order_maturity(
    client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,order_no varchar2(50) -- 预约编号
    ,order_seq_no varchar2(50) -- 预约登记号
    ,maturity_date date -- 到期日期
    ,new_maturity_date date -- 新到期日
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
grant select on ${iol_schema}.ncbs_cl_order_maturity to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_order_maturity to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_order_maturity to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_order_maturity to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_order_maturity is '预约期限变更登记表';
comment on column ${iol_schema}.ncbs_cl_order_maturity.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_order_maturity.company is '法人';
comment on column ${iol_schema}.ncbs_cl_order_maturity.order_no is '预约编号';
comment on column ${iol_schema}.ncbs_cl_order_maturity.order_seq_no is '预约登记号';
comment on column ${iol_schema}.ncbs_cl_order_maturity.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_cl_order_maturity.new_maturity_date is '新到期日';
comment on column ${iol_schema}.ncbs_cl_order_maturity.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_order_maturity.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_order_maturity.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_order_maturity.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_order_maturity.etl_timestamp is 'ETL处理时间戳';
