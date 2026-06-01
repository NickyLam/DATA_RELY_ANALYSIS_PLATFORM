set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

alter table ${idl_schema}.mc_banking_q add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;



-- 同业7个指标
drop table ${idl_schema}.mc_banking_q_temp01 purge;
-- 6个指标及平均值
drop table ${idl_schema}.mc_banking_q_temp02 purge;  
-- 结果计算
drop table ${idl_schema}.mc_banking_q_temp03 purge;  
-- 结果计算
drop table ${idl_schema}.mc_banking_q_temp04 purge;      
-- 存款替换
drop table ${idl_schema}.mc_banking_q_temp05 purge;   
whenever sqlerror exit sql.sqlcode; 


-- 清空分区
alter table ${idl_schema}.mc_banking_q truncate partition p_${batch_date};
-- 以下为依赖了万德的表：
-- mtl_wind_asharebalancesheet                 -- 中国A股资产负债表
-- mtl_wind_unlistedbankbalancesheet           -- 非上市银行资产负债表
-- mtl_wind_asharebankindicator                -- 中国A股银行专用指标
-- mtl_wind_unlistedbankindicator              -- 非上市银行专用指标
-- mtl_wind_ashareincome                       -- 中国A股利润表
-- mtl_wind_unlistedbankincome                 -- 非上市银行利润表

/*
FM0100001	财务指标	财务指标	规模指标	    规模指标	    GM01000000	规模类	资产状况	总览	  资产总额
FM0100054	财务指标	财务指标	规模指标	    规模指标	    GM02011000	规模类	负债状况	总览	  存款总额
FM0100002	财务指标	财务指标	规模指标	    规模指标	    GM01015000	规模类	资产状况	贷款	  贷款总额
FM0300007	财务指标	财务指标	利润指标	    利润指标	    YL03030000	盈利类	利润状况	总览	  净利润
FM0500002	财务指标	财务指标	盈利能力指标	盈利能力指标	YL04021000	盈利类	效率状况	收益率	平均资产收益率（ROAA）
FM0500004	财务指标	财务指标	盈利能力指标	盈利能力指标	YL04022000	盈利类	效率状况	收益率	加权平均净资产收益率（ROAE)
RM0200001	风险指标	风险指标	资产质量	    资产质量	    FX02024000	风险类	资产质量	不良	  不良贷款率
*/

whenever sqlerror exit sql.sqlcode; 
-- 2.1 insert data to table

-- 同业7个指标
            
-- mc_banking_q_temp01存储直接从数仓取得的数据
create table  ${idl_schema}.mc_banking_q_temp01
as   
 -- TY01010000 资产总额                          
select     t1.S_INFO_COMPCODE           as S_INFO_COMPCODE			                                                                         
      ,t1.S_INFO_COMPCODE	              as org_no        -- 公司ID             
      ,t1.TOT_ASSETS	                  as indx_val      -- 资产总计          
      ,t1.CRNCY_CODE	                  as CURR_NO       -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1  as etl_dt
      ,'TY01010000'                     as indx_no 
      ,max(t1.etl_dt)                   as max_dt       
from  mtl_WIND_ASHAREBALANCESHEET t1                     -- 中国A股资产负债表
where t1.CRNCY_CODE = 'CNY'
  and t1.statement_type = '408001000'                    -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')   -- 跑上个季度末数据
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by  t1.S_INFO_COMPCODE 
      ,t1.TOT_ASSETS 
      ,t1.CRNCY_CODE 
union all
select     t1.S_INFO_COMPCODE          as S_INFO_COMPCODE			                                                                       
      ,t1.S_INFO_COMPCODE	             as org_no        -- 公司ID             
      ,t1.TOT_ASSETS	                 as indx_val      -- 资产总计          
      ,t1.CRNCY_CODE	                 as CURR_NO       -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1  as etl_dt
      ,'TY01010000'                    as indx_no  
      ,max(t1.etl_dt)                   as max_dt  
from mtl_WIND_UNLISTEDBANKBALANCESHEET t1      -- 非上市银行资产负债表
where t1.CRNCY_CODE = 'CNY'
  and t1.statement_type = '408001000'          -- 合并报表(调整)
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')     -- 跑上个季度末数据
group by  t1.S_INFO_COMPCODE 
      ,t1.TOT_ASSETS 
      ,t1.CRNCY_CODE 
;
-- 取资产负债表中的【吸收存款】这个字段的数据
CREATE TABLE  ${idl_schema}.mc_banking_q_temp05 compress
AS   
SELECT *
FROM mc_banking_q_temp01
WHERE 1=2
;

