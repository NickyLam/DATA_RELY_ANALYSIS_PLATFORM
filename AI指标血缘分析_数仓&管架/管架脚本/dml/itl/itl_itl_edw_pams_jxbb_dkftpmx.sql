/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_dkftpmx
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_pams_jxbb_dkftpmx drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_jxbb_dkftpmx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_jxbb_dkftpmx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_jxbb_dkftpmx partition for (to_date('${batch_date}','yyyymmdd')) (
    tjrq -- 统计日期
    ,khm -- 客户名称
    ,khh -- 客户号
    ,khjgkhdxdh -- 开户机构考核对象代号
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理姓名
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
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkr -- 放款日
    ,dqr -- 到期日
    ,bz -- 币种
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,ftplxsr -- FTP利息收入
    ,ftpzycb -- FTP转移成本
    ,ftpsy -- FTP净收益
    ,lxkm -- 利息科目号
    ,lxkmmc -- 利息科目名称
    ,pjh -- 票据号
    ,wjfl -- 五级分类
    ,yqxyss -- 预期信用损失
    ,jrj -- 季日均
    ,jlx -- 季利息
    ,djftpzycb -- 当季ftp转移成本
    ,djftpjsy -- 当季ftp净收益
    ,bwbs -- 表外业务标志
    ,gyljrywbz -- 供应链标志
    ,fxjqzcje -- 风险加权资产金额
    ,fptx -- 分配条线
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tjrq), 0) as tjrq -- 统计日期
    ,nvl(trim(khm), ' ') as khm -- 客户名称
    ,nvl(trim(khh), ' ') as khh -- 客户号
    ,nvl(trim(khjgkhdxdh), 0) as khjgkhdxdh -- 开户机构考核对象代号
    ,nvl(trim(khjgh), ' ') as khjgh -- 开户机构号
    ,nvl(trim(khjgmc), ' ') as khjgmc -- 开户机构名称
    ,nvl(trim(ssjgkhdxdh), 0) as ssjgkhdxdh -- 所属机构考核对象代号
    ,nvl(trim(ssjgh), ' ') as ssjgh -- 所属机构号
    ,nvl(trim(ssjgmc), ' ') as ssjgmc -- 所属机构名称
    ,nvl(trim(khjlgh), ' ') as khjlgh -- 客户经理工号
    ,nvl(trim(khjlxm), ' ') as khjlxm -- 客户经理姓名
    ,nvl(trim(fpbl), 0) as fpbl -- 分配比例
    ,nvl(trim(zhbs), ' ') as zhbs -- 账户标识
    ,nvl(trim(xwdkbs), ' ') as xwdkbs -- 小微贷款标识
    ,nvl(trim(jjh), ' ') as jjh -- 借据号
    ,nvl(trim(jjzt), ' ') as jjzt -- 借据状态
    ,nvl(trim(dqzxll), 0) as dqzxll -- 当前执行利率
    ,nvl(trim(jzll), 0) as jzll -- 基准利率
    ,nvl(trim(fdbl), 0) as fdbl -- 浮动比率
    ,nvl(trim(fdfs), ' ') as fdfs -- 浮动方式
    ,nvl(trim(kmh), ' ') as kmh -- 科目号
    ,nvl(trim(kmmc), ' ') as kmmc -- 科目名称
    ,nvl(trim(cpbh), ' ') as cpbh -- 产品编号
    ,nvl(trim(cpejfl), ' ') as cpejfl -- 产品二级分类
    ,nvl(trim(cpsjfl), ' ') as cpsjfl -- 产品三级分类
    ,nvl(trim(cpsijfl), ' ') as cpsijfl -- 产品四级分类
    ,nvl(trim(cpzwmc), ' ') as cpzwmc -- 产品中文名称
    ,nvl(trim(sfxw), ' ') as sfxw -- 是否小微
    ,nvl(trim(qx), ' ') as qx -- 期限
    ,nvl(trim(fkr), 0) as fkr -- 放款日
    ,nvl(trim(dqr), 0) as dqr -- 到期日
    ,nvl(trim(bz), ' ') as bz -- 币种
    ,nvl(trim(ye), 0) as ye -- 余额
    ,nvl(trim(yrj), 0) as yrj -- 月日均
    ,nvl(trim(nrj), 0) as nrj -- 年日均
    ,nvl(trim(ylx), 0) as ylx -- 月利息
    ,nvl(trim(nlx), 0) as nlx -- 年利息
    ,nvl(trim(ftpjg), 0) as ftpjg -- FTP价格
    ,nvl(trim(dyftpzycb), 0) as dyftpzycb -- 当月FTP转移成本
    ,nvl(trim(ljftpzycb), 0) as ljftpzycb -- 累计FTP转移成本
    ,nvl(trim(dyftpjsy), 0) as dyftpjsy -- 当月FTP净收益
    ,nvl(trim(ljftpjsy), 0) as ljftpjsy -- 累计FTP净收益
    ,nvl(trim(ftplxsr), 0) as ftplxsr -- FTP利息收入
    ,nvl(trim(ftpzycb), 0) as ftpzycb -- FTP转移成本
    ,nvl(trim(ftpsy), 0) as ftpsy -- FTP净收益
    ,nvl(trim(lxkm), ' ') as lxkm -- 利息科目号
    ,nvl(trim(lxkmmc), ' ') as lxkmmc -- 利息科目名称
    ,nvl(trim(pjh), ' ') as pjh -- 票据号
    ,nvl(trim(wjfl), ' ') as wjfl -- 五级分类
    ,nvl(trim(yqxyss), 0) as yqxyss -- 预期信用损失
    ,nvl(trim(jrj), 0) as jrj -- 季日均
    ,nvl(trim(jlx), 0) as jlx -- 季利息
    ,nvl(trim(djftpzycb), 0) as djftpzycb -- 当季ftp转移成本
    ,nvl(trim(djftpjsy), 0) as djftpjsy -- 当季ftp净收益
    ,nvl(trim(bwbs), ' ') as bwbs -- 表外业务标志
    ,nvl(trim(gyljrywbz), ' ') as gyljrywbz -- 供应链标志
    ,nvl(trim(fxjqzcje), 0) as fxjqzcje -- 风险加权资产金额
    ,nvl(trim(fptx), ' ') as fptx -- 分配条线
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_jxbb_dkftpmx
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_jxbb_dkftpmx to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_jxbb_dkftpmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);