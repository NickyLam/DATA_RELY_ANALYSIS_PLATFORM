/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_lczh
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM pams_jxdx_lczh_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('pams_jxdx_lczh');
  
  if v_var <> 0 then 
    execute immediate 'alter table pams_jxdx_lczh drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table pams_jxdx_lczh add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
 
insert /*+ append */ into ${iol_schema}.pams_jxdx_lczh(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账号
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,xhrq -- 销户日期
            ,cpdm -- 产品代码
            ,cplb -- 产品类别
            ,cpmc -- 产品名称
            ,mjksr -- 募集开始日
            ,mjjsr -- 募集结束日
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,zhzt -- 账户状态
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,qxrq -- 起息日期
            ,zxrq -- 注销日期
            ,yqnhsyl -- 年化收益率
            ,cpyzsj -- 产品运作时间
            ,mrjehz -- 买入金额汇总
            ,cyfe -- 持有份额
            ,mjje -- 募集金额
            ,zjjszh -- 资金结算账户
            ,xssdm -- 销售商代码
            ,yhbh -- 银行编号
            ,zhbh -- 账户编号
            ,cplbzs -- 产品类别展示
            ,yqsylms -- 预期收益率描述
            ,lcywlx -- 理财业务类型
            ,nextkfqsrq -- 下一个开放起始日期
            ,nextkfjsrq1 -- 下一个开放结束日期
            ,fxjg -- 发行机构
            ,cpxldm -- 产品小类代码
            ,xsfl -- 销售费率
            ,cjfl -- 差价费率
            ,jz -- 净值
            ,mbbh -- 模板编号
            ,ztbz -- 在途标志：0-否，1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账号
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,xhrq -- 销户日期
            ,cpdm -- 产品代码
            ,cplb -- 产品类别
            ,cpmc -- 产品名称
            ,mjksr -- 募集开始日
            ,mjjsr -- 募集结束日
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,zhzt -- 账户状态
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,qxrq -- 起息日期
            ,zxrq -- 注销日期
            ,yqnhsyl -- 年化收益率
            ,cpyzsj -- 产品运作时间
            ,mrjehz -- 买入金额汇总
            ,cyfe -- 持有份额
            ,mjje -- 募集金额
            ,zjjszh -- 资金结算账户
            ,xssdm -- 销售商代码
            ,yhbh -- 银行编号
            ,zhbh -- 账户编号
            ,' ' as cplbzs -- 产品类别展示
            ,' ' as yqsylms -- 预期收益率描述
            ,' ' as lcywlx -- 理财业务类型
            ,0 as nextkfqsrq -- 下一个开放起始日期
            ,0 as nextkfjsrq1 -- 下一个开放结束日期
            ,' ' as fxjg -- 发行机构
            ,' ' as cpxldm -- 产品小类代码
            ,0 as xsfl -- 销售费率
            ,0 as cjfl -- 差价费率
            ,0 as jz -- 净值
            ,' ' as mbbh -- 模板编号
            ,' ' as ztbz -- 在途标志：0-否，1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from pams_jxdx_lczh_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
