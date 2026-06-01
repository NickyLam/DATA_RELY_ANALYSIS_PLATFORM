/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_khftpcl
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
	            where table_name = upper('pams_jxbb_khftpcl_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_khftpcl')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_khftpcl drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_jxbb_khftpcl add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.pams_jxbb_khftpcl(
    tjrq -- 日期
    ,khmc -- 客户名称
    ,khh -- 客户号
    ,zhbs -- 账户标识
    ,lx -- 类型
    ,jgkhdxdh -- 机构考核对象代号
    ,khkhjg -- 客户开户机构
    ,khssjg -- 客户所属机构
    ,dyjsrhj -- 当月净收入合计
    ,ljjsrhj -- 累计净收入合计
    ,ckqmye -- 存款期末余额
    ,ckdyrj -- 存款当月日均
    ,ckljrj -- 存款累计日均
    ,dycklxzc -- 当月存款利息支出
    ,dyftpzysr -- 当月FTP转移收入
    ,dyckftpyyjsr -- 当月存款FTP营业净收入
    ,ljcklxzc -- 累计存款利息支出
    ,ljftpzysr -- 累计FTP转移收入
    ,ljckftpyyjsr -- 累计存款FTP营业净收入
    ,dkqmye -- 贷款期末余额
    ,dkdyrj -- 贷款当月日均
    ,dkljrj -- 贷款累计日均
    ,dydklxsr -- 当月贷款利息收入
    ,dydkftpzycb -- 当月贷款FTP转移成本
    ,dydkftpyyjsr -- 当月贷款FTP营业净收入
    ,ljdklxsr -- 累计贷款利息收入
    ,ljdkftpzycb -- 累计贷款FTP转移成本
    ,ljdkftpyyjsr -- 累计贷款FTP营业净收入
    ,zjywsr -- 中间业务收入
    ,lxdqmye -- 类信贷期末余额
    ,lxddyrj -- 类信贷当月日均
    ,lxdljrj -- 类信贷累计日均
    ,lxddylxsr -- 类信贷当月利息收入
    ,lxddyftpzycb -- 类信贷当月FTP转移成本
    ,lxddyftpjsr -- 类信贷当月FTP净收入
    ,lxdljlxsr -- 类信贷累计利息收入
    ,lxdljftpzycb -- 类信贷累计FTP转移成本
    ,lxdljftpjsr -- 类信贷累计FTP净收入
    ,ztxqmye -- 再贴现期末余额
    ,ztxdyrj -- 再贴现当月日均
    ,ztxljrj -- 再贴现累计日均
    ,ztxdylxzc -- 再贴现当月利息支出
    ,ztxdyftpzysr -- 再贴现当月FTP转移收入
    ,ztxdyftpjsr -- 再贴现当月FTP净收入
    ,ztxljlxzc -- 再贴现累计利息支出
    ,ztxljftpzysr -- 再贴现累计FTP转移收入
    ,ztxljftpyyjsr -- 再贴现累计FTP营业净收入
    ,ssjgkhdxdh -- 机构所属考核对象代号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 日期
    ,khmc -- 客户名称
    ,khh -- 客户号
    ,zhbs -- 账户标识
    ,lx -- 类型
    ,jgkhdxdh -- 机构考核对象代号
    ,khkhjg -- 客户开户机构
    ,khssjg -- 客户所属机构
    ,dyjsrhj -- 当月净收入合计
    ,ljjsrhj -- 累计净收入合计
    ,ckqmye -- 存款期末余额
    ,ckdyrj -- 存款当月日均
    ,ckljrj -- 存款累计日均
    ,dycklxzc -- 当月存款利息支出
    ,dyftpzysr -- 当月FTP转移收入
    ,dyckftpyyjsr -- 当月存款FTP营业净收入
    ,ljcklxzc -- 累计存款利息支出
    ,ljftpzysr -- 累计FTP转移收入
    ,ljckftpyyjsr -- 累计存款FTP营业净收入
    ,dkqmye -- 贷款期末余额
    ,dkdyrj -- 贷款当月日均
    ,dkljrj -- 贷款累计日均
    ,dydklxsr -- 当月贷款利息收入
    ,dydkftpzycb -- 当月贷款FTP转移成本
    ,dydkftpyyjsr -- 当月贷款FTP营业净收入
    ,ljdklxsr -- 累计贷款利息收入
    ,ljdkftpzycb -- 累计贷款FTP转移成本
    ,ljdkftpyyjsr -- 累计贷款FTP营业净收入
    ,zjywsr -- 中间业务收入
    ,lxdqmye -- 类信贷期末余额
    ,lxddyrj -- 类信贷当月日均
    ,lxdljrj -- 类信贷累计日均
    ,lxddylxsr -- 类信贷当月利息收入
    ,lxddyftpzycb -- 类信贷当月FTP转移成本
    ,lxddyftpjsr -- 类信贷当月FTP净收入
    ,lxdljlxsr -- 类信贷累计利息收入
    ,lxdljftpzycb -- 类信贷累计FTP转移成本
    ,lxdljftpjsr -- 类信贷累计FTP净收入
    ,ztxqmye -- 再贴现期末余额
    ,ztxdyrj -- 再贴现当月日均
    ,ztxljrj -- 再贴现累计日均
    ,ztxdylxzc -- 再贴现当月利息支出
    ,ztxdyftpzysr -- 再贴现当月FTP转移收入
    ,ztxdyftpjsr -- 再贴现当月FTP净收入
    ,ztxljlxzc -- 再贴现累计利息支出
    ,ztxljftpzysr -- 再贴现累计FTP转移收入
    ,ztxljftpyyjsr -- 再贴现累计FTP营业净收入
    ,0 as ssjgkhdxdh -- 机构所属考核对象代号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_jxbb_khftpcl_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/