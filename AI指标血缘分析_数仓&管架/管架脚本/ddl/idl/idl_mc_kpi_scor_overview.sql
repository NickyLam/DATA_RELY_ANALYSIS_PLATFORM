/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_kpi_scor_overview
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_kpi_scor_overview
whenever sqlerror continue none;
drop table ${idl_schema}.mc_kpi_scor_overview purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_kpi_scor_overview(
    seq_num number -- 序号
    ,asses_year varchar2(200) -- 考核年份
    ,org_type varchar2(200) -- 机构类型(分行,事业部，支行，团队，客户经理）
    ,sup_org_no varchar2(200) -- 上级机构编号
    ,org_no varchar2(200) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,ind_name varchar2(200) -- 指标名称
    ,ind_scor number(25,4) -- 指标得分
    ,std_scor number(25,4) -- 标准得分
    ,scor_uplmi number(25,4) -- 得分上限
    ,scor_lolmi number(25,4) -- 得分下限
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd')),
	partition p_20250131 values (to_date('20250131','yyyymmdd')),
	partition p_20250228 values (to_date('20250228','yyyymmdd')),
	partition p_20250331 values (to_date('20250331','yyyymmdd')),
	partition p_20250430 values (to_date('20250430','yyyymmdd')),
	partition p_20250531 values (to_date('20250531','yyyymmdd')),
	partition p_20250630 values (to_date('20250630','yyyymmdd')),
	partition p_20250731 values (to_date('20250731','yyyymmdd')),
	partition p_20250831 values (to_date('20250831','yyyymmdd')),
	partition p_20250930 values (to_date('20250930','yyyymmdd')),
	partition p_20251031 values (to_date('20251031','yyyymmdd')),
	partition p_20251130 values (to_date('20251130','yyyymmdd')),
	partition p_20251231 values (to_date('20251231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_kpi_scor_overview to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_kpi_scor_overview is 'KPI得分概览';
comment on column ${idl_schema}.mc_kpi_scor_overview.seq_num is '序号';
comment on column ${idl_schema}.mc_kpi_scor_overview.asses_year is '考核年份';
comment on column ${idl_schema}.mc_kpi_scor_overview.org_type is '机构类型(分行,事业部，支行，团队，客户经理）';
comment on column ${idl_schema}.mc_kpi_scor_overview.sup_org_no is '上级机构编号';
comment on column ${idl_schema}.mc_kpi_scor_overview.org_no is '机构编号';
comment on column ${idl_schema}.mc_kpi_scor_overview.org_name is '机构名称';
comment on column ${idl_schema}.mc_kpi_scor_overview.ind_name is '指标名称';
comment on column ${idl_schema}.mc_kpi_scor_overview.ind_scor is '指标得分';
comment on column ${idl_schema}.mc_kpi_scor_overview.std_scor is '标准得分';
comment on column ${idl_schema}.mc_kpi_scor_overview.scor_uplmi is '得分上限';
comment on column ${idl_schema}.mc_kpi_scor_overview.scor_lolmi is '得分下限';
comment on column ${idl_schema}.mc_kpi_scor_overview.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_kpi_scor_overview.etl_timestamp is 'ETL处理时间戳';