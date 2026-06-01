/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_conl_bk_cust_login_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_conl_bk_cust_login_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_conl_bk_cust_login_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_cust_login_flow(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,visit_flow_num varchar2(100) -- 访问流水号
    ,user_seq_num varchar2(100) -- 用户顺序号
    ,cust_id varchar2(100) -- 交易客户编号
    ,login_status_cd varchar2(30) -- 登录状态代码
    ,login_dt date -- 登录日期
    ,login_tm timestamp -- 登录时间
    ,cust_ip varchar2(500) -- 客户IP
    ,chn_cd varchar2(30) -- 渠道代码
    ,login_way_cd varchar2(30) -- 登录方式代码
    ,return_code varchar2(1000) -- 返回码
    ,return_info varchar2(2000) -- 返回信息
    ,server_ip varchar2(100) -- 服务器IP
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,cust_termn_mac_addr varchar2(100) -- 客户终端MAC地址
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
grant select on ${iml_schema}.evt_conl_bk_cust_login_flow to ${icl_schema};
grant select on ${iml_schema}.evt_conl_bk_cust_login_flow to ${idl_schema};
grant select on ${iml_schema}.evt_conl_bk_cust_login_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_conl_bk_cust_login_flow is '企业网银客户登录流水';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.visit_flow_num is '访问流水号';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.user_seq_num is '用户顺序号';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.login_status_cd is '登录状态代码';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.login_dt is '登录日期';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.login_tm is '登录时间';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.cust_ip is '客户IP';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.login_way_cd is '登录方式代码';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.return_info is '返回信息';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.server_ip is '服务器IP';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.cust_termn_mac_addr is '客户终端MAC地址';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_conl_bk_cust_login_flow.etl_timestamp is 'ETL处理时间戳';
