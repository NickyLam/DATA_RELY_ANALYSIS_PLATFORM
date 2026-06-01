--
--Purpose:    指标引擎日志表-建表脚本，此脚本由生成引擎自动生成。
--Author :     Sunline
--Usage:      python $ETL_HOME/script/init.py idl indicator_excute_log
--CreateDate: 20180515
--FileType:   DDL
--Logs:
--    zjj 2018-05-15 新建表本
--

begin
	  execute immediate 'drop table ${idl_schema}.indicator_excute_log purge';
exception
  when others then
    dbms_output.put_line('table not found');
end;
/

create table ${idl_schema}.indicator_excute_log (
  standard_indicator_index varchar2(30) ,
  mcs_indicator_index varchar2(30) ,
  indicator_name varchar2(30) ,
  indicator_common_name varchar2(30) ,
  measure_index varchar2(30) ,
  source_system varchar2(30) ,
  start_time varchar2(30) ,
  end_time varchar2(30) ,
  excute_time varchar2(30) ,
  excute_result varchar2(10) ,
  log_path varchar2(200) 
) 
;
comment on table  ${idl_schema}.indicator_excute_log is '指标引擎日志表';
comment on column ${idl_schema}.indicator_excute_log.standard_indicator_index is '标准指标编号';
comment on column ${idl_schema}.indicator_excute_log.mcs_indicator_index is '管驾指标编号';
comment on column ${idl_schema}.indicator_excute_log.indicator_name is '指标名称';
comment on column ${idl_schema}.indicator_excute_log.indicator_common_name is '指标常用名';
comment on column ${idl_schema}.indicator_excute_log.measure_index is '度量编号';
comment on column ${idl_schema}.indicator_excute_log.source_system is '来源系统';
comment on column ${idl_schema}.indicator_excute_log.start_time is '开始时间';
comment on column ${idl_schema}.indicator_excute_log.end_time is '结束时间';
comment on column ${idl_schema}.indicator_excute_log.excute_time is '执行耗时';
comment on column ${idl_schema}.indicator_excute_log.excute_result is '执行结果';
comment on column ${idl_schema}.indicator_excute_log.log_path is '日志路径';
