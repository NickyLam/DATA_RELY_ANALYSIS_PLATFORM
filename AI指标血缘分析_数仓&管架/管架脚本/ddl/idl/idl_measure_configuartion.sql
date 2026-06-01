--
--Purpose:    指标引擎度量配置表-建表脚本，此脚本由生成引擎自动生成。
--Author :     Sunline
--Usage:      python $ETL_HOME/script/init.py idl measure_configuartion
--CreateDate: 20180515
--FileType:   DDL
--Logs:
--    zjj 2018-05-15 新建表本
--
begin
	  execute immediate 'drop table ${idl_schema}.measure_configuartion purge';
exception
  when others then
    dbms_output.put_line('table not found');
end;
/

create table ${idl_schema}.measure_configuartion (
  measure_index varchar2(10),
  measure_name varchar2(30),
  sql_source varchar2(10),
  sql_path varchar2(200),
  sql_statement varchar2(200),
  update_date varchar2(30)
) 
;
comment on table  ${idl_schema}.measure_configuartion is '指标引擎度量配置表';
comment on column ${idl_schema}.measure_configuartion.measure_index is '度量编号';
comment on column ${idl_schema}.measure_configuartion.measure_name is '度量名称';
comment on column ${idl_schema}.measure_configuartion.sql_source is 'sql来源';
comment on column ${idl_schema}.measure_configuartion.sql_path is '文件路径';
comment on column ${idl_schema}.measure_configuartion.sql_statement is 'sql语句';
comment on column ${idl_schema}.measure_configuartion.update_date is '更新日期';
