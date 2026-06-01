/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_dkftpmx_bw
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
alter table ${iol_schema}.pams_jxbb_dkftpmx_bw add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''pams_jxbb_dkftpmx_bw'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.pams_jxbb_dkftpmx_bw truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.pams_jxbb_dkftpmx_bw add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.pams_jxbb_dkftpmx_bw(
    tjrq -- 统计日期
    ,khm -- 客户名
    ,khh -- 客户号
    ,khjgkhdxdh -- 开户机构考核对象代号
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理名称
    ,fpbl -- 分配比例
    ,zhbs -- 账户标识
    ,xwdkbs -- 小微贷款标识
    ,jjh -- 借据号
    ,jjzt -- 借据状态
    ,dqzxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkr -- 放款日
    ,dqr -- 到期日期
    ,bz -- 币种
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- ftp价格
    ,dyftpzycb -- 当月ftp转移成本
    ,ljftpzycb -- 累计ftp转移成本
    ,dyftpjsy -- 当月ftp净收益
    ,ljftpjsy -- 累计ftp净收益
    ,ftplxsr -- ftp利息收入
    ,ftpzycb -- ftp转移成本
    ,ftpsy -- ftp收益
    ,pjh -- 票据号
    ,wjfl -- 五级分类
    ,yqxyss -- 预计信用损失
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,fxjqzcje -- 风险加权资产金额
    ,bzdm -- 币种代码
    ,fptx -- 分配条线
    ,txfpbl -- 条线分配比例
    ,zjtxbz -- 
    ,dkje -- 贷款金额
    ,jrj -- 季日均
    ,jlx -- 季利息
    ,djftpzycb -- 当季FTP转移成本累计
    ,djftpjsy -- 当季FTP净收益累计
    ,bwbs -- 表外标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,khm -- 客户名
    ,khh -- 客户号
    ,khjgkhdxdh -- 开户机构考核对象代号
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理名称
    ,fpbl -- 分配比例
    ,zhbs -- 账户标识
    ,xwdkbs -- 小微贷款标识
    ,jjh -- 借据号
    ,jjzt -- 借据状态
    ,dqzxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkr -- 放款日
    ,dqr -- 到期日期
    ,bz -- 币种
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- ftp价格
    ,dyftpzycb -- 当月ftp转移成本
    ,ljftpzycb -- 累计ftp转移成本
    ,dyftpjsy -- 当月ftp净收益
    ,ljftpjsy -- 累计ftp净收益
    ,ftplxsr -- ftp利息收入
    ,ftpzycb -- ftp转移成本
    ,ftpsy -- ftp收益
    ,pjh -- 票据号
    ,wjfl -- 五级分类
    ,yqxyss -- 预计信用损失
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,fxjqzcje -- 风险加权资产金额
    ,bzdm -- 币种代码
    ,fptx -- 分配条线
    ,txfpbl -- 条线分配比例
    ,zjtxbz -- 
    ,dkje -- 贷款金额
    ,jrj -- 季日均
    ,jlx -- 季利息
    ,djftpzycb -- 当季FTP转移成本累计
    ,djftpjsy -- 当季FTP净收益累计
    ,bwbs -- 表外标识
    ,to_date(tjrq,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_dkftpmx_bw
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_dkftpmx_bw',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);