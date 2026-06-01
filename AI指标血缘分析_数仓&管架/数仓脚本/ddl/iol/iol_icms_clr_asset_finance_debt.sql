/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_debt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_debt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_debt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_debt(
    clrid varchar2(32) -- 押品编号
    ,debtcode varchar2(100) -- 国债代码/债券代码
    ,issuanceformat varchar2(10) -- 国债发放形式
    ,debtsubtype varchar2(10) -- 债券细类
    ,certificatecode varchar2(100) -- 债券凭证号
    ,debtname varchar2(100) -- 债券名称
    ,amount number(38,0) -- 数量
    ,issuercode varchar2(30) -- 发行人组织机构代码
    ,issuername varchar2(100) -- 发行人名称
    ,issuertype varchar2(2) -- 发行人类型
    ,isborrower varchar2(2) -- 发行人是否为借款人
    ,ishaveoutrating varchar2(2) -- 债券是否有外部债项评级
    ,outratingresult varchar2(10) -- 债券外部评级结果
    ,issueroutorg varchar2(2) -- 发行人发行的同一级别债券外部评级机构
    ,issueroutresult varchar2(10) -- 发行人发行的同一级别债券外部评级结果
    ,issuercountry varchar2(30) -- 发行人注册地所在国家或地区
    ,issuercountryresult varchar2(10) -- 发行人注册地所在国家或地区外部评级结果
    ,issuerresult varchar2(10) -- 发行人外部评级结果
    ,faceamount number(24,6) -- 票面金额
    ,actuallyamount number(24,6) -- 票面净值
    ,tdcurrency varchar2(3) -- 币种
    ,stoppayment number(24,6) -- 国债冻结/止付金额
    ,paytype varchar2(2) -- 利息支付方式
    ,rate number(24,6) -- 利率
    ,startdate date -- 发行日期
    ,enddate date -- 到期日期
    ,isfirst varchar2(2) -- 是否优先债券
    ,publishreson varchar2(2) -- 发行目的
    ,deadlinetype varchar2(2) -- 债券期限类型
    ,ismarket varchar2(2) -- 是否主要交易所交易
    ,remark varchar2(4000) -- 其他说明
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
grant select on ${iol_schema}.icms_clr_asset_finance_debt to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_debt to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_debt to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_debt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_debt is '金融质押品之债券信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.debtcode is '国债代码/债券代码';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issuanceformat is '国债发放形式';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.debtsubtype is '债券细类';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.certificatecode is '债券凭证号';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.debtname is '债券名称';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.amount is '数量';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issuercode is '发行人组织机构代码';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issuername is '发行人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issuertype is '发行人类型';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.isborrower is '发行人是否为借款人';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.ishaveoutrating is '债券是否有外部债项评级';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.outratingresult is '债券外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issueroutorg is '发行人发行的同一级别债券外部评级机构';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issueroutresult is '发行人发行的同一级别债券外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issuercountry is '发行人注册地所在国家或地区';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issuercountryresult is '发行人注册地所在国家或地区外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.issuerresult is '发行人外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.faceamount is '票面金额';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.actuallyamount is '票面净值';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.stoppayment is '国债冻结/止付金额';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.paytype is '利息支付方式';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.rate is '利率';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.startdate is '发行日期';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.enddate is '到期日期';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.isfirst is '是否优先债券';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.publishreson is '发行目的';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.deadlinetype is '债券期限类型';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.ismarket is '是否主要交易所交易';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_debt.etl_timestamp is 'ETL处理时间戳';
