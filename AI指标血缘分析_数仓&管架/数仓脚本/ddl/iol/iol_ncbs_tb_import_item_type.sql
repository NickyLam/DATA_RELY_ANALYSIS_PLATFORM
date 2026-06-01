/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_import_item_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_import_item_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_import_item_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_import_item_type(
    branch varchar2(12) -- 机构编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,import_item_status varchar2(1) -- 贵重物品状态
    ,item_type varchar2(10) -- 重要物品类型
    ,item_type_desc varchar2(50) -- 物品类型描述
    ,add_date date -- 新增日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
    ,update_branch_id varchar2(12) -- 修改机构
    ,update_user_id varchar2(8) -- 修改柜员
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
grant select on ${iol_schema}.ncbs_tb_import_item_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_import_item_type is '物品类型信息表';
comment on column ${iol_schema}.ncbs_tb_import_item_type.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_import_item_type.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_import_item_type.company is '法人';
comment on column ${iol_schema}.ncbs_tb_import_item_type.import_item_status is '贵重物品状态';
comment on column ${iol_schema}.ncbs_tb_import_item_type.item_type is '重要物品类型';
comment on column ${iol_schema}.ncbs_tb_import_item_type.item_type_desc is '物品类型描述';
comment on column ${iol_schema}.ncbs_tb_import_item_type.add_date is '新增日期';
comment on column ${iol_schema}.ncbs_tb_import_item_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_import_item_type.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_tb_import_item_type.update_branch_id is '修改机构';
comment on column ${iol_schema}.ncbs_tb_import_item_type.update_user_id is '修改柜员';
comment on column ${iol_schema}.ncbs_tb_import_item_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_import_item_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_import_item_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_import_item_type.etl_timestamp is 'ETL处理时间戳';
