/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_underwrite_fee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee(
    deal_id number -- 引用表ID
    ,deal_name varchar2(20) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,portfolio_id number -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,cpty_name varchar2(384) -- 成交编号
    ,security_code varchar2(45) -- 债券代码
    ,fee number -- 手续费
    ,trade_date number(8,0) -- 交易日
    ,value_date number(8,0) -- 交割日
    ,trade_type varchar2(2) -- 交易类型
    ,note varchar2(4000) -- 备注
    ,serial_number varchar2(23) -- 交易序号
    ,uw_trade_no varchar2(23) -- 原承分销交易addon序号
    ,uw_trade_id number -- 原承分销交易F2B编号
    ,review_status varchar2(2) -- 复核状态(前台)
    ,trade_time date -- 交易时间
    ,dealer_id number(4,0) -- 交易员ID
    ,dealer_name varchar2(30) -- 交易员名称
    ,orig_serial_number varchar2(23) -- 原始交易编号
    ,link_serial_number varchar2(23) -- 父原始交易序号
    ,status varchar2(2) -- 状态
    ,process_status varchar2(2) -- 原始处理状态
    ,impstatus varchar2(2) -- 导入状态
    ,prostatus varchar2(2) -- 处理状态
    ,lastmodified timestamp -- 最近更新时间
    ,datasymbol_id number -- 数据源引用ID
    ,user_number number -- addon 交易输入用户编号
    ,modify_user number -- 修改人员
    ,modify_date date -- addon交易录入日
    ,counterparty_seq number -- addon交易对手序号
    ,ori_trade_date number -- 原始交易日期
    ,fee_type varchar2(2) -- 手续费类型
    ,cust_key varchar2(192) -- 交易对手
    ,underwrite_fee_id_grand number -- 原始交易ID
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
    ,dn_dealer varchar2(900) -- 本币交易员
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee is '实际收付确认-承分销手续费';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.cpty_name is '成交编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.fee is '手续费';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.trade_date is '交易日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.value_date is '交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.trade_type is '交易类型';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.note is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.serial_number is '交易序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.uw_trade_no is '原承分销交易addon序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.uw_trade_id is '原承分销交易F2B编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.review_status is '复核状态(前台)';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.trade_time is '交易时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.dealer_name is '交易员名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.orig_serial_number is '原始交易编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.link_serial_number is '父原始交易序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.process_status is '原始处理状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.impstatus is '导入状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.prostatus is '处理状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.lastmodified is '最近更新时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.datasymbol_id is '数据源引用ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.user_number is 'addon 交易输入用户编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.modify_user is '修改人员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.modify_date is 'addon交易录入日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.counterparty_seq is 'addon交易对手序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.ori_trade_date is '原始交易日期';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.fee_type is '手续费类型';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.cust_key is '交易对手';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.underwrite_fee_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee.etl_timestamp is 'ETL处理时间戳';
