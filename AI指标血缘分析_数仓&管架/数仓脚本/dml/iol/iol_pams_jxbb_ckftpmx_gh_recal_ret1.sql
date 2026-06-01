/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_ckftpmx_gh_recal_ret1
CreateDate: 20250603
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

declare
  v_flag   number(10) :=0;

begin
  for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt
               from user_tab_partitions
                   where table_name = upper('pams_jxbb_ckftpmx_gh_recal_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_jxbb_ckftpmx_gh_recal')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_jxbb_ckftpmx_gh_recal drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_jxbb_ckftpmx_gh_recal add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.pams_jxbb_ckftpmx_gh_recal (
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
    ,recal_dt -- 重算日期
    ,shlllx -- 赎回利率类型
    ,ydshrq -- 约定赎回日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq as tjrq -- 统计日期
    ,jxdxdh as jxdxdh -- 绩效对象代号
    ,khdxdh as khdxdh -- 考核对象代号
    ,zhhm as zhhm -- 账户名称
    ,zhdh as zhdh -- 账户代号
    ,zzh as zzh -- 子账号
    ,zhbs as zhbs -- 账户标识
    ,kh as kh -- 卡号
    ,khh as khh -- 客户号
    ,khjgdh as khjgdh -- 开户机构代号
    ,khjgmc as khjgmc -- 开户机构名称
    ,gsjgdh as gsjgdh -- 归属机构代号
    ,gsjgmc as gsjgmc -- 归属机构名称
    ,khjlgh as khjlgh -- 客户经理工号
    ,khjlxm as khjlxm -- 客户经理名称
    ,fpbl as fpbl -- 分配比例
    ,kmh as kmh -- 科目号
    ,kmmc as kmmc -- 科目名称
    ,qxmc as qxmc -- 期限名称
    ,cph as cph -- 产品号
    ,cpejfl as cpejfl -- 产品二级分类
    ,cpsjfl as cpsjfl -- 产品四级分类
    ,cpsijfl as cpsijfl -- 产品四级分类
    ,cpmc as cpmc -- 产品名称
    ,zxll as zxll -- 执行利率
    ,sjll as sjll -- 新型存款实际利率
    ,qxrq as qxrq -- 起息日期
    ,dqrq as dqrq -- 到期日期
    ,xhrq as xhrq -- 销户日期
    ,zzkzqr as zzkzqr -- 最早可支取日
    ,sfzy as sfzy -- 是否质押
    ,sfhx as sfhx -- 是否核心
    ,bz as bz -- 币种
    ,zhye as zhye -- 账户余额
    ,zhyrjye as zhyrjye -- 账户月日均余额
    ,zhnrjye as zhnrjye -- 账户年日均余额
    ,ftplxzcylj as ftplxzcylj -- FTP利息支出月累计
    ,ftplxzcnlj as ftplxzcnlj -- FTP利息支出年累计
    ,zyjg as zyjg -- 转移价格
    ,ftpsrylj as ftpsrylj -- FTP收入月累计
    ,ftpsrnlj as ftpsrnlj -- FTP收入年累计
    ,ftpsyylj as ftpsyylj -- FTP收益月累计
    ,ftpsynlj as ftpsynlj -- FTP收益年累计
    ,zjywsr as zjywsr -- 中间业务收入
    ,ftplxzc as ftplxzc -- FTP利息支出
    ,ftpsr as ftpsr -- FTP收入
    ,ftpsy as ftpsy -- FTP收益
    ,lxkm as lxkm -- 利息科目
    ,lxkmmc as lxkmmc -- 利息科目名称
    ,bzdm as bzdm -- 币种代码
    ,fptx as fptx -- 分配条线
    ,txfpbl as txfpbl -- 条线分配比例
    ,recal_dt as recal_dt -- 重算日期
    ,' ' as shlllx -- 赎回利率类型
    ,0 as ydshrq -- 约定赎回日期
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_jxbb_ckftpmx_gh_recal_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

