/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubqingsd
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
drop table ${iol_schema}.mpcs_a51ubqingsd_ex purge;
alter table ${iol_schema}.mpcs_a51ubqingsd add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a51ubqingsd'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a51ubqingsd truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a51ubqingsd add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.mpcs_a51ubqingsd(
    transdate -- 交易日期
    ,acceptfx -- 交易方类型1 : 发送方2 : 接收方
    ,transtype -- 交易类型1 : 取现 2 : 预授权完成(联机) 3 : 预授权完成撤销 4 : 消费 5 : 消费撤销 6 : 结算通知 7 : 联机退货 8 : 代付撤销 9 : 存款 A : 转帐 B : 转出 C : 转入 D : 存款撤销 E : 贷记调整
    ,ttlamt -- 总金额
    ,conscnt -- 总笔数
    ,revamt -- 冲正金额
    ,revcnt -- 冲正笔数
    ,feeamt -- 手续费金额
    ,netamt -- 净金额
    ,transname -- 交易名称
    ,brchbr -- 
    ,covamt -- 转接清算费
    ,remark1 -- 保留
    ,remark2 -- 保留
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdate -- 交易日期
    ,acceptfx -- 交易方类型1 : 发送方2 : 接收方
    ,transtype -- 交易类型1 : 取现 2 : 预授权完成(联机) 3 : 预授权完成撤销 4 : 消费 5 : 消费撤销 6 : 结算通知 7 : 联机退货 8 : 代付撤销 9 : 存款 A : 转帐 B : 转出 C : 转入 D : 存款撤销 E : 贷记调整
    ,ttlamt -- 总金额
    ,conscnt -- 总笔数
    ,revamt -- 冲正金额
    ,revcnt -- 冲正笔数
    ,feeamt -- 手续费金额
    ,netamt -- 净金额
    ,transname -- 交易名称
    ,brchbr -- 
    ,covamt -- 转接清算费
    ,remark1 -- 保留
    ,remark2 -- 保留
    ,to_date(transdate,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubqingsd
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubqingsd to ${iml_schema};

-- 3.2 drop ex table

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubqingsd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);