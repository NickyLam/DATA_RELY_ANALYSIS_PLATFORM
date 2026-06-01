/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_meta_deposit_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_meta_deposit_define
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_meta_deposit_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_meta_deposit_define(
    draft_type varchar2(15) -- 票据类型
    ,id varchar2(90) -- id
    ,product_name varchar2(300) -- bde系统产品名称
    ,product_no varchar2(15) -- bde系统产品号
    ,prod_class1 varchar2(3000) -- 一级分类编码
    ,prod_class2 varchar2(3000) -- 二级分类编码
    ,prod_class3 varchar2(3000) -- 三级分类编码
    ,prod_class4 varchar2(3000) -- 四级分类编码
    ,prod_code varchar2(750) -- 产品编号
    ,prod_name varchar2(4000) -- 产品名称
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
grant select on ${iol_schema}.bdms_meta_deposit_define to ${iml_schema};
grant select on ${iol_schema}.bdms_meta_deposit_define to ${icl_schema};
grant select on ${iol_schema}.bdms_meta_deposit_define to ${idl_schema};
grant select on ${iol_schema}.bdms_meta_deposit_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_meta_deposit_define is '标准产品表';
comment on column ${iol_schema}.bdms_meta_deposit_define.draft_type is '票据类型';
comment on column ${iol_schema}.bdms_meta_deposit_define.id is 'id';
comment on column ${iol_schema}.bdms_meta_deposit_define.product_name is 'bde系统产品名称';
comment on column ${iol_schema}.bdms_meta_deposit_define.product_no is 'bde系统产品号';
comment on column ${iol_schema}.bdms_meta_deposit_define.prod_class1 is '一级分类编码';
comment on column ${iol_schema}.bdms_meta_deposit_define.prod_class2 is '二级分类编码';
comment on column ${iol_schema}.bdms_meta_deposit_define.prod_class3 is '三级分类编码';
comment on column ${iol_schema}.bdms_meta_deposit_define.prod_class4 is '四级分类编码';
comment on column ${iol_schema}.bdms_meta_deposit_define.prod_code is '产品编号';
comment on column ${iol_schema}.bdms_meta_deposit_define.prod_name is '产品名称';
comment on column ${iol_schema}.bdms_meta_deposit_define.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_meta_deposit_define.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_meta_deposit_define.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_meta_deposit_define.etl_timestamp is 'ETL处理时间戳';
