/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zjywsrmx_recal
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;


--create partition 
--whenever sqlerror continue none ;
set serveroutput on
declare
  o_cnt number(22, 0) := 0; -- 原表数据量
  b_cnt number(22, 0) := 0; -- 备份表数据量
  v_flag number(10)   := 0; -- 判断标志
begin
	-- 判断原表中的分区并在重建后的表增加所有的分区
  for tb in (select table_name, partition_name, substr(partition_name, 3) as etl_dt
               from user_tab_partitions
              where table_name = upper('pams_jxbb_zjywsrmx_recal_bak_${batch_date}')
                and substr(partition_name, 3) <> '19000101'
                and substr(partition_name, 3) >= '20250722'
				and substr(partition_name, 3) < '20250922'
            ) loop

    -- 判断分区是否存在
	  select count(1)
	    into v_flag
	    from all_tab_partitions
	   where table_name = upper('pams_jxbb_zjywsrmx_recal')
	     and table_owner = 'IOL'
	     and partition_name = tb.partition_name;

	  -- 如果分区已经存在，则删除分区
	  if v_flag <> 0 then

	    execute immediate 'alter table iol.pams_jxbb_zjywsrmx_recal drop partition ' || tb.partition_name;

    end if;

      execute immediate 'alter table iol.pams_jxbb_zjywsrmx_recal add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt ||',''yyyymmdd''))';
	 
  end loop;
  
   dbms_output.put_line('pams_jxbb_zjywsrmx_recal');
end;

/

insert /*+ append */ into ${iol_schema}.pams_jxbb_zjywsrmx_recal(
    tjrq -- 数据入库日期
    ,recal_dt -- 重算日期
    ,jzlsh -- 记账流水号
    ,rzrq -- 入账日期
    ,tjrzrq -- 统计入账日期
    ,rzkm -- 入账科目
    ,kmmc -- 科目名称
    ,jzjgdh -- 记账机构编号
    ,jzjgmc -- 记账机构名称
    ,bz -- 币种
    ,khlx -- 客户类型
    ,hsje -- 含税金额
    ,shje -- 赎回金额
    ,se -- 税额
    ,txbz -- 摊销标识
    ,sfrq -- 收费日期
    ,sflsh -- 收费流水号
    ,sfje -- 收费金额
    ,ywbh -- 业务编号
    ,dybwkm -- 对应表外科目
    ,dybwje -- 对应表外金额
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jgdh -- 机构号
    ,jgmc -- 机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 行员名称
    ,zlbl -- 认领比例
    ,jyje -- 交易金额
    ,fphdyje -- 分配后当月金额
    ,fphljje -- 分配后累计金额
    ,ywlx -- 业务类型
    ,jgkhdxdh -- 机构考核对象代号
    ,jzjgkhdxdh -- 记账机构考核对象代号
    ,jxdxdh -- 绩效对象代号
    ,sfdm -- 收费代码,
    ,sfmc -- 收费名称
    ,ybbz -- 原币币种
    ,cpxdl -- 产品线大类
    ,sflx -- 算法类型
    ,sfz -- 身份证
    ,jzsf -- 基础收费
    ,sfxmc -- 收费名称
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,zylx -- 质押类型
    ,xyzbh -- 信用证编号
    ,jylsh -- 交易流水号
    ,sxfzqfs -- 手续费收取方式
    ,yxtdm -- 源系统代码
    ,gjywbs -- 国际业务标识：0-否，1-是
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 数据入库日期
    ,recal_dt -- 重算日期
    ,jzlsh -- 记账流水号
    ,rzrq -- 入账日期
    ,tjrzrq -- 统计入账日期
    ,rzkm -- 入账科目
    ,kmmc -- 科目名称
    ,jzjgdh -- 记账机构编号
    ,jzjgmc -- 记账机构名称
    ,bz -- 币种
    ,khlx -- 客户类型
    ,hsje -- 含税金额
    ,shje -- 赎回金额
    ,se -- 税额
    ,txbz -- 摊销标识
    ,sfrq -- 收费日期
    ,sflsh -- 收费流水号
    ,sfje -- 收费金额
    ,ywbh -- 业务编号
    ,dybwkm -- 对应表外科目
    ,dybwje -- 对应表外金额
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jgdh -- 机构号
    ,jgmc -- 机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 行员名称
    ,zlbl -- 认领比例
    ,jyje -- 交易金额
    ,fphdyje -- 分配后当月金额
    ,fphljje -- 分配后累计金额
    ,ywlx -- 业务类型
    ,jgkhdxdh -- 机构考核对象代号
    ,jzjgkhdxdh -- 记账机构考核对象代号
    ,jxdxdh -- 绩效对象代号
    ,sfdm -- 收费代码,
    ,sfmc -- 收费名称
    ,ybbz -- 原币币种
    ,cpxdl -- 产品线大类
    ,sflx -- 算法类型
    ,sfz -- 身份证
    ,jzsf -- 基础收费
    ,sfxmc -- 收费名称
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,' ' as zylx -- 质押类型
    ,' ' as xyzbh -- 信用证编号
    ,' ' as jylsh -- 交易流水号
    ,' ' as sxfzqfs -- 手续费收取方式
    ,' ' as yxtdm -- 源系统代码
    ,' ' as gjywbs -- 国际业务标识：0-否，1-是
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_jxbb_zjywsrmx_recal_bak_${batch_date} t1
 where t1.etl_dt >= to_date('20250722', 'yyyymmdd')
and t1.etl_dt < to_date('20250922', 'yyyymmdd');
 commit;
