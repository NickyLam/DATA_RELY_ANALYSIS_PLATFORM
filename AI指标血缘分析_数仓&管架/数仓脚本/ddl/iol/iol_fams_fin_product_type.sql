/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_product_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_product_type
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_product_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_type(
    finprod_id varchar2(50) -- 金融产品代码
    ,branch number(10) -- 分支序号
    ,type_1 varchar2(50) -- 分类1
    ,type_2 varchar2(50) -- 分类2
    ,type_3 varchar2(50) -- 分类3
    ,type_4 varchar2(50) -- 分类4
    ,type_5 varchar2(50) -- 分类5
    ,type_6 varchar2(50) -- 投管一级类型
    ,type_7 varchar2(50) -- 投管二级类型
    ,type_8 varchar2(50) -- 分类8（投管资产大类）
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,type_9 varchar2(50) -- 行内二级类型
    ,type_10 varchar2(50) -- 行内三级类型
    ,type_11 varchar2(50) -- 行内四级类型
    ,type_12 varchar2(50) -- 行内五级类型
    ,type_13 varchar2(50) -- 风险资产分类1
    ,type_14 varchar2(50) -- 风险资产分类2
    ,type_15 varchar2(50) -- 风险资产分类3
    ,type_16 varchar2(50) -- 风险资产分类4
    ,type_17 varchar2(50) -- 风险资产分类5
    ,std_prod_id varchar2(12) -- 行内标准产品编号
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
grant select on ${iol_schema}.fams_fin_product_type to ${iml_schema};
grant select on ${iol_schema}.fams_fin_product_type to ${icl_schema};
grant select on ${iol_schema}.fams_fin_product_type to ${idl_schema};
grant select on ${iol_schema}.fams_fin_product_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_product_type is '金融产品分类表';
comment on column ${iol_schema}.fams_fin_product_type.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_product_type.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_product_type.type_1 is '分类1';
comment on column ${iol_schema}.fams_fin_product_type.type_2 is '分类2';
comment on column ${iol_schema}.fams_fin_product_type.type_3 is '分类3';
comment on column ${iol_schema}.fams_fin_product_type.type_4 is '分类4';
comment on column ${iol_schema}.fams_fin_product_type.type_5 is '分类5';
comment on column ${iol_schema}.fams_fin_product_type.type_6 is '投管一级类型';
comment on column ${iol_schema}.fams_fin_product_type.type_7 is '投管二级类型';
comment on column ${iol_schema}.fams_fin_product_type.type_8 is '分类8（投管资产大类）';
comment on column ${iol_schema}.fams_fin_product_type.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_product_type.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_product_type.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_product_type.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_product_type.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_product_type.type_9 is '行内二级类型';
comment on column ${iol_schema}.fams_fin_product_type.type_10 is '行内三级类型';
comment on column ${iol_schema}.fams_fin_product_type.type_11 is '行内四级类型';
comment on column ${iol_schema}.fams_fin_product_type.type_12 is '行内五级类型';
comment on column ${iol_schema}.fams_fin_product_type.type_13 is '风险资产分类1';
comment on column ${iol_schema}.fams_fin_product_type.type_14 is '风险资产分类2';
comment on column ${iol_schema}.fams_fin_product_type.type_15 is '风险资产分类3';
comment on column ${iol_schema}.fams_fin_product_type.type_16 is '风险资产分类4';
comment on column ${iol_schema}.fams_fin_product_type.type_17 is '风险资产分类5';
comment on column ${iol_schema}.fams_fin_product_type.std_prod_id is '行内标准产品编号';
comment on column ${iol_schema}.fams_fin_product_type.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_product_type.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_product_type.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_product_type.etl_timestamp is 'ETL处理时间戳';