INSERT INTO  ${idl_schema}.mc_banking_q_temp05
SELECT T1.S_INFO_COMPCODE                                AS S_INFO_COMPCODE		
      ,T1.S_INFO_COMPCODE	                               AS org_no           -- 公司名称        	                                                                         
      ,T1.CUST_BANK_DEP	                                 AS INDX_VAL         -- 吸收存款          
      ,T1.CRNCY_CODE	                                   AS CURR_NO          -- 货币代码 
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT
      ,'TY01011000'                                      AS INDX_NO       
      ,MAX(T1.ETL_DT)                                    AS MAX_DT       
from  mtl_WIND_ASHAREBALANCESHEET T1                                         -- 中国A股资产负债表
where T1.CRNCY_CODE = 'CNY'
  AND T1.statement_type = '408001000'          -- 合并报表(调整)
  AND T1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')           -- 跑上个季度末数据
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')                                                              -- 排除华兴银行（20200902）
group by  T1.S_INFO_COMPCODE 
      ,T1.CUST_BANK_DEP 
      ,T1.CRNCY_CODE
union all
select T1.S_INFO_COMPCODE                                AS S_INFO_COMPCODE	
      ,T1.S_INFO_COMPCODE	                               AS ORG_NAME         -- 公司名称  		                                                                       
      ,T1.CUST_BANK_DEP	                                 AS INDX_VAL         -- 吸收存款          
      ,T1.CRNCY_CODE	                                   AS CURR_NO          -- 货币代码  
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT
      ,'TY01011000'                                      AS INDX_NO  
      ,MAX(T1.ETL_DT)                                    AS MAX_DT  
from mtl_WIND_UNLISTEDBANKBALANCESHEET T1      -- 非上市银行资产负债表
where T1.CRNCY_CODE = 'CNY'
  AND T1.statement_type = '408001000'          -- 合并报表(调整)
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491') 
  AND T1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')     -- 跑上个季度末数据
group by  T1.S_INFO_COMPCODE 
      ,T1.CUST_BANK_DEP 
      ,T1.CRNCY_CODE 
;
commit ;


-- TY01011000	存款总额
insert into  ${idl_schema}.mc_banking_q_temp01  
select     t1.S_INFO_WINDCODE           as S_INFO_COMPCODE	-- 无 S_INFO_COMPCODE字锻                                        
      ,t1.S_INFO_WINDCODE	              as org_no        -- 公司ID             
      ,CASE WHEN COALESCE(T1.TOTAL_DEPOSIT,0)	= 0 THEN COALESCE(T3.INDX_VAL,0)
            ELSE COALESCE(T1.TOTAL_DEPOSIT,0)	
       END                              as indx_val      -- 存款总额         
      ,t1.CRNCY_CODE	                  as curr_no       -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt                 
      ,'TY01011000'                     as indx_no
      ,max(t1.etl_dt)                   as max_dt  
from mtl_WIND_ASHAREBANKINDICATOR t1           -- 中国A股银行专用指标
LEFT JOIN mc_banking_q_temp05 T3
   ON T3.S_INFO_COMPCODE = T1.S_INFO_WINDCODE
  AND T3.ETL_DT = T1.REPORT_PERIOD
  AND T3.CURR_NO = T1.CRNCY_CODE
  AND T3.INDX_NO = 'TY01011000'
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type = '408001000'          -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')     -- 跑上个季度末数据
  and t1.S_INFO_WINDCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by  t1.S_INFO_WINDCODE 
      ,CASE WHEN COALESCE(T1.TOTAL_DEPOSIT,0)	= 0 THEN COALESCE(T3.INDX_VAL,0)
            ELSE COALESCE(T1.TOTAL_DEPOSIT,0)	
       END
      ,t1.CRNCY_CODE 
union all
select     t1.S_INFO_COMPCODE           as S_INFO_COMPCODE			                                                                       
      ,t1.S_INFO_COMPCODE	              as org_no        -- 公司ID             
      ,CASE WHEN COALESCE(T1.TOTAL_DEPOSIT,0)	= 0 THEN COALESCE(T3.INDX_VAL,0)
            ELSE COALESCE(T1.TOTAL_DEPOSIT,0)	
       END                              as indx_val      -- 存款总额        
      ,t1.CRNCY_CODE	                  as CURR_NO       -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1as etl_dt
      ,'TY01011000'                     as indx_no
      ,max(t1.etl_dt)                   as max_dt  
