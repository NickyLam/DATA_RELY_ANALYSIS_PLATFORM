--
--Purpose:    指标引擎度量配置表-建表脚本，此脚本由生成引擎自动生成。
--Author :     Sunline
--Usage:      python $ETL_HOME/script/init.py idl indicator_result
--CreateDate: 20180515
--FileType:   DDL
--Logs:
--    zjj 2018-05-15 新建表本
--
begin
	  execute immediate 'drop table ${idl_schema}.indicator_result purge';
exception
  when others then
    dbms_output.put_line('table not found');
end;
/

create table ${idl_schema}.indicator_result (
	standard_indicator_index varchar2(10),
	mcs_indicator_index varchar2(10),
	indicator_name varchar2(30),
	indicator_common_name varchar2(30),
	measure_index varchar2(10),
	measure_name varchar2(30),
	currency varchar2(30),
	frequency varchar2(30),
	indicator_value varchar2(200),
	batch_date varchar2(30),
	update_date varchar2(30)
) 
;
comment on table  ${idl_schema}.indicator_result is '指标引擎指标结果表';
comment on column ${idl_schema}.indicator_result.standard_indicator_index is '标准指标编号';
comment on column ${idl_schema}.indicator_result.mcs_indicator_index is '管驾指标编号';
comment on column ${idl_schema}.indicator_result.indicator_name is '指标名称';
comment on column ${idl_schema}.indicator_result.indicator_common_name is '指标常用名';
comment on column ${idl_schema}.indicator_result.measure_index is '度量编号';
comment on column ${idl_schema}.indicator_result.measure_name is '度量名称';
comment on column ${idl_schema}.indicator_result.currency is '币种';
comment on column ${idl_schema}.indicator_result.frequency is '频度';
comment on column ${idl_schema}.indicator_result.indicator_value is '指标值';
comment on column ${idl_schema}.indicator_result.batch_date is '批量日期';
comment on column ${idl_schema}.indicator_result.update_date is '更新日期';
