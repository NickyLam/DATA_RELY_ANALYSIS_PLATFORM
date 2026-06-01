/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92ym_asset_view
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92ym_asset_view
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92ym_asset_view purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92ym_asset_view(
    custno varchar2(64) -- 客户号
    ,cardno varchar2(40) -- 账号
    ,fundcode varchar2(30) -- 基金代码
    ,fundfullname varchar2(100) -- 基金全称
    ,fundname varchar2(100) -- 基金简称
    ,fundtype varchar2(1) -- 基金类型
    ,totalshare number(17,4) -- 份额
    ,totalsharedt varchar2(16) -- 份额日期
    ,nav number(17,4) -- 净值
    ,navdt varchar2(8) -- 净值日期
    ,divamt number(17,2) -- 净值日期对应的分红金额
    ,oldtotalshare number(17,4) -- 上日份额
    ,oldtotalsharedt varchar2(16) -- 上日份额日期
    ,oldnav number(17,4) -- 上日净值
    ,oldnavtdt varchar2(8) -- 上日净值日期
    ,olddivamt number(17,2) -- 上日净值日期对应的分红金额
    ,total_cosr number(17,2) -- 投入资金
    ,total_income number(17,2) -- 收益资金（不含分红）
    ,total_div number(17,2) -- 分红收益
    ,old_total_cosr number(17,2) -- 上日投入资金
    ,old_total_income number(17,2) -- 上日收益资金（不含分红）
    ,old_total_div number(17,2) -- 上日分行收益
    ,income number(17,2) -- 最新收益（基金净值差计算）
    ,accprofit number(17,4) -- 净值日期对应的浮动盈亏
    ,lastaccprofit number(17,4) -- 上日净值日期对应的浮动盈亏
    ,fund_income number(17,4) -- 最新收益（浮动盈亏相差计算）
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
grant select on ${iol_schema}.mpcs_a92ym_asset_view to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92ym_asset_view to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92ym_asset_view to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92ym_asset_view to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92ym_asset_view is '视图-盈米浮动盈亏数据';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.custno is '客户号';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.cardno is '账号';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.fundcode is '基金代码';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.fundfullname is '基金全称';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.fundname is '基金简称';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.fundtype is '基金类型';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.totalshare is '份额';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.totalsharedt is '份额日期';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.nav is '净值';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.navdt is '净值日期';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.divamt is '净值日期对应的分红金额';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.oldtotalshare is '上日份额';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.oldtotalsharedt is '上日份额日期';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.oldnav is '上日净值';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.oldnavtdt is '上日净值日期';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.olddivamt is '上日净值日期对应的分红金额';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.total_cosr is '投入资金';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.total_income is '收益资金（不含分红）';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.total_div is '分红收益';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.old_total_cosr is '上日投入资金';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.old_total_income is '上日收益资金（不含分红）';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.old_total_div is '上日分行收益';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.income is '最新收益（基金净值差计算）';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.accprofit is '净值日期对应的浮动盈亏';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.lastaccprofit is '上日净值日期对应的浮动盈亏';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.fund_income is '最新收益（浮动盈亏相差计算）';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a92ym_asset_view.etl_timestamp is 'ETL处理时间戳';
