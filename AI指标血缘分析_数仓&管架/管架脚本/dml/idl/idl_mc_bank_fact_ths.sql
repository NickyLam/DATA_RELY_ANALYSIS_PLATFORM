set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 CREATE TABLE for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_bank_fact add partition p_${last_quarter_end} values (to_date('${last_quarter_end}','yyyymmdd'))
; 
-- 同业9个指标(除去华兴行转列统一处理)
drop table ${idl_schema}.mc_bank_fact_temp00 purge;                                             
-- 同业9个指标(除去华兴)
drop table ${idl_schema}.mc_bank_fact_temp01 purge;
-- 排序取最大值，每个机构一条 
drop table ${idl_schema}.mc_bank_fact_temp02 purge;  
-- 所有指标值
drop table ${idl_schema}.mc_bank_fact_temp03 purge;     
-- 吸收存款
drop table ${idl_schema}.mc_bank_fact_temp04 purge;   
-- 机构
drop table ${idl_schema}.mc_bank_fact_temp05 purge;  
-- 金额类上年数据（因出数时间不一致，做的比对与同期机构比）
drop table ${idl_schema}.mc_bank_fact_temp06 purge;    
whenever sqlerror exit sql.sqlcode; 

-- 清空分区
alter table ${idl_schema}.mc_bank_fact truncate partition p_${last_quarter_end};
commit;
-- 以下为依赖
/*
-- 同花顺的表
itl_edw_uxds_corp_basic_info          公司基本资料    
itl_edw_uxds_bank_special_fnncl_indicator          银行特殊财务指标
itl_edw_uxds_income_statement_ns    利润表(新准则)
itl_edw_uxds_bank_analysis_indicators         银行分析指标
-- 财务的表
MC_INDEX_FACT                        财务指标结果表
-- 机构
0816010201  国有行
0816010202  股份制
0816010203  城商行 
00212990   珠海华润银行
T000008107  东莞银行
00212911  广州银行
00212999  广东南粤银行
T000027142  广州农村商业银行
*/


-- 2.1 insert data to table

-- 同业13个指标
CREATE TABLE  ${idl_schema}.mc_bank_fact_temp00 compress
AS   
SELECT ORG_NO	      AS S_INFO_COMPCODE
      ,CURR_NO	
      ,INDEX_NAME   AS INDX_TYPE
      ,INDEX_VALUE	AS INDX_VAL
      ,ETL_DT
FROM MC_BANK_FACT
WHERE 1=2
;
            
-- mc_bank_fact_temp01存储直接从数仓取得的数据
CREATE TABLE  ${idl_schema}.mc_bank_fact_temp01 compress
AS   
SELECT ORG_NO	      AS S_INFO_COMPCODE
      ,ORG_NAME	  
      ,INDEX_VALUE	AS INDX_VAL
      ,CURR_NO	    
      ,ORG_NAME	    AS S_INFO_TYPECODE
      ,ETL_DT
      ,INDEX_NO     AS INDX_NO
      ,INDEX_NAME   AS INDX_NAME
      ,MEASURE_NO
      ,ETL_DT       AS MAX_DT
FROM mc_bank_fact
WHERE 1=2
;
-- 上线日之前的用当天的机构，上线日后的，用当日值
CREATE TABLE mc_bank_fact_temp05 compress
AS 
select *
  from itl_edw_uxds_corp_basic_info
 where etl_dt = (case
         when to_date('${batch_date}', 'yyyymmdd') <= to_date('20250613', 'yyyymmdd') then
          to_date('20250624', 'yyyymmdd')
         else
          to_date('${batch_date}', 'yyyymmdd')
       end)
	   and ORG_TYPE like '%银行%' --待细化
;

INSERT INTO ${idl_schema}.mc_bank_fact_temp00
SELECT CORP_CODE
      ,currency_code
      ,INDX_TYPE
      ,RESULT
      ,ETL_DT
FROM itl_edw_uxds_bank_special_fnncl_indicator   -- 银行特殊财务指标
UNPIVOT(                                     
    RESULT FOR INDX_TYPE IN (                
        TOTAL_DEPOSIT_AMT                    -- TY01011000 存款总额
        ,TOTAL_LOAN_AMT                      -- TY01021000 贷款总额
        ,NET_INTEREST_MARGIN                 -- TY02031000 净息差
        ,NET_PROFIT_MARGIN                   -- TY02032000 净利差
        ,COST_TO_INCOME_RATIO                -- TY02023000 成本收入比
        ,NON_INTEREST_INCOME_RATIO           -- TY02012000 非利息净收入占比
        ,CAPITAL_ADEQUACY_RATIO              -- TY03010000 资本充足率
        ,BAD_LOAN_RATIO                      -- TY03021000 不良率
        ,BAD_LOAN                            -- TY03022000 不良贷款额
        ,PROVISION_COVERAGE                  -- TY03023000 拨备覆盖率
    )
)
WHERE currency_code='CNY'
  and ED = to_date('${last_quarter_end}','yyyymmdd')  -- 跑上个季度末数据
  AND corp_code<>'T000053124'
;
COMMIT ;


/*
来源表资产负债表的2条指标
*/
INSERT INTO ${idl_schema}.mc_bank_fact_temp00
SELECT CORP_CODE
      ,currency_code
      ,INDX_TYPE
      ,RESULT
      ,ETL_DT
FROM itl_edw_uxds_bank_analysis_indicators
UNPIVOT(
    RESULT FOR INDX_TYPE IN (
        TOTAL_ASSETS                     -- TY01010000 资产总额 
        ,NET_ASSETS                      -- TY01030000 净资产
    )
)
WHERE currency_code='CNY'
  AND ED = to_date('${last_quarter_end}','yyyymmdd')  -- 跑上个季度末数据
  AND corp_code<>'T000053124'
;
COMMIT ;


/*
来源表为利润表的1条指标
*/
INSERT INTO ${idl_schema}.MC_BANK_FACT_TEMP00
SELECT org_id
      ,currency_code
      ,INDX_TYPE
      ,RESULT
      ,ETL_DT
