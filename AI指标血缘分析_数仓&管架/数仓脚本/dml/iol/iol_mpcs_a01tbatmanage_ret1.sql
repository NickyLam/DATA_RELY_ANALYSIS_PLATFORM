/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a01tbatmanage
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
	            where table_name = upper('mpcs_a01tbatmanage_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('mpcs_a01tbatmanage')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table mpcs_a01tbatmanage drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table mpcs_a01tbatmanage add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.mpcs_a01tbatmanage(
    chnlid -- 
    ,batchtype -- 
    ,batchdt -- 
    ,batchno -- 批次号
    ,fntdt -- 
    ,fntseqno -- 
    ,filename -- 
    ,custno -- 
    ,payacctno -- 
    ,payacctname -- 
    ,ccy -- 
    ,totalnum -- 
    ,succnum -- 
    ,failnum -- 
    ,totalamt -- 
    ,succamt -- 
    ,failamt -- 
    ,trndtts -- 
    ,tmpflag -- 
    ,tmpacctno -- 
    ,tmpacctname -- 
    ,memo -- 
    ,stat -- 
    ,reserve -- 
    ,crossflag -- 跨行标识:0-本行1-跨行
    ,otherflag -- 他行标识
    ,inneracno -- 过渡内部户账号
    ,inneracna -- 过渡内部户户名
    ,rspcd -- 返回码
    ,dataid -- 核心外围流水号
    ,hostseqno -- 核心流水号
    ,hostseqdt -- 核心日期
    ,brcno -- 开户机构
    ,tlrno -- 交易柜员
    ,realchn -- 实际代发系统标识 1-薪酬服务平台 0-企业网银
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    chnlid -- 
    ,batchtype -- 
    ,batchdt -- 
    ,batchno -- 批次号
    ,fntdt -- 
    ,fntseqno -- 
    ,filename -- 
    ,custno -- 
    ,payacctno -- 
    ,payacctname -- 
    ,ccy -- 
    ,totalnum -- 
    ,succnum -- 
    ,failnum -- 
    ,totalamt -- 
    ,succamt -- 
    ,failamt -- 
    ,trndtts -- 
    ,tmpflag -- 
    ,tmpacctno -- 
    ,tmpacctname -- 
    ,memo -- 
    ,stat -- 
    ,reserve -- 
    ,crossflag -- 跨行标识:0-本行1-跨行
    ,otherflag -- 他行标识
    ,inneracno -- 过渡内部户账号
    ,inneracna -- 过渡内部户户名
    ,rspcd -- 返回码
    ,dataid -- 核心外围流水号
    ,hostseqno -- 核心流水号
    ,hostseqdt -- 核心日期
    ,brcno -- 开户机构
    ,tlrno -- 交易柜员
    ,' ' as realchn -- 实际代发系统标识 1-薪酬服务平台 0-企业网银
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from mpcs_a01tbatmanage_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/