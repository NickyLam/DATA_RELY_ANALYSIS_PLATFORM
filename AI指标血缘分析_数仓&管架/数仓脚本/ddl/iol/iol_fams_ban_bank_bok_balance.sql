/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_bank_bok_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_bank_bok_balance
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_bank_bok_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_bank_bok_balance(
    finprod_id varchar2(50) -- 金融产品代码
    ,balance_date date -- 余额日期
    ,subject_no varchar2(30) -- 科目号
    ,fsubject_no varchar2(32) -- 父科目号
    ,subject_level number(10) -- 科目级别
    ,bal_flag varchar2(50) -- 余额方向
    ,o_ccy varchar2(50) -- 原币
    ,o_amt number(30,2) -- 原币余额
    ,b_ccy varchar2(50) -- 本位币
    ,b_amt number(30,2) -- 本位币余额
    ,is_leaf varchar2(50) -- 是否叶子节点
    ,num_amt number(30,2) -- 数量余额
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,bookset_id varchar2(50) -- 账套代码
    ,detail_subject_no varchar2(12) -- 产品编号
    ,detail_subject_level number(10) -- 可售产品级别
    ,tdy_o_c_amt number(30,2) -- 原币本期贷方发生额
    ,tdy_o_d_amt number(30,2) -- 原币本期借方发生额
    ,o_c_amt number(30,2) -- 原币本期贷方余额
    ,o_d_amt number(30,2) -- 原币本期借方余额
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
grant select on ${iol_schema}.fams_ban_bank_bok_balance to ${iml_schema};
grant select on ${iol_schema}.fams_ban_bank_bok_balance to ${icl_schema};
grant select on ${iol_schema}.fams_ban_bank_bok_balance to ${idl_schema};
grant select on ${iol_schema}.fams_ban_bank_bok_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_bank_bok_balance is '银行账科目余额表';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.balance_date is '余额日期';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.subject_no is '科目号';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.fsubject_no is '父科目号';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.subject_level is '科目级别';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.bal_flag is '余额方向';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.o_ccy is '原币';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.o_amt is '原币余额';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.b_ccy is '本位币';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.b_amt is '本位币余额';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.is_leaf is '是否叶子节点';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.num_amt is '数量余额';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.detail_subject_no is '产品编号';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.detail_subject_level is '可售产品级别';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.tdy_o_c_amt is '原币本期贷方发生额';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.tdy_o_d_amt is '原币本期借方发生额';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.o_c_amt is '原币本期贷方余额';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.o_d_amt is '原币本期借方余额';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_bank_bok_balance.etl_timestamp is 'ETL处理时间戳';