FROM itl_edw_uxds_income_statement_ns
UNPIVOT(
    RESULT FOR INDX_TYPE IN (
        NET_PROFIT      -- TY02011000 净利润
    )
)
WHERE currency_code='CNY'
  AND ED = to_date('${last_quarter_end}','yyyymmdd')  -- 跑上个季度末数据
  AND org_id<>'T000053124'
  AND STATEMENT_TYPE = '合并'
;
COMMIT ;

/*
将上面13条指标处理到临时表
部分‘率’为单位的，万德单位是百分比，管驾统一使用1（此处转化）
*/
INSERT INTO ${idl_schema}.MC_BANK_FACT_TEMP01
SELECT T1.S_INFO_COMPCODE
      ,T2.ORG_SHORT_NAME_CN	
      ,CASE WHEN INDX_TYPE IN ('NET_INTEREST_MARGIN','NET_PROFIT_MARGIN','COST_TO_INCOME_RATIO'
                              ,'NON_INTEREST_INCOME_RATIO','CAPITAL_ADEQUACY_RATIO','BAD_LOAN_RATIO','PROVISION_COVERAGE') 
            THEN INDX_VAL/100           -- 单位转换
            ELSE INDX_VAL
       END 
      ,T1.CURR_NO
      ,T2.org_type 
      ,TO_DATE('${last_quarter_end}','yyyymmdd')   AS ETL_DT
      ,CASE T1.INDX_TYPE WHEN 'TOTAL_DEPOSIT_AMT'                THEN 'TY01011000'
                         WHEN 'TOTAL_LOAN_AMT'                   THEN 'TY01021000'
                         WHEN 'NET_INTEREST_MARGIN'          THEN 'TY02031000'
                         WHEN 'NET_PROFIT_MARGIN'          THEN 'TY02032000'
                         WHEN 'COST_TO_INCOME_RATIO'            THEN 'TY02023000'
                         WHEN 'NON_INTEREST_INCOME_RATIO'          THEN 'TY02012000'
                         WHEN 'CAPITAL_ADEQUACY_RATIO'               THEN 'TY03010000'
                         WHEN 'BAD_LOAN_RATIO'                    THEN 'TY03021000'
                         WHEN 'BAD_LOAN'          THEN 'TY03022000'
                         WHEN 'PROVISION_COVERAGE'       THEN 'TY03023000'
                         WHEN 'TOTAL_ASSETS'                   THEN 'TY01010000'
                         WHEN 'NET_ASSETS' THEN 'TY01030000'
                         WHEN 'NET_PROFIT'  THEN 'TY02011000'
       END
      ,CASE T1.INDX_TYPE WHEN 'TOTAL_DEPOSIT_AMT'                THEN '存款总额'
                         WHEN 'TOTAL_LOAN_AMT'                   THEN '贷款总额'
                         WHEN 'NET_INTEREST_MARGIN'          THEN '同业净息差'
                         WHEN 'NET_PROFIT_MARGIN'          THEN '同业净利差'
                         WHEN 'COST_TO_INCOME_RATIO'            THEN '同业成本收入比'
                         WHEN 'NON_INTEREST_INCOME_RATIO'          THEN '同业非利息净收入占比'
                         WHEN 'CAPITAL_ADEQUACY_RATIO'               THEN '同业资本充足率'
                         WHEN 'BAD_LOAN_RATIO'                    THEN '不良率'
                         WHEN 'BAD_LOAN'          THEN '同业不良贷款额'
                         WHEN 'PROVISION_COVERAGE'       THEN '同业拨备覆盖率'
                         WHEN 'TOTAL_ASSETS'                   THEN '资产总额'
                         WHEN 'NET_ASSETS' THEN '同业净资产'
                         WHEN 'NET_PROFIT'  THEN '净利润'
       END
      ,CASE WHEN T1.S_INFO_COMPCODE IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
        END 
      ,MAX(T1.ETL_DT)   
FROM MC_BANK_FACT_TEMP00 T1                
INNER JOIN mc_bank_fact_temp05 T2       -- 国内银行业金融机构分类(银监会) 
   ON TRIM(T1.S_INFO_COMPCODE) = TRIM(T2.ORG_ID) 
GROUP BY T1.S_INFO_COMPCODE
      ,T2.ORG_SHORT_NAME_CN	
      ,CASE WHEN INDX_TYPE IN ('NET_INTEREST_MARGIN','NET_PROFIT_MARGIN','COST_TO_INCOME_RATIO'
                              ,'NON_INTEREST_INCOME_RATIO','CAPITAL_ADEQUACY_RATIO','BAD_LOAN_RATIO','PROVISION_COVERAGE') 
            THEN INDX_VAL/100           -- 单位转换
            ELSE INDX_VAL
       END 
      ,T1.CURR_NO
      ,T2.org_type 
      ,TO_DATE('${last_quarter_end}','yyyymmdd')
      ,CASE T1.INDX_TYPE WHEN 'TOTAL_DEPOSIT_AMT'                THEN 'TY01011000'
                         WHEN 'TOTAL_LOAN_AMT'                   THEN 'TY01021000'
                         WHEN 'NET_INTEREST_MARGIN'          THEN 'TY02031000'
                         WHEN 'NET_PROFIT_MARGIN'          THEN 'TY02032000'
                         WHEN 'COST_TO_INCOME_RATIO'            THEN 'TY02023000'
                         WHEN 'NON_INTEREST_INCOME_RATIO'          THEN 'TY02012000'
                         WHEN 'CAPITAL_ADEQUACY_RATIO'               THEN 'TY03010000'
                         WHEN 'BAD_LOAN_RATIO'                    THEN 'TY03021000'
                         WHEN 'BAD_LOAN'          THEN 'TY03022000'
                         WHEN 'PROVISION_COVERAGE'       THEN 'TY03023000'
                         WHEN 'TOTAL_ASSETS'                   THEN 'TY01010000'
                         WHEN 'NET_ASSETS' THEN 'TY01030000'
                         WHEN 'NET_PROFIT'  THEN 'TY02011000'
       END
      ,CASE T1.INDX_TYPE WHEN 'TOTAL_DEPOSIT_AMT'                THEN '存款总额'
                         WHEN 'TOTAL_LOAN_AMT'                   THEN '贷款总额'
                         WHEN 'NET_INTEREST_MARGIN'          THEN '同业净息差'
                         WHEN 'NET_PROFIT_MARGIN'          THEN '同业净利差'
                         WHEN 'COST_TO_INCOME_RATIO'            THEN '同业成本收入比'
                         WHEN 'NON_INTEREST_INCOME_RATIO'          THEN '同业非利息净收入占比'
                         WHEN 'CAPITAL_ADEQUACY_RATIO'               THEN '同业资本充足率'
                         WHEN 'BAD_LOAN_RATIO'                    THEN '不良率'
                         WHEN 'BAD_LOAN'          THEN '同业不良贷款额'
                         WHEN 'PROVISION_COVERAGE'       THEN '同业拨备覆盖率'
                         WHEN 'TOTAL_ASSETS'                   THEN '资产总额'
                         WHEN 'NET_ASSETS' THEN '同业净资产'
                         WHEN 'NET_PROFIT'  THEN '净利润'
       END
      ,CASE WHEN T1.S_INFO_COMPCODE IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
        END 
