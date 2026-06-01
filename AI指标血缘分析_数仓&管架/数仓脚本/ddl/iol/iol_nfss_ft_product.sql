/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ft_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ft_product
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ft_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_product(
    product_id varchar2(75) -- 主键序号
    ,product_name varchar2(150) -- 产品名称
    ,product_code varchar2(48) -- 产品代码
    ,risk_grade varchar2(5) -- 风险等级 r1:r1低风险  r2:r2中低风险 r3:r3中风险 r4:r4中高风险 r5:r5高风险
    ,performance_status number(20,2) -- 业绩比较基准
    ,establishment_date varchar2(36) -- 成立日
    ,termination_date varchar2(36) -- 终止日
    ,product_status varchar2(5) -- 产品状态 0募集，1成立，2终止
    ,purchase_amount number(20,2) -- 起购金额
    ,commencement_date varchar2(36) -- 募集开始日
    ,closing_date varchar2(36) -- 募集结束日
    ,init_amount number(20,2) -- 初始创立金额
    ,current_net_worth number(20,8) -- 当前净值
    ,current_market_value number(20,8) -- 当前市值
    ,trustcompany_code varchar2(48) -- 信托公司代码
    ,trustcompany_name varchar2(150) -- 信托公司名称
    ,product_sorted varchar2(21) -- 排序字段
    ,created_by varchar2(150) -- 创建者
    ,updated_by varchar2(150) -- 修改者
    ,create_time date -- 创建时间
    ,update_time date -- 修改时间
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
grant select on ${iol_schema}.nfss_ft_product to ${iml_schema};
grant select on ${iol_schema}.nfss_ft_product to ${icl_schema};
grant select on ${iol_schema}.nfss_ft_product to ${idl_schema};
grant select on ${iol_schema}.nfss_ft_product to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ft_product is '产品表';
comment on column ${iol_schema}.nfss_ft_product.product_id is '主键序号';
comment on column ${iol_schema}.nfss_ft_product.product_name is '产品名称';
comment on column ${iol_schema}.nfss_ft_product.product_code is '产品代码';
comment on column ${iol_schema}.nfss_ft_product.risk_grade is '风险等级 r1:r1低风险  r2:r2中低风险 r3:r3中风险 r4:r4中高风险 r5:r5高风险';
comment on column ${iol_schema}.nfss_ft_product.performance_status is '业绩比较基准';
comment on column ${iol_schema}.nfss_ft_product.establishment_date is '成立日';
comment on column ${iol_schema}.nfss_ft_product.termination_date is '终止日';
comment on column ${iol_schema}.nfss_ft_product.product_status is '产品状态 0募集，1成立，2终止';
comment on column ${iol_schema}.nfss_ft_product.purchase_amount is '起购金额';
comment on column ${iol_schema}.nfss_ft_product.commencement_date is '募集开始日';
comment on column ${iol_schema}.nfss_ft_product.closing_date is '募集结束日';
comment on column ${iol_schema}.nfss_ft_product.init_amount is '初始创立金额';
comment on column ${iol_schema}.nfss_ft_product.current_net_worth is '当前净值';
comment on column ${iol_schema}.nfss_ft_product.current_market_value is '当前市值';
comment on column ${iol_schema}.nfss_ft_product.trustcompany_code is '信托公司代码';
comment on column ${iol_schema}.nfss_ft_product.trustcompany_name is '信托公司名称';
comment on column ${iol_schema}.nfss_ft_product.product_sorted is '排序字段';
comment on column ${iol_schema}.nfss_ft_product.created_by is '创建者';
comment on column ${iol_schema}.nfss_ft_product.updated_by is '修改者';
comment on column ${iol_schema}.nfss_ft_product.create_time is '创建时间';
comment on column ${iol_schema}.nfss_ft_product.update_time is '修改时间';
comment on column ${iol_schema}.nfss_ft_product.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_ft_product.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_ft_product.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_ft_product.etl_timestamp is 'ETL处理时间戳';
