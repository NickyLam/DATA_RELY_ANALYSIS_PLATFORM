/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_gjyw_dkftpmx
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
drop table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_ex purge;
alter table ${iol_schema}.pams_jxbb_gjyw_dkftpmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_gjyw_dkftpmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_gjyw_dkftpmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_gjyw_dkftpmx_ex(
    tjrq -- 统计日期
    ,jjh -- 借据号
    ,khmc -- 客户名
    ,khh -- 客户号
    ,fhjgdh -- 分行机构号
    ,fhjgmc -- 分行机构名称
    ,khjgdh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 客户经理名称
    ,fpbl -- 分配比例
    ,zxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,lxkmh -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkrq -- 放款日
    ,dqrq -- 到期日期
    ,bzmc -- 币种（中文）
    ,dkje_yb -- 发放金额(原币）
    ,dkje -- 发放金额（折合人民币）
    ,zhye_yb -- 余额(原币）
    ,zhye -- 余额（折合人民币）
    ,yrj -- 月日均
    ,jrj -- 季日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,djftpjsy -- 当季FTP净收益
    ,dnftpjsy -- 当年FTP净收益
    ,lsljftpjsy -- 历史累计FTP净收益
    ,bwbs -- 表内外标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jjh -- 借据号
    ,khmc -- 客户名
    ,khh -- 客户号
    ,fhjgdh -- 分行机构号
    ,fhjgmc -- 分行机构名称
    ,khjgdh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 客户经理名称
    ,fpbl -- 分配比例
    ,zxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,lxkmh -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkrq -- 放款日
    ,dqrq -- 到期日期
    ,bzmc -- 币种（中文）
    ,dkje_yb -- 发放金额(原币）
    ,dkje -- 发放金额（折合人民币）
    ,zhye_yb -- 余额(原币）
    ,zhye -- 余额（折合人民币）
    ,yrj -- 月日均
    ,jrj -- 季日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,djftpjsy -- 当季FTP净收益
    ,dnftpjsy -- 当年FTP净收益
    ,lsljftpjsy -- 历史累计FTP净收益
    ,bwbs -- 表内外标识
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_gjyw_dkftpmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_gjyw_dkftpmx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_gjyw_dkftpmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_gjyw_dkftpmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_gjyw_dkftpmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);