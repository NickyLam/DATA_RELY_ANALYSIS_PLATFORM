/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_v_fee_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_v_fee_inf
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_v_fee_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_v_fee_inf(
    finr varchar2(12) -- 主键
    ,fdat varchar2(15) -- 收费日期
    ,fbchnam varchar2(60) -- 收费机构
    ,fcno varchar2(30) -- 收费客户号
    ,fact varchar2(75) -- 收费账号
    ,fcur varchar2(5) -- 费用币种
    ,famt number(17,2) -- 费用金额
    ,ftxt varchar2(120) -- 费用描述
    ,ftyp varchar2(3) -- 费用类型
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
grant select on ${iol_schema}.isbs_v_fee_inf to ${iml_schema};
grant select on ${iol_schema}.isbs_v_fee_inf to ${icl_schema};
grant select on ${iol_schema}.isbs_v_fee_inf to ${idl_schema};
grant select on ${iol_schema}.isbs_v_fee_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_v_fee_inf is '中收手续费明细';
comment on column ${iol_schema}.isbs_v_fee_inf.finr is '主键';
comment on column ${iol_schema}.isbs_v_fee_inf.fdat is '收费日期';
comment on column ${iol_schema}.isbs_v_fee_inf.fbchnam is '收费机构';
comment on column ${iol_schema}.isbs_v_fee_inf.fcno is '收费客户号';
comment on column ${iol_schema}.isbs_v_fee_inf.fact is '收费账号';
comment on column ${iol_schema}.isbs_v_fee_inf.fcur is '费用币种';
comment on column ${iol_schema}.isbs_v_fee_inf.famt is '费用金额';
comment on column ${iol_schema}.isbs_v_fee_inf.ftxt is '费用描述';
comment on column ${iol_schema}.isbs_v_fee_inf.ftyp is '费用类型';
comment on column ${iol_schema}.isbs_v_fee_inf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_v_fee_inf.etl_timestamp is 'ETL处理时间戳';
