/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_listedstock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_listedstock
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_listedstock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_listedstock(
    clrid varchar2(32) -- 押品编号
    ,stockcode varchar2(100) -- 股票代码
    ,stockname varchar2(100) -- 股票名称
    ,companyname varchar2(120) -- 公司名称
    ,isborrower varchar2(2) -- 发行人是否为借款人
    ,profits number(24,6) -- 公司上年度利润
    ,isnromal varchar2(2) -- 股票状态是否正常
    ,bourse varchar2(2) -- 交易所名称
    ,ispublic varchar2(2) -- 是否公开交易
    ,exponent varchar2(100) -- 主要指数成分股及其名称
    ,shareamount number(38,0) -- 持股数量
    ,stockamount number(24,6) -- 出质股权数额
    ,persharemarketprice number(24,6) -- 每股市价
    ,profitmoney number(24,6) -- 上年每股分红金额
    ,warningline number(24,6) -- 警戒线
    ,persharevalue number(24,6) -- 每股净资产
    ,liquidateline number(24,6) -- 平仓线
    ,totalvalue number(24,6) -- 质押总价值
    ,duedate date -- 限售到期日
    ,remark varchar2(4000) -- 股票其他说明
    ,tdcurrency varchar2(3) -- 币种
    ,stockidc varchar2(100) -- 股票托管券商
    ,pledgeregistration varchar2(200) -- 质押登记号
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,pledgetag varchar2(2) -- 场内外质押标签
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
grant select on ${iol_schema}.icms_clr_asset_finance_listedstock to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_listedstock to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_listedstock to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_listedstock to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_listedstock is '金融质押品之上市股权信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.stockcode is '股票代码';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.stockname is '股票名称';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.companyname is '公司名称';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.isborrower is '发行人是否为借款人';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.profits is '公司上年度利润';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.isnromal is '股票状态是否正常';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.bourse is '交易所名称';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.ispublic is '是否公开交易';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.exponent is '主要指数成分股及其名称';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.shareamount is '持股数量';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.stockamount is '出质股权数额';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.persharemarketprice is '每股市价';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.profitmoney is '上年每股分红金额';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.warningline is '警戒线';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.persharevalue is '每股净资产';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.liquidateline is '平仓线';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.totalvalue is '质押总价值';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.duedate is '限售到期日';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.remark is '股票其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.stockidc is '股票托管券商';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.pledgeregistration is '质押登记号';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.pledgetag is '场内外质押标签';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_listedstock.etl_timestamp is 'ETL处理时间戳';