from mtl_WIND_UNLISTEDBANKINDICATOR t1         -- 非上市银行专用指标
LEFT JOIN mc_banking_q_temp05 T3
   ON T3.S_INFO_COMPCODE = T1.S_INFO_COMPCODE
  AND T3.ETL_DT = T1.REPORT_PERIOD
  AND T3.CURR_NO = T1.CRNCY_CODE
  AND T3.INDX_NO = 'TY01011000'
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type = '408001000'          -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')    -- 跑上个季度末数据
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by  t1.S_INFO_COMPCODE 
      ,CASE WHEN COALESCE(T1.TOTAL_DEPOSIT,0)	= 0 THEN COALESCE(T3.INDX_VAL,0)
            ELSE COALESCE(T1.TOTAL_DEPOSIT,0)	
       END
      ,t1.CRNCY_CODE 
;

commit;


-- TY01021000	贷款总额
insert into  ${idl_schema}.mc_banking_q_temp01  
select     t1.S_INFO_WINDCODE            as S_INFO_COMPCODE	-- 无 S_INFO_COMPCODE字锻		                                                                        
      ,t1.S_INFO_WINDCODE	               as org_no          -- 公司ID             
      ,t1.TOTAL_LOAN	                   as indx_val        -- 贷款总额          
      ,t1.CRNCY_CODE	                   as CURR_NO         -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt
      ,'TY01021000'                      as indx_no
      ,max(t1.etl_dt)                    as max_dt  
from mtl_WIND_ASHAREBANKINDICATOR t1             -- 中国A股银行专用指标
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type = '408001000'            -- 合并报表  
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')    -- 跑上个季度末数据        -- 报告日期 
  and t1.S_INFO_WINDCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_WINDCODE
      ,t1.TOTAL_LOAN	
      ,t1.CRNCY_CODE
 union all
select      t1.S_INFO_COMPCODE           as S_INFO_COMPCODE			                                                                     
      ,t1.S_INFO_COMPCODE	               as org_no         -- 公司ID              S_INFO_WINDCODE	Wind代码
      ,t1.TOTAL_LOAN	                   as indx_val       -- 贷款总额          
      ,t1.CRNCY_CODE	                   as CURR_NO        -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt
      ,'TY01021000'                      as indx_no
      ,max(t1.etl_dt)                    as max_dt  
from mtl_WIND_UNLISTEDBANKINDICATOR t1           -- 非上市银行专用指标
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type = '408001000'            -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')     -- 跑上个季度末数据
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_COMPCODE
      ,t1.TOTAL_LOAN	
      ,t1.CRNCY_CODE
;

commit;


-- TY02011000	净利润
insert into  ${idl_schema}.mc_banking_q_temp01  
select     t1.S_INFO_COMPCODE            as S_INFO_COMPCODE			                                                                        
      ,t1.S_INFO_COMPCODE	               as org_no        -- 公司ID
      ,t1.NET_PROFIT_INCL_MIN_INT_INC	   as indx_val      -- 净利润(含少数股东损益) -- 20200909 修改净利润差额为净利润
      ,t1.CRNCY_CODE	                   as CURR_NO       -- 货币代码
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt
      ,'TY02011000'                      as indx_no
      ,max(t1.etl_dt)                    as max_dt  
from mtl_WIND_ASHAREINCOME t1                      -- 中国A股利润表
where t1.CRNCY_CODE = 'CNY'
  and t1.statement_type = '408001000'              -- 合并报表
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')     -- 跑上个季度末数据
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_COMPCODE
      ,t1.NET_PROFIT_INCL_MIN_INT_INC
      ,t1.CRNCY_CODE
union all
select     t1.S_INFO_COMPCODE            as S_INFO_COMPCODE			                                                                        
      ,t1.S_INFO_COMPCODE	               as org_no        -- 公司ID             
      ,t1.NET_PROFIT_INCL_MIN_INT_INC	   as indx_val      -- 净利润(含少数股东损益)
      ,t1.CRNCY_CODE	                   as CURR_NO       -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt
      ,'TY02011000'                      as indx_no
      ,max(t1.etl_dt)                    as max_dt  
from mtl_WIND_UNLISTEDBANKINCOME t1               -- 非上市银行利润表
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type = '408001000'             -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')    -- 跑上个季度末数据
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_COMPCODE
      ,t1.NET_PROFIT_INCL_MIN_INT_INC
      ,t1.CRNCY_CODE

;
commit;


-- TY03021000	不良率
insert into  ${idl_schema}.mc_banking_q_temp01  
select t1.S_INFO_WINDCODE                as S_INFO_COMPCODE		-- 无 S_INFO_COMPCODE字锻		                                                                       
      ,t1.S_INFO_WINDCODE	               as org_no            -- 公司ID
      ,COALESCE(t1.NPL_RATIO,0)/100	     as indx_val          -- 不良贷款比例
      ,t1.CRNCY_CODE	                   as CURR_NO           -- 货币代码
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1  as etl_dt
      ,'TY03021000'                      as indx_no
      ,max(t1.etl_dt)                    as max_dt  
