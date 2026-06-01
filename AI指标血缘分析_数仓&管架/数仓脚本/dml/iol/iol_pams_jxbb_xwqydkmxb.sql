/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_xwqydkmxb
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
drop table ${iol_schema}.pams_jxbb_xwqydkmxb_ex purge;
alter table ${iol_schema}.pams_jxbb_xwqydkmxb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_xwqydkmxb truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_xwqydkmxb_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_xwqydkmxb where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_xwqydkmxb_ex(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,jjh -- 借据号
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,dklx -- 贷款类型
    ,sfxw -- 是否小微标识
    ,ywpz -- 业务配置
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,ffrq -- 发放日期
    ,dqrq -- 到期日期
    ,bzzwmc -- 币种
    ,dkje -- 贷款金额
    ,zcye -- 正常余额
    ,zcyrj -- 正常月日均
    ,zcjrj -- 正常季日均
    ,zcnrj -- 正常年日均
    ,yqye -- 逾期余额
    ,yqyrj -- 逾期月日均
    ,yqjrj -- 逾期季日均
    ,yqnrj -- 逾期年日均
    ,nll -- 年利率
    ,jzll -- 基准利率
    ,khdxdh -- 考核对象代号
    ,hydh -- 客户经理工号
    ,hymc -- 客户经理名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,fpje -- 分配总金额
    ,zlbl -- 分配比例
    ,fphzcye -- 分配后正常余额
    ,fphzcyrj -- 分配后正常月日均
    ,fphzcjrj -- 分配后正常季日均
    ,fphzcnrj -- 分配后正常年日均
    ,fphyqye -- 分配后逾期余额
    ,fphyqyrj -- 分配后逾期月日均
    ,fphyqjrj -- 分配后逾期季日均
    ,fphyqnrj -- 分配后逾期年日均
    ,gyljrywbz -- 供应链金融业务标志
    ,ftplxsr -- FTP利息收入
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpzycb -- FTP转移成本
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,ftpsy -- FTP收益
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,xbcxdbs -- 1+N信保贷标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,jjh -- 借据号
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,dklx -- 贷款类型
    ,sfxw -- 是否小微标识
    ,ywpz -- 业务配置
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,ffrq -- 发放日期
    ,dqrq -- 到期日期
    ,bzzwmc -- 币种
    ,dkje -- 贷款金额
    ,zcye -- 正常余额
    ,zcyrj -- 正常月日均
    ,zcjrj -- 正常季日均
    ,zcnrj -- 正常年日均
    ,yqye -- 逾期余额
    ,yqyrj -- 逾期月日均
    ,yqjrj -- 逾期季日均
    ,yqnrj -- 逾期年日均
    ,nll -- 年利率
    ,jzll -- 基准利率
    ,khdxdh -- 考核对象代号
    ,hydh -- 客户经理工号
    ,hymc -- 客户经理名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,fpje -- 分配总金额
    ,zlbl -- 分配比例
    ,fphzcye -- 分配后正常余额
    ,fphzcyrj -- 分配后正常月日均
    ,fphzcjrj -- 分配后正常季日均
    ,fphzcnrj -- 分配后正常年日均
    ,fphyqye -- 分配后逾期余额
    ,fphyqyrj -- 分配后逾期月日均
    ,fphyqjrj -- 分配后逾期季日均
    ,fphyqnrj -- 分配后逾期年日均
    ,gyljrywbz -- 供应链金融业务标志
    ,ftplxsr -- FTP利息收入
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpzycb -- FTP转移成本
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,ftpsy -- FTP收益
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,xbcxdbs -- 1+N信保贷标识
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_xwqydkmxb
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_xwqydkmxb exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_xwqydkmxb_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_xwqydkmxb to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_xwqydkmxb_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_xwqydkmxb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);