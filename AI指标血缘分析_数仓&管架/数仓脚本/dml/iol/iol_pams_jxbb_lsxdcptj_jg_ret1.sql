/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_lsxdcptj_jg
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
	            where table_name = upper('pams_jxbb_lsxdcptj_jg_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_lsxdcptj_jg')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_lsxdcptj_jg drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_jxbb_lsxdcptj_jg add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.pams_jxbb_lsxdcptj_jg(
    tjrq -- 数据日期
    ,jgkhdxdh -- 行员考核对象代号
    ,jgjb -- 机构级别
    ,fpjs -- 业绩关系
    ,cpbh -- 产品编号
    ,cpmc -- 产品名称
    ,hyye -- 余额
    ,yrj -- 月日均
    ,jrj -- 季日均
    ,nrj -- 年日均
    ,jsr -- FTP净收入(时点)
    ,jsrylj -- FTP净收入(月累计)
    ,jsrjlj -- FTP净收入(季累计)
    ,jsrnlj -- FTP净收入(年累计)
    ,lxsrylj -- 累计利息（月累计）
    ,lxsrjlj -- 累计利息（季累计）
    ,lxsrnlj -- 累计利息（年累计）
    ,ftpzycbnlj -- 累计FTP成本
    ,xwdkbs -- 小微贷款标识
    ,bz -- 币种
    ,zdbfs -- 主担保方式
    ,zhbs -- 账户标识
    ,lxsr -- 累计利息收入（时点）
    ,fkje -- 放款金额(时点)
    ,zxll -- 执行利率
    ,jjh -- 借据号
    ,khh -- 客户号
    ,ffrq -- 发放日期
    ,bzjje -- 保证金金额
    ,cdje -- 存单金额
    ,ddckje -- 带动存款金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 数据日期
    ,jgkhdxdh -- 行员考核对象代号
    ,jgjb -- 机构级别
    ,fpjs -- 业绩关系
    ,cpbh -- 产品编号
    ,cpmc -- 产品名称
    ,hyye -- 余额
    ,yrj -- 月日均
    ,jrj -- 季日均
    ,nrj -- 年日均
    ,jsr -- FTP净收入(时点)
    ,jsrylj -- FTP净收入(月累计)
    ,jsrjlj -- FTP净收入(季累计)
    ,jsrnlj -- FTP净收入(年累计)
    ,lxsrylj -- 累计利息（月累计）
    ,lxsrjlj -- 累计利息（季累计）
    ,lxsrnlj -- 累计利息（年累计）
    ,ftpzycbnlj -- 累计FTP成本
    ,xwdkbs -- 小微贷款标识
    ,bz -- 币种
    ,zdbfs -- 主担保方式
    ,zhbs -- 账户标识
    ,lxsr -- 累计利息收入（时点）
    ,fkje -- 放款金额(时点)
    ,zxll -- 执行利率
    ,jjh -- 借据号
    ,khh -- 客户号
    ,ffrq -- 发放日期
    ,0 as bzjje -- 保证金金额
    ,0 as cdje -- 存单金额
    ,0 as ddckje -- 带动存款金额
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from iol.pams_jxbb_lsxdcptj_jg_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/