from mtl_WIND_ASHAREBANKINDICATOR t1                -- 中国A股银行专用指标
where CRNCY_CODE = 'CNY'
  and t1.statement_type = '408001000'               -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')     -- 跑上个季度末数据
  and t1.S_INFO_WINDCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by  t1.S_INFO_WINDCODE
      ,COALESCE(t1.NPL_RATIO,0)/100	 
      ,t1.CRNCY_CODE
union all
select t1.S_INFO_COMPCODE                as S_INFO_COMPCODE			                                                                       
      ,t1.S_INFO_COMPCODE	               as org_no            -- 公司ID             
      ,COALESCE(t1.NPL_RATIO,0)/100	     as indx_val          -- 不良贷款比例
      ,t1.CRNCY_CODE	                   as CURR_NO           -- 货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt
      ,'TY03021000'                      as indx_no
      ,max(t1.etl_dt)                   as max_dt  
from mtl_WIND_UNLISTEDBANKINDICATOR t1              -- 非上市银行专用指标
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type = '408001000'               -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd')    -- 跑上个季度末数据           -- 报告日期
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by  t1.S_INFO_COMPCODE
      ,COALESCE(t1.NPL_RATIO,0)/100	
      ,t1.CRNCY_CODE
      
;
commit;

 
-- mc_banking_q_temp01 存储从数仓取得数据但需要自算的结果
-- TY02021000	总资产收益率（ROAA）
insert into  ${idl_schema}.mc_banking_q_temp01
select  t1.S_INFO_COMPCODE                               as S_INFO_COMPCODE	
       ,t1.S_INFO_COMPCODE	                             as org_no--公司ID             
       ,case when coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0) = 0 then 0
             else cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	
                        /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                        /((coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0))/2)
                                                         as NUMBER(30,8)) 
        end                                              as indx_val---总资产收益率（ROAA）
       ,t1.CRNCY_CODE	                                   as CURR_NO --货币代码           
       ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt
       ,'TY02021000'                                     as indx_no
       ,max(t1.etl_dt)                                   as max_dt  
 from mtl_WIND_UNLISTEDBANKINCOME t1
 left join mtl_WIND_UNLISTEDBANKBALANCESHEET t2
        on t1.S_INFO_COMPCODE = t2.S_INFO_COMPCODE
       and t1.CRNCY_CODE	= t2.CRNCY_CODE	
       and t2.statement_type =  '408001000'           -- 合并报表(调整)
      and t2.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyyMMdd')        --报告日期      
 left join mtl_WIND_UNLISTEDBANKBALANCESHEET t3
        on t1.S_INFO_COMPCODE = t3.S_INFO_COMPCODE
       and t1.CRNCY_CODE	= t3.CRNCY_CODE	
       and t3.statement_type =  '408001000'           -- 合并报表(调整)
       and t3.report_period = to_char(trunc(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yy')-1 ,'yyyyMMdd')  --期初报告日期（年初）
 where t1.CRNCY_CODE  ='CNY'
     and t1.statement_type =  '408001000'             -- 合并报表 
     and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyyMMdd')   -- 跑上个季度末数据           --报告日期 
     and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_COMPCODE
       ,case when coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0) = 0 then 0
             else cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	
                        /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                        /((coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0))/2)
                                                         as NUMBER(30,8)) 
        end 
       ,t1.CRNCY_CODE	
UNION ALL
select     t1.S_INFO_COMPCODE                            as S_INFO_COMPCODE			                                                                      
      ,t1.S_INFO_WINDCODE	                               as org_no  --公司ID             
      ,case when coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0) = 0  then 0
            else  cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	   
                       /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                       /((coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0))/2)
                                                         as NUMBER(30,8))  
       end                                               as indx_val---总资产收益率（ROAA）
      ,t1.CRNCY_CODE	                                   as CURR_NO --货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1  as etl_dt
      ,'TY02021000'                                      as indx_no
      ,max(t1.etl_dt)                                    as max_dt  
from mtl_WIND_ASHAREINCOME t1                       -- 中国A股利润表
left join mtl_WIND_ASHAREBALANCESHEET t2            -- 中国A股资产负债表
       on t1.S_INFO_WINDCODE = t2.S_INFO_WINDCODE
      and t1.CRNCY_CODE	= t2.CRNCY_CODE	
      and t2.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 ,'yyyyMMdd')        -- 报告日期   
      and t2.statement_type =  '408001000'          -- 合并报表(调整)
