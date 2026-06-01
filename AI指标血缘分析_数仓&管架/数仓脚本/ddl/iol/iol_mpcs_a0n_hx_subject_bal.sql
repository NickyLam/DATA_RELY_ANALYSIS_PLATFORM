/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0n_hx_subject_bal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0n_hx_subject_bal
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0n_hx_subject_bal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0n_hx_subject_bal(
    systid varchar2(45) -- 系统代号
    ,acctdt varchar2(12) -- 账务日期
    ,brchcd varchar2(24) -- 账务机构编号
    ,itemcd varchar2(45) -- 科目编号
    ,assis8 varchar2(45) -- 产品
    ,crcycd varchar2(5) -- 币种
    ,drtsam number(20,2) -- 借方本期发生额
    ,crtsam number(20,2) -- 贷方本期发生额
    ,drctbl number(20,2) -- 借方本期余额
    ,crctbl number(20,2) -- 贷方本期余额
    ,blncdn varchar2(2) -- 当前余额方向
    ,onlnbl number(20,2) -- 当前余额
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
grant select on ${iol_schema}.mpcs_a0n_hx_subject_bal to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0n_hx_subject_bal to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0n_hx_subject_bal to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0n_hx_subject_bal to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0n_hx_subject_bal is '微粒贷核算中台余额表';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.systid is '系统代号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.acctdt is '账务日期';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.brchcd is '账务机构编号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.itemcd is '科目编号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.assis8 is '产品';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.crcycd is '币种';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.drtsam is '借方本期发生额';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.crtsam is '贷方本期发生额';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.drctbl is '借方本期余额';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.crctbl is '贷方本期余额';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.blncdn is '当前余额方向';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.onlnbl is '当前余额';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_bal.etl_timestamp is 'ETL处理时间戳';
