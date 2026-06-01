/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_ams_blacklist_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_ams_blacklist_detail
whenever sqlerror continue none;
drop table ${iol_schema}.alss_ams_blacklist_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_ams_blacklist_detail(
    bla_det_id varchar2(50) -- 唯一id
    ,black_id varchar2(30) -- 名单编号
    ,bla_name varchar2(768) -- 名称
    ,bla_iden_type varchar2(100) -- 证件类型
    ,bla_identity varchar2(150) -- 证件号码
    ,bla_cust_type varchar2(3) -- 客户类型(01个人，02对公)
    ,eff_date varchar2(12) -- 生效日期（yyyymmdd）
    ,exp_date varchar2(12) -- 失效日期（yyyymmdd）
    ,bla_desc varchar2(3000) -- 描述性说明
    ,bla_status varchar2(2) -- 数据状态（1已生效/0已失效）
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
grant select on ${iol_schema}.alss_ams_blacklist_detail to ${iml_schema};
grant select on ${iol_schema}.alss_ams_blacklist_detail to ${icl_schema};
grant select on ${iol_schema}.alss_ams_blacklist_detail to ${idl_schema};
grant select on ${iol_schema}.alss_ams_blacklist_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_ams_blacklist_detail is '名单数据明细';
comment on column ${iol_schema}.alss_ams_blacklist_detail.bla_det_id is '唯一id';
comment on column ${iol_schema}.alss_ams_blacklist_detail.black_id is '名单编号';
comment on column ${iol_schema}.alss_ams_blacklist_detail.bla_name is '名称';
comment on column ${iol_schema}.alss_ams_blacklist_detail.bla_iden_type is '证件类型';
comment on column ${iol_schema}.alss_ams_blacklist_detail.bla_identity is '证件号码';
comment on column ${iol_schema}.alss_ams_blacklist_detail.bla_cust_type is '客户类型(01个人，02对公)';
comment on column ${iol_schema}.alss_ams_blacklist_detail.eff_date is '生效日期（yyyymmdd）';
comment on column ${iol_schema}.alss_ams_blacklist_detail.exp_date is '失效日期（yyyymmdd）';
comment on column ${iol_schema}.alss_ams_blacklist_detail.bla_desc is '描述性说明';
comment on column ${iol_schema}.alss_ams_blacklist_detail.bla_status is '数据状态（1已生效/0已失效）';
comment on column ${iol_schema}.alss_ams_blacklist_detail.add_user is '新增操作人员';
comment on column ${iol_schema}.alss_ams_blacklist_detail.add_date is '新增时间';
comment on column ${iol_schema}.alss_ams_blacklist_detail.del_user is '删除操作人员';
comment on column ${iol_schema}.alss_ams_blacklist_detail.del_date is '删除时间';
comment on column ${iol_schema}.alss_ams_blacklist_detail.exp_user is '失效操作人员';
comment on column ${iol_schema}.alss_ams_blacklist_detail.exp_time is '失效操作时间';
comment on column ${iol_schema}.alss_ams_blacklist_detail.last_update_user is '最后更新人员';
comment on column ${iol_schema}.alss_ams_blacklist_detail.last_update_date is '最后更新时间';
comment on column ${iol_schema}.alss_ams_blacklist_detail.start_dt is '开始时间';
comment on column ${iol_schema}.alss_ams_blacklist_detail.end_dt is '结束时间';
comment on column ${iol_schema}.alss_ams_blacklist_detail.id_mark is '增删标志';
comment on column ${iol_schema}.alss_ams_blacklist_detail.etl_timestamp is 'ETL处理时间戳';
