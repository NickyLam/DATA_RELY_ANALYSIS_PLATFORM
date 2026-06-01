--
--Purpose:    指标引擎算法配置表-建表脚本，此脚本由生成引擎自动生成。
--Author :     Sunline
--Usage:      python $ETL_HOME/script/init.py idl algorithm_configuartion
--CreateDate: 20180515
--FileType:   DDL
--Logs:
--    zjj 2018-05-15 新建表本
--
begin
	  execute immediate 'drop table ${idl_schema}.algorithm_configuartion purge';
exception
  when others then
    dbms_output.put_line('table not found');
end;
/

create table ${idl_schema}.algorithm_configuartion (
  algorithm_index varchar2(10),
  sql_statement varchar2(200),
  update_date varchar2(30)
) 
;
comment on table  ${idl_schema}.algorithm_configuartion is '指标引擎算法配置表';
comment on column ${idl_schema}.algorithm_configuartion.algorithm_index is '算法编号';
comment on column ${idl_schema}.algorithm_configuartion.sql_statement is 'sql语句';
comment on column ${idl_schema}.algorithm_configuartion.update_date is '更新日期';
