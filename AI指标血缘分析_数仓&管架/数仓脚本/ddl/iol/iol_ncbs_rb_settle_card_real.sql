/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_settle_card_real
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_settle_card_real
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_settle_card_real purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_real(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,all_dra_ind varchar2(1) -- 通兑标志
    ,auto_collect_flag varchar2(1) -- 联动扣款标志
    ,card_tran_flag varchar2(1) -- 卡片是否停用标志
    ,card_tranform_flag varchar2(1) -- 卡内互转标识
    ,collect_no varchar2(20) -- 归集顺序号
    ,collect_order varchar2(1) -- 自动归集顺序
    ,company varchar2(20) -- 法人
    ,cret_trans_flag varchar2(1) -- 可存款
    ,debt_trans_flag varchar2(1) -- 可转出
    ,default_flag varchar2(1) -- 是否默认账号
    ,is_cash_trans varchar2(1) -- 可取现
    ,main_card_flag varchar2(1) -- 主卡标识
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,card_prod_type varchar2(12) -- 卡产品类型
    ,main_card_no varchar2(50) -- 主卡卡号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,inc_exp_flag varchar2(1) -- 以收定支标识，单位结算卡限额用
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
grant select on ${iol_schema}.ncbs_rb_settle_card_real to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_real to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_real to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_real to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_settle_card_real is '单位结算卡关联信息表';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.all_dra_ind is '通兑标志';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.auto_collect_flag is '联动扣款标志';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.card_tran_flag is '卡片是否停用标志';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.card_tranform_flag is '卡内互转标识';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.collect_no is '归集顺序号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.collect_order is '自动归集顺序';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.company is '法人';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.cret_trans_flag is '可存款';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.debt_trans_flag is '可转出';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.default_flag is '是否默认账号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.is_cash_trans is '可取现';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.main_card_flag is '主卡标识';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.card_prod_type is '卡产品类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.main_card_no is '主卡卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.inc_exp_flag is '以收定支标识，单位结算卡限额用';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_settle_card_real.etl_timestamp is 'ETL处理时间戳';
