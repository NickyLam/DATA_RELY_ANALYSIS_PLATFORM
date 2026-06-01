/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_t_executive_position_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_t_executive_position_info
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_t_executive_position_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_t_executive_position_info(
    id varchar2(96) -- 主键ID
    ,user_id varchar2(96) -- 员工号
    ,login_name varchar2(300) -- 域名
    ,user_name varchar2(150) -- 姓名
    ,approval_date varchar2(96) -- 批复日期
    ,position_date varchar2(96) -- 任职日期
    ,is_effective varchar2(3) -- 是否有效（Y：有效，N：无效）
    ,create_user_id varchar2(96) -- 创建人ID
    ,create_user_name varchar2(150) -- 创建人姓名
    ,create_time date -- 创建时间
    ,update_user_id varchar2(96) -- 修改人ID
    ,update_user_name varchar2(150) -- 修改人姓名
    ,update_time date -- 修改时间
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
grant select on ${iol_schema}.nhrs_t_executive_position_info to ${iml_schema};
grant select on ${iol_schema}.nhrs_t_executive_position_info to ${icl_schema};
grant select on ${iol_schema}.nhrs_t_executive_position_info to ${idl_schema};
grant select on ${iol_schema}.nhrs_t_executive_position_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_t_executive_position_info is '高管任职信息表';
comment on column ${iol_schema}.nhrs_t_executive_position_info.id is '主键ID';
comment on column ${iol_schema}.nhrs_t_executive_position_info.user_id is '员工号';
comment on column ${iol_schema}.nhrs_t_executive_position_info.login_name is '域名';
comment on column ${iol_schema}.nhrs_t_executive_position_info.user_name is '姓名';
comment on column ${iol_schema}.nhrs_t_executive_position_info.approval_date is '批复日期';
comment on column ${iol_schema}.nhrs_t_executive_position_info.position_date is '任职日期';
comment on column ${iol_schema}.nhrs_t_executive_position_info.is_effective is '是否有效（Y：有效，N：无效）';
comment on column ${iol_schema}.nhrs_t_executive_position_info.create_user_id is '创建人ID';
comment on column ${iol_schema}.nhrs_t_executive_position_info.create_user_name is '创建人姓名';
comment on column ${iol_schema}.nhrs_t_executive_position_info.create_time is '创建时间';
comment on column ${iol_schema}.nhrs_t_executive_position_info.update_user_id is '修改人ID';
comment on column ${iol_schema}.nhrs_t_executive_position_info.update_user_name is '修改人姓名';
comment on column ${iol_schema}.nhrs_t_executive_position_info.update_time is '修改时间';
comment on column ${iol_schema}.nhrs_t_executive_position_info.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_t_executive_position_info.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_t_executive_position_info.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_t_executive_position_info.etl_timestamp is 'ETL处理时间戳';
