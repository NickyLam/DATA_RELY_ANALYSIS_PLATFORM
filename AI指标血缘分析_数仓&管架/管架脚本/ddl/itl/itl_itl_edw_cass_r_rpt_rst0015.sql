/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cass_r_rpt_rst0015
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cass_r_rpt_rst0015
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cass_r_rpt_rst0015 purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cass_r_rpt_rst0015(
    etl_dt_ora date -- 数据日期
    ,curr_cd varchar2(45) -- 币种
    ,curr_name varchar2(60) -- 币种名称
    ,com_line varchar2(30) -- 常规条线
    ,com_line_name varchar2(30) -- 常规条线名称
    ,index_level1_class varchar2(60) -- 指标一级分类
    ,index_level2_class varchar2(60) -- 指标二级分类
    ,index_level3_class varchar2(60) -- 指标三级分类
    ,std_pro_no varchar2(60) -- 财务集市标准产品
    ,std_pro_name varchar2(300) -- 产品名称
    ,manager_org varchar2(60) -- 考核机构
    ,manager_org_name varchar2(300) -- 考核机构名称
    ,cust_mgr_no varchar2(60) -- 客户经理编号
    ,cust_mgr_name varchar2(300) -- 客户经理名称
    ,kpi_value_y number(38,8) -- 当年值
    ,kpi_value_m number(38,8) -- 当月值
    ,kpi_value_yy number(38,8) -- 当年值_分子（存贷利差指标：分子）
    ,kpi_value_mm number(38,8) -- 当月值_分子（存贷利差指标：分子）
    ,kpi_value_yoy number(38,8) -- 当年值_分母（存贷利差指标：分母）
    ,kpi_value_mom number(38,8) -- 当月值_分母（存贷利差指标：分母）
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
grant select on ${itl_schema}.itl_edw_cass_r_rpt_rst0015 to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cass_r_rpt_rst0015 is '报表-管驾明细表';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.etl_dt_ora is '数据日期';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.curr_cd is '币种';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.curr_name is '币种名称';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.com_line is '常规条线';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.com_line_name is '常规条线名称';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.index_level1_class is '指标一级分类';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.index_level2_class is '指标二级分类';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.index_level3_class is '指标三级分类';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.std_pro_no is '财务集市标准产品';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.std_pro_name is '产品名称';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.manager_org is '考核机构';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.manager_org_name is '考核机构名称';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.cust_mgr_no is '客户经理编号';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.cust_mgr_name is '客户经理名称';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.kpi_value_y is '当年值';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.kpi_value_m is '当月值';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.kpi_value_yy is '当年值_分子（存贷利差指标：分子）';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.kpi_value_mm is '当月值_分子（存贷利差指标：分子）';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.kpi_value_yoy is '当年值_分母（存贷利差指标：分母）';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.kpi_value_mom is '当月值_分母（存贷利差指标：分母）';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_cass_r_rpt_rst0015.etl_timestamp is 'ETL处理时间戳';
