/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pbss_cfg_t_biz_code
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pbss_cfg_t_biz_code
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pbss_cfg_t_biz_code purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pbss_cfg_t_biz_code(
    etl_dt date -- 数据日期
    ,id varchar2(32) -- 
    ,biz_code varchar2(6) -- 
    ,biz_name varchar2(60) -- 
    ,eft_date date -- 
    ,biz_property varchar2(2) -- 
    ,is_auto_priority varchar2(1) -- 是否使用动态优化级 1-是 0-否
    ,pre_setup_point number(10,2) -- 取值0至1之间，其它值表示无效
    ,pre_setup_priority number -- 预先调整优先级值
    ,time_len varchar2(10) -- 业务时长，单位：分钟
    ,timeout_priority number -- 超时调整优先级
    ,time_limit varchar2(8) -- 截止时间，格式：hh:mm:ss
    ,timelimit_priority number -- 限时调整优先级
    ,kind_code varchar2(4) -- 业务种类编码
    ,order_no number -- 2016年9月投产需求要求指定顺序
    ,is_display varchar2(1) -- 用于“指定任务获取界面”的“业务类型”是否显示，新增业务类型默认设置为显示。0:不显示,1:显示
    ,start_dt date -- 开始日期
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pbss_cfg_t_biz_code to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pbss_cfg_t_biz_code is '业务类型表';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.id is '';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.biz_code is '';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.biz_name is '';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.eft_date is '';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.biz_property is '';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.is_auto_priority is '是否使用动态优化级 1-是 0-否';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.pre_setup_point is '取值0至1之间，其它值表示无效';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.pre_setup_priority is '预先调整优先级值';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.time_len is '业务时长，单位：分钟';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.timeout_priority is '超时调整优先级';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.time_limit is '截止时间，格式：hh:mm:ss';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.timelimit_priority is '限时调整优先级';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.kind_code is '业务种类编码';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.order_no is '2016年9月投产需求要求指定顺序';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.is_display is '用于“指定任务获取界面”的“业务类型”是否显示，新增业务类型默认设置为显示。0:不显示,1:显示';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.start_dt is '开始日期';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.end_dt is '结束日期';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.id_mark is '删除标识';
comment on column ${itl_schema}.itl_edw_pbss_cfg_t_biz_code.etl_timestamp is 'ETL处理时间戳';