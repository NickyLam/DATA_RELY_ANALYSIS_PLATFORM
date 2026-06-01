/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_fit_deal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_fit_deal
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_fit_deal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_fit_deal(
    cus_number number(5,0) -- 机构的唯一标识号
    ,branch_number number(5,0) -- 分支机构的唯一标识号
    ,deal_sqno number(18,0) -- 成交流水号
    ,deal_date date -- 交易日期和时间
    ,trnsfr_date date -- 头寸调拨日
    ,trnsfr_type number(2,0) -- 调拨类型
    ,crncy_code varchar2(5) -- 货币的SRNO
    ,first_amnt number -- 交易金额
    ,trade_purpose number(2,0) -- 交易目的
    ,business_date date -- 系统交易日
    ,counter_party_id number(8,0) -- 交易对手编码
    ,counter_party_scname varchar2(384) -- 交易对手中文简称
    ,update_time timestamp -- 记录修改日期
    ,pdd_deal_sqno number(18,0) -- 成交流水号
    ,deal_status varchar2(3) -- 成交单状态
    ,deal_dir number(2,0) -- 交易方向
    ,client_deal_sqno varchar2(45) -- 业务成交编号，
    ,trade_type varchar2(3) -- 交易模式
    ,deal_source varchar2(3) -- 交易来源
    ,deal_market varchar2(8) -- 交易场所
    ,settle_type number(2,0) -- 清算方式
    ,deal_link_sqno number -- 交易修改删除的序列关系。
    ,modify_date date -- 更新日期
    ,portfolio_sqno number(18,0) -- 投组交易编号
    ,portfolio_id number(8,0) -- 投资组合ID
    ,portfolio_name varchar2(383) -- 投资组合名称
    ,portfolio_type varchar2(60) -- 投组类型
    ,portfolio_status varchar2(3) -- 投资组合状态
    ,portfolio_link_sqno number(18,0) -- 投组交易链接编号
    ,amnt_type number(2,0) -- 金额类型
    ,stlmnt_stts number(2,0) -- INDC结算状态
    ,from_account_infr_srno varchar2(300) -- 划出行账户编号
    ,to_account_infr_srno varchar2(60) -- 划入行账户编号
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
grant select on ${iol_schema}.ctms_fbs_v_fit_deal to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_fit_deal to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_fit_deal to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_fit_deal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_fit_deal is '头寸调拨视图';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.cus_number is '机构的唯一标识号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.branch_number is '分支机构的唯一标识号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.deal_sqno is '成交流水号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.deal_date is '交易日期和时间';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.trnsfr_date is '头寸调拨日';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.trnsfr_type is '调拨类型';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.crncy_code is '货币的SRNO';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.first_amnt is '交易金额';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.trade_purpose is '交易目的';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.business_date is '系统交易日';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.counter_party_id is '交易对手编码';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.counter_party_scname is '交易对手中文简称';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.update_time is '记录修改日期';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.pdd_deal_sqno is '成交流水号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.deal_status is '成交单状态';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.deal_dir is '交易方向';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.client_deal_sqno is '业务成交编号，';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.trade_type is '交易模式';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.deal_source is '交易来源';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.deal_market is '交易场所';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.settle_type is '清算方式';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.deal_link_sqno is '交易修改删除的序列关系。';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.modify_date is '更新日期';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.portfolio_sqno is '投组交易编号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.portfolio_id is '投资组合ID';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.portfolio_name is '投资组合名称';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.portfolio_type is '投组类型';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.portfolio_status is '投资组合状态';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.portfolio_link_sqno is '投组交易链接编号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.amnt_type is '金额类型';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.stlmnt_stts is 'INDC结算状态';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.from_account_infr_srno is '划出行账户编号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.to_account_infr_srno is '划入行账户编号';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_fit_deal.etl_timestamp is 'ETL处理时间戳';
