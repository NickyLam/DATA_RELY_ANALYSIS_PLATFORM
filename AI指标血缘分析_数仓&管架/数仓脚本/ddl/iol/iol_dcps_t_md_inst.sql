/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol dcps_t_md_inst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.dcps_t_md_inst
whenever sqlerror continue none;
drop table ${iol_schema}.dcps_t_md_inst purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dcps_t_md_inst(
    inst_id varchar2(50) -- 实例ID
    ,inst_code varchar2(500) -- 实例代码
    ,inst_name varchar2(4000) -- 实例名称
    ,class_id varchar2(255) -- 类代码
    ,parent_id varchar2(50) -- 父实例ID
    ,namespace_id varchar2(500) -- 路径ID
    ,namespace_code varchar2(1000) -- 路径CODE
    ,ver_id varchar2(32) -- 当前版本ID
    ,start_time date -- 开始时间
    ,isroot varchar2(4) -- 是否根节点
    ,app_type varchar2(255) -- 元数据：MD数据标准：DS
    ,status varchar2(32) -- 状态：01-已发布02-已废止
    ,page_view number(22) -- 用户访问量
    ,creater varchar2(36) -- 创建者
    ,corp_id varchar2(32) -- 多法人
    ,rsv_str_1 varchar2(4000) -- 字符1-保留字段
    ,rsv_str_2 varchar2(4000) -- 字符2-保留字段
    ,rsv_str_3 varchar2(4000) -- 字符3-保留字段
    ,rsv_str_4 varchar2(4000) -- 字符4-保留字段
    ,rsv_str_5 varchar2(4000) -- 字符5-保留字段
    ,rsv_str_6 varchar2(4000) -- 字符6-保留字段
    ,rsv_str_7 varchar2(4000) -- 字符7-保留字段
    ,rsv_str_8 varchar2(4000) -- 字符8-保留字段
    ,rsv_str_9 varchar2(4000) -- 字符9-保留字段
    ,rsv_str_10 varchar2(4000) -- 字符10-保留字段
    ,rsv_str_11 varchar2(4000) -- 字符11-保留字段
    ,rsv_str_12 varchar2(4000) -- 字符12-保留字段
    ,rsv_str_13 varchar2(4000) -- 字符13-保留字段
    ,rsv_str_14 varchar2(4000) -- 字符14-保留字段
    ,rsv_str_15 varchar2(4000) -- 字符15-保留字段
    ,rsv_str_16 varchar2(4000) -- 字符16-保留字段
    ,rsv_str_17 varchar2(4000) -- 字符17-保留字段
    ,rsv_str_18 varchar2(4000) -- 字符18-保留字段
    ,rsv_str_19 varchar2(4000) -- 字符19-保留字段
    ,rsv_str_20 varchar2(4000) -- 字符20-保留字段
    ,rsv_str_21 varchar2(4000) -- 字符21-保留字段
    ,rsv_str_22 varchar2(4000) -- 字符22-保留字段
    ,rsv_str_23 varchar2(4000) -- 字符23-保留字段
    ,rsv_str_24 varchar2(4000) -- 字符24-保留字段
    ,rsv_str_25 varchar2(4000) -- 字符25-保留字段
    ,rsv_str_26 varchar2(4000) -- 字符26-保留字段
    ,rsv_str_27 varchar2(4000) -- 字符27-保留字段
    ,rsv_str_28 varchar2(4000) -- 字符28-保留字段
    ,rsv_str_29 varchar2(4000) -- 字符29-保留字段
    ,rsv_str_30 varchar2(4000) -- 字符30-保留字段
    ,rsv_str_31 varchar2(4000) -- 字符31-保留字段
    ,rsv_str_32 varchar2(4000) -- 字符32-保留字段
    ,rsv_str_33 varchar2(4000) -- 字符33-保留字段
    ,rsv_str_34 varchar2(4000) -- 字符34-保留字段
    ,rsv_str_35 varchar2(4000) -- 字符35-保留字段
    ,rsv_str_36 varchar2(4000) -- 字符36-保留字段
    ,rsv_str_37 varchar2(4000) -- 字符37-保留字段
    ,rsv_str_38 varchar2(4000) -- 字符38-保留字段
    ,rsv_str_39 varchar2(4000) -- 字符39-保留字段
    ,rsv_str_40 varchar2(4000) -- 字符40-保留字段
    ,version_date date -- 版本日期
    ,lucnec_falgdate date -- 索引扫描日期
    ,db_name varchar2(255) -- 
    ,db_code varchar2(255) -- 
    ,sys_name varchar2(255) -- 
    ,sys_code varchar2(255) -- 
    ,sch_name varchar2(255) -- 
    ,sch_code varchar2(255) -- 
    ,tab_name varchar2(1000) -- 
    ,tab_code varchar2(255) -- 
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
grant select on ${iol_schema}.dcps_t_md_inst to ${iml_schema};
grant select on ${iol_schema}.dcps_t_md_inst to ${icl_schema};
grant select on ${iol_schema}.dcps_t_md_inst to ${idl_schema};
grant select on ${iol_schema}.dcps_t_md_inst to ${iel_schema};

-- comment
comment on table ${iol_schema}.dcps_t_md_inst is '元数据表';
comment on column ${iol_schema}.dcps_t_md_inst.inst_id is '实例ID';
comment on column ${iol_schema}.dcps_t_md_inst.inst_code is '实例代码';
comment on column ${iol_schema}.dcps_t_md_inst.inst_name is '实例名称';
comment on column ${iol_schema}.dcps_t_md_inst.class_id is '类代码';
comment on column ${iol_schema}.dcps_t_md_inst.parent_id is '父实例ID';
comment on column ${iol_schema}.dcps_t_md_inst.namespace_id is '路径ID';
comment on column ${iol_schema}.dcps_t_md_inst.namespace_code is '路径CODE';
comment on column ${iol_schema}.dcps_t_md_inst.ver_id is '当前版本ID';
comment on column ${iol_schema}.dcps_t_md_inst.start_time is '开始时间';
comment on column ${iol_schema}.dcps_t_md_inst.isroot is '是否根节点';
comment on column ${iol_schema}.dcps_t_md_inst.app_type is '元数据：MD数据标准：DS';
comment on column ${iol_schema}.dcps_t_md_inst.status is '状态：01-已发布02-已废止';
comment on column ${iol_schema}.dcps_t_md_inst.page_view is '用户访问量';
comment on column ${iol_schema}.dcps_t_md_inst.creater is '创建者';
comment on column ${iol_schema}.dcps_t_md_inst.corp_id is '多法人';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_1 is '字符1-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_2 is '字符2-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_3 is '字符3-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_4 is '字符4-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_5 is '字符5-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_6 is '字符6-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_7 is '字符7-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_8 is '字符8-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_9 is '字符9-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_10 is '字符10-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_11 is '字符11-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_12 is '字符12-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_13 is '字符13-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_14 is '字符14-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_15 is '字符15-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_16 is '字符16-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_17 is '字符17-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_18 is '字符18-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_19 is '字符19-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_20 is '字符20-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_21 is '字符21-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_22 is '字符22-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_23 is '字符23-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_24 is '字符24-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_25 is '字符25-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_26 is '字符26-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_27 is '字符27-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_28 is '字符28-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_29 is '字符29-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_30 is '字符30-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_31 is '字符31-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_32 is '字符32-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_33 is '字符33-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_34 is '字符34-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_35 is '字符35-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_36 is '字符36-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_37 is '字符37-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_38 is '字符38-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_39 is '字符39-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.rsv_str_40 is '字符40-保留字段';
comment on column ${iol_schema}.dcps_t_md_inst.version_date is '版本日期';
comment on column ${iol_schema}.dcps_t_md_inst.lucnec_falgdate is '索引扫描日期';
comment on column ${iol_schema}.dcps_t_md_inst.db_name is '';
comment on column ${iol_schema}.dcps_t_md_inst.db_code is '';
comment on column ${iol_schema}.dcps_t_md_inst.sys_name is '';
comment on column ${iol_schema}.dcps_t_md_inst.sys_code is '';
comment on column ${iol_schema}.dcps_t_md_inst.sch_name is '';
comment on column ${iol_schema}.dcps_t_md_inst.sch_code is '';
comment on column ${iol_schema}.dcps_t_md_inst.tab_name is '';
comment on column ${iol_schema}.dcps_t_md_inst.tab_code is '';
comment on column ${iol_schema}.dcps_t_md_inst.start_dt is '开始时间';
comment on column ${iol_schema}.dcps_t_md_inst.end_dt is '结束时间';
comment on column ${iol_schema}.dcps_t_md_inst.id_mark is '增删标志';
comment on column ${iol_schema}.dcps_t_md_inst.etl_timestamp is 'ETL处理时间戳';
