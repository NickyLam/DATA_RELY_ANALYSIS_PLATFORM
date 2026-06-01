/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_pledgebond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_pledgebond
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_pledgebond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_pledgebond(
    i_code varchar2(45) -- 金融工具代码 关联交易表ttrd_otc_trade intordid字段 或关联审批表ttrd_otc_order  intordid字段
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型 xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间
    ,p_i_code varchar2(45) -- 质押券金融工具
    ,p_m_type varchar2(30) -- xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间
    ,p_a_type varchar2(30) -- 资产类型
    ,amount number(20,3) -- 质押券面额
    ,discount number(31,4) -- 折价率
    ,disamount number(31,4) -- 折价金额
    ,partytype varchar2(2) -- 1-本方 ; 0-对手方
    ,resertype varchar2(2) -- 1-质押券 ; 0-保证券
    ,evalfullprice number(10,4) -- 中债估值（全价）
    ,volume number(38,4) -- 余额数量变动
    ,secu_acct_id varchar2(45) -- 内部证券账户id
    ,ext_secu_acct_id varchar2(45) -- 外部证券账户id
    ,trade_grp_id varchar2(45) -- 核算交易组合
    ,sort number(22,0) -- 排序序号
    ,si_id number(16,0) -- 
    ,sysordid number(16,0) -- 交易序号
    ,demo varchar2(1500) -- 备注
    ,trd_alt_mark varchar2(3) -- 新旧交替标识 默认为0，新券1老券-1
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
grant select on ${iol_schema}.ibms_ttrd_pledgebond to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_pledgebond to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_pledgebond to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_pledgebond to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_pledgebond is '质押式回购质押券表';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.i_code is '金融工具代码 关联交易表ttrd_otc_trade intordid字段 或关联审批表ttrd_otc_order  intordid字段';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.m_type is '市场类型 xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.p_i_code is '质押券金融工具';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.p_m_type is 'xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.p_a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.amount is '质押券面额';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.discount is '折价率';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.disamount is '折价金额';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.partytype is '1-本方 ; 0-对手方';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.resertype is '1-质押券 ; 0-保证券';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.evalfullprice is '中债估值（全价）';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.volume is '余额数量变动';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.secu_acct_id is '内部证券账户id';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.ext_secu_acct_id is '外部证券账户id';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.trade_grp_id is '核算交易组合';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.sort is '排序序号';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.si_id is '';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.sysordid is '交易序号';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.demo is '备注';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.trd_alt_mark is '新旧交替标识 默认为0，新券1老券-1';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_pledgebond.etl_timestamp is 'ETL处理时间戳';
