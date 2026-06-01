/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_bdws_u_cust_jsh_ind_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_bdws_u_cust_jsh_ind_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_bdws_u_cust_jsh_ind_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_bdws_u_cust_jsh_ind_info(
    etl_dt varchar(10)
    ,index_no varchar(60)
    ,index_name varchar(250)
    ,execut_type varchar(10)
    ,clerk_id varchar(100)
    ,clerk_name varchar(250)
    ,belong_org_id varchar(100)
    ,belong_org_name varchar(250)
    ,statis_cycle varchar(10)
    ,plan_type varchar(10)
    ,val number(22,2)
    ,d_sub_bal number(22,2)
    ,m_sub_bal number(22,2)
    ,q_sub_bal number(22,2)
    ,y_sub_bal number(22,2)
    ,w_sub_bal number(22,2)
    ,yoy_sub_bal number(22,2)
    ,d_sub_zf number(18,6)
    ,m_sub_zf number(18,6)
    ,q_sub_zf number(18,6)
    ,y_sub_zf number(18,6)
    ,w_sub_zf number(18,6)
    ,yoy_sub_zf number(18,6)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_bdws_u_cust_jsh_ind_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_bdws_u_cust_jsh_ind_info is '零售检视会指标信息表';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.index_no is '指标编号';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.index_name is '指标名称';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.execut_type is '管户类型';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.clerk_id is '员工编号';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.clerk_name is '员工名称';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.belong_org_id is '机构编号';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.belong_org_name is '机构名称';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.statis_cycle is '统计周期代码';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.plan_type is '方案类型代码';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.val is '值';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.d_sub_bal is '比上日末';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.m_sub_bal is '比上月末';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.q_sub_bal is '比上季末';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.y_sub_bal is '比上年末';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.w_sub_bal is '比上周';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.yoy_sub_bal is '比去年同期';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.d_sub_zf is '比上日增幅';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.m_sub_zf is '比上月末增幅';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.q_sub_zf is '比上季末增幅';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.y_sub_zf is '比上年末增幅';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.w_sub_zf is '比上周增幅';
comment on column ${msl_schema}.msl_bdws_u_cust_jsh_ind_info.yoy_sub_zf is '比去年同期增幅';
