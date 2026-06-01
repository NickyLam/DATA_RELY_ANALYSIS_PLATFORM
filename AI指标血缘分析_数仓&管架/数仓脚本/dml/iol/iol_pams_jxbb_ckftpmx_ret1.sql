/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_ckftpmx_ret1
CreateDate: 20250512
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
                   where table_name = upper('pams_jxbb_ckftpmx_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_jxbb_ckftpmx')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_jxbb_ckftpmx drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_jxbb_ckftpmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.pams_jxbb_ckftpmx (
    tjrq -- 
    ,jxdxdh -- 
    ,khdxdh -- 
    ,zhhm -- 
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
    ,txfpbl -- 条线分配比例
    ,fptx -- 分配条线
    ,qx -- 账户期限
    ,ydshrq -- 大额存单约定赎回日期
    ,sjssjgdh -- 实际所属机构号
    ,zhjrjye -- 季日均余额
    ,xhczhll -- 兴惠存综合利率(%)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq as tjrq -- 
    ,jxdxdh as jxdxdh -- 
    ,khdxdh as khdxdh -- 
    ,zhhm as zhhm -- 
    ,zhdh as zhdh -- 
    ,zzh as zzh -- 
    ,zhbs as zhbs -- 
    ,kh as kh -- 
    ,khh as khh -- 
    ,khjgdh as khjgdh -- 
    ,khjgmc as khjgmc -- 
    ,gsjgdh as gsjgdh -- 
    ,gsjgmc as gsjgmc -- 
    ,khjlgh as khjlgh -- 
    ,khjlxm as khjlxm -- 
    ,fpbl as fpbl -- 
    ,kmh as kmh -- 
    ,kmmc as kmmc -- 
    ,qxmc as qxmc -- 
    ,cph as cph -- 
    ,cpejfl as cpejfl -- 
    ,cpsjfl as cpsjfl -- 
    ,cpsijfl as cpsijfl -- 
    ,cpmc as cpmc -- 
    ,zxll as zxll -- 
    ,sjll as sjll -- 
    ,qxrq as qxrq -- 
    ,dqrq as dqrq -- 
    ,xhrq as xhrq -- 
    ,zzkzqr as zzkzqr -- 
    ,sfzy as sfzy -- 
    ,sfhx as sfhx -- 
    ,bz as bz -- 
    ,zhye as zhye -- 
    ,zhyrjye as zhyrjye -- 
    ,zhnrjye as zhnrjye -- 
    ,ftplxzcylj as ftplxzcylj -- 
    ,ftplxzcnlj as ftplxzcnlj -- 
    ,zyjg as zyjg -- 
    ,ftpsrylj as ftpsrylj -- 
    ,ftpsrnlj as ftpsrnlj -- 
    ,ftpsyylj as ftpsyylj -- 
    ,ftpsynlj as ftpsynlj -- 
    ,zjywsr as zjywsr -- 
    ,ftplxzc as ftplxzc -- 
    ,ftpsr as ftpsr -- 
    ,ftpsy as ftpsy -- 
    ,lxkm as lxkm -- 
    ,lxkmmc as lxkmmc -- 
    ,bzdm as bzdm -- 币种码值
    ,txfpbl as txfpbl -- 条线分配比例
    ,fptx as fptx -- 分配条线
    ,qx as qx -- 账户期限
    ,ydshrq as ydshrq -- 大额存单约定赎回日期
    ,sjssjgdh as sjssjgdh -- 实际所属机构号
    ,zhjrjye as zhjrjye -- 季日均余额
    ,0 as xhczhll -- 兴惠存综合利率(%)
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_jxbb_ckftpmx_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

