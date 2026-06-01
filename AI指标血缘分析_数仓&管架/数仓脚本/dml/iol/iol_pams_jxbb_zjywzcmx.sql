/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zjywzcmx
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iol_schema}.pams_jxbb_zjywzcmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''pams_jxbb_zjywzcmx'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.pams_jxbb_zjywzcmx truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.pams_jxbb_zjywzcmx add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.pams_jxbb_zjywzcmx(
    tjrq -- 数据日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,gsjgdxdh -- 管护机构对象代号
    ,gsjgdh -- 管护机构代号
    ,gsjgmc -- 管护机构名称
    ,zwjgdxdh -- 归属机构对象代号
    ,zwjgdh -- 账务机构编号
    ,zwjgmc -- 归属机构名称
    ,khlx -- 客户类型
    ,jylsh -- 交易流水号
    ,qjlsh -- 全局流水号
    ,ywlsh -- 业务流水号
    ,sfdjh -- 收费单据号
    ,sflsh -- 收费流水号
    ,sfrq -- 收费日期
    ,jsrq -- 交易日期
    ,zwrq -- 账务日期
    ,txbz -- 摊销标志
    ,txlsh -- 摊销流水号
    ,txksrq -- 摊销开始日期
    ,txjsrq -- 摊销结束日期
    ,ljtxje -- 累计摊销金额
    ,dtze -- 待摊总金额
    ,jyje -- 交易金额
    ,bz -- 币种代码
    ,kmh -- 科目编号
    ,kmmc -- 科目名称
    ,bzcpbh -- 标准产品编号
    ,khh -- 客户编号
    ,khmc -- 客户名称
    ,khgstxlxdm -- 客户归属条线类型代码
    ,jyjgdh -- 交易机构代号
    ,jyjgdxdh -- 交易机构对象代号
    ,jyjgmc -- 交易机构名称
    ,jyzhbh -- 交易账户编号
    ,jyzzhbh -- 交易主账户编号
    ,jyczhbh -- 交易子账户编号
    ,jyqddm -- 交易渠道代码
    ,yxtdm -- 源系统代码
    ,hydh -- 客户经理编号
    ,hymc -- 行员名称
    ,sffsdm -- 收费方式代码
    ,sxfzqfs -- 手续费收取方式
    ,jylxdm -- 交易类型代码
    ,jdbz -- 借贷标志
    ,mzbz -- 抹账标志
    ,czbz -- 冲正标志
    ,xjjybz -- 现金交易标志
    ,etl_t -- ETL处理时间戳
    ,ywzhbh -- 业务账户编号
    ,ybbz -- 原表币种
    ,jyjeylj -- 交易金额月累计
    ,jyjejlj -- 交易金额季累计
    ,jyjenlj -- 交易金额年累计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 数据日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,gsjgdxdh -- 管护机构对象代号
    ,gsjgdh -- 管护机构代号
    ,gsjgmc -- 管护机构名称
    ,zwjgdxdh -- 归属机构对象代号
    ,zwjgdh -- 账务机构编号
    ,zwjgmc -- 归属机构名称
    ,khlx -- 客户类型
    ,jylsh -- 交易流水号
    ,qjlsh -- 全局流水号
    ,ywlsh -- 业务流水号
    ,sfdjh -- 收费单据号
    ,sflsh -- 收费流水号
    ,sfrq -- 收费日期
    ,jsrq -- 交易日期
    ,zwrq -- 账务日期
    ,txbz -- 摊销标志
    ,txlsh -- 摊销流水号
    ,txksrq -- 摊销开始日期
    ,txjsrq -- 摊销结束日期
    ,ljtxje -- 累计摊销金额
    ,dtze -- 待摊总金额
    ,jyje -- 交易金额
    ,bz -- 币种代码
    ,kmh -- 科目编号
    ,kmmc -- 科目名称
    ,bzcpbh -- 标准产品编号
    ,khh -- 客户编号
    ,khmc -- 客户名称
    ,khgstxlxdm -- 客户归属条线类型代码
    ,jyjgdh -- 交易机构代号
    ,jyjgdxdh -- 交易机构对象代号
    ,jyjgmc -- 交易机构名称
    ,jyzhbh -- 交易账户编号
    ,jyzzhbh -- 交易主账户编号
    ,jyczhbh -- 交易子账户编号
    ,jyqddm -- 交易渠道代码
    ,yxtdm -- 源系统代码
    ,hydh -- 客户经理编号
    ,hymc -- 行员名称
    ,sffsdm -- 收费方式代码
    ,sxfzqfs -- 手续费收取方式
    ,jylxdm -- 交易类型代码
    ,jdbz -- 借贷标志
    ,mzbz -- 抹账标志
    ,czbz -- 冲正标志
    ,xjjybz -- 现金交易标志
    ,etl_t -- ETL处理时间戳
    ,ywzhbh -- 业务账户编号
    ,ybbz -- 原表币种
    ,jyjeylj -- 交易金额月累计
    ,jyjejlj -- 交易金额季累计
    ,jyjenlj -- 交易金额年累计
    ,to_date(tjrq,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_zjywzcmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_zjywzcmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);