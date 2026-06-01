/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_import_item_subtype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_import_item_subtype
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_import_item_subtype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_import_item_subtype(
    branch varchar2(12) -- 机构编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,import_item_status varchar2(1) -- 贵重物品状态
    ,item_subtype varchar2(10) -- 重要物品子类型
    ,item_subtype_desc varchar2(50) -- 物品子类型描述
    ,item_type varchar2(10) -- 重要物品类型
    ,item_type_desc varchar2(50) -- 物品类型描述
    ,last_item_type varchar2(3) -- 上次修改物品类型
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
grant select on ${iol_schema}.ncbs_tb_import_item_subtype to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_subtype to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_subtype to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_subtype to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_import_item_subtype is '物品子类型信息表';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.company is '法人';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.import_item_status is '贵重物品状态';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.item_subtype is '重要物品子类型';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.item_subtype_desc is '物品子类型描述';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.item_type is '重要物品类型';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.item_type_desc is '物品类型描述';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.last_item_type is '上次修改物品类型';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.add_date is '新增日期';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.update_branch_id is '修改机构';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.update_user_id is '修改柜员';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_import_item_subtype.etl_timestamp is 'ETL处理时间戳';
