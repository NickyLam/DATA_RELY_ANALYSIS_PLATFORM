/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ctms_tbs_v_wtrade_lend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend(
    etl_dt date -- 数据日期
    ,deal_id number -- 引用表ID
    ,deal_tablename varchar2(10) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,portfolio_id number(5) -- 交易组别
    ,portfolio_name varchar2(80) -- 交易组别名称
    ,serial_number varchar2(15) -- 交易序号
    ,user_number number(5) -- 操作员
    ,branch_number number(5) -- 分支机构号
    ,currency varchar2(3) -- 币别
    ,buyorsell varchar2(1) -- 交易方向
    ,amount number(17,2) -- 面额
    ,trade_rate number(17,8) -- 借贷费率
    ,market_rate number(17,8) -- 市值
    ,value_date varchar2(8) -- 首期结算日
    ,maturity_date varchar2(8) -- 到期结算日
    ,trade_date varchar2(8) -- 交易录入日
    ,trade_time date -- 交易时间
    ,ref_number varchar2(32) -- 成交编号
    ,link_serial_number varchar2(15) -- 删除或修改的原始交易
    ,status varchar2(1) -- 状态
    ,dealer number(5) -- 交易员ID
    ,account varchar2(30) -- 
    ,maturity_amount number(17,2) -- 到期结算金额
    ,lend_id varchar2(16) -- 交易品种
    ,bondscode varchar2(340) -- 质押券代码
    ,lendbondscode varchar2(20) -- 标的券代码
    ,fee number(17,2) -- 首期费用
    ,tax_amt number(17,2) -- 首期税金
    ,broker_amt number(17,2) -- 首期佣金
    ,interest number(17,2) -- 应计利息
    ,note varchar2(400) -- 备注
    ,day_count varchar2(1) -- 日计息基准
    ,process_status varchar2(1) -- 处理状态
    ,realized_pl number(17,2) -- 已实现损益
    ,unrealized_pl number(17,2) -- 未实现损益
    ,total_pl number(17,2) -- 总损益
    ,daily_pl number(17,2) -- 每日损益
    ,interest_pl number(17,2) -- 利息损益
    ,realized_days number(5) -- 实际天数
    ,ori_trade_date varchar2(8) -- 原始交易日
    ,security_face_amount varchar2(340) -- 抵押品每张券面总额
    ,collateral_type varchar2(1) -- 抵押品种类
    ,lend_rate varchar2(256) -- 抵押比例
    ,settle_type varchar2(1) -- 首次结算方式
    ,settle_type2 varchar2(1) -- 到期结算方式
    ,deal_time date -- 交易时间
    ,modify_user number(5) -- 修改人
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(50) -- 账户名称
    ,cptys_short_name varchar2(128) -- 交易对手名
    ,cptys_id number -- 交易对手序号
    ,ref_deal_sn varchar2(15) -- 参考编号
    ,valid_source_sn varchar2(15) -- 连结的审批序号
    ,cancel_reason varchar2(256) -- 审批单被撤销理由
    ,source varchar2(1) -- 交易来源
    ,input_from varchar2(2) -- 输入来源
    ,cstp_serial varchar2(15) -- 原始交易序号
    ,cfets_from varchar2(1) -- 是否是CFETS交易
    ,lend_days number -- 借贷期限
    ,inv_type varchar2(1) -- 库存方式
    ,inv_short varchar2(1) -- 库存是否短仓
    ,auto_import varchar2(1) -- 是否自动导入
    ,price_flag varchar2(1) -- 金额标识
    ,match_flag varchar2(1) -- 是否匹配
    ,is_trans_quote varchar2(1) -- 审批单是否转成报价
    ,wtrade_lend_id_grand number(38) -- 原始交易ID
    ,datasymbol_id number(38) -- 数据源ID
    ,orig_serial_number varchar2(15) -- 原始交易序号
    ,impstatus varchar2(1) -- 导入状态
    ,prostatus varchar2(1) -- 处理状态
    ,spotfwd varchar2(1) -- 远期/即期
    ,lastmodified timestamp(6) -- 最后修改时间
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend is '债券借贷交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.deal_id is '引用表ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.deal_tablename is '引用表名';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.aspclient_id is '部门编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.portfolio_id is '交易组别';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.portfolio_name is '交易组别名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.serial_number is '交易序号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.user_number is '操作员';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.branch_number is '分支机构号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.currency is '币别';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.buyorsell is '交易方向';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.amount is '面额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.trade_rate is '借贷费率';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.market_rate is '市值';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.value_date is '首期结算日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.maturity_date is '到期结算日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.trade_date is '交易录入日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.trade_time is '交易时间';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.ref_number is '成交编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.link_serial_number is '删除或修改的原始交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.status is '状态';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.dealer is '交易员ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.account is '';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.maturity_amount is '到期结算金额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.lend_id is '交易品种';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.bondscode is '质押券代码';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.lendbondscode is '标的券代码';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.fee is '首期费用';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.tax_amt is '首期税金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.broker_amt is '首期佣金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.interest is '应计利息';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.note is '备注';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.day_count is '日计息基准';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.process_status is '处理状态';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.realized_pl is '已实现损益';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.unrealized_pl is '未实现损益';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.total_pl is '总损益';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.daily_pl is '每日损益';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.interest_pl is '利息损益';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.realized_days is '实际天数';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.ori_trade_date is '原始交易日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.security_face_amount is '抵押品每张券面总额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.collateral_type is '抵押品种类';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.lend_rate is '抵押比例';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.settle_type is '首次结算方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.settle_type2 is '到期结算方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.deal_time is '交易时间';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.modify_user is '修改人';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.keepfolder_id is '账户ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.keepfolder_shortname is '账户名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.cptys_short_name is '交易对手名';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.cptys_id is '交易对手序号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.ref_deal_sn is '参考编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.valid_source_sn is '连结的审批序号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.cancel_reason is '审批单被撤销理由';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.source is '交易来源';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.input_from is '输入来源';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.cstp_serial is '原始交易序号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.cfets_from is '是否是CFETS交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.lend_days is '借贷期限';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.inv_type is '库存方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.inv_short is '库存是否短仓';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.auto_import is '是否自动导入';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.price_flag is '金额标识';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.match_flag is '是否匹配';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.is_trans_quote is '审批单是否转成报价';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.wtrade_lend_id_grand is '原始交易ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.datasymbol_id is '数据源ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.orig_serial_number is '原始交易序号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.impstatus is '导入状态';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.prostatus is '处理状态';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.spotfwd is '远期/即期';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.lastmodified is '最后修改时间';
comment on column ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend.etl_timestamp is '数据处理时间';
