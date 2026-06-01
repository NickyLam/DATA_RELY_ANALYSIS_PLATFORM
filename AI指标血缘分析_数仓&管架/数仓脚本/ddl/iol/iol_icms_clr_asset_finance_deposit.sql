/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_deposit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_deposit
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_deposit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_deposit(
    clrid varchar2(32) -- 押品编号
    ,deposittype varchar2(10) -- 存单类型
    ,currency varchar2(3) -- 币种
    ,buyaccount varchar2(40) -- 认购账号
    ,account varchar2(100) -- 止付账号
    ,subaccount varchar2(60) -- 子账户号
    ,accountname varchar2(200) -- 账户名称
    ,bankname varchar2(200) -- 银行名称
    ,certificateno varchar2(100) -- 存单凭证号
    ,depositsum number(24,6) -- 存单金额
    ,usebalance number(24,6) -- 账户可用余额
    ,pledgesum number(24,6) -- 质押金额
    ,startdate date -- 生效日
    ,valuedate date -- 起息日
    ,enddate date -- 到期日
    ,rate number(24,6) -- 存单利率
    ,depositdays number(22,0) -- 存期（天）
    ,remark varchar2(4000) -- 其他说明
    ,stoppayno varchar2(100) -- 止付通知书编号
    ,productid varchar2(20) -- 产品编号
    ,productname varchar2(400) -- 产品名称
    ,payinttype varchar2(10) -- 付息方式
    ,customerid varchar2(40) -- 客户编号
    ,liabaccount varchar2(60) -- 负债账号
    ,registcountry varchar2(30) -- 银行注册地所在国家或地区
    ,inratingresult varchar2(10) -- 银行的内部评级结果
    ,inratingdate date -- 银行的内部评级日期
    ,outratingresult varchar2(10) -- 银行的外部评级结果
    ,outratingdate date -- 银行的外部评级日期
    ,depositstatus varchar2(2) -- 存单状态
    ,backnbr varchar2(32) -- 核心限制流水号
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,vouchertype varchar2(10) -- 凭证类型
    ,acctbranchorgid varchar2(32) -- 存单开户机构编号
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
grant select on ${iol_schema}.icms_clr_asset_finance_deposit to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_deposit to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_deposit to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_deposit to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_deposit is '金融质押品之存单信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.deposittype is '存单类型';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.currency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.buyaccount is '认购账号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.account is '止付账号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.subaccount is '子账户号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.accountname is '账户名称';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.bankname is '银行名称';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.certificateno is '存单凭证号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.depositsum is '存单金额';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.usebalance is '账户可用余额';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.pledgesum is '质押金额';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.startdate is '生效日';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.valuedate is '起息日';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.enddate is '到期日';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.rate is '存单利率';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.depositdays is '存期（天）';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.stoppayno is '止付通知书编号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.productid is '产品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.productname is '产品名称';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.payinttype is '付息方式';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.customerid is '客户编号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.liabaccount is '负债账号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.registcountry is '银行注册地所在国家或地区';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.inratingresult is '银行的内部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.inratingdate is '银行的内部评级日期';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.outratingresult is '银行的外部评级结果';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.outratingdate is '银行的外部评级日期';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.depositstatus is '存单状态';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.backnbr is '核心限制流水号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.vouchertype is '凭证类型';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.acctbranchorgid is '存单开户机构编号';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_deposit.etl_timestamp is 'ETL处理时间戳';
