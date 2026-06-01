/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_bill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_bill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_bill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_bill(
    clrid varchar2(32) -- 押品编号
    ,notecode varchar2(32) -- 票据号码
    ,notetype varchar2(2) -- 票据类型
    ,remitter varchar2(100) -- 出票人名称
    ,remittercode varchar2(30) -- 出票人组织机构代码
    ,remittertype varchar2(2) -- 出票人类型
    ,remitteropenacount varchar2(30) -- 出票人开户行行号
    ,remitteraccount varchar2(60) -- 出票人账号
    ,acceptor varchar2(100) -- 承兑人名称
    ,acceptortype varchar2(2) -- 承兑人类型
    ,payee varchar2(100) -- 收款人名称
    ,payeetype varchar2(2) -- 收款人类型
    ,isbillbhand varchar2(2) -- 是否有票据前手
    ,billbhandname varchar2(100) -- 票据前手名称
    ,billbhandtype varchar2(2) -- 票据前手类型
    ,faceamount number(24,6) -- 票面金额
    ,startdate date -- 票据签发日
    ,enddate date -- 票据到期日期
    ,remittercountry varchar2(30) -- 出票人注册地所在国家或地区
    ,remitterrating varchar2(4) -- 出票人注册地所在国家或地区外部评级结果
    ,acceptorcountry varchar2(30) -- 承兑人注册地所在国家或地区
    ,acceptorrating varchar2(2) -- 承兑人注册地所在国家或地区外部评级结果
    ,remark varchar2(4000) -- 其他说明
    ,isbankpaste varchar2(2) -- 是否银行保贴
    ,bankpastename varchar2(100) -- 银行保贴名称
    ,tdcurrency varchar2(3) -- 币种
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_finance_bill to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_bill to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_bill to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_bill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_bill is '金融质押品之非承兑汇票类票据信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.notecode is '票据号码';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.notetype is '票据类型';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remitter is '出票人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remittercode is '出票人组织机构代码';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remittertype is '出票人类型';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remitteropenacount is '出票人开户行行号';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remitteraccount is '出票人账号';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.acceptor is '承兑人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.acceptortype is '承兑人类型';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.payee is '收款人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.payeetype is '收款人类型';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.isbillbhand is '是否有票据前手';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.billbhandname is '票据前手名称';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.billbhandtype is '票据前手类型';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.faceamount is '票面金额';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.startdate is '票据签发日';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.enddate is '票据到期日期';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remittercountry is '出票人注册地所在国家或地区';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remitterrating is '出票人注册地所在国家或地区外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.acceptorcountry is '承兑人注册地所在国家或地区';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.acceptorrating is '承兑人注册地所在国家或地区外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.isbankpaste is '是否银行保贴';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.bankpastename is '银行保贴名称';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_bill.etl_timestamp is 'ETL处理时间戳';
