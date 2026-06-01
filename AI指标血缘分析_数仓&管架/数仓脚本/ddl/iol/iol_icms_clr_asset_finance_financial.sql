/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_financial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_financial
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_financial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_financial(
    accountday number(38,0) -- 资金到帐天数
    ,accountname varchar2(30) -- 专用账户名称
    ,accountno varchar2(100) -- 银行账号
    ,address varchar2(10) -- 银行注册地所在国家或地区
    ,allnum number(20,2) -- 总份额
    ,backnbr varchar2(100) -- 理财冻结流水号
    ,cashaccount varchar2(50) -- 保证金账号
    ,cfmno varchar2(32) -- 确认流水号
    ,clrid varchar2(32) -- 押品编号
    ,customertype varchar2(2) -- 理财系统客户类型
    ,depositstatus varchar2(2) -- 冻结状态
    ,enddate date -- 到期日期
    ,impawnnum number(20,2) -- 质押份额
    ,incometype varchar2(2) -- 收益类型
    ,inratingdate date -- 银行的内部评级日期
    ,inratingresult varchar2(100) -- 银行的内部评级结果
    ,isowner varchar2(10) -- 是否本行理财
    ,istermright varchar2(2) -- 提前终止权
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,outratingdate date -- 银行的外部评级日期
    ,outratingresult varchar2(100) -- 银行的外部评级结果
    ,predictyield number(5,2) -- 预期收益率
    ,productcode varchar2(100) -- 理财产品编码
    ,productname varchar2(100) -- 理财产品名称
    ,remark varchar2(4000) -- 其他说明
    ,startdate date -- 起始日期
    ,tdcurrency varchar2(3) -- 币种
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
grant select on ${iol_schema}.icms_clr_asset_finance_financial to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_financial to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_financial to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_financial to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_financial is '押品-金融质押品之理财产品信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.accountday is '资金到帐天数';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.accountname is '专用账户名称';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.accountno is '银行账号';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.address is '银行注册地所在国家或地区';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.allnum is '总份额';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.backnbr is '理财冻结流水号';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.cashaccount is '保证金账号';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.cfmno is '确认流水号';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.customertype is '理财系统客户类型';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.depositstatus is '冻结状态';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.enddate is '到期日期';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.impawnnum is '质押份额';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.incometype is '收益类型';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.inratingdate is '银行的内部评级日期';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.inratingresult is '银行的内部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.isowner is '是否本行理财';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.istermright is '提前终止权';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.outratingdate is '银行的外部评级日期';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.outratingresult is '银行的外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.predictyield is '预期收益率';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.productcode is '理财产品编码';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.productname is '理财产品名称';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.startdate is '起始日期';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_financial.etl_timestamp is 'ETL处理时间戳';
