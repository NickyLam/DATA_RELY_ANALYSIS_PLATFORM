/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ama_mdsr_acct_h
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
	            where table_name = upper('tgls_ama_mdsr_acct_h_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('tgls_ama_mdsr_acct_h')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table tgls_ama_mdsr_acct_h drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table tgls_ama_mdsr_acct_h add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


insert /*+ append */ into ${iol_schema}.tgls_ama_mdsr_acct_h(
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,transq -- 交易流水
    ,trancd -- 子交易
    ,bathid -- 批次号
    ,loanno -- 单据编号
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,bfprducd -- 调整前产品编号
    ,deptcd -- 账务机构编号
    ,bfdeptcd -- 调整前账务机构编号
    ,crcycd -- 币种
    ,lnctno -- 合同编号
    ,descpt -- 业务说明
    ,custcd -- 客户编号
    ,custna -- 客户名称
    ,prodp1 -- 产品属性1
    ,prodp2 -- 产品属性2
    ,prodp3 -- 产品属性3
    ,prodp4 -- 产品属性4
    ,prodp5 -- 产品属性5
    ,prodp6 -- 产品属性6
    ,prodp7 -- 产品属性7
    ,prodp8 -- 产品属性8
    ,prodp9 -- 产品属性9
    ,prodpa -- 产品属性10
    ,amotrbdt -- 摊销开始日期
    ,amotrodt -- 摊销结束日期
    ,acamotrbdt -- 实际摊销开始日期
    ,normpr -- 待摊总金额
    ,amortam -- 本次摊销金额
    ,amortisedam -- 累计摊销金额
    ,amortamredu -- 剩余摊销金额
    ,daynum -- 摊销天数
    ,amorfr -- 摊销频度
    ,amortst -- 摊销状态[n:未摊销,i:摊销中,s:摊销完成]
    ,amou01 -- 金额01
    ,amou02 -- 金额02
    ,amou03 -- 金额03
    ,amou04 -- 金额04
    ,amou05 -- 金额05
    ,amou06 -- 金额06
    ,amou07 -- 金额07
    ,attra1 -- 附加属性1
    ,attra2 -- 附加属性2
    ,attra3 -- 附加属性3
    ,attra4 -- 附加属性4
    ,attra5 -- 附加属性5
    ,attra6 -- 附加属性6
    ,attra7 -- 附加属性7
    ,attra8 -- 附加属性8
    ,attra9 -- 附加属性9
    ,attraa -- 附加属性10
    ,puprtg -- 客户类型
    ,islast -- 是否交易场景的最后一条，1-是，0-否
    ,eventp -- 交易场景
    ,tranti -- 时间
    ,chrgmd -- 收费方式
    ,changst -- 是否需要重新计算本次摊销金额（每次摊销金额）默认yn:不需要y:需要
    ,oridatadt -- 原表数据日期
    ,remark -- 历史备份说明
    ,tranbr -- 交易机构编号
    ,bsnssq -- 全局流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,transq -- 交易流水
    ,trancd -- 子交易
    ,bathid -- 批次号
    ,loanno -- 单据编号
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,bfprducd -- 调整前产品编号
    ,deptcd -- 账务机构编号
    ,bfdeptcd -- 调整前账务机构编号
    ,crcycd -- 币种
    ,lnctno -- 合同编号
    ,descpt -- 业务说明
    ,custcd -- 客户编号
    ,custna -- 客户名称
    ,prodp1 -- 产品属性1
    ,prodp2 -- 产品属性2
    ,prodp3 -- 产品属性3
    ,prodp4 -- 产品属性4
    ,prodp5 -- 产品属性5
    ,prodp6 -- 产品属性6
    ,prodp7 -- 产品属性7
    ,prodp8 -- 产品属性8
    ,prodp9 -- 产品属性9
    ,prodpa -- 产品属性10
    ,amotrbdt -- 摊销开始日期
    ,amotrodt -- 摊销结束日期
    ,acamotrbdt -- 实际摊销开始日期
    ,normpr -- 待摊总金额
    ,amortam -- 本次摊销金额
    ,amortisedam -- 累计摊销金额
    ,amortamredu -- 剩余摊销金额
    ,daynum -- 摊销天数
    ,amorfr -- 摊销频度
    ,amortst -- 摊销状态[n:未摊销,i:摊销中,s:摊销完成]
    ,amou01 -- 金额01
    ,amou02 -- 金额02
    ,amou03 -- 金额03
    ,amou04 -- 金额04
    ,amou05 -- 金额05
    ,amou06 -- 金额06
    ,amou07 -- 金额07
    ,attra1 -- 附加属性1
    ,attra2 -- 附加属性2
    ,attra3 -- 附加属性3
    ,attra4 -- 附加属性4
    ,attra5 -- 附加属性5
    ,attra6 -- 附加属性6
    ,attra7 -- 附加属性7
    ,attra8 -- 附加属性8
    ,attra9 -- 附加属性9
    ,attraa -- 附加属性10
    ,puprtg -- 客户类型
    ,islast -- 是否交易场景的最后一条，1-是，0-否
    ,eventp -- 交易场景
    ,tranti -- 时间
    ,chrgmd -- 收费方式
    ,changst -- 是否需要重新计算本次摊销金额（每次摊销金额）默认yn:不需要y:需要
    ,oridatadt -- 原表数据日期
    ,remark -- 历史备份说明
    ,' ' as tranbr -- 交易机构编号
    ,' ' as bsnssq -- 全局流水号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from tgls_ama_mdsr_acct_h_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/