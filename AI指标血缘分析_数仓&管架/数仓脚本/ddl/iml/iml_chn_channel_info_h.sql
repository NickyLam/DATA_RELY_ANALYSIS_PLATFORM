/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml chn_channel_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.chn_channel_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.chn_channel_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_channel_info_h(
    lp_id varchar2(100) -- 法人编号
    ,chn_id varchar2(100) -- 渠道编号
    ,chn_cls_cd varchar2(30) -- 渠道分类代码
    ,chn_subclass_cd varchar2(30) -- 渠道细类代码
    ,chn_name varchar2(1000) -- 渠道名称
    ,chn_abbr varchar2(500) -- 渠道简称
    ,cnter_flg varchar2(10) -- 柜面标志
    ,sys_id varchar2(100) -- 系统编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.chn_channel_info_h to ${icl_schema};
grant select on ${iml_schema}.chn_channel_info_h to ${idl_schema};
grant select on ${iml_schema}.chn_channel_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.chn_channel_info_h is '渠道信息历史';
comment on column ${iml_schema}.chn_channel_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.chn_channel_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.chn_channel_info_h.chn_cls_cd is '渠道分类代码';
comment on column ${iml_schema}.chn_channel_info_h.chn_subclass_cd is '渠道细类代码';
comment on column ${iml_schema}.chn_channel_info_h.chn_name is '渠道名称';
comment on column ${iml_schema}.chn_channel_info_h.chn_abbr is '渠道简称';
comment on column ${iml_schema}.chn_channel_info_h.cnter_flg is '柜面标志';
comment on column ${iml_schema}.chn_channel_info_h.sys_id is '系统编号';
comment on column ${iml_schema}.chn_channel_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.chn_channel_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.chn_channel_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.chn_channel_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.chn_channel_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.chn_channel_info_h.etl_timestamp is 'ETL处理时间戳';
