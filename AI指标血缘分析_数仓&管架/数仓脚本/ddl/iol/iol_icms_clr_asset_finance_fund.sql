/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_fund
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_fund(
    clrid varchar2(32) -- 押品编号
    ,fundcode varchar2(100) -- 基金代码
    ,account varchar2(60) -- 账户号码
    ,issuername varchar2(100) -- 发行人名称
    ,startdate date -- 起始日期
    ,enddate date -- 截止日期
    ,fundname varchar2(100) -- 基金名称
    ,fundtype varchar2(2) -- 基金类型
    ,iscp varchar2(2) -- 是否保本
    ,istransfer varchar2(2) -- 是否可转让
    ,invest varchar2(30) -- 投资标的
    ,ispublicoffer varchar2(2) -- 是否公开报价
    ,impawnnum number(38,0) -- 质押份数
    ,netvalue number(24,6) -- 单位净值
    ,totalvalue number(24,6) -- 质押总价值
    ,isborrower varchar2(2) -- 发行人是否为借款人
    ,remark varchar2(4000) -- 其他说明
    ,tdcurrency varchar2(3) -- 币种
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,registno varchar2(200) -- 质押登记号
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
grant select on ${iol_schema}.icms_clr_asset_finance_fund to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_fund to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_fund to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_fund to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_fund is '金融质押品之基金信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.fundcode is '基金代码';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.account is '账户号码';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.issuername is '发行人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.startdate is '起始日期';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.enddate is '截止日期';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.fundname is '基金名称';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.fundtype is '基金类型';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.iscp is '是否保本';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.istransfer is '是否可转让';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.invest is '投资标的';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.ispublicoffer is '是否公开报价';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.impawnnum is '质押份数';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.netvalue is '单位净值';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.totalvalue is '质押总价值';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.isborrower is '发行人是否为借款人';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.registno is '质押登记号';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_fund.etl_timestamp is 'ETL处理时间戳';
