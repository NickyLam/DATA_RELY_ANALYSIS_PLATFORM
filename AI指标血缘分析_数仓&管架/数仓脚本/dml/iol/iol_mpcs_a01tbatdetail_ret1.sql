/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a01tbatdetail_ret1
CreateDate: 20250702
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
                   where table_name = upper('mpcs_a01tbatdetail_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('mpcs_a01tbatdetail')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table mpcs_a01tbatdetail drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table mpcs_a01tbatdetail add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.mpcs_a01tbatdetail (
	batchdt -- 批次日期
	,batchno -- 批次流水
	,fntdt -- 前置日期
	,fntseqno -- 前置流水
	,trntype -- 处理类型00－扣款05－入账10－解冻并扣款15－入账并冻结20－解冻25－冻结此类型是站在[明细账户]的角度定义.
	,prdcd -- 产品代码
	,recordno -- 记录编号
	,bgndt -- 缴费起始日期
	,enddt -- 缴费结束日期
	,trnmonth -- 缴费月数
	,payacctno -- 明细账号
	,trnamt -- 交易金额
	,amt1 -- 备用金额1
	,amt2 -- 备用金额2
	,amt3 -- 备用金额3
	,amt4 -- 备用金额4
	,paytype -- 扣款模式0－可用余额必须大于等于请求金额,不够则失败1－可用余额大余零则处理,等于零则失败处理类型为:00时需送
	,memocd -- 摘要代码
	,dt1 -- 备用日期1
	,prtmemocd -- 打印摘要
	,oppoacctno -- 代理账号记账对手方账号
	,payacctname -- 明细账号户名
	,freezedt -- 原止付交易日期
	,freezeno -- 原止付交易流水
	,succamt -- 成功金额
	,hostseqno -- 核心交易流水
	,hostseqdt -- 核心交易日期
	,rspcd -- 响应码
	,rspmsg -- 响应信息
	,otherbankno -- 他行联行号
	,addword -- 附言
	,orderid -- 订单标识
	,upptranseqno -- 交易流水号
	,trndate -- 中台交易日期
	,glob_seq_num -- 全局流水号
	,srv_cllpty_trx_seq -- 交易流水号
	,etl_dt -- ETL处理日期
	,etl_timestamp -- ETL处理时间戳
)
select
	batchdt as batchdt -- 批次日期
	,batchno as batchno -- 批次流水
	,fntdt as fntdt -- 前置日期
	,fntseqno as fntseqno -- 前置流水
	,trntype as trntype -- 处理类型00－扣款05－入账10－解冻并扣款15－入账并冻结20－解冻25－冻结此类型是站在[明细账户]的角度定义.
	,prdcd as prdcd -- 产品代码
	,recordno as recordno -- 记录编号
	,bgndt as bgndt -- 缴费起始日期
	,enddt as enddt -- 缴费结束日期
	,trnmonth as trnmonth -- 缴费月数
	,payacctno as payacctno -- 明细账号
	,trnamt as trnamt -- 交易金额
	,amt1 as amt1 -- 备用金额1
	,amt2 as amt2 -- 备用金额2
	,amt3 as amt3 -- 备用金额3
	,amt4 as amt4 -- 备用金额4
	,paytype as paytype -- 扣款模式0－可用余额必须大于等于请求金额,不够则失败1－可用余额大余零则处理,等于零则失败处理类型为:00时需送
	,memocd as memocd -- 摘要代码
	,dt1 as dt1 -- 备用日期1
	,prtmemocd as prtmemocd -- 打印摘要
	,oppoacctno as oppoacctno -- 代理账号记账对手方账号
	,payacctname as payacctname -- 明细账号户名
	,freezedt as freezedt -- 原止付交易日期
	,freezeno as freezeno -- 原止付交易流水
	,succamt as succamt -- 成功金额
	,hostseqno as hostseqno -- 核心交易流水
	,hostseqdt as hostseqdt -- 核心交易日期
	,rspcd as rspcd -- 响应码
	,rspmsg as rspmsg -- 响应信息
	,otherbankno as otherbankno -- 他行联行号
	,addword as addword -- 附言
	,orderid as orderid -- 订单标识
	,upptranseqno as upptranseqno -- 交易流水号
	,' ' as trndate -- 中台交易日期
	,' ' as glob_seq_num -- 全局流水号
	,' ' as srv_cllpty_trx_seq -- 交易流水号
	,etl_dt as etl_dt -- ETL处理日期
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a01tbatdetail_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

