/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_tax_item_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_tax_item_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.fin_tax_item_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_tax_item_info_h(
    tax_item_id varchar2(100) -- 税目编号
    ,lp_id varchar2(60) -- 法人编号
    ,tax_item_name varchar2(500) -- 税目名称
    ,tax_rat number(30,8) -- 税率
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,tax_item_status_cd varchar(30) -- 税目状态代码
    ,remark varchar2(500) -- 备注
    ,dedu_idf_cd varchar(30) -- 可抵扣标识代码
    ,taxable_idf_cd varchar(30) -- 应税标识代码
    ,tax_way_cd varchar(30) -- 计税方式代码
    ,open_invoice_type_cd varchar(30) -- 开票类型代码
    ,item_type_cd varchar(30) -- 进销项类型代码
    ,tax_cls_id varchar2(100) -- 税收分类编号
    ,free_tax_id varchar2(100) -- 免税编号
    ,merchd_serv_name varchar2(500) -- 商品服务名称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)

partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;
-- grant
grant select on ${iml_schema}.fin_tax_item_info_h to ${icl_schema};
grant select on ${iml_schema}.fin_tax_item_info_h to ${idl_schema};
grant select on ${iml_schema}.fin_tax_item_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_tax_item_info_h is '税目信息历史';
comment on column ${iml_schema}.fin_tax_item_info_h.tax_item_id is '税目编号';
comment on column ${iml_schema}.fin_tax_item_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.fin_tax_item_info_h.tax_item_name is '税目名称';
comment on column ${iml_schema}.fin_tax_item_info_h.tax_rat is '税率';
comment on column ${iml_schema}.fin_tax_item_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.fin_tax_item_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.fin_tax_item_info_h.tax_item_status_cd is '税目状态代码';
comment on column ${iml_schema}.fin_tax_item_info_h.remark is '备注';
comment on column ${iml_schema}.fin_tax_item_info_h.dedu_idf_cd is '可抵扣标识代码';
comment on column ${iml_schema}.fin_tax_item_info_h.taxable_idf_cd is '应税标识代码';
comment on column ${iml_schema}.fin_tax_item_info_h.tax_way_cd is '计税方式代码';
comment on column ${iml_schema}.fin_tax_item_info_h.open_invoice_type_cd is '开票类型代码';
comment on column ${iml_schema}.fin_tax_item_info_h.item_type_cd is '进销项类型代码';
comment on column ${iml_schema}.fin_tax_item_info_h.tax_cls_id is '税收分类编号';
comment on column ${iml_schema}.fin_tax_item_info_h.free_tax_id is '免税编号';
comment on column ${iml_schema}.fin_tax_item_info_h.merchd_serv_name is '商品服务名称';
comment on column ${iml_schema}.fin_tax_item_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.fin_tax_item_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.fin_tax_item_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.fin_tax_item_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_tax_item_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.fin_tax_item_info_h.etl_timestamp is 'ETL处理时间戳';
