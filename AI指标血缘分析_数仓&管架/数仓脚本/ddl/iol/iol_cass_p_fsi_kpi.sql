/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_p_fsi_kpi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_p_fsi_kpi
whenever sqlerror continue none;
drop table ${iol_schema}.cass_p_fsi_kpi purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_p_fsi_kpi(
    etl_dt_ora date -- 数据日期
    ,kpi_code varchar2(30) -- 指标编号
    ,accts_org_no varchar2(60) -- 账务机构
    ,manager_org varchar2(60) -- 考核机构
    ,bus_line varchar2(30) -- 业务条线
    ,com_line varchar2(30) -- 常规条线
    ,subj_no varchar2(60) -- 科目编号
    ,std_prod_no varchar2(100) -- 标准产品编号
    ,org_term_dim varchar2(30) -- 期限
    ,level5_class_cd varchar2(30) -- 五级分类
    ,curr_cd varchar2(60) -- 币种
    ,cust_level varchar2(30) -- 客户等级
    ,adjust_type varchar2(30) -- 调整类型
    ,kpi_value number(38,8) -- 指标值
    ,kpi_value_m number(38,8) -- 指标值(月)
    ,kpi_value_q number(38,8) -- 指标值(季)
    ,kpi_value_y number(38,8) -- 指标值(年)
    ,dir_indus_cd varchar2(30) -- 投向行业代码
    ,cust_indus_type_cd varchar2(30) -- 行业代码
    ,cost_type varchar2(30) -- 成本类型
    ,cust_group varchar2(60) -- 客群
    ,area varchar2(60) -- 所属区域
    ,cust_mgr_no varchar2(100) -- 客户经理编号
    ,ger_name varchar2(150) -- 客户经理名称
    ,type_004 varchar2(60) -- 分子/分母标识
    ,curr_cd_ori varchar2(60) -- 源币种(折币前原始币种）
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cass_p_fsi_kpi to ${iml_schema};
grant select on ${iol_schema}.cass_p_fsi_kpi to ${icl_schema};
grant select on ${iol_schema}.cass_p_fsi_kpi to ${idl_schema};
grant select on ${iol_schema}.cass_p_fsi_kpi to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_p_fsi_kpi is 'SDM_指标表';
comment on column ${iol_schema}.cass_p_fsi_kpi.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_p_fsi_kpi.kpi_code is '指标编号';
comment on column ${iol_schema}.cass_p_fsi_kpi.accts_org_no is '账务机构';
comment on column ${iol_schema}.cass_p_fsi_kpi.manager_org is '考核机构';
comment on column ${iol_schema}.cass_p_fsi_kpi.bus_line is '业务条线';
comment on column ${iol_schema}.cass_p_fsi_kpi.com_line is '常规条线';
comment on column ${iol_schema}.cass_p_fsi_kpi.subj_no is '科目编号';
comment on column ${iol_schema}.cass_p_fsi_kpi.std_prod_no is '标准产品编号';
comment on column ${iol_schema}.cass_p_fsi_kpi.org_term_dim is '期限';
comment on column ${iol_schema}.cass_p_fsi_kpi.level5_class_cd is '五级分类';
comment on column ${iol_schema}.cass_p_fsi_kpi.curr_cd is '币种';
comment on column ${iol_schema}.cass_p_fsi_kpi.cust_level is '客户等级';
comment on column ${iol_schema}.cass_p_fsi_kpi.adjust_type is '调整类型';
comment on column ${iol_schema}.cass_p_fsi_kpi.kpi_value is '指标值';
comment on column ${iol_schema}.cass_p_fsi_kpi.kpi_value_m is '指标值(月)';
comment on column ${iol_schema}.cass_p_fsi_kpi.kpi_value_q is '指标值(季)';
comment on column ${iol_schema}.cass_p_fsi_kpi.kpi_value_y is '指标值(年)';
comment on column ${iol_schema}.cass_p_fsi_kpi.dir_indus_cd is '投向行业代码';
comment on column ${iol_schema}.cass_p_fsi_kpi.cust_indus_type_cd is '行业代码';
comment on column ${iol_schema}.cass_p_fsi_kpi.cost_type is '成本类型';
comment on column ${iol_schema}.cass_p_fsi_kpi.cust_group is '客群';
comment on column ${iol_schema}.cass_p_fsi_kpi.area is '所属区域';
comment on column ${iol_schema}.cass_p_fsi_kpi.cust_mgr_no is '客户经理编号';
comment on column ${iol_schema}.cass_p_fsi_kpi.ger_name is '客户经理名称';
comment on column ${iol_schema}.cass_p_fsi_kpi.type_004 is '分子/分母标识';
comment on column ${iol_schema}.cass_p_fsi_kpi.curr_cd_ori is '源币种(折币前原始币种）';
comment on column ${iol_schema}.cass_p_fsi_kpi.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_p_fsi_kpi.etl_timestamp is 'ETL处理时间戳';
