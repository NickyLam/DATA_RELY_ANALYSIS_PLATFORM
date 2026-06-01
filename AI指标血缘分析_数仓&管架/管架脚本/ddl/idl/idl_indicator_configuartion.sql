--
--Purpose:    指标引擎配置表-建表脚本，此脚本由生成引擎自动生成。
--Author :     Sunline
--Usage:      python $ETL_HOME/script/init.py idl indicator_configuartion
--CreateDate: 20180515
--FileType:   DDL
--Logs:
--    zjj 2018-05-15 新建表本
--
begin
	  execute immediate 'drop table ${idl_schema}.indicator_configuartion purge';
exception
  when others then
    dbms_output.put_line('table not found');
end;
/

create table ${idl_schema}.indicator_configuartion (
	standard_indicator_index varchar2(10),
	standard_indicator_level_1_classification varchar2(10),
	standard_indicator_level_2_classification varchar2(10),
	standard_indicator_level_3_classification varchar2(10),
	mcs_indicator_index varchar2(10),
	mcs_level_1_classification varchar2(10),
	mcs_level_2_classification varchar2(10),
	mcs_level_3_classification varchar2(10),
	indicator_name varchar2(30),
	indicator_common_name varchar2(30),
	source_system varchar2(15),
	management_department varchar2(15),
	user_department varchar2(15),
	frequency varchar2(10),
	measurement_unit varchar2(10),
	is_manually_adjusted varchar2(10),
	manual_adjustment_source_system varchar2(15),
	manual_adjustment_indicator_index varchar2(10),
	indicator_status varchar2(10),
	measure_index varchar2(10),
	algorithm_type varchar2(10),
	algorithm_index varchar2(10),
	excution_group varchar2(10),
	source_table_list varchar2(100),
	target_table varchar2(50),
	sql_source varchar2(10),
	sql_statement varchar2(200),
	sql_path varchar2(200),
	update_date varchar2(30)
) 
;

comment on table ${idl_schema}.indicator_configuartion is '指标引擎配置表';
comment on column ${idl_schema}.indicator_configuartion.standard_indicator_index is '标准指标编号';
comment on column ${idl_schema}.indicator_configuartion.standard_indicator_level_1_classification is '标准指标一级分类';
comment on column ${idl_schema}.indicator_configuartion.standard_indicator_level_2_classification is '标准指标二级分类';
comment on column ${idl_schema}.indicator_configuartion.standard_indicator_level_3_classification is '标准指标三级分类';
comment on column ${idl_schema}.indicator_configuartion.mcs_indicator_index is '管驾指标编号';
comment on column ${idl_schema}.indicator_configuartion.mcs_level_1_classification is '管驾一级分类';
comment on column ${idl_schema}.indicator_configuartion.mcs_level_2_classification is '管驾二级分类';
comment on column ${idl_schema}.indicator_configuartion.mcs_level_3_classification is '管驾三级分类';
comment on column ${idl_schema}.indicator_configuartion.indicator_name is '指标名称';
comment on column ${idl_schema}.indicator_configuartion.indicator_common_name is '指标常用名';
comment on column ${idl_schema}.indicator_configuartion.source_system is '来源系统';
comment on column ${idl_schema}.indicator_configuartion.management_department is '管理部门';
comment on column ${idl_schema}.indicator_configuartion.user_department is '使用部门';
comment on column ${idl_schema}.indicator_configuartion.frequency is '频度';
comment on column ${idl_schema}.indicator_configuartion.measurement_unit is '计量单位';
comment on column ${idl_schema}.indicator_configuartion.is_manually_adjusted is '是否涉及手工调整';
comment on column ${idl_schema}.indicator_configuartion.manual_adjustment_source_system is '手工调整来源系统';
comment on column ${idl_schema}.indicator_configuartion.manual_adjustment_indicator_index is '手工调整指标编号';
comment on column ${idl_schema}.indicator_configuartion.indicator_status is '指标状态';
comment on column ${idl_schema}.indicator_configuartion.measure_index is '度量编号';
comment on column ${idl_schema}.indicator_configuartion.algorithm_type is '算法类型';
comment on column ${idl_schema}.indicator_configuartion.algorithm_index is '算法编号';
comment on column ${idl_schema}.indicator_configuartion.excution_group is '执行分组';
comment on column ${idl_schema}.indicator_configuartion.source_table_list is '来源表清单';
comment on column ${idl_schema}.indicator_configuartion.target_table is '目标表';
comment on column ${idl_schema}.indicator_configuartion.sql_source is 'sql来源';
comment on column ${idl_schema}.indicator_configuartion.sql_statement is 'sql语句';
comment on column ${idl_schema}.indicator_configuartion.sql_path is 'sql路径';
comment on column ${idl_schema}.indicator_configuartion.update_date is '更新日期';
