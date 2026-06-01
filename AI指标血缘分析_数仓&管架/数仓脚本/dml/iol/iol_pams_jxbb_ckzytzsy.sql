/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_ckzytzsy
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iol_schema}.pams_jxbb_ckzytzsy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''pams_jxbb_ckzytzsy'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
-- 2.3 insert data to ex table
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.pams_jxbb_ckzytzsy truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    else 
        v_sql := 'alter table iol.pams_jxbb_ckzytzsy add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.pams_jxbb_ckzytzsy(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,zyzqlx -- 质押债券类型
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,zyzqje -- 质押债券金额
    ,tzsy -- 调整收益
    ,sdtzsy -- 时点调整收益
    ,tzsyylj -- 调整收益月累计
    ,tzsyjlj -- 调整收益季累计
    ,tzsynlj -- 调整收益年累计
    ,khjlgh -- 客户经理工号
    ,hth -- 合同号
    ,zyr -- 质押日
    ,dqr -- 到期日
    ,ldpz -- 联动标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,zyzqlx -- 质押债券类型
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,zyzqje -- 质押债券金额
    ,tzsy -- 调整收益
    ,sdtzsy -- 时点调整收益
    ,tzsyylj -- 调整收益月累计
    ,tzsyjlj -- 调整收益季累计
    ,tzsynlj -- 调整收益年累计
    ,khjlgh -- 客户经理工号
	,hth -- 合同号
    ,zyr -- 质押日
    ,dqr -- 到期日
    ,ldpz -- 联动标志
    ,to_date(tjrq,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_ckzytzsy
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table

-- 3.1 table grant
-- grant select on ${iol_schema}.pams_jxbb_ckzytzsy to ${iml_schema};

-- 3.2 drop ex table

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_ckzytzsy',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);