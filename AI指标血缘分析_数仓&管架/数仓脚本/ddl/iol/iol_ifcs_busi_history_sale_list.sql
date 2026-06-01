/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_busi_history_sale_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_busi_history_sale_list
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_busi_history_sale_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_busi_history_sale_list(
    bhsl_id varchar2(90) -- 主键id
    ,bhsl_industry_id varchar2(90) -- 关联产业信息id
    ,bhsl_transdate varchar2(21) -- 数据日期
    ,bhsl_filename varchar2(113) -- 文件名
    ,bhsl_company varchar2(450) -- 公司
    ,bhsl_userareatype varchar2(75) -- 客户区域分类
    ,bhsl_username varchar2(113) -- 客户名称
    ,bhsl_certtype varchar2(23) -- 客户证件类型
    ,bhsl_certnum varchar2(45) -- 客户证件号码
    ,bhsl_department varchar2(113) -- 部门名称
    ,bhsl_dist_code varchar2(300) -- 区域
    ,bhsl_province varchar2(300) -- 省
    ,bhsl_city varchar2(45) -- 市
    ,bhsl_area varchar2(45) -- 区
    ,bhsl_address varchar2(450) -- 详细地址
    ,bhsl_salesman varchar2(113) -- 业务员名称
    ,bhsl_is17 varchar2(23) -- is17
    ,bhsl_date varchar2(45) -- 单据日期
    ,bhsl_stockcode varchar2(68) -- 存货编码
    ,bhsl_productname varchar2(225) -- 产品名称
    ,bhsl_stocktype varchar2(135) -- 存货分类
    ,bhsl_materialtype varchar2(135) -- 物料大类
    ,bhsl_brand varchar2(135) -- 品牌
    ,bhsl_particlesize varchar2(113) -- 粒径
    ,bhsl_specifications varchar2(113) -- 规格
    ,bhsl_tonnage varchar2(113) -- 吨数
    ,bhsl_packagenumber varchar2(113) -- 包数
    ,bhsl_unitprice varchar2(45) -- 单价
    ,bhsl_salesvolume varchar2(45) -- 销售额
    ,bhsl_delete_flag varchar2(3) -- 删除表示0-正常；1-已删除
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
grant select on ${iol_schema}.ifcs_busi_history_sale_list to ${iml_schema};
grant select on ${iol_schema}.ifcs_busi_history_sale_list to ${icl_schema};
grant select on ${iol_schema}.ifcs_busi_history_sale_list to ${idl_schema};
grant select on ${iol_schema}.ifcs_busi_history_sale_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_busi_history_sale_list is '恒兴erp信息表';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_id is '主键id';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_industry_id is '关联产业信息id';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_transdate is '数据日期';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_filename is '文件名';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_company is '公司';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_userareatype is '客户区域分类';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_username is '客户名称';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_certtype is '客户证件类型';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_certnum is '客户证件号码';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_department is '部门名称';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_dist_code is '区域';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_province is '省';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_city is '市';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_area is '区';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_address is '详细地址';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_salesman is '业务员名称';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_is17 is 'is17';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_date is '单据日期';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_stockcode is '存货编码';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_productname is '产品名称';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_stocktype is '存货分类';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_materialtype is '物料大类';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_brand is '品牌';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_particlesize is '粒径';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_specifications is '规格';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_tonnage is '吨数';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_packagenumber is '包数';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_unitprice is '单价';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_salesvolume is '销售额';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.bhsl_delete_flag is '删除表示0-正常；1-已删除';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.start_dt is '开始时间';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.end_dt is '结束时间';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.id_mark is '增删标志';
comment on column ${iol_schema}.ifcs_busi_history_sale_list.etl_timestamp is 'ETL处理时间戳';
