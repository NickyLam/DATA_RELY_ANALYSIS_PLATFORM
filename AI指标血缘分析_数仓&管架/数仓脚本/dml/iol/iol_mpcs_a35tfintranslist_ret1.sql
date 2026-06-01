/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a35tfintranslist
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
	            where table_name = upper('mpcs_a35tfintranslist_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('mpcs_a35tfintranslist')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table mpcs_a35tfintranslist drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table mpcs_a35tfintranslist add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.mpcs_a35tfintranslist(
    seqno -- 
    ,trntm -- 
    ,chnlid -- 
    ,chnlseqno -- 
    ,chnltime -- 
    ,cobank -- 
    ,acctno -- 
    ,custname -- 
    ,seccd -- 
    ,secname -- 
    ,capitalacctno -- 
    ,trntype -- 
    ,trnamt -- 
    ,ccy -- 
    ,acctbal -- 
    ,capitalacctbal -- 
    ,hostseqno -- 
    ,hostdt -- 
    ,rspcd -- 
    ,rspmsg -- 
    ,dataid -- 
    ,paechkflag -- 
    ,paechkremark -- 
    ,paechktime -- 
    ,jtechkflag -- 
    ,jtechkremark -- 
    ,jtechktime -- 
    ,turnflag -- 
    ,hangflag -- 
    ,addflag -- 
    ,glob_seq_num -- 全局流水号
    ,trnchnl -- 渠道类型(01：手机 02：网银 03：银银平台 04：其他)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seqno -- 
    ,trntm -- 
    ,chnlid -- 
    ,chnlseqno -- 
    ,chnltime -- 
    ,cobank -- 
    ,acctno -- 
    ,custname -- 
    ,seccd -- 
    ,secname -- 
    ,capitalacctno -- 
    ,trntype -- 
    ,trnamt -- 
    ,ccy -- 
    ,acctbal -- 
    ,capitalacctbal -- 
    ,hostseqno -- 
    ,hostdt -- 
    ,rspcd -- 
    ,rspmsg -- 
    ,dataid -- 
    ,paechkflag -- 
    ,paechkremark -- 
    ,paechktime -- 
    ,jtechkflag -- 
    ,jtechkremark -- 
    ,jtechktime -- 
    ,turnflag -- 
    ,hangflag -- 
    ,addflag -- 
    ,glob_seq_num -- 全局流水号
    ,' ' as trnchnl -- 渠道类型(01：手机 02：网银 03：银银平台 04：其他)
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from mpcs_a35tfintranslist_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/