left join mtl_WIND_ASHAREBALANCESHEET t3            -- 中国A股资产负债表
       on t1.S_INFO_WINDCODE = t3.S_INFO_WINDCODE
      and t1.CRNCY_CODE	= t3.CRNCY_CODE	
      and t3.report_period = to_char(trunc(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yy')-1 ,'yyyyMMdd')   --期初报告日期（年初）
      and t3.statement_type =  '408001000'           -- 合并报表(调整)
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type =  '408001000'               -- 合并报表(调整)
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyyMMdd')   -- 跑上个季度末数据           --报告日期
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_COMPCODE
      ,t1.S_INFO_WINDCODE	
      ,case when coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0) = 0  then 0
            else  cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	   
                       /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                       /((coalesce(t2.TOT_ASSETS,0) + coalesce(t3.TOT_ASSETS,0))/2)
                                                         as NUMBER(30,8))  
       end
      ,t1.CRNCY_CODE	       
;
commit ;

       
-- TY02022000	净资产收益率（ROAE）      
insert into  ${idl_schema}.mc_banking_q_temp01
select t1.S_INFO_COMPCODE                                as S_INFO_COMPCODE	
       ,t1.S_INFO_COMPCODE	                             as org_no--公司ID             
       ,case when  coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) = 0   then 0
             else cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	
                        /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                        /(( coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0))/2) 
                                                         as NUMBER(30,8))    
        end                                              as indx_val---净资产收益率（ROAE）
       ,t1.CRNCY_CODE	                                   as CURR_NO --货币代码           
       ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1 as etl_dt
       ,'TY02022000'                                     as indx_no
       ,max(t1.etl_dt)                                   as max_dt  
 from mtl_WIND_UNLISTEDBANKINCOME t1
 left join mtl_WIND_UNLISTEDBANKBALANCESHEET t2
        on t1.S_INFO_COMPCODE = t2.S_INFO_COMPCODE
       and t1.CRNCY_CODE	= t2.CRNCY_CODE	
       and t2.statement_type =  '408001000'          -- 合并报表(调整)
      and t2.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyyMMdd')       --报告日期       
 left join mtl_WIND_UNLISTEDBANKBALANCESHEET t3
        on t1.S_INFO_COMPCODE = t3.S_INFO_COMPCODE
       and t1.CRNCY_CODE	= t3.CRNCY_CODE	
       and t3.statement_type =  '408001000'          -- 合并报表(调整)
       and t3.report_period = to_char(trunc(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yy')-1 ,'yyyyMMdd')  --期初报告日期（年初）
 where t1.CRNCY_CODE  ='CNY'
   and t1.statement_type =  '408001000'              -- 合并报表 
   and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyyMMdd')   -- 跑上个季度末数据           --报告日期  
   and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_COMPCODE
       ,case when  coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) = 0   then 0
             else cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	
                        /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                        /(( coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0))/2) 
                                                          as NUMBER(30,8))    
        end
       ,t1.CRNCY_CODE	
union all
select     t1.S_INFO_COMPCODE                            as S_INFO_COMPCODE			                                                                    
      ,t1.S_INFO_WINDCODE	                               as org_no--公司ID             
      ,case when coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) = 0 then 0
            else cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	
                      /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                      /((coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0))/2)
                                                         as NUMBER(30,8))
       end                                               as indx_val---净资产收益率（ROAE）   
      ,t1.CRNCY_CODE	                                   as CURR_NO --货币代码           
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1  as etl_dt
      ,'TY02022000'                                      as indx_no
      ,max(t1.etl_dt)                                    as max_dt  
from mtl_WIND_ASHAREINCOME t1                      -- 中国A股利润表
left join mtl_WIND_ASHAREBALANCESHEET t2           -- 中国A股资产负债表  期初净资产
       on t1.S_INFO_WINDCODE = t2.S_INFO_WINDCODE
      and t1.CRNCY_CODE	= t2.CRNCY_CODE	
      and t2.statement_type =  '408001000'          -- 合并报表(调整)
      and t2.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyyMMdd')    --报告日期   
