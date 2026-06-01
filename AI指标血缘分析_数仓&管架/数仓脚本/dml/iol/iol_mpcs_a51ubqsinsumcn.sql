/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubqsinsumcn
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
drop table ${iol_schema}.mpcs_a51ubqsinsumcn_ex purge;
alter table ${iol_schema}.mpcs_a51ubqsinsumcn add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
-- 3.1 get new data into table
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 8 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a51ubqsinsumcn'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a51ubqsinsumcn truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a51ubqsinsumcn add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.mpcs_a51ubqsinsumcn(
    transdate -- 清算日期
    ,coutseq -- 序号
    ,curr -- 清算货币代码
    ,sect -- 卡产品类型
    ,stac -- 统计内容
    ,trol -- 交易角色
    ,mstp -- 报文类型
    ,pcod -- 交易处理码
    ,pscc -- 服务点条件码
    ,mdor -- 交易发起方式
    ,scod -- 交易代码
    ,cpro -- 账户结算类型
    ,amot -- 交易金额
    ,traf -- 手续费
    ,logf -- 品牌费
    ,ertf -- 差错费用
    ,podf -- 周期计费
    ,stif -- 代授权费用
    ,plog -- 脱机交易小额打包品牌费
    ,neta -- 净金额
    ,brchbr -- 机构代码
	,clear_no -- 银联清算场次号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdate -- 清算日期
    ,coutseq -- 序号
    ,curr -- 清算货币代码
    ,sect -- 卡产品类型
    ,stac -- 统计内容
    ,trol -- 交易角色
    ,mstp -- 报文类型
    ,pcod -- 交易处理码
    ,pscc -- 服务点条件码
    ,mdor -- 交易发起方式
    ,scod -- 交易代码
    ,cpro -- 账户结算类型
    ,amot -- 交易金额
    ,traf -- 手续费
    ,logf -- 品牌费
    ,ertf -- 差错费用
    ,podf -- 周期计费
    ,stif -- 代授权费用
    ,plog -- 脱机交易小额打包品牌费
    ,neta -- 净金额
    ,brchbr -- 机构代码
	,clear_no -- 银联清算场次号
    ,to_date(transdate,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubqsinsumcn
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubqsinsumcn to ${iml_schema};

-- 3.2 drop ex table

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubqsinsumcn',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);