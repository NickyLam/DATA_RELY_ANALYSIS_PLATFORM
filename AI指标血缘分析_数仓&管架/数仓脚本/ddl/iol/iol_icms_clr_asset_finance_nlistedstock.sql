/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_nlistedstock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_nlistedstock
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_nlistedstock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_nlistedstock(
    clrid varchar2(32) -- 押品编号
    ,isprofitcompany varchar2(2) -- 是否为股份公司
    ,companyname varchar2(120) -- 出质股权所在公司名称
    ,stockcode varchar2(30) -- 出质股权所在公司证件号码
    ,isborrower varchar2(2) -- 发行人是否为借款人
    ,shareamount number(38,0) -- 持股数量
    ,ratio number(24,6) -- 出质股权所占总股权比例
    ,stockamount number(22,0) -- 出质股权数
    ,persharemarketprice number(24,6) -- 每股市价
    ,profitmoney number(24,6) -- 上年度每股分红金额
    ,peridentyshare number(24,6) -- 每股认定价值
    ,totalvalue number(38,6) -- 质押总价值
    ,persharevalue number(24,6) -- 每股净资产
    ,warningline number(24,6) -- 警戒线
    ,liquidateline number(24,6) -- 平仓线
    ,sharetotalvalue number(24,6) -- 净资产总额
    ,remark varchar2(4000) -- 其他说明
    ,tdcurrency varchar2(3) -- 币种
    ,pledgeregistration varchar2(200) -- 质押登记号
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,stockcodetype varchar2(10) -- 出质股权所在公司证件类型
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
grant select on ${iol_schema}.icms_clr_asset_finance_nlistedstock to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_nlistedstock to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_nlistedstock to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_nlistedstock to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_nlistedstock is '金融质押品之非上市股权信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.isprofitcompany is '是否为股份公司';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.companyname is '出质股权所在公司名称';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.stockcode is '出质股权所在公司证件号码';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.isborrower is '发行人是否为借款人';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.shareamount is '持股数量';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.ratio is '出质股权所占总股权比例';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.stockamount is '出质股权数';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.persharemarketprice is '每股市价';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.profitmoney is '上年度每股分红金额';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.peridentyshare is '每股认定价值';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.totalvalue is '质押总价值';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.persharevalue is '每股净资产';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.warningline is '警戒线';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.liquidateline is '平仓线';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.sharetotalvalue is '净资产总额';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.pledgeregistration is '质押登记号';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.stockcodetype is '出质股权所在公司证件类型';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_nlistedstock.etl_timestamp is 'ETL处理时间戳';
