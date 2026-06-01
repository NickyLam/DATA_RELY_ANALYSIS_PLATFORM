/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbautoinvest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbautoinvest
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbautoinvest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbautoinvest(
    serial_no varchar2(48) -- 自动理财编号
    ,busin_flag varchar2(2) -- 理财业务标志
    ,trans_date number(22,0) -- 申请日期
    ,in_client_no varchar2(30) -- 内部客户编号
    ,bank_no varchar2(32) -- 银行编号
    ,client_no varchar2(36) -- 客户编号
    ,bank_acc varchar2(64) -- 银行账号
    ,cash_flag varchar2(2) -- 钞汇标志
    ,client_group varchar2(10) -- 客户分组
    ,channel varchar2(2) -- 开通渠道
    ,branch_no varchar2(24) -- 交易机构
    ,prd_code varchar2(32) -- 产品代码
    ,asso_code varchar2(30) -- 关联代码
    ,ta_code varchar2(18) -- ta代码
    ,amt number(18,2) -- 投资金额
    ,vol number(18,3) -- 投资份额
    ,larg_red_flag varchar2(2) -- 巨额赎回标志
    ,min_amt number(18,2) -- 最低金额
    ,max_amt number(18,2) -- 最高金额
    ,hold_amt number(18,2) -- 保留金额
    ,agio number(5,4) -- 交易折扣率
    ,over_flag varchar2(2) -- 终止模式
    ,invest_day number(22,0) -- 投资日
    ,invest_times number(24,2) -- 投资期数
    ,remain_times number(22,0) -- 剩余投资期数
    ,tot_times number(22,0) -- 成功投资期数
    ,fail_times number(22,0) -- 连续失败期数
    ,end_date number(22,0) -- 终止日期
    ,period varchar2(2) -- 投资周期
    ,span number(22,0) -- 投资间隔
    ,next_invest_date number(22,0) -- 下一投资日
    ,last_invest_date number(22,0) -- 最近申购日期
    ,last_deal_date number(22,0) -- 最近处理日期
    ,last_msg varchar2(256) -- 最近处理信息
    ,finish_flag varchar2(2) -- 结束标志
    ,start_invest_date number(22,0) -- 开始日期
    ,client_manager varchar2(48) -- 客户经理
    ,reserve1 varchar2(375) -- 保留域1
    ,reserve2 varchar2(375) -- 保留域2
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
grant select on ${iol_schema}.nfss_tbautoinvest to ${iml_schema};
grant select on ${iol_schema}.nfss_tbautoinvest to ${icl_schema};
grant select on ${iol_schema}.nfss_tbautoinvest to ${idl_schema};
grant select on ${iol_schema}.nfss_tbautoinvest to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbautoinvest is '自动投资信息表';
comment on column ${iol_schema}.nfss_tbautoinvest.serial_no is '自动理财编号';
comment on column ${iol_schema}.nfss_tbautoinvest.busin_flag is '理财业务标志';
comment on column ${iol_schema}.nfss_tbautoinvest.trans_date is '申请日期';
comment on column ${iol_schema}.nfss_tbautoinvest.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_tbautoinvest.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tbautoinvest.client_no is '客户编号';
comment on column ${iol_schema}.nfss_tbautoinvest.bank_acc is '银行账号';
comment on column ${iol_schema}.nfss_tbautoinvest.cash_flag is '钞汇标志';
comment on column ${iol_schema}.nfss_tbautoinvest.client_group is '客户分组';
comment on column ${iol_schema}.nfss_tbautoinvest.channel is '开通渠道';
comment on column ${iol_schema}.nfss_tbautoinvest.branch_no is '交易机构';
comment on column ${iol_schema}.nfss_tbautoinvest.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbautoinvest.asso_code is '关联代码';
comment on column ${iol_schema}.nfss_tbautoinvest.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbautoinvest.amt is '投资金额';
comment on column ${iol_schema}.nfss_tbautoinvest.vol is '投资份额';
comment on column ${iol_schema}.nfss_tbautoinvest.larg_red_flag is '巨额赎回标志';
comment on column ${iol_schema}.nfss_tbautoinvest.min_amt is '最低金额';
comment on column ${iol_schema}.nfss_tbautoinvest.max_amt is '最高金额';
comment on column ${iol_schema}.nfss_tbautoinvest.hold_amt is '保留金额';
comment on column ${iol_schema}.nfss_tbautoinvest.agio is '交易折扣率';
comment on column ${iol_schema}.nfss_tbautoinvest.over_flag is '终止模式';
comment on column ${iol_schema}.nfss_tbautoinvest.invest_day is '投资日';
comment on column ${iol_schema}.nfss_tbautoinvest.invest_times is '投资期数';
comment on column ${iol_schema}.nfss_tbautoinvest.remain_times is '剩余投资期数';
comment on column ${iol_schema}.nfss_tbautoinvest.tot_times is '成功投资期数';
comment on column ${iol_schema}.nfss_tbautoinvest.fail_times is '连续失败期数';
comment on column ${iol_schema}.nfss_tbautoinvest.end_date is '终止日期';
comment on column ${iol_schema}.nfss_tbautoinvest.period is '投资周期';
comment on column ${iol_schema}.nfss_tbautoinvest.span is '投资间隔';
comment on column ${iol_schema}.nfss_tbautoinvest.next_invest_date is '下一投资日';
comment on column ${iol_schema}.nfss_tbautoinvest.last_invest_date is '最近申购日期';
comment on column ${iol_schema}.nfss_tbautoinvest.last_deal_date is '最近处理日期';
comment on column ${iol_schema}.nfss_tbautoinvest.last_msg is '最近处理信息';
comment on column ${iol_schema}.nfss_tbautoinvest.finish_flag is '结束标志';
comment on column ${iol_schema}.nfss_tbautoinvest.start_invest_date is '开始日期';
comment on column ${iol_schema}.nfss_tbautoinvest.client_manager is '客户经理';
comment on column ${iol_schema}.nfss_tbautoinvest.reserve1 is '保留域1';
comment on column ${iol_schema}.nfss_tbautoinvest.reserve2 is '保留域2';
comment on column ${iol_schema}.nfss_tbautoinvest.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbautoinvest.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbautoinvest.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbautoinvest.etl_timestamp is 'ETL处理时间戳';
