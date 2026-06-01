/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_fls_insurance_product_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_fls_insurance_product_detail
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_fls_insurance_product_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_fls_insurance_product_detail(
    fip_prdct_code varchar2(100) -- 产品编码
    ,fip_prdct_name varchar2(100) -- 产品名称
    ,fip_prdct_pic1 varchar2(100) -- 网银图片路径
    ,fip_prdct_pic2 varchar2(100) -- 手机银行图片路径
    ,fip_prdct_brief varchar2(4000) -- 产品简介
    ,fip_prdct_age varchar2(100) -- 投保年龄
    ,fip_risk_level varchar2(50) -- 风险等级
    ,fip_prdct_feature varchar2(4000) -- 产品特色
    ,fip_prdct_illustration varchar2(20) -- 产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D
    ,fip_special_notice varchar2(4000) -- 特别告知
    ,fip_exemp_clause varchar2(4000) -- 免责条款
    ,fip_customer_notify varchar2(4000) -- 客户告知
    ,fip_buy_tip varchar2(4000) -- 购买提示
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
grant select on ${iol_schema}.osbs_fls_insurance_product_detail to ${iml_schema};
grant select on ${iol_schema}.osbs_fls_insurance_product_detail to ${icl_schema};
grant select on ${iol_schema}.osbs_fls_insurance_product_detail to ${idl_schema};
grant select on ${iol_schema}.osbs_fls_insurance_product_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_fls_insurance_product_detail is '银保通参数维护表';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_code is '产品编码';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_name is '产品名称';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_pic1 is '网银图片路径';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_pic2 is '手机银行图片路径';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_brief is '产品简介';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_age is '投保年龄';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_risk_level is '风险等级';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_feature is '产品特色';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_prdct_illustration is '产品协议，多个用逗号隔开《产品说明书》：A、《保险产品条款》:B、《投保提示书》:C、《投保声明协议》:D';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_special_notice is '特别告知';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_exemp_clause is '免责条款';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_customer_notify is '客户告知';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.fip_buy_tip is '购买提示';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_fls_insurance_product_detail.etl_timestamp is 'ETL处理时间戳';
