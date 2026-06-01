/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_dic_param
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_dic_param
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_dic_param purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_dic_param(
    pk_dic_param number(20,0) -- 流水号
    ,param_code varchar2(150) -- 参数编码
    ,param_name varchar2(384) -- 参数名称
    ,param_desc varchar2(4000) -- 描述
    ,param_order number(9,0) -- 显示顺序
    ,parent_code varchar2(150) -- 父code
    ,field1 varchar2(600) -- 保留字段
    ,crt_time varchar2(42) -- 创建时间
    ,upd_time varchar2(42) -- 最后修改时间
    ,obj_version number(9,0) -- 版本号
    ,flag_enable varchar2(3) -- 是否有效
    ,usage_key varchar2(12) -- 部门标识
    ,param_desc2 varchar2(300) -- 参数描述2
    ,param_desc3 varchar2(600) -- 参数描述3
    ,param_system varchar2(12) -- 归属系统
    ,create_time varchar2(60) -- 创建日期
    ,update_time varchar2(60) -- 更新日期
    ,del_flag varchar2(3) -- 逻辑删除标志
    ,created_by varchar2(60) -- 创建人
    ,updated_by varchar2(60) -- 更新人
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
grant select on ${iol_schema}.pbms_tbl_dic_param to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_dic_param to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_dic_param to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_dic_param to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_dic_param is '数据字典表';
comment on column ${iol_schema}.pbms_tbl_dic_param.pk_dic_param is '流水号';
comment on column ${iol_schema}.pbms_tbl_dic_param.param_code is '参数编码';
comment on column ${iol_schema}.pbms_tbl_dic_param.param_name is '参数名称';
comment on column ${iol_schema}.pbms_tbl_dic_param.param_desc is '描述';
comment on column ${iol_schema}.pbms_tbl_dic_param.param_order is '显示顺序';
comment on column ${iol_schema}.pbms_tbl_dic_param.parent_code is '父code';
comment on column ${iol_schema}.pbms_tbl_dic_param.field1 is '保留字段';
comment on column ${iol_schema}.pbms_tbl_dic_param.crt_time is '创建时间';
comment on column ${iol_schema}.pbms_tbl_dic_param.upd_time is '最后修改时间';
comment on column ${iol_schema}.pbms_tbl_dic_param.obj_version is '版本号';
comment on column ${iol_schema}.pbms_tbl_dic_param.flag_enable is '是否有效';
comment on column ${iol_schema}.pbms_tbl_dic_param.usage_key is '部门标识';
comment on column ${iol_schema}.pbms_tbl_dic_param.param_desc2 is '参数描述2';
comment on column ${iol_schema}.pbms_tbl_dic_param.param_desc3 is '参数描述3';
comment on column ${iol_schema}.pbms_tbl_dic_param.param_system is '归属系统';
comment on column ${iol_schema}.pbms_tbl_dic_param.create_time is '创建日期';
comment on column ${iol_schema}.pbms_tbl_dic_param.update_time is '更新日期';
comment on column ${iol_schema}.pbms_tbl_dic_param.del_flag is '逻辑删除标志';
comment on column ${iol_schema}.pbms_tbl_dic_param.created_by is '创建人';
comment on column ${iol_schema}.pbms_tbl_dic_param.updated_by is '更新人';
comment on column ${iol_schema}.pbms_tbl_dic_param.start_dt is '开始时间';
comment on column ${iol_schema}.pbms_tbl_dic_param.end_dt is '结束时间';
comment on column ${iol_schema}.pbms_tbl_dic_param.id_mark is '增删标志';
comment on column ${iol_schema}.pbms_tbl_dic_param.etl_timestamp is 'ETL处理时间戳';
