/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_upd_balance_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_upd_balance_tran
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_upd_balance_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_upd_balance_tran(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,tran_type varchar2(10) -- 交易类型
    ,bal_calc_flag varchar2(1) -- 金额处理标志
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,event_type varchar2(20) -- 事件类型
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_upd_balance_tran to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_upd_balance_tran to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_upd_balance_tran to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_upd_balance_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_upd_balance_tran is '批量更新余额信息表';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.bal_calc_flag is '金额处理标志';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.company is '法人';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_upd_balance_tran.etl_timestamp is 'ETL处理时间戳';
