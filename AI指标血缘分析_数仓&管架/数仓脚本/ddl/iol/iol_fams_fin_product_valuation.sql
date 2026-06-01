/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_product_valuation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_product_valuation
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_product_valuation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_valuation(
    finprod_id varchar2(50) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,val_date date -- 估值日期
    ,publish_date date -- 公布日期
    ,valuation number(30,14) -- 每日估值，净值、万份收益等
    ,day7_year_yield number(30,14) -- 七日年化收益率
    ,year_yield number(30,14) -- 年化收益率
    ,total_value number(30,14) -- 累计净值
    ,input_type varchar2(50) -- 录入方式，手工维护、接口导入
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,rest_net_value number(30,14) -- 复权单位净值
    ,f_price_valuation number(30,14) -- 全价估值
    ,c_shares number(26,4) -- 基金总份额
    ,full_valuation varchar2(500) -- 全价估值
    ,value_source varchar2(50) -- 估值来源
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
grant select on ${iol_schema}.fams_fin_product_valuation to ${iml_schema};
grant select on ${iol_schema}.fams_fin_product_valuation to ${icl_schema};
grant select on ${iol_schema}.fams_fin_product_valuation to ${idl_schema};
grant select on ${iol_schema}.fams_fin_product_valuation to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_product_valuation is '场外金融产品估值';
comment on column ${iol_schema}.fams_fin_product_valuation.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_product_valuation.finprod_type is '金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_product_valuation.finprod_type2 is '金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_product_valuation.val_date is '估值日期';
comment on column ${iol_schema}.fams_fin_product_valuation.publish_date is '公布日期';
comment on column ${iol_schema}.fams_fin_product_valuation.valuation is '每日估值，净值、万份收益等';
comment on column ${iol_schema}.fams_fin_product_valuation.day7_year_yield is '七日年化收益率';
comment on column ${iol_schema}.fams_fin_product_valuation.year_yield is '年化收益率';
comment on column ${iol_schema}.fams_fin_product_valuation.total_value is '累计净值';
comment on column ${iol_schema}.fams_fin_product_valuation.input_type is '录入方式，手工维护、接口导入';
comment on column ${iol_schema}.fams_fin_product_valuation.remark is '备注';
comment on column ${iol_schema}.fams_fin_product_valuation.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_product_valuation.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_product_valuation.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_product_valuation.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_product_valuation.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_product_valuation.rest_net_value is '复权单位净值';
comment on column ${iol_schema}.fams_fin_product_valuation.f_price_valuation is '全价估值';
comment on column ${iol_schema}.fams_fin_product_valuation.c_shares is '基金总份额';
comment on column ${iol_schema}.fams_fin_product_valuation.full_valuation is '全价估值';
comment on column ${iol_schema}.fams_fin_product_valuation.value_source is '估值来源';
comment on column ${iol_schema}.fams_fin_product_valuation.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_product_valuation.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_product_valuation.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_product_valuation.etl_timestamp is 'ETL处理时间戳';
