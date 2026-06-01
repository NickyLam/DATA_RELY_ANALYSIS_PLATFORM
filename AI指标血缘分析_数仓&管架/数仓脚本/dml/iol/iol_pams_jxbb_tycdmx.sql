/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_tycdmx
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
alter table ${iol_schema}.pams_jxbb_tycdmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''pams_jxbb_tycdmx'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.pams_jxbb_tycdmx truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.pams_jxbb_tycdmx add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.pams_jxbb_tycdmx(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,ywbh -- 业务编号
    ,cddm -- 存单代码
    ,cdjc -- 存单简称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,fxrq -- 发行日期
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,dfrq -- 兑付日
    ,qx -- 期限
    ,jxts -- 计息天数
    ,fxjg -- 发行机构
    ,nll -- 年利率
    ,fxl -- 发行量(元)
    ,fxje -- 发行金额(元)
    ,bqye -- 本期余额(元)
    ,sjtzrkhh -- 实际投资人客户号
    ,sjtzrqc -- 实际投资人全称
    ,fxjgmc -- 发行机构
    ,xsjgmc -- 销售机构
    ,nrj -- 年日均
    ,yrj -- 月日均
    ,nzc -- 年支出
    ,yzc -- 月支出
    ,ftpll -- 准备金ftp利率
    ,dyftpjsr -- 当月ftp季收入
    ,ljftpjsr -- 累计ftp季收入
    ,fpbl -- 分配比例
    ,fpjs -- 分配角色
    ,ftplxsrylj -- ftp利息收入月累计
    ,ftplxsrnlj -- ftp利息收入年累计
    ,rzc -- 日支出
    ,drftpjsr -- 当日FTP净收入
    ,dnftpjsr -- 当年FTP净收入
    ,ftplxsr -- ftp利息收入
    ,xsjgmczh -- 销售机构名称组合
    ,xsjgmczb -- 销售机构占比说明
    ,gsjgmczh -- 归属机构名称组合
    ,gsjgmczb -- 归属机构占比说明
    ,cpdm -- 产品代码
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,cjdrgjgkhh -- 成交单认购机构客户号
    ,cjdrgjg -- 成交单认购机构
    ,sjrgfkhh -- 实际认购方客户号
    ,sjrgfqc -- 实际认购方全称
    ,tycb -- 摊余成本
    ,btje -- 
    ,btjeylj -- 
    ,btjejlj -- 
    ,btjenlj --
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,ywbh -- 业务编号
    ,cddm -- 存单代码
    ,cdjc -- 存单简称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,fxrq -- 发行日期
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,dfrq -- 兑付日
    ,qx -- 期限
    ,jxts -- 计息天数
    ,fxjg -- 发行机构
    ,nll -- 年利率
    ,fxl -- 发行量(元)
    ,fxje -- 发行金额(元)
    ,bqye -- 本期余额(元)
    ,sjtzrkhh -- 实际投资人客户号
    ,sjtzrqc -- 实际投资人全称
    ,fxjgmc -- 发行机构
    ,xsjgmc -- 销售机构
    ,nrj -- 年日均
    ,yrj -- 月日均
    ,nzc -- 年支出
    ,yzc -- 月支出
    ,ftpll -- 准备金ftp利率
    ,dyftpjsr -- 当月ftp季收入
    ,ljftpjsr -- 累计ftp季收入
    ,fpbl -- 分配比例
    ,fpjs -- 分配角色
    ,ftplxsrylj -- ftp利息收入月累计
    ,ftplxsrnlj -- ftp利息收入年累计
    ,rzc -- 日支出
    ,drftpjsr -- 当日FTP净收入
    ,dnftpjsr -- 当年FTP净收入
    ,ftplxsr -- ftp利息收入
    ,xsjgmczh -- 销售机构名称组合
    ,xsjgmczb -- 销售机构占比说明
    ,gsjgmczh -- 归属机构名称组合
    ,gsjgmczb -- 归属机构占比说明
    ,cpdm -- 产品代码
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,cjdrgjgkhh -- 成交单认购机构客户号
    ,cjdrgjg -- 成交单认购机构
    ,sjrgfkhh -- 实际认购方客户号
    ,sjrgfqc -- 实际认购方全称
    ,tycb -- 摊余成本
    ,btje -- 
    ,btjeylj -- 
    ,btjejlj -- 
    ,btjenlj --
    ,to_date(tjrq,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_tycdmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_tycdmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);