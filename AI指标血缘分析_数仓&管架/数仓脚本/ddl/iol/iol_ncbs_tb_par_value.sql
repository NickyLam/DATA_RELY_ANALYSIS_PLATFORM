/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_par_value
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_par_value
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_par_value purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_par_value(
    ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,is_spall varchar2(1) -- 是否残损币
    ,par_desc varchar2(50) -- 券别描述
    ,par_type varchar2(1) -- 券别类型
    ,par_value number(17,2) -- 券别值
    ,par_value_id varchar2(20) -- 券别代码
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
    ,spall_type varchar2(2) -- 残损币类型
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
grant select on ${iol_schema}.ncbs_tb_par_value to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_par_value to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_par_value to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_par_value to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_par_value is '券别币种表';
comment on column ${iol_schema}.ncbs_tb_par_value.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_par_value.company is '法人';
comment on column ${iol_schema}.ncbs_tb_par_value.is_spall is '是否残损币';
comment on column ${iol_schema}.ncbs_tb_par_value.par_desc is '券别描述';
comment on column ${iol_schema}.ncbs_tb_par_value.par_type is '券别类型';
comment on column ${iol_schema}.ncbs_tb_par_value.par_value is '券别值';
comment on column ${iol_schema}.ncbs_tb_par_value.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_par_value.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_par_value.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_tb_par_value.spall_type is '残损币类型';
comment on column ${iol_schema}.ncbs_tb_par_value.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_par_value.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_par_value.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_par_value.etl_timestamp is 'ETL处理时间戳';
