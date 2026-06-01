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

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('mpcs_a51ubqsinsumcn_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('mpcs_a51ubqsinsumcn')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table mpcs_a51ubqsinsumcn drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table mpcs_a51ubqsinsumcn add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

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
    ,' ' as clear_no -- 银联清算场次号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from mpcs_a51ubqsinsumcn_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/