/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ca_product_additional_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ca_product_additional_info
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ca_product_additional_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ca_product_additional_info(
    id varchar2(75) -- 主键
    ,prod_id varchar2(75) -- 关联产品表id
    ,prd_cd varchar2(300) -- 产品代码
    ,prd_name varchar2(750) -- 产品名称
    ,prod_desc varchar2(4000) -- 产品说明
    ,invest_direction varchar2(75) -- 投资方向
    ,invt_range varchar2(4000) -- 投资范围
    ,inc_measr varchar2(4000) -- 增信措施
    ,purch_rule varchar2(4000) -- 购买规则
    ,income_rule varchar2(4000) -- 收益规则
    ,rede_rule varchar2(4000) -- 赎回规则
    ,liqdt_cash varchar2(4000) -- 清算兑付
    ,created_time date -- 创建时间
    ,created_by varchar2(75) -- 创建人
    ,updated_time date -- 更新时间
    ,updated_by varchar2(75) -- 更新人
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nfss_ca_product_additional_info to ${iml_schema};
grant select on ${iol_schema}.nfss_ca_product_additional_info to ${icl_schema};
grant select on ${iol_schema}.nfss_ca_product_additional_info to ${idl_schema};
grant select on ${iol_schema}.nfss_ca_product_additional_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ca_product_additional_info is '私募产品附加信息表';
comment on column ${iol_schema}.nfss_ca_product_additional_info.id is '主键';
comment on column ${iol_schema}.nfss_ca_product_additional_info.prod_id is '关联产品表id';
comment on column ${iol_schema}.nfss_ca_product_additional_info.prd_cd is '产品代码';
comment on column ${iol_schema}.nfss_ca_product_additional_info.prd_name is '产品名称';
comment on column ${iol_schema}.nfss_ca_product_additional_info.prod_desc is '产品说明';
comment on column ${iol_schema}.nfss_ca_product_additional_info.invest_direction is '投资方向';
comment on column ${iol_schema}.nfss_ca_product_additional_info.invt_range is '投资范围';
comment on column ${iol_schema}.nfss_ca_product_additional_info.inc_measr is '增信措施';
comment on column ${iol_schema}.nfss_ca_product_additional_info.purch_rule is '购买规则';
comment on column ${iol_schema}.nfss_ca_product_additional_info.income_rule is '收益规则';
comment on column ${iol_schema}.nfss_ca_product_additional_info.rede_rule is '赎回规则';
comment on column ${iol_schema}.nfss_ca_product_additional_info.liqdt_cash is '清算兑付';
comment on column ${iol_schema}.nfss_ca_product_additional_info.created_time is '创建时间';
comment on column ${iol_schema}.nfss_ca_product_additional_info.created_by is '创建人';
comment on column ${iol_schema}.nfss_ca_product_additional_info.updated_time is '更新时间';
comment on column ${iol_schema}.nfss_ca_product_additional_info.updated_by is '更新人';
comment on column ${iol_schema}.nfss_ca_product_additional_info.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_ca_product_additional_info.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_ca_product_additional_info.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_ca_product_additional_info.etl_timestamp is 'ETL处理时间戳';
