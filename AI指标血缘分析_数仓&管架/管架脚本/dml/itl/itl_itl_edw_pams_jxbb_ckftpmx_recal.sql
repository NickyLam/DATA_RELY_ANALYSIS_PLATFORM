/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_ckftpmx_recal
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
--alter table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx_recal drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx_recal drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx_recal add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_jxbb_ckftpmx_recal partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,ftplxzcylj -- ftp利息支出月累计
    ,ftplxzcnlj -- ftp利息支出年累计
    ,zyjg -- 转移价格
    ,ftpsrylj -- ftp收入月累计
    ,ftpsrnlj -- ftp收入年累计
    ,ftpsyylj -- ftp收益月累计
    ,ftpsynlj -- ftp收益年累计
    ,zjywsr -- 中间业务收入
    ,ftplxzc -- ftp利息支出
    ,ftpsr -- ftp收入
    ,ftpsy -- ftp收益
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
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tjrq), 0) as tjrq -- 统计日期
    ,nvl(trim(jxdxdh), 0) as jxdxdh -- 绩效对象代号
    ,nvl(trim(khdxdh), 0) as khdxdh -- 考核对象代号
    ,nvl(trim(zhhm), ' ') as zhhm -- 账户名称
    ,nvl(trim(zhdh), ' ') as zhdh -- 账户代号
    ,nvl(trim(zzh), ' ') as zzh -- 子账号
    ,nvl(trim(zhbs), ' ') as zhbs -- 账户标识
    ,nvl(trim(kh), ' ') as kh -- 卡号
    ,nvl(trim(khh), ' ') as khh -- 客户号
    ,nvl(trim(khjgdh), ' ') as khjgdh -- 开户机构代号
    ,nvl(trim(khjgmc), ' ') as khjgmc -- 开户机构名称
    ,nvl(trim(gsjgdh), ' ') as gsjgdh -- 归属机构代号
    ,nvl(trim(gsjgmc), ' ') as gsjgmc -- 归属机构名称
    ,nvl(trim(khjlgh), ' ') as khjlgh -- 客户经理工号
    ,nvl(trim(khjlxm), ' ') as khjlxm -- 客户经理名称
    ,nvl(trim(fpbl), 0) as fpbl -- 分配比例
    ,nvl(trim(kmh), ' ') as kmh -- 科目号
    ,nvl(trim(kmmc), ' ') as kmmc -- 科目名称
    ,nvl(trim(qxmc), ' ') as qxmc -- 期限名称
    ,nvl(trim(cph), ' ') as cph -- 产品号
    ,nvl(trim(cpejfl), ' ') as cpejfl -- 产品二级分类
    ,nvl(trim(cpsjfl), ' ') as cpsjfl -- 产品四级分类
    ,nvl(trim(cpsijfl), ' ') as cpsijfl -- 产品四级分类
    ,nvl(trim(cpmc), ' ') as cpmc -- 产品名称
    ,nvl(trim(zxll), 0) as zxll -- 执行利率
    ,nvl(trim(sjll), 0) as sjll -- 新型存款实际利率
    ,nvl(trim(qxrq), 0) as qxrq -- 起息日期
    ,nvl(trim(dqrq), 0) as dqrq -- 到期日期
    ,nvl(trim(xhrq), 0) as xhrq -- 销户日期
    ,nvl(trim(zzkzqr), ' ') as zzkzqr -- 最早可支取日
    ,nvl(trim(sfzy), ' ') as sfzy -- 是否质押
    ,nvl(trim(sfhx), ' ') as sfhx -- 是否核心
    ,nvl(trim(bz), ' ') as bz -- 币种
    ,nvl(trim(zhye), 0) as zhye -- 账户余额
    ,nvl(trim(zhyrjye), 0) as zhyrjye -- 账户月日均余额
    ,nvl(trim(zhnrjye), 0) as zhnrjye -- 账户年日均余额
    ,nvl(trim(ftplxzcylj), 0) as ftplxzcylj -- ftp利息支出月累计
    ,nvl(trim(ftplxzcnlj), 0) as ftplxzcnlj -- ftp利息支出年累计
    ,nvl(trim(zyjg), 0) as zyjg -- 转移价格
    ,nvl(trim(ftpsrylj), 0) as ftpsrylj -- ftp收入月累计
    ,nvl(trim(ftpsrnlj), 0) as ftpsrnlj -- ftp收入年累计
    ,nvl(trim(ftpsyylj), 0) as ftpsyylj -- ftp收益月累计
    ,nvl(trim(ftpsynlj), 0) as ftpsynlj -- ftp收益年累计
    ,nvl(trim(zjywsr), 0) as zjywsr -- 中间业务收入
    ,nvl(trim(ftplxzc), 0) as ftplxzc -- ftp利息支出
    ,nvl(trim(ftpsr), 0) as ftpsr -- ftp收入
    ,nvl(trim(ftpsy), 0) as ftpsy -- ftp收益
    ,nvl(trim(lxkm), ' ') as lxkm -- 利息科目
    ,nvl(trim(lxkmmc), ' ') as lxkmmc -- 利息科目名称
    ,nvl(trim(bzdm), ' ') as bzdm -- 币种代码
    ,nvl(trim(fptx), ' ') as fptx -- 分配条线
    ,nvl(trim(txfpbl), 0) as txfpbl -- 条线分配比例
    ,nvl(trim(qx), ' ') as qx -- 账户期限代码
    ,nvl(trim(ydshrq), 0) as ydshrq -- 大额存单约定赎回日期
    ,nvl(trim(sjssjgdh), ' ') as sjssjgdh -- 实际所属机构号
    ,nvl(trim(zhjrjye), 0) as zhjrjye -- 账户季日均余额
    ,nvl(trim(recal_dt), 0) as recal_dt -- 重算日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_jxbb_ckftpmx_recal to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_jxbb_ckftpmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);