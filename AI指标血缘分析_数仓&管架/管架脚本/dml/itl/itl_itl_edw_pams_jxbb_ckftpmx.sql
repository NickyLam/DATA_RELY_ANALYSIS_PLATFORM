/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_ckftpmx
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
--alter table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_jxbb_ckftpmx partition for (to_date('${batch_date}','yyyymmdd')) (
    tjrq -- 
    ,jxdxdh -- 
    ,khdxdh -- 
    ,zhhm -- 账户户名
    ,zhdh -- 
    ,zzh -- 
    ,zhbs -- 
    ,kh -- 
    ,khh -- 
    ,khjgdh -- 
    ,khjgmc -- 
    ,gsjgdh -- 
    ,gsjgmc -- 
    ,khjlgh -- 
    ,khjlxm -- 
    ,fpbl -- 
    ,kmh -- 
    ,kmmc -- 
    ,qxmc -- 
    ,cph -- 
    ,cpejfl -- 
    ,cpsjfl -- 
    ,cpsijfl -- 
    ,cpmc -- 
    ,zxll -- 
    ,sjll -- 
    ,qxrq -- 
    ,dqrq -- 
    ,xhrq -- 
    ,zzkzqr -- 
    ,sfzy -- 
    ,sfhx -- 
    ,bz -- 
    ,zhye -- 
    ,zhyrjye -- 
    ,zhnrjye -- 
    ,ftplxzcylj -- 
    ,ftplxzcnlj -- 
    ,zyjg -- 
    ,ftpsrylj -- 
    ,ftpsrnlj -- 
    ,ftpsyylj -- 
    ,ftpsynlj -- 
    ,zjywsr -- 
    ,ftplxzc -- 
    ,ftpsr -- 
    ,ftpsy -- 
    ,lxkm -- 
    ,lxkmmc -- 
    ,bzdm -- 币种码值
    ,qx -- 账户期限
    ,ydshrq -- 大额存单约定赎回日期
    ,zhjrjye -- 季日均余额
    ,xhczhll -- 兴惠存综合利率(%)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tjrq), 0) as tjrq -- 
    ,nvl(trim(jxdxdh), 0) as jxdxdh -- 
    ,nvl(trim(khdxdh), 0) as khdxdh -- 
    ,nvl(trim(zhhm), ' ') as zhhm -- 账户户名
    ,nvl(trim(zhdh), ' ') as zhdh -- 
    ,nvl(trim(zzh), ' ') as zzh -- 
    ,nvl(trim(zhbs), ' ') as zhbs -- 
    ,nvl(trim(kh), ' ') as kh -- 
    ,nvl(trim(khh), ' ') as khh -- 
    ,nvl(trim(khjgdh), ' ') as khjgdh -- 
    ,nvl(trim(khjgmc), ' ') as khjgmc -- 
    ,nvl(trim(gsjgdh), ' ') as gsjgdh -- 
    ,nvl(trim(gsjgmc), ' ') as gsjgmc -- 
    ,nvl(trim(khjlgh), ' ') as khjlgh -- 
    ,nvl(trim(khjlxm), ' ') as khjlxm -- 
    ,nvl(trim(fpbl), 0) as fpbl -- 
    ,nvl(trim(kmh), ' ') as kmh -- 
    ,nvl(trim(kmmc), ' ') as kmmc -- 
    ,nvl(trim(qxmc), ' ') as qxmc -- 
    ,nvl(trim(cph), ' ') as cph -- 
    ,nvl(trim(cpejfl), ' ') as cpejfl -- 
    ,nvl(trim(cpsjfl), ' ') as cpsjfl -- 
    ,nvl(trim(cpsijfl), ' ') as cpsijfl -- 
    ,nvl(trim(cpmc), ' ') as cpmc -- 
    ,nvl(trim(zxll), 0) as zxll -- 
    ,nvl(trim(sjll), 0) as sjll -- 
    ,nvl(trim(qxrq), 0) as qxrq -- 
    ,nvl(trim(dqrq), 0) as dqrq -- 
    ,nvl(trim(xhrq), 0) as xhrq -- 
    ,nvl(trim(zzkzqr), ' ') as zzkzqr -- 
    ,nvl(trim(sfzy), ' ') as sfzy -- 
    ,nvl(trim(sfhx), ' ') as sfhx -- 
    ,nvl(trim(bz), ' ') as bz -- 
    ,nvl(trim(zhye), 0) as zhye -- 
    ,nvl(trim(zhyrjye), 0) as zhyrjye -- 
    ,nvl(trim(zhnrjye), 0) as zhnrjye -- 
    ,nvl(trim(ftplxzcylj), 0) as ftplxzcylj -- 
    ,nvl(trim(ftplxzcnlj), 0) as ftplxzcnlj -- 
    ,nvl(trim(zyjg), 0) as zyjg -- 
    ,nvl(trim(ftpsrylj), 0) as ftpsrylj -- 
    ,nvl(trim(ftpsrnlj), 0) as ftpsrnlj -- 
    ,nvl(trim(ftpsyylj), 0) as ftpsyylj -- 
    ,nvl(trim(ftpsynlj), 0) as ftpsynlj -- 
    ,nvl(trim(zjywsr), 0) as zjywsr -- 
    ,nvl(trim(ftplxzc), 0) as ftplxzc -- 
    ,nvl(trim(ftpsr), 0) as ftpsr -- 
    ,nvl(trim(ftpsy), 0) as ftpsy -- 
    ,nvl(trim(lxkm), ' ') as lxkm -- 
    ,nvl(trim(lxkmmc), ' ') as lxkmmc -- 
    ,nvl(trim(bzdm), ' ') as bzdm -- 币种码值
    ,nvl(trim(qx), ' ') as qx -- 账户期限
    ,nvl(trim(ydshrq), 0) as ydshrq -- 大额存单约定赎回日期
    ,nvl(trim(zhjrjye), 0) as zhjrjye -- 季日均余额
    ,nvl(trim(xhczhll), 0) as xhczhll -- 兴惠存综合利率(%)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_jxbb_ckftpmx
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_jxbb_ckftpmx to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_jxbb_ckftpmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);