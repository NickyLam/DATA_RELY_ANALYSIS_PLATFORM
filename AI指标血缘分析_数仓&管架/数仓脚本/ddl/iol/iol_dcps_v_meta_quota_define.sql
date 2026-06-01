/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol dcps_v_meta_quota_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.dcps_v_meta_quota_define
whenever sqlerror continue none;
drop table ${iol_schema}.dcps_v_meta_quota_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dcps_v_meta_quota_define(
    quota_id varchar2(50) -- 指标内部id
    ,quota_type varchar2(1000) -- 指标大类
    ,quota_class1 varchar2(1000) -- 指标一级分类
    ,quota_class2 varchar2(1000) -- 指标二级分类
    ,quota_class3 varchar2(1000) -- 指标三级分类
    ,quota_code varchar2(500) -- 指标编号
    ,quota_name varchar2(4000) -- 指标名称
    ,busmean varchar2(4000) -- 指标描述
    ,quotameasure varchar2(4000) -- 指标度量
    ,derivemeasure varchar2(4000) -- 指标衍生度量
    ,dataattr varchar2(4000) -- 数值属性
    ,dimension_num varchar2(4000) -- 指标维度
    ,common_units_of_measurement varchar2(4000) -- 度量单位
    ,countcycle varchar2(4000) -- 统计周期
    ,dataformat varchar2(4000) -- 数据格式
    ,protype varchar2(4000) -- 产生方式
    ,busncore varchar2(4000) -- 业务口径
    ,techcore varchar2(4000) -- 技术口径
    ,range varchar2(4000) -- 发布范围
    ,mainsys varchar2(4000) -- 主系统
    ,warn_value varchar2(4000) -- 预警值
    ,alarm_value varchar2(4000) -- 报警值
    ,owner varchar2(4000) -- 所有者
    ,userfillin varchar2(4000) -- 填写人
    ,effectivedate varchar2(4000) -- 生效日期
    ,expirydate varchar2(4000) -- 失效日期
    ,defenduser varchar2(4000) -- 维护人
    ,defenddate varchar2(4000) -- 维护日期
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
grant select on ${iol_schema}.dcps_v_meta_quota_define to ${iml_schema};
grant select on ${iol_schema}.dcps_v_meta_quota_define to ${icl_schema};
grant select on ${iol_schema}.dcps_v_meta_quota_define to ${idl_schema};

-- comment
comment on table ${iol_schema}.dcps_v_meta_quota_define is '指定定义表';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quota_id is '指标内部id';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quota_type is '指标大类';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quota_class1 is '指标一级分类';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quota_class2 is '指标二级分类';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quota_class3 is '指标三级分类';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quota_code is '指标编号';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quota_name is '指标名称';
comment on column ${iol_schema}.dcps_v_meta_quota_define.busmean is '指标描述';
comment on column ${iol_schema}.dcps_v_meta_quota_define.quotameasure is '指标度量';
comment on column ${iol_schema}.dcps_v_meta_quota_define.derivemeasure is '指标衍生度量';
comment on column ${iol_schema}.dcps_v_meta_quota_define.dataattr is '数值属性';
comment on column ${iol_schema}.dcps_v_meta_quota_define.dimension_num is '指标维度';
comment on column ${iol_schema}.dcps_v_meta_quota_define.common_units_of_measurement is '度量单位';
comment on column ${iol_schema}.dcps_v_meta_quota_define.countcycle is '统计周期';
comment on column ${iol_schema}.dcps_v_meta_quota_define.dataformat is '数据格式';
comment on column ${iol_schema}.dcps_v_meta_quota_define.protype is '产生方式';
comment on column ${iol_schema}.dcps_v_meta_quota_define.busncore is '业务口径';
comment on column ${iol_schema}.dcps_v_meta_quota_define.techcore is '技术口径';
comment on column ${iol_schema}.dcps_v_meta_quota_define.range is '发布范围';
comment on column ${iol_schema}.dcps_v_meta_quota_define.mainsys is '主系统';
comment on column ${iol_schema}.dcps_v_meta_quota_define.warn_value is '预警值';
comment on column ${iol_schema}.dcps_v_meta_quota_define.alarm_value is '报警值';
comment on column ${iol_schema}.dcps_v_meta_quota_define.owner is '所有者';
comment on column ${iol_schema}.dcps_v_meta_quota_define.userfillin is '填写人';
comment on column ${iol_schema}.dcps_v_meta_quota_define.effectivedate is '生效日期';
comment on column ${iol_schema}.dcps_v_meta_quota_define.expirydate is '失效日期';
comment on column ${iol_schema}.dcps_v_meta_quota_define.defenduser is '维护人';
comment on column ${iol_schema}.dcps_v_meta_quota_define.defenddate is '维护日期';
comment on column ${iol_schema}.dcps_v_meta_quota_define.start_dt is '开始时间';
comment on column ${iol_schema}.dcps_v_meta_quota_define.end_dt is '结束时间';
comment on column ${iol_schema}.dcps_v_meta_quota_define.id_mark is '增删标志';
comment on column ${iol_schema}.dcps_v_meta_quota_define.etl_timestamp is 'ETL处理时间戳';