;
COMMIT ;

/*
需要管驾计算的三个同业指标
*/

-- TY02021000	总资产收益率（ROAA）
insert into  ${idl_schema}.mc_bank_fact_temp01
select  T1.org_id                                              AS S_INFO_COMPCODE	
      ,T4.ORG_SHORT_NAME_CN	                                              AS ORG_NAME          -- 公司名称
      ,case when coalesce(T2.TOTAL_ASSETS,0) + coalesce(T3.TOTAL_ASSETS,0) = 0 then 0
             else cast(coalesce(T1.NET_PROFIT,0)	
                        /cast(substr('${last_quarter_end}',5,2) AS decimal(4,0)) *12
                        /((coalesce(T2.TOTAL_ASSETS,0) + coalesce(T3.TOTAL_ASSETS,0))/2)
                                                                         AS NUMBER(30,8)) 
        end                                                              AS indx_val         --总资产收益率（ROAA）
       ,T1.currency_code	                                                   AS CURR_NO          --货币代码   
       ,T4.org_type                                               AS S_INFO_TYPECODE  -- 机构分类        
       ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1                 AS etl_dt
       ,'TY02021000'                                                     AS indx_no
       ,'平均资产收益率（ROAA）'                                         AS INDX_NAME
       ,CASE WHEN T1.org_id IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
        END                                                              AS MEASURE_NO       -- 度量为001的，显示在界面
       ,max(T1.etl_dt)                                                   AS max_dt  
 from itl_edw_uxds_income_statement_ns T1
 INNER JOIN mc_bank_fact_temp05 T4                         
   ON TRIM(T1.org_id) = TRIM(T4.org_id) 
 left join itl_edw_uxds_bank_analysis_indicators T2
        on T1.org_id = T2.CORP_CODE
       AND T1.currency_code=T2.currency_code
      AND T2.ed = '${last_quarter_end}'        --报告日期      
 left join itl_edw_uxds_bank_analysis_indicators T3
        on T1.org_id = T3.CORP_CODE
       AND T1.currency_code=T3.currency_code
       AND T3.ed = to_char(trunc(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yy')-1 ,'yyyyMMdd')  --期初报告日期（年初）
 where  T1.currency_code='CNY'
     AND T1.ed = '${last_quarter_end}'   -- 跑上个季度末数据           --报告日期 
     AND T1.org_id <> 'T000053124'         -- 排除华兴银行（20200902）
	 AND T1.STATEMENT_TYPE = '合并'
group by T1.org_id
       ,case when coalesce(T2.TOTAL_ASSETS,0) + coalesce(T3.TOTAL_ASSETS,0) = 0 then 0
             else cast(coalesce(T1.NET_PROFIT,0)	
                        /cast(substr('${last_quarter_end}',5,2) AS decimal(4,0)) *12
                        /((coalesce(T2.TOTAL_ASSETS,0) + coalesce(T3.TOTAL_ASSETS,0))/2)
                                                                         AS NUMBER(30,8)) 
        end 
	
       ,T1.currency_code
       ,T4.ORG_SHORT_NAME_CN
       ,T4.org_type
       ,CASE WHEN T1.org_id IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
        END;
commit ;


-- TY02022000	净资产收益率（ROAE）      
insert into  ${idl_schema}.mc_bank_fact_temp01
select T1.org_id                                                AS S_INFO_COMPCODE	
       ,T4.ORG_SHORT_NAME_CN	                                             AS ORG_NAME        -- 公司名称
       ,case when  coalesce(T2.NET_ASSETS,0) + coalesce(T3.NET_ASSETS,0) = 0   then 0
             else cast(coalesce(T1.NET_PROFIT,0)	
                        /cast(substr('${last_quarter_end}',5,2) AS decimal(4,0)) *12
                        /(( coalesce(T2.NET_ASSETS,0) + coalesce(T3.NET_ASSETS,0))/2) 
                                                                         AS NUMBER(30,8))    
        end                                                              AS indx_val         --净资产收益率（ROAE）
       ,T1.currency_code	                                                   AS CURR_NO          --货币代码    
       ,T4.org_type                                               AS S_INFO_TYPECODE  -- 机构分类       
       ,trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1                 AS etl_dt
       ,'TY02022000'                                                     AS indx_no
       ,'净资产收益率（ROAE）'                                           AS INDX_NAME
       ,CASE WHEN T1.org_id IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
        END                                                              AS MEASURE_NO       -- 度量为001的，显示在界面
       ,max(T1.etl_dt)                                                   AS max_dt  
 from itl_edw_uxds_income_statement_ns T1
 INNER JOIN mc_bank_fact_temp05 T4                         
   ON TRIM(T1.org_id) = TRIM(T4.org_id) 
 left join itl_edw_uxds_bank_analysis_indicators T2
        on T1.org_id = T2.CORP_CODE
        AND T1.currency_code=T2.currency_code
      AND T2.ed = '${last_quarter_end}'       --报告日期       
 left join itl_edw_uxds_bank_analysis_indicators T3
        on T1.org_id = T3.CORP_CODE
       AND T1.currency_code=T2.currency_code
       AND T3.ed = to_char(trunc(trunc(to_date('${batch_date}','yyyymmdd'),'Q')-1,'yy')-1 ,'yyyyMMdd')  --期初报告日期（年初）
 where T1.STATEMENT_TYPE = '合并'
   AND T1.currency_code='CNY'
   AND T1.ed = '${last_quarter_end}'   -- 跑上个季度末数据           --报告日期  
   AND T1.org_id <> 'T000053124'         -- 排除华兴银行（20200902）
group by T1.org_id
       ,case when  coalesce(T2.NET_ASSETS,0) + coalesce(T3.NET_ASSETS,0) = 0   then 0
             else cast(coalesce(T1.NET_PROFIT,0)	
                        /cast(substr('${last_quarter_end}',5,2)                 AS decimal(4,0)) *12
                        /(( coalesce(T2.NET_ASSETS,0) + coalesce(T3.NET_ASSETS,0))/2) 
                                                                         AS NUMBER(30,8))    
        end
       ,T1.currency_code
       ,T4.ORG_SHORT_NAME_CN	
       ,T4.org_type
       ,CASE WHEN T1.org_id IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
        END ;
commit;  

INSERT INTO  ${idl_schema}.mc_bank_fact_temp01
SELECT T1.CORP_CODE                                AS S_INFO_COMPCODE	 -- 机构号
      ,T2.ORG_SHORT_NAME_CN	                               AS ORG_NAME         -- 公司名称
      ,T1.PROV_TO_LOAN_RATIO /100                   
                                                         AS INDX_VAL         -- 同业拨贷比
      ,T1.currency_code	                                   AS CURR_NO          -- 货币代码
      ,T2.org_type                                AS S_INFO_TYPECODE  -- 机构分类
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT           -- 日期
      ,'TY03024000'                                      AS INDX_NO          -- 指标编号
      ,'同业拨贷比'                                      AS INDX_NAME        -- 指标名称
      ,CASE WHEN T1.CORP_CODE IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
       END                                               AS MEASURE_NO       -- 度量为001的，显示在界面
      ,MAX(T1.ETL_DT)                                    AS MAX_DT           -- 取最大推送日期的那条数据
FROM  itl_edw_uxds_bank_special_fnncl_indicator T1                                        -- 中国A股资产负债表
INNER JOIN mc_bank_fact_temp05 T2                                    -- 国内银行业金融机构分类(银监会) 
   ON TRIM(T1.CORP_CODE) = TRIM(T2.ORG_ID) 
--  AND T2.ETL_DT = TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1
WHERE T1.currency_code = 'CNY'
  AND T1.ed = '${last_quarter_end}'   -- 跑上个季度末数据
  AND T1.CORP_CODE <> 'T000053124'                                     -- 排除华兴银行
GROUP BY T1.CORP_CODE                           
     ,T1.PROV_TO_LOAN_RATIO /100
     ,T1.currency_code
     ,T2.org_type 
     ,T2.ORG_SHORT_NAME_CN
     ,CASE WHEN T1.CORP_CODE IN ('00212990','T000008107','00212911','00212999','T000027142') THEN '001' 
            ELSE '001'  
      END ;
COMMIT ;



/*
开始计算华兴数据
净资产           FM0200001	财务指标	权益指标	    GM02030000	规模类	所有者权益总额   原始值 001	原始统计值
净息差           FM0500038	财务指标	盈利能力指标	YL05020000	盈利类	净息差（NIM）    月累计年华 013	单一度量	月年化
净利差           FM0500034	财务指标	盈利能力指标	YL05011000	盈利类	净利差（NIS）    月累计年华 013	单一度量	月年化
成本收入比       FM0500007	财务指标	盈利能力指标	YL04030000	盈利类	成本收入比       月累计年华 013	单一度量	月年化
非利息净收入占比 FM0600002	财务指标	结构指标	    YL01012100	盈利类	非利息净收入占比 月累计年华	013	单一度量	月年化
资本充足率       RM0100001	风险指标	资本管理	    FX01030000	风险类	资本充足率
不良贷款额       RM0200016	风险指标	资产质量	    RM0200214	风险类	不良贷款余额
拨备覆盖率       RM0200003	风险指标	资产质量	    RM0200208	风险类	拨备覆盖率
拨贷比           RM0200093	风险指标	资产质量	    RM0200207	风险类	贷款拨备率
TY01030000	同业类	净资产
TY02031000	同业类	净息差
TY02032000	同业类	净利差
TY02023000	同业类	成本收入比
TY02012000	同业类	非利息净收入占比
TY03010000	同业类	资本充足率
TY03022000	同业类	不良贷款额
TY03023000	同业类	拨备覆盖率
TY03024000	同业类	拨贷比
*/

INSERT INTO  ${idl_schema}.mc_bank_fact_temp01
select 'T000053124'                                         AS S_INFO_COMPCODE   -- 华兴银行                                                                         
      ,T1.ORG_NAME                                          AS ORG_NAME          -- 公司名称
      ,CASE WHEN INDEX_NO IN ('YL04030000','YL05020000','YL05011000') AND T1.MEASURE_NO = '015' THEN COALESCE(T1.INDEX_VALUE,0) 
            WHEN INDEX_NO IN ('FX01030000','RM0200214','RM0200207','RM0200208') THEN COALESCE(T1.INDEX_VALUE,0) 
            WHEN INDEX_NO IN ('GM02030000','GM01000000','GM02011000','GM01015000','YL04021000','YL01012100','YL04022000','RM0200203') AND T1.MEASURE_NO = '001' THEN COALESCE(T1.INDEX_VALUE,0)
            WHEN INDEX_NO = 'YL03030000' AND T1.MEASURE_NO = '001' THEN COALESCE(T1.ACCU_INDEX_VALUE_Y,0)
       END                                                  AS INDX_VAL          -- 指标值
      ,'CNY'                                                AS CURR_NO           -- 货币代码置成本外币
      ,'0816010203'                                         AS S_INFO_TYPECODE   -- 机构分类
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1     AS ETL_DT
      ,CASE WHEN INDEX_NO = 'GM02030000' AND T1.MEASURE_NO = '001'  THEN 'TY01030000'
            WHEN INDEX_NO = 'YL05020000' AND T1.MEASURE_NO = '015'  THEN 'TY02031000'
            WHEN INDEX_NO = 'YL05011000' AND T1.MEASURE_NO = '015'  THEN 'TY02032000'
            WHEN INDEX_NO = 'YL04030000' AND T1.MEASURE_NO = '015'  THEN 'TY02023000'
            WHEN INDEX_NO = 'FX01030000' THEN 'TY03010000'
            WHEN INDEX_NO = 'RM0200214' THEN 'TY03022000'
            WHEN INDEX_NO = 'RM0200208' THEN 'TY03023000'
            WHEN INDEX_NO = 'RM0200207' THEN 'TY03024000'
            WHEN INDEX_NO = 'YL01012100' AND T1.MEASURE_NO = '001' THEN 'TY02012000'
            WHEN INDEX_NO = 'GM01000000' AND T1.MEASURE_NO = '001' THEN 'TY01010000'
            WHEN INDEX_NO = 'GM02011000' AND T1.MEASURE_NO = '001' THEN 'TY01011000'
            WHEN INDEX_NO = 'GM01015000' AND T1.MEASURE_NO = '001' THEN 'TY01021000'
            WHEN INDEX_NO = 'YL03030000' AND T1.MEASURE_NO = '001' THEN 'TY02011000'
            WHEN INDEX_NO = 'YL04021000' AND T1.MEASURE_NO = '001' THEN 'TY02021000'
            WHEN INDEX_NO = 'YL04022000' AND T1.MEASURE_NO = '001' THEN 'TY02022000'
            WHEN INDEX_NO = 'RM0200203' AND T1.MEASURE_NO = '001' THEN 'TY03021000'
       END                                                  AS INDX_NO 
      ,CASE WHEN INDEX_NO = 'GM02030000' AND T1.MEASURE_NO = '001'  THEN '同业净资产'
            WHEN INDEX_NO = 'YL05020000' AND T1.MEASURE_NO = '015'  THEN '同业净息差'
            WHEN INDEX_NO = 'YL05011000' AND T1.MEASURE_NO = '015'  THEN '同业净利差'
            WHEN INDEX_NO = 'YL04030000' AND T1.MEASURE_NO = '015'  THEN '同业成本收入比'
            WHEN INDEX_NO = 'FX01030000' THEN '同业资本充足率'
            WHEN INDEX_NO = 'RM0200214' THEN '同业不良贷款额'
            WHEN INDEX_NO = 'RM0200208' THEN '同业拨备覆盖率'
            WHEN INDEX_NO = 'RM0200207' THEN '同业拨贷比'
            WHEN INDEX_NO = 'YL01012100' AND T1.MEASURE_NO = '001' THEN '同业非利息净收入占比'
            WHEN INDEX_NO = 'GM01000000' AND T1.MEASURE_NO = '001' THEN '资产总额'
            WHEN INDEX_NO = 'GM02011000' AND T1.MEASURE_NO = '001' THEN '存款总额'
            WHEN INDEX_NO = 'GM01015000' AND T1.MEASURE_NO = '001' THEN '贷款总额'
            WHEN INDEX_NO = 'YL03030000' AND T1.MEASURE_NO = '001' THEN '净利润'
            WHEN INDEX_NO = 'YL04021000' AND T1.MEASURE_NO = '001' THEN '平均资产收益率（ROAA）'
            WHEN INDEX_NO = 'YL04022000' AND T1.MEASURE_NO = '001' THEN '净资产收益率（ROAE）'
            WHEN INDEX_NO = 'RM0200203' AND T1.MEASURE_NO = '001' THEN '不良率'
       END                                                   AS INDX_NAME
      ,'001'                                                 AS MEASURE_NO       -- 度量为001的，显示在界面
      ,T1.ETL_DT                                             AS MAX_DT  
from MC_INDEX_FACT T1                                                            -- 中国A股银行专用指标
where T1.ETL_DT = TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1               -- 跑上个季度末数据
  -- AND T1.MEASURE_NO = '001'  
  AND T1.ORG_NO = '000000'
  AND T1.CURR_NO = 'BWB'
  AND T1.INDEX_NO in ( 'GM02030000'
                       ,'YL05020000'
                       ,'YL05011000'
                       ,'YL04030000'
                       ,'YL01012100'
                       ,'FX01030000'
                       ,'RM0200214'--,'FX02023000'
                       ,'RM0200208'--,'FX02042000'
                       ,'RM0200207'--,'FX02041000'
                       ,'GM01000000'
                       ,'GM02011000'
                       ,'GM01015000'
                       ,'YL03030000'
                       ,'YL04021000'
                       ,'YL04022000'
                       ,'RM0200203'--,'FX02024000'
					   )
;
COMMIT ;   


/*
每个机构取排序第一的值，进行排序
*/
CREATE TABLE  ${idl_schema}.MC_BANK_FACT_TEMP02 compress
AS 
SELECT T1.S_INFO_COMPCODE
      ,T1.ORG_NAME
      ,T1.INDX_VAL
      ,T1.CURR_NO
      ,T1.S_INFO_TYPECODE
      ,T1.ETL_DT
      ,T1.INDX_NO
      ,T1.INDX_NAME 
      ,T1.MEASURE_NO
FROM 
(
    SELECT  T1.S_INFO_COMPCODE
           ,T1.ORG_NAME
           ,T1.INDX_VAL
           ,T1.CURR_NO
           ,T1.S_INFO_TYPECODE
           ,T1.ETL_DT
           ,T1.INDX_NO
           ,T1.INDX_NAME 
           ,T1.MEASURE_NO
           ,ROW_NUMBER()OVER(PARTITION BY T1.S_INFO_COMPCODE,T1.INDX_NO ORDER BY T1.INDX_VAL DESC ) AS  INDEX_RANKING             
    FROM  MC_BANK_FACT_TEMP01 t1  
    WHERE t1.CURR_NO = 'CNY'
      AND t1.ETL_DT = TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1   -- 跑上个季度末数据  
      AND  T1.INDX_NO IS NOT NULL 
)  T1
WHERE t1.INDEX_RANKING=1
;


/*
开始计算平均值
*/
CREATE TABLE  ${idl_schema}.MC_BANK_FACT_TEMP03 compress
AS  
SELECT ORG_NO	      AS S_INFO_COMPCODE
      ,ORG_NAME
      ,INDEX_VALUE	AS INDX_VAL
      ,CURR_NO
      ,ORG_NAME	    AS S_INFO_TYPECODE
      ,ETL_DT
      ,INDEX_NO     AS INDX_NO
      ,INDEX_NAME   AS INDX_NAME
      ,MEASURE_NO
      ,INDEX_VALUE_LIMIT
FROM mc_bank_fact WHERE 1=2 ;



INSERT INTO ${idl_schema}.MC_BANK_FACT_TEMP03
SELECT 'avg'                                             AS S_INFO_COMPCODE	 -- 机构号
      ,'对标行均值'                                      AS ORG_NAME         -- 公司名称
      ,ROUND(AVG(COALESCE(INDX_VAL,0)),6)                AS INDX_VAL         -- 指标值
      ,T1.CURR_NO   	                                   AS CURR_NO          -- 货币代码
      ,'avg'                                             AS S_INFO_TYPECODE  -- 机构分类
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT           -- 日期
      ,T1.INDX_NO                                        AS INDX_NO          -- 指标编号
      ,T1.INDX_NAME                                      AS INDX_NAME        -- 指标名称
      ,'001'                                             AS MEASURE_NO       -- 度量为001的，显示在界面
      ,0                                                 AS INDEX_VALUE_LIMIT 
FROM  MC_BANK_FACT_TEMP02 T1
WHERE T1.CURR_NO    = 'CNY'
  AND T1.ETL_DT = TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1          -- 跑上个季度末数据
  AND T1.S_INFO_COMPCODE IN ('00212990','T000008107','00212911','00212999','T000027142')  --五家行的平均
  AND T1.INDX_VAL IS NOT NULL
GROUP BY T1.CURR_NO   
        ,T1.INDX_NO 
        ,T1.INDX_NAME
;
COMMIT ;
/*
以下合计为计算比对行内连接有的合计
开始计算合计,三类行的合计 - 金额部分
*/
INSERT INTO  ${idl_schema}.MC_BANK_FACT_TEMP03
SELECT T1.S_INFO_TYPECODE                                AS S_INFO_COMPCODE	  -- 机构号
      ,CASE WHEN T1.S_INFO_TYPECODE = '0816010201' THEN '国有行合计'
            WHEN T1.S_INFO_TYPECODE = '0816010202' THEN '股份制合计'
            WHEN T1.S_INFO_TYPECODE = '0816010203' THEN '城商行合计'
       END                                               AS ORG_NAME          -- 公司名称
      ,SUM(COALESCE(T1.INDX_VAL,0))                      AS INDX_VAL          -- 指标值
      ,T1.CURR_NO   	                                   AS CURR_NO           -- 货币代码
      ,T1.S_INFO_TYPECODE                                AS S_INFO_TYPECODE   -- 机构分类
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT            -- 日期
      ,T1.INDX_NO                                        AS INDX_NO           -- 指标编号
      ,T1.INDX_NAME                                      AS INDX_NAME         -- 指标名称
      ,'001'                                             AS MEASURE_NO        -- 度量为999的合计，显示在二级界面
      ,COUNT(T1.S_INFO_COMPCODE)                         AS INDEX_VALUE_LIMIT -- 此处用阀值存放两个时间机构交集数
FROM  MC_BANK_FACT_TEMP02 T1     
INNER JOIN ${idl_schema}.MC_BANK_FACT T2            --上年
       ON TRIM(T1.INDX_NO)  = TRIM(T2.INDEX_NO)
      AND TRIM(T1.S_INFO_COMPCODE) = TRIM(T2.ORG_NO)
      AND T1.CURR_NO = T2.CURR_NO
      AND T2.ETL_DT = TRUNC(TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1 ,'yy') -1 
WHERE T1.CURR_NO = 'CNY'                                                   
  AND T1.ETL_DT =  TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1           -- 跑上个季度末数据
  AND T1.S_INFO_TYPECODE IN ('0816010201','0816010202','0816010203')
  AND T1.INDX_NO NOT IN ( 'TY02021000','TY02022000','TY02031000','TY02032000'
               ,'TY02023000','TY02012000','TY03010000','TY03021000'
               ,'TY03023000','TY03024000')
GROUP BY CASE WHEN T1.S_INFO_TYPECODE = '0816010201' THEN '国有行合计'
              WHEN T1.S_INFO_TYPECODE = '0816010202' THEN '股份制合计'
              WHEN T1.S_INFO_TYPECODE = '0816010203' THEN '城商行合计'
         END
        ,T1.CURR_NO   
        ,T1.S_INFO_TYPECODE
        ,T1.INDX_NO 
        ,T1.INDX_NAME
;
COMMIT ;

/*
以下合计为计算比对行内连接有的合计
开始计算合计,三类行的合计 - ***率部分
*/
INSERT INTO  ${idl_schema}.MC_BANK_FACT_TEMP03
SELECT T1.S_INFO_TYPECODE                                AS S_INFO_COMPCODE	  -- 机构号
      ,CASE WHEN T1.S_INFO_TYPECODE = '0816010201' THEN '国有行合计'
            WHEN T1.S_INFO_TYPECODE = '0816010202' THEN '股份制合计'
            WHEN T1.S_INFO_TYPECODE = '0816010203' THEN '城商行合计'
       END                                               AS ORG_NAME          -- 公司名称
      ,AVG(COALESCE(T1.INDX_VAL,0))                      AS INDX_VAL          -- 指标值
      ,T1.CURR_NO   	                                   AS CURR_NO           -- 货币代码
      ,T1.S_INFO_TYPECODE                                AS S_INFO_TYPECODE   -- 机构分类
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT            -- 日期
      ,T1.INDX_NO                                        AS INDX_NO           -- 指标编号
      ,T1.INDX_NAME                                      AS INDX_NAME         -- 指标名称
      ,'001'                                             AS MEASURE_NO        -- 度量为999的合计，显示在二级界面
      ,COUNT(T1.S_INFO_COMPCODE)                         AS INDEX_VALUE_LIMIT -- 此处用阀值存放两个时间机构交集数
FROM  MC_BANK_FACT_TEMP02 T1  
INNER JOIN ${idl_schema}.MC_BANK_FACT T2            --上年
       ON TRIM(T1.INDX_NO)  = TRIM(T2.INDEX_NO)
      AND TRIM(T1.S_INFO_COMPCODE) = TRIM(T2.ORG_NO)
      AND T1.CURR_NO = T2.CURR_NO
      AND T2.ETL_DT = TRUNC(TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1 ,'yy') -1                                                 
WHERE T1.CURR_NO = 'CNY'                                                   
  AND T1.ETL_DT =  TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1           -- 跑上个季度末数据
  AND T1.S_INFO_TYPECODE IN ('0816010201','0816010202','0816010203')
  AND T1.INDX_NO IN ( 'TY02021000','TY02022000','TY02031000','TY02032000'
               ,'TY02023000','TY02012000','TY03010000','TY03021000'
               ,'TY03023000','TY03024000')
GROUP BY CASE WHEN T1.S_INFO_TYPECODE = '0816010201' THEN '国有行合计'
              WHEN T1.S_INFO_TYPECODE = '0816010202' THEN '股份制合计'
              WHEN T1.S_INFO_TYPECODE = '0816010203' THEN '城商行合计'
         END
        ,T1.CURR_NO   
        ,T1.S_INFO_TYPECODE
        ,T1.INDX_NO 
        ,T1.INDX_NAME
;
COMMIT ;

/*
以下合计为计算比对行内连接有的合计
开始计算合计，全部银行的合计 - 金额部分
*/
INSERT INTO  ${idl_schema}.mc_bank_fact_temp03
SELECT 'all'                                             AS S_INFO_COMPCODE	 -- 机构号
      ,'银行业合计'                                      AS ORG_NAME         -- 公司名称
      ,SUM(COALESCE(T1.INDX_VAL,0))                      AS INDX_VAL         -- 指标值
      ,T1.CURR_NO	                                       AS CURR_NO          -- 货币代码
      ,'all'                                             AS S_INFO_TYPECODE  -- 机构分类
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT           -- 日期
      ,T1.INDX_NO                                        AS INDX_NO          -- 指标编号
      ,T1.INDX_NAME                                      AS INDX_NAME        -- 指标名称
      ,'001'                                             AS MEASURE_NO       -- 度量为999的合计，显示在二级界面
      ,COUNT(T1.S_INFO_COMPCODE)                         AS INDEX_VALUE_LIMIT -- 此处用阀值存放两个时间机构交集数
FROM  MC_BANK_FACT_TEMP02 T1
INNER JOIN ${idl_schema}.MC_BANK_FACT T2            --上年
       ON TRIM(T1.INDX_NO)  = TRIM(T2.INDEX_NO)
      AND TRIM(T1.S_INFO_COMPCODE) = TRIM(T2.ORG_NO)
      AND T1.CURR_NO = T2.CURR_NO
      AND T2.ETL_DT = TRUNC(TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1 ,'yy') -1   
WHERE T1.CURR_NO = 'CNY'
  AND T1.ETL_DT =  TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1          -- 跑上个季度末数据
  AND T1.INDX_NO NOT IN ( 'TY02021000','TY02022000','TY02031000','TY02032000'
               ,'TY02023000','TY02012000','TY03010000','TY03021000'
               ,'TY03023000','TY03024000')
GROUP BY T1.CURR_NO   
        ,T1.INDX_NO 
        ,T1.INDX_NAME
;
COMMIT ;





/*
以下合计为计算比对行内连接有的合计
开始计算合计，全部银行的合计 - ***率部分
*/
INSERT INTO  ${idl_schema}.mc_bank_fact_temp03
SELECT 'all'                                             AS S_INFO_COMPCODE	 -- 机构号
      ,'银行业合计'                                      AS ORG_NAME         -- 公司名称
      ,AVG(COALESCE(INDX_VAL,0))                         AS INDX_VAL         -- 指标值
      ,T1.CURR_NO	                                       AS CURR_NO          -- 货币代码
      ,'all'                                             AS S_INFO_TYPECODE  -- 机构分类
      ,TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  AS ETL_DT           -- 日期
      ,T1.INDX_NO                                        AS INDX_NO          -- 指标编号
      ,T1.INDX_NAME                                      AS INDX_NAME        -- 指标名称
      ,'001'                                             AS MEASURE_NO       -- 度量为001的，显示在界面
      ,COUNT(T1.S_INFO_COMPCODE)                         AS INDEX_VALUE_LIMIT -- 此处用阀值存放两个时间机构交集数
FROM  MC_BANK_FACT_TEMP02 T1
INNER JOIN ${idl_schema}.MC_BANK_FACT T2            --上年
       ON TRIM(T1.INDX_NO)  = TRIM(T2.INDEX_NO)
      AND TRIM(T1.S_INFO_COMPCODE) = TRIM(T2.ORG_NO)
      AND T1.CURR_NO = T2.CURR_NO
      AND T2.ETL_DT = TRUNC(TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1 ,'yy') -1   
WHERE T1.CURR_NO = 'CNY'
  AND T1.ETL_DT =  TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1          -- 跑上个季度末数据
  AND T1.INDX_NO IN ( 'TY02021000','TY02022000','TY02031000','TY02032000'
               ,'TY02023000','TY02012000','TY03010000','TY03021000'
               ,'TY03023000','TY03024000')
GROUP BY T1.CURR_NO   
        ,T1.INDX_NO 
        ,T1.INDX_NAME
;
COMMIT ;

/*
其他行数据插入临时表
*/
INSERT INTO  ${idl_schema}.MC_BANK_FACT_TEMP03
SELECT T1.S_INFO_COMPCODE
      ,T1.ORG_NAME
      ,T1.INDX_VAL
      ,T1.CURR_NO
      ,T1.S_INFO_TYPECODE
      ,T1.ETL_DT
      ,T1.INDX_NO
      ,T1.INDX_NAME 
      ,T1.MEASURE_NO
      ,0  
FROM MC_BANK_FACT_TEMP02 T1
WHERE T1.CURR_NO = 'CNY'
  AND T1.ETL_DT =  TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1          -- 跑上个季度末数据
;
COMMIT ;
/*
开始计算较上年较上月等
*/

INSERT INTO ${idl_schema}.mc_bank_fact                                                                     
SELECT T1.ETL_DT                                         AS ETL_DT	            -- 时间
       ,T1.INDX_NO                                       AS INDEX_NO	          -- 指标编号
       ,T1.INDX_NAME                                     AS INDEX_NAME	        -- 指标名称
       ,T1.S_INFO_COMPCODE                               AS ORG_NO	            -- 机构号
       ,T1.ORG_NAME                                      AS ORG_NAME	          -- 机构名称
       ,'000000'                                         AS SUPER_ORG_NO	      -- 上级机构号 -无
       ,'总行'                                           AS ORG_SORT	          -- 上级机构名称 -无
       ,T1.CURR_NO                                       AS CURR_NO	            -- 币种编码
       ,'人民币'                                         AS CURR_NAME	          -- 币种名字
       ,COALESCE(T1.INDX_VAL,0)                          AS INDEX_VALUE	        -- 指标值
       ,COALESCE(T1.INDX_VAL,0)                          AS ACCU_INDEX_VALUE_M	-- 当月累计,此处因计算频度为季度所以取当月值
       ,COALESCE(T1.INDX_VAL,0)                          AS ACCU_INDEX_VALUE_Y	-- 当年累计,此处因计算频度为季度所以取当月值
       ,0                                                AS RATE_UP_DAY	        -- 比上日百分比
       ,0                                                AS RATE_LAST_MONTH	    -- 比上月百分比
       ,COALESCE(T1.INDX_VAL,0) - COALESCE(T2.INDEX_VALUE,0)AS RATE_LAST_YEAR	  -- 比上年
       ,COALESCE(T1.INDX_VAL,0) - COALESCE(T3.INDEX_VALUE,0)AS RATE_LAST_PERIOD	-- 同比 
       ,0                                                AS RATE_UP_DAY_PER	
       ,0                                                AS RATE_LAST_MONTH_PER	
       ,CASE WHEN COALESCE(T2.INDEX_VALUE,0) = 0 THEN 0  
             ELSE ROUND((COALESCE(T1.INDX_VAL,0) - COALESCE(T2.INDEX_VALUE,0))/COALESCE(T2.INDEX_VALUE,0),6)
        END                                              AS RATE_LAST_YEAR_PER	
       ,CASE WHEN COALESCE(T3.INDEX_VALUE,0) = 0 THEN 0     
             ELSE ROUND((COALESCE(T1.INDX_VAL,0) - COALESCE(T3.INDEX_VALUE,0))/COALESCE(T3.INDEX_VALUE,0),6)
        END                                              AS RATE_LAST_PERIOD_PER	
       ,0                                                AS INDEX_RANKING	
       ,0                                                AS INDEX_RANKING_CHA	
       ,0                                                AS INDEX_VALUE_AVG	
       ,T1.INDEX_VALUE_LIMIT                             AS INDEX_VALUE_LIMIT	
       ,0                                                AS RATIO_INDEX	
       ,0                                                AS RATIO_ORG	
       ,CASE WHEN T1.INDX_NO IN ('TY01010000','TY01011000','TY01021000','TY01030000','TY02011000','TY03022000','TY01040000','TY01050000') THEN '亿元'
             ELSE '%'
        END                                              AS UNIT	
       ,'季'                                             AS FREQUENCY	
       ,T1.MEASURE_NO                                    AS MEASURE_NO
       ,'THS'                                            AS SOURCE_SYS	
       ,CASE WHEN T1.MEASURE_NO = '001' THEN '显示'
             ELSE '不显示'
        END                                              AS INDEX_MEASURE	
       ,T1.S_INFO_TYPECODE                               AS ORG_TYPE            -- 机构类别
       ,T4.FIRST_NAME                                    AS FIRST_NAME          -- 一级分类名称
       ,T4.SECOND_NAME                                   AS SECOND_NAME         -- 二级分类名称
       ,COALESCE(T4.THIRD_NAME,T4.SECOND_NAME)           AS THIRD_NAME          -- 三级分类名称
       ,CAST(TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS TIMESTAMP(6))    
                                                         AS ETL_TIMESTAMP	
FROM MC_BANK_FACT_TEMP03 T1
LEFT JOIN ${idl_schema}.MC_BANK_FACT T2            --上年
       ON TRIM(T1.INDX_NO)  = TRIM(T2.INDEX_NO)
      AND TRIM(T1.S_INFO_COMPCODE) = TRIM(T2.ORG_NO)
      AND T1.CURR_NO = T2.CURR_NO
      AND T1.MEASURE_NO = T2.MEASURE_NO
      AND T2.ETL_DT = TRUNC(TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1 ,'yy') -1 
LEFT JOIN ${idl_schema}.MC_BANK_FACT T3            --同比
       ON TRIM(T1.INDX_NO)  = TRIM(T3.INDEX_NO)
      AND TRIM(T1.S_INFO_COMPCODE) = TRIM(T3.ORG_NO)
      AND T1.CURR_NO = T3.CURR_NO
      AND T1.MEASURE_NO = T3.MEASURE_NO
      AND T3.ETL_DT = ADD_MONTHS(TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1  ,-12)  
LEFT JOIN ${idl_schema}.MC_WIND_ORG_PARA T4
       ON T1.S_INFO_TYPECODE = COALESCE(TRIM(T4.THIRD_CODE),TRIM(T4.SECOND_CODE))
WHERE T1.CURR_NO = 'CNY'
  AND T1.ETL_DT =  TRUNC(TO_DATE('${batch_date}','yyyymmdd'),'Q')-1          -- 跑上个季度末数据
;
commit ;

whenever sqlerror continue none;
-- 同业9个指标(除去华兴行转列统一处理)
drop table ${idl_schema}.mc_bank_fact_temp00 purge;                                             
-- 同业9个指标(除去华兴)
drop table ${idl_schema}.mc_bank_fact_temp01 purge;
-- 排序取最大值，每个机构一条 
drop table ${idl_schema}.mc_bank_fact_temp02 purge;  
-- 所有指标值
drop table ${idl_schema}.mc_bank_fact_temp03 purge;     
-- 吸收存款
drop table ${idl_schema}.mc_bank_fact_temp04 purge;   
-- 机构
drop table ${idl_schema}.mc_bank_fact_temp05 purge;  
-- 金额类上年数据（因出数时间不一致，做的比对与同期机构比）
drop table ${idl_schema}.mc_bank_fact_temp06 purge;  
-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_bank_fact', degree => 8, cascade => true);