/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_ann_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_ann_info
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_ann_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_ann_info(
    annid number(20) -- 公告ID
    ,uaid number(20) -- 发布人
    ,companyid number(20) -- 企业Id
    ,title varchar2(150) -- 标题
    ,background varchar2(765) -- 背景图片
    ,summary varchar2(150) -- 摘要
    ,content varchar2(4000) -- 内容
    ,anntype number(10) -- 公告类型
    ,publishdate date -- 发布时间
    ,validbegindate date -- 有效起始时间
    ,validenddate date -- 有效截止时间
    ,versions number(20) -- 版本号
    ,sys_ctime date -- 系统-创建时间
    ,sys_utime date -- 系统-修改时间
    ,sys_valid number(4) -- 系统-有效状态
    ,flowid number(20) -- 流程Id
    ,status number(4) -- 公告状态
    ,clientinfo varchar2(1024) -- 存储客户端信息
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
grant select on ${iol_schema}.tbms_t_ann_info to ${iml_schema};
grant select on ${iol_schema}.tbms_t_ann_info to ${icl_schema};
grant select on ${iol_schema}.tbms_t_ann_info to ${idl_schema};
grant select on ${iol_schema}.tbms_t_ann_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_ann_info is '公告';
comment on column ${iol_schema}.tbms_t_ann_info.annid is '公告ID';
comment on column ${iol_schema}.tbms_t_ann_info.uaid is '发布人';
comment on column ${iol_schema}.tbms_t_ann_info.companyid is '企业Id';
comment on column ${iol_schema}.tbms_t_ann_info.title is '标题';
comment on column ${iol_schema}.tbms_t_ann_info.background is '背景图片';
comment on column ${iol_schema}.tbms_t_ann_info.summary is '摘要';
comment on column ${iol_schema}.tbms_t_ann_info.content is '内容';
comment on column ${iol_schema}.tbms_t_ann_info.anntype is '公告类型';
comment on column ${iol_schema}.tbms_t_ann_info.publishdate is '发布时间';
comment on column ${iol_schema}.tbms_t_ann_info.validbegindate is '有效起始时间';
comment on column ${iol_schema}.tbms_t_ann_info.validenddate is '有效截止时间';
comment on column ${iol_schema}.tbms_t_ann_info.versions is '版本号';
comment on column ${iol_schema}.tbms_t_ann_info.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_ann_info.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_ann_info.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_ann_info.flowid is '流程Id';
comment on column ${iol_schema}.tbms_t_ann_info.status is '公告状态';
comment on column ${iol_schema}.tbms_t_ann_info.clientinfo is '存储客户端信息';
comment on column ${iol_schema}.tbms_t_ann_info.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_ann_info.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_ann_info.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_ann_info.etl_timestamp is 'ETL处理时间戳';
