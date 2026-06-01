/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_balance
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_balance(
    bookset_id varchar2(50) -- 账套代码
    ,balance_date date -- 余额日期
    ,subject_no varchar2(300) -- 科目号
    ,fsubject_no varchar2(32) -- 父科目号
    ,subject_level number(10) -- 科目级别
    ,bal_flag varchar2(50) -- 余额方向
    ,bal_co_flag varchar2(50) -- 结转余额方向
    ,o_ccy varchar2(50) -- 原币
    ,o_amt number(30,2) -- 原币余额
    ,o_c_amt number(30,2) -- 原币余额贷方
    ,o_d_amt number(30,2) -- 原币余额借方
    ,o_co_amt number(30,2) -- 原币结转余额
    ,o_co_c_amt number(30,2) -- 原币结转余额贷方
    ,o_co_d_amt number(30,2) -- 原币结转余额借方
    ,b_ccy varchar2(50) -- 本位币
    ,b_amt number(30,2) -- 本位币余额
    ,b_c_amt number(30,2) -- 本位币余额贷方
    ,b_co_amt number(30,2) -- 本位币结转余额
    ,b_co_c_amt number(30,2) -- 本位币结转余额贷方
    ,b_co_d_amt number(30,2) -- 本位币结转余额借方
    ,b_d_amt number(30,2) -- 本位币余额借方
    ,tdy_o_amt number(30,2) -- 原币当日发生额
    ,tdy_o_c_amt number(30,2) -- 原币当日发生额贷方
    ,tdy_o_d_amt number(30,2) -- 原币当日发生额借方
    ,tdy_o_co_amt number(30,2) -- 原币结转当日发生额
    ,tdy_o_co_c_amt number(30,2) -- 原币结转当日发生额贷方
    ,tdy_o_co_d_amt number(30,2) -- 原币结转当日发生额借方
    ,tdy_b_amt number(30,2) -- 本位币当日发生额
    ,tdy_b_c_amt number(30,2) -- 本位币当日发生额贷方
    ,tdy_b_d_amt number(30,2) -- 本位币当日发生额借方
    ,tdy_b_co_amt number(30,2) -- 本位币结转当日发生额
    ,tdy_b_co_c_amt number(30,2) -- 本位币结转当日发生额贷方
    ,tdy_b_co_d_amt number(30,2) -- 本位币结转当日发生额借方
    ,is_leaf varchar2(50) -- 是否叶子节点
    ,num_amt number(30,2) -- 数量余额
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,tdy_amt_flag varchar2(50) -- 当日发生额方向
    ,tdy_co_flag varchar2(50) -- 结转当日发生额方向
    ,tdy_pur_o_d_ulamt number(30,2) -- 原币申购未实现平准金借
    ,tdy_red_o_d_ulamt number(30,2) -- 原币赎回未实现平准金借
    ,tdy_pur_o_c_ulamt number(30,2) -- 原币申购未实现平准金贷
    ,tdy_red_o_c_ulamt number(30,2) -- 原币赎回未实现平准金贷
    ,tdy_pur_b_d_ulamt number(30,2) -- 本位币申购未实现平准金借
    ,tdy_red_b_d_ulamt number(30,2) -- 本位币赎回未实现平准金借
    ,tdy_pur_b_c_ulamt number(30,2) -- 本位币申购未实现平准金贷
    ,tdy_red_b_c_ulamt number(30,2) -- 本位币赎回未实现平准金贷
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
grant select on ${iol_schema}.fams_bok_balance to ${iml_schema};
grant select on ${iol_schema}.fams_bok_balance to ${icl_schema};
grant select on ${iol_schema}.fams_bok_balance to ${idl_schema};
grant select on ${iol_schema}.fams_bok_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_balance is '科目余额';
comment on column ${iol_schema}.fams_bok_balance.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_balance.balance_date is '余额日期';
comment on column ${iol_schema}.fams_bok_balance.subject_no is '科目号';
comment on column ${iol_schema}.fams_bok_balance.fsubject_no is '父科目号';
comment on column ${iol_schema}.fams_bok_balance.subject_level is '科目级别';
comment on column ${iol_schema}.fams_bok_balance.bal_flag is '余额方向';
comment on column ${iol_schema}.fams_bok_balance.bal_co_flag is '结转余额方向';
comment on column ${iol_schema}.fams_bok_balance.o_ccy is '原币';
comment on column ${iol_schema}.fams_bok_balance.o_amt is '原币余额';
comment on column ${iol_schema}.fams_bok_balance.o_c_amt is '原币余额贷方';
comment on column ${iol_schema}.fams_bok_balance.o_d_amt is '原币余额借方';
comment on column ${iol_schema}.fams_bok_balance.o_co_amt is '原币结转余额';
comment on column ${iol_schema}.fams_bok_balance.o_co_c_amt is '原币结转余额贷方';
comment on column ${iol_schema}.fams_bok_balance.o_co_d_amt is '原币结转余额借方';
comment on column ${iol_schema}.fams_bok_balance.b_ccy is '本位币';
comment on column ${iol_schema}.fams_bok_balance.b_amt is '本位币余额';
comment on column ${iol_schema}.fams_bok_balance.b_c_amt is '本位币余额贷方';
comment on column ${iol_schema}.fams_bok_balance.b_co_amt is '本位币结转余额';
comment on column ${iol_schema}.fams_bok_balance.b_co_c_amt is '本位币结转余额贷方';
comment on column ${iol_schema}.fams_bok_balance.b_co_d_amt is '本位币结转余额借方';
comment on column ${iol_schema}.fams_bok_balance.b_d_amt is '本位币余额借方';
comment on column ${iol_schema}.fams_bok_balance.tdy_o_amt is '原币当日发生额';
comment on column ${iol_schema}.fams_bok_balance.tdy_o_c_amt is '原币当日发生额贷方';
comment on column ${iol_schema}.fams_bok_balance.tdy_o_d_amt is '原币当日发生额借方';
comment on column ${iol_schema}.fams_bok_balance.tdy_o_co_amt is '原币结转当日发生额';
comment on column ${iol_schema}.fams_bok_balance.tdy_o_co_c_amt is '原币结转当日发生额贷方';
comment on column ${iol_schema}.fams_bok_balance.tdy_o_co_d_amt is '原币结转当日发生额借方';
comment on column ${iol_schema}.fams_bok_balance.tdy_b_amt is '本位币当日发生额';
comment on column ${iol_schema}.fams_bok_balance.tdy_b_c_amt is '本位币当日发生额贷方';
comment on column ${iol_schema}.fams_bok_balance.tdy_b_d_amt is '本位币当日发生额借方';
comment on column ${iol_schema}.fams_bok_balance.tdy_b_co_amt is '本位币结转当日发生额';
comment on column ${iol_schema}.fams_bok_balance.tdy_b_co_c_amt is '本位币结转当日发生额贷方';
comment on column ${iol_schema}.fams_bok_balance.tdy_b_co_d_amt is '本位币结转当日发生额借方';
comment on column ${iol_schema}.fams_bok_balance.is_leaf is '是否叶子节点';
comment on column ${iol_schema}.fams_bok_balance.num_amt is '数量余额';
comment on column ${iol_schema}.fams_bok_balance.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_balance.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_balance.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_balance.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_balance.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_balance.tdy_amt_flag is '当日发生额方向';
comment on column ${iol_schema}.fams_bok_balance.tdy_co_flag is '结转当日发生额方向';
comment on column ${iol_schema}.fams_bok_balance.tdy_pur_o_d_ulamt is '原币申购未实现平准金借';
comment on column ${iol_schema}.fams_bok_balance.tdy_red_o_d_ulamt is '原币赎回未实现平准金借';
comment on column ${iol_schema}.fams_bok_balance.tdy_pur_o_c_ulamt is '原币申购未实现平准金贷';
comment on column ${iol_schema}.fams_bok_balance.tdy_red_o_c_ulamt is '原币赎回未实现平准金贷';
comment on column ${iol_schema}.fams_bok_balance.tdy_pur_b_d_ulamt is '本位币申购未实现平准金借';
comment on column ${iol_schema}.fams_bok_balance.tdy_red_b_d_ulamt is '本位币赎回未实现平准金借';
comment on column ${iol_schema}.fams_bok_balance.tdy_pur_b_c_ulamt is '本位币申购未实现平准金贷';
comment on column ${iol_schema}.fams_bok_balance.tdy_red_b_c_ulamt is '本位币赎回未实现平准金贷';
comment on column ${iol_schema}.fams_bok_balance.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_bok_balance.etl_timestamp is 'ETL处理时间戳';
