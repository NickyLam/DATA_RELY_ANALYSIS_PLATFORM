/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_product_tranche
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_product_tranche
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_product_tranche purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_product_tranche(
    trancheid varchar2(48) -- 分档编号
    ,productid varchar2(48) -- 产品编号
    ,tranchetype varchar2(27) -- 分档类型
    ,tranchename varchar2(300) -- 分档名称
    ,currency varchar2(27) -- 币种
    ,trancheamountratio number(12,6) -- 分档金额占比
    ,trancheamount number(24,6) -- 分档金额
    ,selfholdratio number(12,6) -- 自持比例
    ,maturity varchar2(36) -- 法定到期日
    ,ratinglevel1 varchar2(27) -- 评级级别1
    ,ratingagency1 varchar2(48) -- 评级机构1
    ,ratinglevel2 varchar2(27) -- 评级级别2
    ,ratingagency2 varchar2(48) -- 评级机构2
    ,remark varchar2(48) -- 备注
    ,exchangeservicefee number(24,6) -- 兑换服务费
    ,premiumdiscountrate number(24,6) -- 溢价折价率
    ,tempsaveflag varchar2(15) -- 暂存标识
    ,begindate varchar2(15) -- 起始日期
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
grant select on ${iol_schema}.abss_abs_product_tranche to ${iml_schema};
grant select on ${iol_schema}.abss_abs_product_tranche to ${icl_schema};
grant select on ${iol_schema}.abss_abs_product_tranche to ${idl_schema};
grant select on ${iol_schema}.abss_abs_product_tranche to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_product_tranche is '产品分档信息表';
comment on column ${iol_schema}.abss_abs_product_tranche.trancheid is '分档编号';
comment on column ${iol_schema}.abss_abs_product_tranche.productid is '产品编号';
comment on column ${iol_schema}.abss_abs_product_tranche.tranchetype is '分档类型';
comment on column ${iol_schema}.abss_abs_product_tranche.tranchename is '分档名称';
comment on column ${iol_schema}.abss_abs_product_tranche.currency is '币种';
comment on column ${iol_schema}.abss_abs_product_tranche.trancheamountratio is '分档金额占比';
comment on column ${iol_schema}.abss_abs_product_tranche.trancheamount is '分档金额';
comment on column ${iol_schema}.abss_abs_product_tranche.selfholdratio is '自持比例';
comment on column ${iol_schema}.abss_abs_product_tranche.maturity is '法定到期日';
comment on column ${iol_schema}.abss_abs_product_tranche.ratinglevel1 is '评级级别1';
comment on column ${iol_schema}.abss_abs_product_tranche.ratingagency1 is '评级机构1';
comment on column ${iol_schema}.abss_abs_product_tranche.ratinglevel2 is '评级级别2';
comment on column ${iol_schema}.abss_abs_product_tranche.ratingagency2 is '评级机构2';
comment on column ${iol_schema}.abss_abs_product_tranche.remark is '备注';
comment on column ${iol_schema}.abss_abs_product_tranche.exchangeservicefee is '兑换服务费';
comment on column ${iol_schema}.abss_abs_product_tranche.premiumdiscountrate is '溢价折价率';
comment on column ${iol_schema}.abss_abs_product_tranche.tempsaveflag is '暂存标识';
comment on column ${iol_schema}.abss_abs_product_tranche.begindate is '起始日期';
comment on column ${iol_schema}.abss_abs_product_tranche.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_product_tranche.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_product_tranche.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_product_tranche.etl_timestamp is 'ETL处理时间戳';
