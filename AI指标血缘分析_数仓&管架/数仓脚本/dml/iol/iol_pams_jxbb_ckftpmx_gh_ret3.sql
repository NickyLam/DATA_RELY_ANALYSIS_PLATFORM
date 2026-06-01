/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_ckftpmx_gh
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;


--create partition 
--whenever sqlerror continue none ;
set serveroutput on
declare
  o_cnt number(22, 0) := 0; -- 原表数据量
  b_cnt number(22, 0) := 0; -- 备份表数据量
  v_flag number(10)   := 0; -- 判断标志
begin
	-- 判断原表中的分区并在重建后的表增加所有的分区
  for tb in (select table_name, partition_name, substr(partition_name, 3) as etl_dt
               from user_tab_partitions
              where table_name = upper('pams_jxbb_ckftpmx_gh_bak_${batch_date}')
                and substr(partition_name, 3) <> '19000101'
                and substr(partition_name, 3) >= '20240801'
				and substr(partition_name, 3) < '20241001'
            ) loop

    -- 判断分区是否存在
	  select count(1)
	    into v_flag
	    from all_tab_partitions
	   where table_name = upper('pams_jxbb_ckftpmx_gh')
	     and table_owner = 'IOL'
	     and partition_name = tb.partition_name;

	  -- 如果分区已经存在，则删除分区
	  if v_flag <> 0 then

	    execute immediate 'alter table iol.pams_jxbb_ckftpmx_gh drop partition ' || tb.partition_name;

    end if;

      execute immediate 'alter table iol.pams_jxbb_ckftpmx_gh add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt ||',''yyyymmdd''))';
	 
  end loop;
  
   dbms_output.put_line('pams_jxbb_ckftpmx_gh');
end;

/

insert /*+ append */ into ${iol_schema}.pams_jxbb_ckftpmx_gh(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,zhhm -- 账户户名
    ,zhdh -- 账号代号
    ,zzh -- 子账号
    ,zhbs -- 账户标识
    ,kh -- 卡号
    ,khh -- 客户号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理姓名
    ,fpbl -- 分配比例
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,qxmc -- 期限名称
    ,cph -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品中文名称
    ,zxll -- 账户执行利率
    ,sjll -- 新型存款实际利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,zzkzqr -- 最早可支取日
    ,sfzy -- 是否质押
    ,sfhx -- 是否核心存款
    ,bz -- 币种
    ,zhye -- 账户余额
    ,zhyrjye -- 当月日均
    ,zhnrjye -- 年日均
    ,ftplxzcylj -- 当月利息支出
    ,ftplxzcnlj -- 累计利息支出
    ,zyjg -- 转移价格
    ,ftpsrylj -- 当月ftp转移收入
    ,ftpsrnlj -- 累计ftp转移收入
    ,ftpsyylj -- 当月ftp净收益
    ,ftpsynlj -- 累计ftp净收益
    ,zjywsr -- 中间业务收入
    ,ftplxzc -- ftp利息支出
    ,ftpsr -- ftp收入
    ,ftpsy -- ftp收益
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,bzdm -- 币种码值
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,shlllx -- 赎回利率类型
    ,ydshrq -- 约定赎回日期
    ,tscpbz -- 特殊产品标识
	    ,xhczhll -- 兴惠存综合利率
    ,shll -- 赎回利率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,zhhm -- 账户户名
    ,zhdh -- 账号代号
    ,zzh -- 子账号
    ,zhbs -- 账户标识
    ,kh -- 卡号
    ,khh -- 客户号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理姓名
    ,fpbl -- 分配比例
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,qxmc -- 期限名称
    ,cph -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品中文名称
    ,zxll -- 账户执行利率
    ,sjll -- 新型存款实际利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,zzkzqr -- 最早可支取日
    ,sfzy -- 是否质押
    ,sfhx -- 是否核心存款
    ,bz -- 币种
    ,zhye -- 账户余额
    ,zhyrjye -- 当月日均
    ,zhnrjye -- 年日均
    ,ftplxzcylj -- 当月利息支出
    ,ftplxzcnlj -- 累计利息支出
    ,zyjg -- 转移价格
    ,ftpsrylj -- 当月ftp转移收入
    ,ftpsrnlj -- 累计ftp转移收入
    ,ftpsyylj -- 当月ftp净收益
    ,ftpsynlj -- 累计ftp净收益
    ,zjywsr -- 中间业务收入
    ,ftplxzc -- ftp利息支出
    ,ftpsr -- ftp收入
    ,ftpsy -- ftp收益
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,bzdm -- 币种码值
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,shlllx -- 赎回利率类型
    ,ydshrq -- 约定赎回日期
    ,tscpbz -- 特殊产品标识
	,0 as xhczhll -- 兴惠存综合利率
    ,0 as shll -- 赎回利率
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_jxbb_ckftpmx_gh_bak_${batch_date} t1
 where t1.etl_dt >= to_date('20240801', 'yyyymmdd')
and t1.etl_dt < to_date('20241001', 'yyyymmdd');
 commit;
