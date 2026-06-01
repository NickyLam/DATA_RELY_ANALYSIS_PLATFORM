/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_import_item_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_import_item_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_import_item_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_import_item_info(
    branch varchar2(12) -- 机构编号
    ,remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,import_item_status varchar2(1) -- 贵重物品状态
    ,item_id varchar2(50) -- 物品编号
    ,item_subtype varchar2(10) -- 重要物品子类型
    ,item_type varchar2(10) -- 重要物品类型
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,belong_user_id varchar2(8) -- 所属柜员
    ,end_user_id varchar2(8) -- 最后操作柜员
    ,last_user_id varchar2(8) -- 上一柜员id
    ,register_date date -- 登记日期
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
grant select on ${iol_schema}.ncbs_tb_import_item_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_import_item_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_import_item_info is '重要物品登记信息表';
comment on column ${iol_schema}.ncbs_tb_import_item_info.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_import_item_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_import_item_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_import_item_info.import_item_status is '贵重物品状态';
comment on column ${iol_schema}.ncbs_tb_import_item_info.item_id is '物品编号';
comment on column ${iol_schema}.ncbs_tb_import_item_info.item_subtype is '重要物品子类型';
comment on column ${iol_schema}.ncbs_tb_import_item_info.item_type is '重要物品类型';
comment on column ${iol_schema}.ncbs_tb_import_item_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_import_item_info.belong_user_id is '所属柜员';
comment on column ${iol_schema}.ncbs_tb_import_item_info.end_user_id is '最后操作柜员';
comment on column ${iol_schema}.ncbs_tb_import_item_info.last_user_id is '上一柜员id';
comment on column ${iol_schema}.ncbs_tb_import_item_info.register_date is '登记日期';
comment on column ${iol_schema}.ncbs_tb_import_item_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_import_item_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_import_item_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_import_item_info.etl_timestamp is 'ETL处理时间戳';
