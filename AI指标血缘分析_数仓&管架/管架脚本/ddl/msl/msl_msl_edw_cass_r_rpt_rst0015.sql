/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cass_r_rpt_rst0015
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cass_r_rpt_rst0015
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cass_r_rpt_rst0015 purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cass_r_rpt_rst0015(
    ETL_DT DATE
    ,etl_dt_ora date
    ,curr_cd varchar2(45)
    ,curr_name varchar2(60)
    ,com_line varchar2(30)
    ,com_line_name varchar2(30)
    ,index_level1_class varchar2(60)
    ,index_level2_class varchar2(60)
    ,index_level3_class varchar2(60)
    ,std_pro_no varchar2(60)
    ,std_pro_name varchar2(300)
    ,manager_org varchar2(60)
    ,manager_org_name varchar2(300)
    ,cust_mgr_no varchar2(60)
    ,cust_mgr_name varchar2(300)
    ,kpi_value_y number(38,8)
    ,kpi_value_m number(38,8)
    ,kpi_value_yy number(38,8)
    ,kpi_value_mm number(38,8)
    ,kpi_value_yoy number(38,8)
    ,kpi_value_mom number(38,8)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cass_r_rpt_rst0015 to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cass_r_rpt_rst0015 is '报表-管驾明细表';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.etl_dt_ora is '数据日期';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.curr_cd is '币种';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.curr_name is '币种名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.com_line is '常规条线';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.com_line_name is '常规条线名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.index_level1_class is '指标一级分类';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.index_level2_class is '指标二级分类';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.index_level3_class is '指标三级分类';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.std_pro_no is '财务集市标准产品';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.std_pro_name is '产品名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.manager_org is '考核机构';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.manager_org_name is '考核机构名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.cust_mgr_no is '客户经理编号';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.cust_mgr_name is '客户经理名称';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.kpi_value_y is '当年值';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.kpi_value_m is '当月值';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.kpi_value_yy is '当年值_分子（存贷利差指标：分子）';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.kpi_value_mm is '当月值_分子（存贷利差指标：分子）';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.kpi_value_yoy is '当年值_分母（存贷利差指标：分母）';
comment on column ${msl_schema}.msl_edw_cass_r_rpt_rst0015.kpi_value_mom is '当月值_分母（存贷利差指标：分母）';
