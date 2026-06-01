/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ponl_bk_cust_login_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ponl_bk_cust_login_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ponl_bk_cust_login_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ponl_bk_cust_login_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,login_flow_num varchar2(100) -- 登录流水号
    ,cust_id varchar2(100) -- 交易客户编号
    ,oper_type_cd varchar2(30) -- 操作类型代码
    ,login_rest_cd varchar2(30) -- 登录结果代码
    ,login_rest_descb varchar2(500) -- 登录结果描述
    ,login_user_name varchar2(100) -- 登录用户名称
    ,login_tm date -- 登录时间
    ,chn_cd varchar2(30) -- 渠道代码
    ,login_equip_num varchar2(100) -- 登录设备号
    ,cust_ip varchar2(250) -- 客户IP
    ,login_user_id varchar2(100) -- 登录用户编号
    ,login_type_cd varchar2(30) -- 登录类型代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_ponl_bk_cust_login_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ponl_bk_cust_login_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ponl_bk_cust_login_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ponl_bk_cust_login_flow is '个人网银客户登录流水';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_flow_num is '登录流水号';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.oper_type_cd is '操作类型代码';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_rest_cd is '登录结果代码';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_rest_descb is '登录结果描述';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_user_name is '登录用户名称';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_tm is '登录时间';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_equip_num is '登录设备号';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.cust_ip is '客户IP';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_user_id is '登录用户编号';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.login_type_cd is '登录类型代码';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ponl_bk_cust_login_flow.etl_timestamp is 'ETL处理时间戳';
