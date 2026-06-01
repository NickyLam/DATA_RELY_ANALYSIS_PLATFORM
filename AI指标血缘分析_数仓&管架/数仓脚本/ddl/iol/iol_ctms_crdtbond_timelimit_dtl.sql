/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_crdtbond_timelimit_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_crdtbond_timelimit_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_crdtbond_timelimit_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_crdtbond_timelimit_dtl(
    settledate varchar2(15) -- 数据日期
    ,src_trd_id varchar2(48) -- 系统编号
    ,currency varchar2(12) -- 币种
    ,limit_name varchar2(300) -- 限额类型
    ,portfolio_id number(38,0) -- 投组编号
    ,portfolio_name varchar2(384) -- 投组名称
    ,bondscode varchar2(24) -- 债券代码
    ,bondsname varchar2(384) -- 债券名称
    ,bondstype varchar2(60) -- 债券类别
    ,occupy_value number(38,4) -- 买入金额
    ,sum_occupy_value number(38,4) -- 累计买入金额
    ,balance number(38,4) -- 余额
    ,maturity_date varchar2(15) -- 到期日
    ,trade_date varchar2(15) -- 交易日
    ,sec_maturity_date varchar2(15) -- 180天到期日
    ,sec_term_to_maturity number -- 180天剩余有效期限
    ,thd_maturity_date varchar2(15) -- 30天到期日
    ,thd_term_to_maturity number -- 30天剩余有效期限
    ,dmp_time timestamp -- 创建时间戳
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
grant select on ${iol_schema}.ctms_crdtbond_timelimit_dtl to ${iml_schema};
grant select on ${iol_schema}.ctms_crdtbond_timelimit_dtl to ${icl_schema};
grant select on ${iol_schema}.ctms_crdtbond_timelimit_dtl to ${idl_schema};
grant select on ${iol_schema}.ctms_crdtbond_timelimit_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_crdtbond_timelimit_dtl is '信用债180天监控明细表';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.settledate is '数据日期';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.src_trd_id is '系统编号';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.currency is '币种';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.limit_name is '限额类型';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.portfolio_id is '投组编号';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.portfolio_name is '投组名称';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.bondscode is '债券代码';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.bondsname is '债券名称';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.bondstype is '债券类别';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.occupy_value is '买入金额';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.sum_occupy_value is '累计买入金额';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.balance is '余额';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.maturity_date is '到期日';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.trade_date is '交易日';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.sec_maturity_date is '180天到期日';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.sec_term_to_maturity is '180天剩余有效期限';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.thd_maturity_date is '30天到期日';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.thd_term_to_maturity is '30天剩余有效期限';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.dmp_time is '创建时间戳';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_crdtbond_timelimit_dtl.etl_timestamp is 'ETL处理时间戳';
