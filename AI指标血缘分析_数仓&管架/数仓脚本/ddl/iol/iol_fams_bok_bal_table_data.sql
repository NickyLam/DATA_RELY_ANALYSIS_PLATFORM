/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_bal_table_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_bal_table_data
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_bal_table_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_bal_table_data(
    seq_no varchar2(32) -- 账套代码
    ,o_ccy varchar2(50) -- 币种
    ,o_open_bal_flag varchar2(50) -- 原币期初余额方向
    ,o_open_balance number(30,2) -- 原币期初余额
    ,o_happen_amt_d number(30,2) -- 原币本期借方发生额
    ,o_happen_amt_c number(30,2) -- 原币本期贷方发生额
    ,o_end_bal_flag varchar2(50) -- 原币期末余额方向
    ,o_end_balance number(30,2) -- 原币期末余额
    ,b_open_bal_flag varchar2(50) -- 本位币期初余额方向
    ,b_open_balance number(30,2) -- 本位币期初余额
    ,b_happen_amt_d number(30,2) -- 本位币本期借方发生额
    ,b_happen_amt_c number(30,2) -- 本位币本期贷方发生额
    ,b_end_bal_flag varchar2(50) -- 本位币期末余额方向
    ,b_end_balance number(30,2) -- 本位币期末余额
    ,bookset_id varchar2(50) -- 账套代码
    ,bookset_name varchar2(200) -- 账套名称
    ,bal_date date -- 估值日期
    ,subject_no varchar2(300) -- 科目号
    ,subject_name varchar2(200) -- 科目名称
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_bok_bal_table_data to ${iml_schema};
grant select on ${iol_schema}.fams_bok_bal_table_data to ${icl_schema};
grant select on ${iol_schema}.fams_bok_bal_table_data to ${idl_schema};
grant select on ${iol_schema}.fams_bok_bal_table_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_bal_table_data is '余额表数据';
comment on column ${iol_schema}.fams_bok_bal_table_data.seq_no is '账套代码';
comment on column ${iol_schema}.fams_bok_bal_table_data.o_ccy is '币种';
comment on column ${iol_schema}.fams_bok_bal_table_data.o_open_bal_flag is '原币期初余额方向';
comment on column ${iol_schema}.fams_bok_bal_table_data.o_open_balance is '原币期初余额';
comment on column ${iol_schema}.fams_bok_bal_table_data.o_happen_amt_d is '原币本期借方发生额';
comment on column ${iol_schema}.fams_bok_bal_table_data.o_happen_amt_c is '原币本期贷方发生额';
comment on column ${iol_schema}.fams_bok_bal_table_data.o_end_bal_flag is '原币期末余额方向';
comment on column ${iol_schema}.fams_bok_bal_table_data.o_end_balance is '原币期末余额';
comment on column ${iol_schema}.fams_bok_bal_table_data.b_open_bal_flag is '本位币期初余额方向';
comment on column ${iol_schema}.fams_bok_bal_table_data.b_open_balance is '本位币期初余额';
comment on column ${iol_schema}.fams_bok_bal_table_data.b_happen_amt_d is '本位币本期借方发生额';
comment on column ${iol_schema}.fams_bok_bal_table_data.b_happen_amt_c is '本位币本期贷方发生额';
comment on column ${iol_schema}.fams_bok_bal_table_data.b_end_bal_flag is '本位币期末余额方向';
comment on column ${iol_schema}.fams_bok_bal_table_data.b_end_balance is '本位币期末余额';
comment on column ${iol_schema}.fams_bok_bal_table_data.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_bal_table_data.bookset_name is '账套名称';
comment on column ${iol_schema}.fams_bok_bal_table_data.bal_date is '估值日期';
comment on column ${iol_schema}.fams_bok_bal_table_data.subject_no is '科目号';
comment on column ${iol_schema}.fams_bok_bal_table_data.subject_name is '科目名称';
comment on column ${iol_schema}.fams_bok_bal_table_data.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_bal_table_data.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_bal_table_data.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_bal_table_data.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_bal_table_data.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_bal_table_data.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_bal_table_data.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_bal_table_data.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_bal_table_data.etl_timestamp is 'ETL处理时间戳';
