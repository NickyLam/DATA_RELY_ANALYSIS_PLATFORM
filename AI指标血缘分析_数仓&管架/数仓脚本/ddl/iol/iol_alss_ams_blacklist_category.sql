/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_ams_blacklist_category
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_ams_blacklist_category
whenever sqlerror continue none;
drop table ${iol_schema}.alss_ams_blacklist_category purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_ams_blacklist_category(
    black_id varchar2(30) -- 名单编号
    ,black_type varchar2(750) -- 名单大类（迁移时等于名单名称）
    ,black_nane varchar2(750) -- 名单名称
    ,black_source varchar2(3000) -- 名单来源
    ,black_desc varchar2(3000) -- 名单说明
    ,control_measure_desc varchar2(3000) -- 管控措施说明
    ,supervise_file varchar2(3000) -- 监管文件参考
    ,effective_region varchar2(1500) -- 生效地区
    ,data_permisions varchar2(1500) -- 数据维护权限
    ,effective_date varchar2(75) -- 有效期限
    ,black_status varchar2(15) -- 名单状态（1已生效/0已失效）
    ,add_user varchar2(15) -- 新增操作人员
    ,add_date varchar2(27) -- 新增时间
    ,del_user varchar2(15) -- 删除操作人员
    ,del_date varchar2(27) -- 删除时间
    ,exp_user varchar2(15) -- 失效操作人员
    ,exp_time varchar2(27) -- 失效操作时间
    ,last_update_user varchar2(15) -- 最后更新人员
    ,last_update_date varchar2(27) -- 最后更新时间
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
grant select on ${iol_schema}.alss_ams_blacklist_category to ${iml_schema};
grant select on ${iol_schema}.alss_ams_blacklist_category to ${icl_schema};
grant select on ${iol_schema}.alss_ams_blacklist_category to ${idl_schema};
grant select on ${iol_schema}.alss_ams_blacklist_category to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_ams_blacklist_category is '名单列表';
comment on column ${iol_schema}.alss_ams_blacklist_category.black_id is '名单编号';
comment on column ${iol_schema}.alss_ams_blacklist_category.black_type is '名单大类（迁移时等于名单名称）';
comment on column ${iol_schema}.alss_ams_blacklist_category.black_nane is '名单名称';
comment on column ${iol_schema}.alss_ams_blacklist_category.black_source is '名单来源';
comment on column ${iol_schema}.alss_ams_blacklist_category.black_desc is '名单说明';
comment on column ${iol_schema}.alss_ams_blacklist_category.control_measure_desc is '管控措施说明';
comment on column ${iol_schema}.alss_ams_blacklist_category.supervise_file is '监管文件参考';
comment on column ${iol_schema}.alss_ams_blacklist_category.effective_region is '生效地区';
comment on column ${iol_schema}.alss_ams_blacklist_category.data_permisions is '数据维护权限';
comment on column ${iol_schema}.alss_ams_blacklist_category.effective_date is '有效期限';
comment on column ${iol_schema}.alss_ams_blacklist_category.black_status is '名单状态（1已生效/0已失效）';
comment on column ${iol_schema}.alss_ams_blacklist_category.add_user is '新增操作人员';
comment on column ${iol_schema}.alss_ams_blacklist_category.add_date is '新增时间';
comment on column ${iol_schema}.alss_ams_blacklist_category.del_user is '删除操作人员';
comment on column ${iol_schema}.alss_ams_blacklist_category.del_date is '删除时间';
comment on column ${iol_schema}.alss_ams_blacklist_category.exp_user is '失效操作人员';
comment on column ${iol_schema}.alss_ams_blacklist_category.exp_time is '失效操作时间';
comment on column ${iol_schema}.alss_ams_blacklist_category.last_update_user is '最后更新人员';
comment on column ${iol_schema}.alss_ams_blacklist_category.last_update_date is '最后更新时间';
comment on column ${iol_schema}.alss_ams_blacklist_category.start_dt is '开始时间';
comment on column ${iol_schema}.alss_ams_blacklist_category.end_dt is '结束时间';
comment on column ${iol_schema}.alss_ams_blacklist_category.id_mark is '增删标志';
comment on column ${iol_schema}.alss_ams_blacklist_category.etl_timestamp is 'ETL处理时间戳';
