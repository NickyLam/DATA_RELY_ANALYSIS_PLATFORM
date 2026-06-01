/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_bdws_u_cust_jsh_ind_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_bdws_u_cust_jsh_ind_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_bdws_u_cust_jsh_ind_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_bdws_u_cust_jsh_ind_info(
    index_no varchar2(60) -- 指标编号
    ,index_name varchar2(250) -- 指标名称
    ,execut_type varchar2(10) -- 管户类型
    ,clerk_id varchar2(100) -- 员工编号
    ,clerk_name varchar2(250) -- 员工名称
    ,belong_org_id varchar2(100) -- 机构编号
    ,belong_org_name varchar2(250) -- 机构名称
    ,statis_cycle varchar2(10) -- 统计周期代码
    ,plan_type varchar2(10) -- 方案类型代码
    ,val number(22,2) -- 值
    ,d_sub_bal number(22,2) -- 比上日末
    ,m_sub_bal number(22,2) -- 比上月末
    ,q_sub_bal number(22,2) -- 比上季末
    ,y_sub_bal number(22,2) -- 比上年末
    ,w_sub_bal number(22,2) -- 比上周
    ,yoy_sub_bal number(22,2) -- 比去年同期
    ,d_sub_zf number(18,6) -- 比上日增幅
    ,m_sub_zf number(18,6) -- 比上月末增幅
    ,q_sub_zf number(18,6) -- 比上季末增幅
    ,y_sub_zf number(18,6) -- 比上年末增幅
    ,w_sub_zf number(18,6) -- 比上周增幅
    ,yoy_sub_zf number(18,6) -- 比去年同期增幅
    ,etl_dt date -- ETL处理日期
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
grant select on ${itl_schema}.itl_bdws_u_cust_jsh_ind_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_bdws_u_cust_jsh_ind_info is '零售检视会指标信息表';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.index_no is '指标编号';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.index_name is '指标名称';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.execut_type is '管户类型';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.clerk_id is '员工编号';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.clerk_name is '员工名称';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.belong_org_id is '机构编号';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.belong_org_name is '机构名称';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.statis_cycle is '统计周期代码';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.plan_type is '方案类型代码';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.val is '值';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.d_sub_bal is '比上日末';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.m_sub_bal is '比上月末';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.q_sub_bal is '比上季末';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.y_sub_bal is '比上年末';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.w_sub_bal is '比上周';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.yoy_sub_bal is '比去年同期';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.d_sub_zf is '比上日增幅';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.m_sub_zf is '比上月末增幅';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.q_sub_zf is '比上季末增幅';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.y_sub_zf is '比上年末增幅';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.w_sub_zf is '比上周增幅';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.yoy_sub_zf is '比去年同期增幅';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_bdws_u_cust_jsh_ind_info.etl_timestamp is 'ETL处理时间戳';
