/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_ckftpmx_recal
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
	            where table_name = upper('pams_jxbb_ckftpmx_recal_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_ckftpmx_recal')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_ckftpmx_recal drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_jxbb_ckftpmx_recal add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';
end loop;
end;
/
insert /*+ append */ into ${iol_schema}.pams_jxbb_ckftpmx_recal(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,zhhm -- 账户名称
    ,zhdh -- 账户代号
    ,zzh -- 子账号
    ,zhbs -- 账户标识
    ,kh -- 卡号
    ,khh -- 客户号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理名称
    ,fpbl -- 分配比例
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,qxmc -- 期限名称
    ,cph -- 产品号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品名称
    ,zxll -- 执行利率
    ,sjll -- 新型存款实际利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,zzkzqr -- 最早可支取日
    ,sfzy -- 是否质押
    ,sfhx -- 是否核心
    ,bz -- 币种
    ,zhye -- 账户余额
    ,zhyrjye -- 账户月日均余额
    ,zhnrjye -- 账户年日均余额
    ,ftplxzcylj -- FTP利息支出月累计
    ,ftplxzcnlj -- FTP利息支出年累计
    ,zyjg -- 转移价格
    ,ftpsrylj -- FTP收入月累计
    ,ftpsrnlj -- FTP收入年累计
    ,ftpsyylj -- FTP收益月累计
    ,ftpsynlj -- FTP收益年累计
    ,zjywsr -- 中间业务收入
    ,ftplxzc -- FTP利息支出
    ,ftpsr -- FTP收入
    ,ftpsy -- FTP收益
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,bzdm -- 币种代码
    ,fptx -- 分配条线
    ,txfpbl -- 条线分配比例
    ,qx -- 账户期限代码
    ,ydshrq -- 大额存单约定赎回日期
    ,sjssjgdh -- 实际所属机构号
    ,zhjrjye -- 账户季日均余额
    ,recal_dt -- 重算日期
    ,xhczhll -- 兴惠存综合利率(%)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,zhhm -- 账户名称
    ,zhdh -- 账户代号
    ,zzh -- 子账号
    ,zhbs -- 账户标识
    ,kh -- 卡号
    ,khh -- 客户号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理名称
    ,fpbl -- 分配比例
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,qxmc -- 期限名称
    ,cph -- 产品号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品名称
    ,zxll -- 执行利率
    ,sjll -- 新型存款实际利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,zzkzqr -- 最早可支取日
    ,sfzy -- 是否质押
    ,sfhx -- 是否核心
    ,bz -- 币种
    ,zhye -- 账户余额
    ,zhyrjye -- 账户月日均余额
    ,zhnrjye -- 账户年日均余额
    ,ftplxzcylj -- FTP利息支出月累计
    ,ftplxzcnlj -- FTP利息支出年累计
    ,zyjg -- 转移价格
    ,ftpsrylj -- FTP收入月累计
    ,ftpsrnlj -- FTP收入年累计
    ,ftpsyylj -- FTP收益月累计
    ,ftpsynlj -- FTP收益年累计
    ,zjywsr -- 中间业务收入
    ,ftplxzc -- FTP利息支出
    ,ftpsr -- FTP收入
    ,ftpsy -- FTP收益
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,bzdm -- 币种代码
    ,fptx -- 分配条线
    ,txfpbl -- 条线分配比例
    ,qx -- 账户期限代码
    ,ydshrq -- 大额存单约定赎回日期
    ,sjssjgdh -- 实际所属机构号
    ,zhjrjye -- 账户季日均余额
    ,recal_dt -- 重算日期
    ,0 as xhczhll -- 兴惠存综合利率(%)
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_jxbb_ckftpmx_recal_bak${batch_date}

commit;
