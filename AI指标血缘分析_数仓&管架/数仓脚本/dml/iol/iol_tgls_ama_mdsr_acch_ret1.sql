/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ama_mdsr_acch
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;


declare
  v_flag number(10)   := 0; -- 判断标志


begin     
	-- 判断原表中的分区并在重建后的表增加所有的分区
  for tb in (SELECT datadt as etl_dt
               FROM itl.tgls_ama_mdsr_acch WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
              group by datadt
            ) loop
     
    -- 判断分区是否存在
	  select count(1)
	    into v_flag
	    from all_tab_partitions
	   where table_name = upper('tgls_ama_mdsr_acch')
	     and table_owner = 'IOL'
	     and substr(partition_name,3) = tb.etl_dt;

	  -- 如果分区已经存在，则删除分区
	  if v_flag <> 0 then

	    execute immediate 'alter table iOl.tgls_ama_mdsr_acch drop partition p_' || tb.etl_dt;

    end if;

    -- 增加分区        
      execute immediate 'alter table iOl.tgls_ama_mdsr_acch add partition p_' || tb.etl_dt || ' values (to_date(' || tb.etl_dt ||',''yyyymmdd''))';


insert /*+ append */ into ${iol_schema}.tgls_ama_mdsr_acch(
    stacid -- 账套
    ,systid -- 来源系统编号
    ,loanno -- 单据编号
    ,datadt -- 数据日期
    ,trandt -- 交易日期[变动日期]
    ,sortno -- 序号
    ,transq -- 交易流水
    ,trancd -- 子交易
    ,bathid -- 批次号
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
    ,tranti -- 时间
    ,eventp -- 交易场景
    ,amortamredu -- 剩余摊销金额
    ,daynum -- 摊销天数
    ,amorfr -- 摊销频度
    ,chrgmd -- 收费方式
    ,changst -- 是否需要重新计算 本次摊销金额（每次摊销金额） 默认y n:不需要 y:需要
    ,desccg -- 分户余额变动说明
    ,bsnssq -- 全局流水号
    ,tranbr -- 交易机构
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 来源系统编号
    ,loanno -- 单据编号
    ,datadt -- 数据日期
    ,trandt -- 交易日期[变动日期]
    ,sortno -- 序号
    ,transq -- 交易流水
    ,trancd -- 子交易
    ,bathid -- 批次号
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
    ,amortst -- 摊销状态[n:未摊销,i:摊销中,s:摊销完成]
    ,amou01 -- 金额01
    ,amou02 -- 金额02
    ,amou03 -- 金额03
    ,0 as amou04 -- 金额04
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
    ,tranti -- 时间
    ,eventp -- 交易场景
    ,amortamredu -- 剩余摊销金额
    ,daynum -- 摊销天数
    ,amorfr -- 摊销频度
    ,chrgmd -- 收费方式
    ,changst -- 是否需要重新计算 本次摊销金额（每次摊销金额） 默认y n:不需要 y:需要
    ,desccg -- 分户余额变动说明
    ,bsnssq -- 全局流水号
    ,tranbr -- 交易机构
    ,to_date(datadt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_ama_mdsr_acch
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
and datadt = tb.etl_dt;
commit;

  end loop;

end;

/ 