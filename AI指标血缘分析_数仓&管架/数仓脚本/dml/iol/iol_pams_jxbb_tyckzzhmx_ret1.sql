/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_tyckzzhmx
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
	            where table_name = upper('pams_jxbb_tyckzzhmx_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_tyckzzhmx')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_tyckzzhmx drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_jxbb_tyckzzhmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.pams_jxbb_tyckzzhmx(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jrjglb -- 金融机构类型
    ,zhdh -- 账户代号
    ,zhid -- 账户id
    ,zzh -- 子账号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,bz -- 币种
    ,cz -- 储种
    ,khrq -- 开户日期
    ,nll -- 年利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,fxpl -- 付息频率
    ,zhye -- 账户余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,ftpll -- 准备金ftp利率
    ,byftpjsr -- 当月ftp净收入
    ,bnftpjsr -- 半年ftp净支出
    ,ljftpjsr -- 累计ftp季收入
    ,fpjs -- 分配角色
    ,fpbl -- 分配比例
    ,lxzcylj -- 利息支出月累计
    ,lxzcnlj -- 利息支出年累计
    ,lxsrylj -- 利息收入月累计
    ,lxsrnlj -- 利息收入年累计
    ,lxzcrlj -- 利息支出日累计
    ,lxsrrlj -- 利息收入日累计
    ,brftpjsr -- 当日FTP净收入
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,qylx -- 签约类型
    ,cph -- 产品编号
    ,cpejfl -- 产品小类（二级分类）
    ,cpsjfl -- 产品组（三级分类）
    ,cpsijfl -- 基础产品（四级分类）
    ,cpzwmc -- 可售产品（产品名称）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jrjglb -- 金融机构类型
    ,zhdh -- 账户代号
    ,zhid -- 账户id
    ,zzh -- 子账号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,bz -- 币种
    ,cz -- 储种
    ,khrq -- 开户日期
    ,nll -- 年利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,fxpl -- 付息频率
    ,zhye -- 账户余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,ftpll -- 准备金ftp利率
    ,byftpjsr -- 当月ftp净收入
    ,bnftpjsr -- 半年ftp净支出
    ,ljftpjsr -- 累计ftp季收入
    ,fpjs -- 分配角色
    ,fpbl -- 分配比例
    ,lxzcylj -- 利息支出月累计
    ,lxzcnlj -- 利息支出年累计
    ,lxsrylj -- 利息收入月累计
    ,lxsrnlj -- 利息收入年累计
    ,lxzcrlj -- 利息支出日累计
    ,lxsrrlj -- 利息收入日累计
    ,brftpjsr -- 当日FTP净收入
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,' ' as qylx -- 签约类型
    ,' ' as cph -- 产品编号
    ,' ' as cpejfl -- 产品小类（二级分类）
    ,' ' as cpsjfl -- 产品组（三级分类）
    ,' ' as cpsijfl -- 基础产品（四级分类）
    ,' ' as cpzwmc -- 可售产品（产品名称）    
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_jxbb_tyckzzhmx_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/