left join mtl_WIND_ASHAREBALANCESHEET t3            -- 中国A股资产负债表
       on t1.S_INFO_WINDCODE = t3.S_INFO_WINDCODE
      and t1.CRNCY_CODE	= t3.CRNCY_CODE	
      and t3.statement_type =  '408001000'          -- 合并报表(调整)
      and t3.report_period = to_char(trunc(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yy')-1 ,'yyyyMMdd')  --期初报告日期（年初）
where t1.CRNCY_CODE  ='CNY'
  and t1.statement_type =  '408001000'              -- 合并报表 
  and t1.report_period = to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyyMMdd')        -- 跑上个季度末数据 --报告日期 
  and t1.S_INFO_COMPCODE in ('502045086','1AI997EA31','04863CDE01','04A5778076','0PH6B96491')
group by t1.S_INFO_COMPCODE 
      ,t1.S_INFO_WINDCODE
      ,case when coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) = 0 then 0
            else cast(coalesce(t1.NET_PROFIT_INCL_MIN_INT_INC,0)	
                      /cast(substr(to_char(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yyyymmdd'),5,2) as decimal(4,0)) *12
                      /((coalesce(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT,0) + coalesce(t3.TOT_SHRHLDR_EQY_INCL_MIN_INT,0))/2) 
                                                        as NUMBER(30,8))
       end 
      ,t1.CRNCY_CODE
;
commit;  



-- 添加机构为华兴银行的数据，数据出自指标结果表
-- 华兴的不良贷款率需要特殊处理成百分比的值
insert into  ${idl_schema}.mc_banking_q_temp01  
select 'TzdUzhXR2n'                       as S_INFO_COMPCODE   -- 华兴银行                                                                           
      ,t1.ORG_NO                          as ORG_NO            -- 公司ID
      ,CASE WHEN INDEX_NO = 'FX02024000' THEN COALESCE(t1.index_value,0)
            WHEN INDEX_NO = 'YL03030000' THEN COALESCE(t1.ACCU_INDEX_VALUE_Y,0)
            ELSE COALESCE(t1.INDEX_VALUE,0)
       END                                as INDX_VAL          -- 指标值
      ,'CNY'                              as CURR_NO           -- 货币代码置成本外币
      ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1  as etl_dt
      ,CASE WHEN INDEX_NO = 'GM01000000'   THEN  'TY01010000'
            WHEN INDEX_NO = 'GM02011000'   THEN  'TY01011000'
            WHEN INDEX_NO = 'GM01015000'   THEN  'TY01021000'
            WHEN INDEX_NO = 'YL03030000'   THEN  'TY02011000'
            WHEN INDEX_NO = 'YL04021000'   THEN  'TY02021000'
            WHEN INDEX_NO = 'YL04022000'   THEN  'TY02022000'
            WHEN INDEX_NO = 'FX02024000'   THEN  'TY03021000'
       END                                as indx_no
      ,t1.etl_dt                          as max_dt  
from mc_index_fact t1                -- 中国A股银行专用指标
where  t1.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1     -- 跑上个季度末数据
  and t1.measure_no = '001'
  and t1.org_no = '000000'
  and t1.curr_no = 'BWB'
  and t1.index_no in ('GM01000000',   --资产总额                          GM01000000 FM0100001
                      'GM02011000',   --存款总额                          GM02011000 FM0100054
                      'GM01015000',   --贷款总额                          GM01015000 FM0100002
                      'YL03030000',   --净利润                            YL03030000 FM0300007
                      'YL04021000',   --平均资产收益率（ROAA）            YL04021000 FM0500002
                      'YL04022000',   --加权平均净资产收益率（ROAE)       YL04022000 FM0500004
                      'FX02024000'    --不良贷款率                        FX02024000 RM0200001
                     )
;
commit ;   



                                             
--   所有参数表机构 
create table  ${idl_schema}.mc_banking_q_temp02
as 
select t1.S_INFO_COMPCODE               as S_INFO_COMPCODE			                                
      ,t2.banking_name                  as banking_name  -- 银行名称  
      ,t2.banking_sort                  as banking_sort  -- 银行性质分类
      ,t2.banking_ipo                   as banking_ipo   -- 银行上市分类                                   
      ,t1.org_no	                      as org_no        -- 公司ID             
      ,t1.indx_val	                    as indx_val      -- 资产总计          
      ,t1.CURR_NO	                      as CURR_NO       -- 货币代码           
      ,t1.etl_dt
      ,indx_no                          as indx_no             
from  mc_banking_q_temp01 t1                   -- 临时表
left join MC_BANKING_PARA t2
     on trim(t1.S_INFO_COMPCODE) = trim(t2.S_INFO_COMPCODE)
where t1.CURR_NO = 'CNY'
  and t1.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1   -- 跑上个季度末数据
 
;
-- 同一天一条机构多个值时,机构取一个最大值
create table  ${idl_schema}.mc_banking_q_temp03
as 
select 
      t1.s_info_compcode 
     ,t1.banking_name    
     ,t1.banking_sort    
     ,t1.banking_ipo     
     ,t1.org_no	        
     ,t1.indx_val	      
     ,t1.curr_no	        
     ,t1.etl_dt          
     ,t1.indx_no                 
from 
(
    select t1.S_INFO_COMPCODE               as s_info_compcode			                                
          ,t2.banking_name                  as banking_name  -- 银行名称  
          ,t2.banking_sort                  as banking_sort  -- 银行性质分类
          ,t2.banking_ipo                   as banking_ipo   -- 银行上市分类                                   
          ,t1.org_no	                      as org_no        -- 公司ID             
          ,t1.indx_val	                    as indx_val      -- 资产总计          
          ,t1.CURR_NO	                      as curr_no       -- 货币代码           
          ,t1.etl_dt
          ,t1.indx_no                          as indx_no 
          ,row_number()over(partition by t1.S_INFO_COMPCODE,t1.indx_no order by t1.indx_val desc ) as  index_ranking             
    from  mc_banking_q_temp01 t1
    inner join mc_banking_para t2
         on t1.S_INFO_COMPCODE = t2.S_INFO_COMPCODE
    where t1.CURR_NO = 'CNY'
      and t1.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1   -- 跑上个季度末数据  
)  t1
where t1.index_ranking=1
;



create table  ${idl_schema}.mc_banking_q_temp04
as                                                                                            
select    t2.S_INFO_COMPCODE                        as S_INFO_COMPCODE			                                
			   ,t2.banking_name                           as banking_name            --银行名称  
         ,t2.banking_sort                           as banking_sort            --银行性质分类
         ,t2.banking_ipo                            as banking_ipo             --银行上市分类                                   
				 ,t1.index_no_mcs                           as INDEX_NO                --指标编码                                                           
         ,t1.index_name_mcs                         as INDEX_NAME              --指标名称                                                          
         ,t2.org_no                                                            --机构编码                                                          
         ,t2.banking_name                           as ORG_NAME                --公司名称                                                        
         ,' '	                                      as super_org_no            --上级机构编号                                                                         
         ,'null'                                    as ORG_SORT                --机构分类                                                          
         ,t2.CURR_NO                                as CURR_NO                 --币种编号                                                          
         ,'人民币'                                  as CURR_NAME               --币种名称
         ,t2.indx_val                               as INDEX_VALUE             --指标值                                                           
         ,0                                         as ACCU_INDEX_VALUE        --当年累计                                                          
         ,0                                         as RATE_UP_DAY             --比上日   
         ,0                                         as RATE_LAST_MONTH         --比上月                                                                                                                             --比上月                                                           
         ,0                                         as RATE_LAST_YEAR          --比上年                                                           
         ,0                                         as RATE_LAST_PERIOD        --同比                                                            
         ,0                                         as RATE_UP_DAY_PER         --比上日百分比                                                        
         ,0                                         as RATE_LAST_MONTH_PER     --比上月百分比                                                        
         ,0                                         as RATE_LAST_YEAR_PER      --比上年百分比
         ,0                                         as RATE_LAST_PERIOD_PER    --同比百分比                                                         
         ,0                                         as  INDEX_RANKING          --当前排名                                                          
         ,0                                         as INDEX_RANKING_CHA       --排名变动                                                                                                                           
         ,cast (null          as number(20,4))      as RATIO_ORG    
         ,t1.UNIT             --单位                                                            
         ,t1.FREQUENCY        --频度                                                            
         ,'001'                                     as MEASURE_NO                --度量编号                                                          
         ,'原始统计值'                              as INDEX_MEASURE             --度量名称                                                          
         ,to_date('${batch_date}','yyyymmdd')       as etl_dt                    --数据日期      
 from  mc_index_define t1 
 inner join mc_banking_q_temp02 t2  
         on t1.index_no_mcs = t2.indx_no

;




 insert into ${idl_schema}.mc_banking_q	  
   (
    WIND_CODE                 --万德ID 
   ,BANKING_NAME              --银行名称     
   ,BANKING_SORT              --银行性质分类   
   ,BANKING_IPO               --银行上市分类  
   ,INDEX_NO                  --指标编号
   ,INDEX_NAME                --指标名称  
   ,INDEX_VALUE               --指标值   
   ,ACCU_INDEX_VALUE          --当年累计 
   ,RATE_UP_DAY               --比上日   
   ,RATE_LAST_MONTH           --比上月   
   ,RATE_LAST_YEAR            --比上年   
   ,RATE_LAST_PERIOD          --同比     
   ,RATE_UP_DAY_PER           --比上日百分比 
   ,RATE_LAST_MONTH_PER       --比上月百分比 
   ,RATE_LAST_YEAR_PER        --比上年百分比 
   ,RATE_LAST_PERIOD_PER      --同比百分比 
   ,INDEX_RANKING_CCB         --当前排名 
   ,INDEX_VALUE_AVG_CCB       --排名变动   
   ,ETL_DT                    --  ETL处理日期  
   ,REPORT_PERIOD             -- 报告日期
   ,ETL_TIMESTAMP             --  数据跑批时间                    
    ) 
    select S_INFO_COMPCODE	
          ,banking_name     
          ,banking_sort     
          ,banking_ipo      
          ,INDEX_NO                  --指标编码 
          ,INDEX_NAME                --指标名称 
          ,INDEX_VALUE               --指标值   
          ,ACCU_INDEX_VALUE          --年累计值        
          ,RATE_UP_DAY               --比上日   
          ,RATE_LAST_MONTH           --比上月   
          ,RATE_LAST_YEAR            --比上年   
          ,RATE_LAST_PERIOD          --同比     
          ,RATE_UP_DAY_PER           --比上日百分比 
          ,RATE_LAST_MONTH_PER       --比上月百分比 
          ,RATE_LAST_YEAR_PER        --比上年百分比 
          ,RATE_LAST_PERIOD_PER      --同比百分比 
          ,INDEX_RANKING             --当前排名 
          ,INDEX_RANKING_CHA         --排名变动          
          ,ETL_DT                    --  ETL处理日期   
          ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1   -- 报表日期为上个季度末数据
          ,cast(to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as TIMESTAMP(6))as etl_timestamp                         
    from mc_banking_q_temp04
    ;
	  commit;

-- 删除表上个季度末数据
delete from ${idl_schema}.mc_bank_benc where etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1   
;
commit ;

-- 插入数据
 insert into ${idl_schema}.mc_bank_benc	  
   (
     ETL_DT         -- etl数据日期
    ,WIND_CODE      -- 万德ID
    ,ORG_NO         -- 机构编码
    ,ORG_NAME       -- 机构名称
    ,CURR_NO        -- 币种编号
    ,CURR_NAME      -- 币种
    ,BANK_NAME      -- 银行名称
    ,ASSETS_TOTAL   -- 资产总额
    ,DEPOSITS       -- 存款总额
    ,LENDING_TOTAL  -- 贷款总额
    ,NET_PROFITS    -- 净利润
    ,ROAA           -- ROAA
    ,ROAE           -- ROAE
    ,DEFECT_RATE    -- 不良率
    ,FREQUENCY      -- 频度                    
    ) 
    select  trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1   --  上个季度末数据
      ,t1.S_INFO_COMPCODE
      ,'000000'
      ,'总行'
      ,'BWB'
      ,'本外币合计'
      ,t1.banking_name
      ,sum(case when t2.indx_no = 'TY01010000' then coalesce(t2.indx_val,0) else 0 end )    -- 资产总额
      ,sum(case when t2.indx_no = 'TY01011000' then coalesce(t2.indx_val,0) else 0 end )    -- 存款总额
      ,sum(case when t2.indx_no = 'TY01021000' then coalesce(t2.indx_val,0) else 0 end )    -- 贷款总额
      ,sum(case when t2.indx_no = 'TY02011000' then coalesce(t2.indx_val,0) else 0 end )    -- 净利润
      ,sum(case when t2.indx_no = 'TY02021000' then coalesce(t2.indx_val,0) else 0 end )    -- 总资产收益率（ROAA） 
      ,sum(case when t2.indx_no = 'TY02022000' then coalesce(t2.indx_val,0) else 0 end )    -- 净资产收益率（ROAE）
      ,sum(case when t2.indx_no = 'TY03021000' then coalesce(t2.indx_val,0) else 0 end )    -- 不良率
      ,''
    from mc_banking_para t1
    inner join mc_banking_q_temp03 t2
           on trim(t1.s_info_compcode) = trim(t2.s_info_compcode)
          and t2.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1   -- 跑上个季度末数据
    group by t1.banking_name
      ,t1.S_INFO_COMPCODE
   ;
	  commit;


--20221101 执行后删除临时表

drop table ${idl_schema}.mc_banking_q_temp01 purge;
-- 6个指标及平均值
drop table ${idl_schema}.mc_banking_q_temp02 purge;  
-- 结果计算
drop table ${idl_schema}.mc_banking_q_temp03 purge;  
-- 结果计算
drop table ${idl_schema}.mc_banking_q_temp04 purge;      
-- 存款替换
drop table ${idl_schema}.mc_banking_q_temp05 purge;   

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_banking_q', degree => 8, cascade => true);