/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_trd_trade_fee_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_trd_trade_fee_detail
whenever sqlerror continue none;
drop table ${iol_schema}.fams_trd_trade_fee_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_trd_trade_fee_detail(
    trade_id varchar2(32) -- 交易编号
    ,fee_type varchar2(50) -- 费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等
    ,is_pay_with_trade varchar2(50) -- 是否随交易支付
    ,fee_amt number(30,2) -- 费用金额
    ,chl_finprod_id varchar2(50) -- 通道代码，通道费时填该值。
    ,fee_id varchar2(50) -- 费用代码，计提式费用存现金流代码，一次性费用存费用类型
    ,fee_rate number(30,14) -- 费率
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,ccy varchar2(50) -- 币种
    ,is_prepaid varchar2(50) -- 是否作为待摊
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
grant select on ${iol_schema}.fams_trd_trade_fee_detail to ${iml_schema};
grant select on ${iol_schema}.fams_trd_trade_fee_detail to ${icl_schema};
grant select on ${iol_schema}.fams_trd_trade_fee_detail to ${idl_schema};
grant select on ${iol_schema}.fams_trd_trade_fee_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_trd_trade_fee_detail is '交易费用明细表';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.trade_id is '交易编号';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.fee_type is '费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.is_pay_with_trade is '是否随交易支付';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.fee_amt is '费用金额';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.chl_finprod_id is '通道代码，通道费时填该值。';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.fee_id is '费用代码，计提式费用存现金流代码，一次性费用存费用类型';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.fee_rate is '费率';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.create_user is '创建人';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.create_dept is '创建部门';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.create_time is '创建时间';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.update_user is '更新人';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.update_time is '更新时间';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.ccy is '币种';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.is_prepaid is '是否作为待摊';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.start_dt is '开始时间';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.end_dt is '结束时间';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.id_mark is '增删标志';
comment on column ${iol_schema}.fams_trd_trade_fee_detail.etl_timestamp is 'ETL处理时间戳';
