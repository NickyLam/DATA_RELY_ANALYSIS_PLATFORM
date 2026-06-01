/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_prod_charge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_prod_charge
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_prod_charge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_prod_charge(
    prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,fee_type varchar2(20) -- 费率类型
    ,libra_op_time number(15) -- libra执行次数
    ,next_charge_date date -- 下一收费日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,charge_day varchar2(2) -- 收费日
    ,charge_period_freq varchar2(5) -- 收费频率
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
grant select on ${iol_schema}.ncbs_rb_prod_charge to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_prod_charge to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_prod_charge to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_prod_charge to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_prod_charge is '产品类型费用类型关联表';
comment on column ${iol_schema}.ncbs_rb_prod_charge.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_prod_charge.company is '法人';
comment on column ${iol_schema}.ncbs_rb_prod_charge.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_prod_charge.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_prod_charge.next_charge_date is '下一收费日期';
comment on column ${iol_schema}.ncbs_rb_prod_charge.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_prod_charge.charge_day is '收费日';
comment on column ${iol_schema}.ncbs_rb_prod_charge.charge_period_freq is '收费频率';
comment on column ${iol_schema}.ncbs_rb_prod_charge.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_prod_charge.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_prod_charge.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_prod_charge.etl_timestamp is 'ETL处理时间戳';
