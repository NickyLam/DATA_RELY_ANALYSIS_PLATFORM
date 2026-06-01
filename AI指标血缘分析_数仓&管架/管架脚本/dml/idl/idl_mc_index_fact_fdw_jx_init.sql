set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 以下为依赖了上游的表 :
-- mtl_fdl_idx_index_data_jx
-- mtl_fml_f99_int_org_info_new
-- 以下为依赖的参数表 :
-- mc_index_define           -- 指标表清单
-- mc_sup_para

-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_index_fact add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_jx values ('JX')
                                              )
;
alter table ${idl_schema}.mc_index_fact modify partition p_${batch_date}
                                             add subpartition p_${batch_date}_jx values ('JX')
;
drop table ${idl_schema}.mc_index_fact_fdw_temp01_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp02_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp03_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp04_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp05_jx purge;


whenever sqlerror exit sql.sqlcode;

alter table ${idl_schema}.mc_index_fact truncate subpartition p_${batch_date}_jx;
commit;
-- 2.1 insert data to table
create table  ${idl_schema}.mc_index_fact_fdw_temp04_jx compress
as
select t1.INDEX_NO	                                     --指标编号
      ,t1.ORG_NO	                                       --机构编号
      ,t1.BIZ_STRIP_LINE_CD	                             --业务条线代码
      ,t1.DIM_CD1	                                       --维度代码1
      ,t1.DIM_CD2		                                     --维度代码2
      ,t1.DIM_CD3		                                     --维度代码3
      ,t1.BATCH_FREQ	                                   --批次频度
      ,case when  t1.INDEX_MEASURE is null or t1.INDEX_MEASURE =''   
            then  '001'                               
            else  cast(t1.INDEX_MEASURE as varchar(10))
            end    as INDEX_MEASURE                   --指标度量
      ,case when  t1.CURR_CD is null or t1.CURR_CD =''   
            then  'BWB'                               
            else  cast(t1.CURR_CD as varchar(10))
            end    as CURR_CD                         --币种代码
      ,t1.INDEX_VAL	                                     --指标值
      ,t1.ETL_DT	                                       --ETL处理日期
      ,t1.ETL_TIMESTAMP	 
from
${idl_schema}.mtl_fdl_idx_index_data_jx t1
inner join mc_index_define t2
on trim(t1.index_no) = trim(t2.index_no)
  and   t1.INDEX_MEASURE in ('001','002','003','004','013','014','015','007')
where t1.etl_dt in (to_date('${batch_date}','yyyymmdd') ,to_date('${batch_date}','yyyymmdd') - 1 ,trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1  ,trunc(add_months(to_date('${batch_date}','yyyymmdd'),-1),'mm') -1 )
;



create table  ${idl_schema}.mc_index_fact_fdw_temp05_jx compress
as
select t1.*
from ${idl_schema}.mc_index_fact t1
where t1.etl_dt in (to_date('${batch_date}','yyyymmdd') - 1 ,trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
          ,trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 ,add_months(to_date('${batch_date}','yyyymmdd'),-12)
          ,add_months(to_date('${batch_date}','yyyymmdd'),-1),trunc(to_date('${batch_date}','yyyymmdd'),'Q') - 1)
;


--YL 开头的才有当月累计，当年累计
---财务集市,规模类：余额，月日均
create table  ${idl_schema}.mc_index_fact_fdw_temp01_jx compress
as
select etl_dt
,index_no
,index_name
,org_no
,org_name
,super_org_no
,org_sort
,curr_no
,curr_name
,index_value
,accu_index_value_m
,accu_index_value_y
,rate_up_day
,rate_last_month
,rate_last_year
,rate_last_period
,rate_up_day_per
,rate_last_month_per
,rate_last_year_per
,rate_last_period_per
,index_ranking
,index_ranking_cha
,index_value_avg
,index_value_limit
,ratio_index
,ratio_org
,unit
,frequency
,measure_no
,source_sys
,index_measure
,etl_timestamp
,rate_last_quater
,rate_last_quater_per
 from  ${idl_schema}.mc_index_fact
where 1=2 ;

insert into    ${idl_schema}.mc_index_fact_fdw_temp01_jx
select    to_date('${batch_date}','yyyymmdd') as etl_dt
         ,t1.index_no_mcs                     as INDEX_NO        --指标编码
         ,t1.index_name_mcs                   as INDEX_NAME      --指标名称
         ,t2.org_no                                              --机构编码
         ,t3.org_abbr                         as ORG_NAME        --机构名称
         ,t3.ADMIN_SUPER_ORG_ID               as super_org_no    --上级机构编号
         ,cast('null' as VARCHAR2(30) )       as ORG_SORT        --机构分类
         ,cast(t2.curr_cd as varchar(10))     as CURR_NO         --币种编号
         ,cast('null' as VARCHAR2(200) )      as CURR_NAME       --币种名称
         ,t2.index_val                        as INDEX_VALUE     --指标值
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'mm') =  to_date('${batch_date}','yyyymmdd')
               then t2.index_val
               else coalesce(t2.index_val ,0) +  coalesce(t4.ACCU_INDEX_VALUE_M,0)
                end                           as  ACCU_INDEX_VALUE_M    --当月累计
         ,case when trunc(to_date('${batch_date}','yyyymmdd'),'yy') =  to_date('${batch_date}','yyyymmdd')
               then t2.index_val
               else coalesce(t2.index_val ,0) + coalesce( t4.ACCU_INDEX_VALUE_Y,0)
                end                           as  ACCU_INDEX_VALUE_Y    --当年累计
         ,coalesce(t2.index_val,0) - coalesce(t4.INDEX_VALUE,0)       RATE_UP_DAY               --比上日
         ,coalesce(t2.index_val,0) - coalesce(t5.INDEX_VALUE,0)       RATE_LAST_MONTH           --比上月                                                                                                                          --比上月
         ,coalesce(t2.index_val,0) - coalesce(t6.INDEX_VALUE,0)       RATE_LAST_YEAR            --比上年
         ,coalesce(t2.index_val,0) - coalesce(t7.INDEX_VALUE,0)       RATE_LAST_PERIOD          --同比
         ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0
               else  round((coalesce(t2.index_val,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6)
               end                            as RATE_UP_DAY_PER        --比上日百分比
         ,case when coalesce(t5.INDEX_VALUE ,0) =0 then 0
               else  round((coalesce(t2.index_val,0) - coalesce(t5.INDEX_VALUE,0)) / coalesce(t5.INDEX_VALUE,0),6)
               end                            as RATE_LAST_MONTH_PER    --比上月百分比
         ,case when coalesce(t6.INDEX_VALUE ,0) =0 then 0
               else round((coalesce(t2.index_val,0) - coalesce(t6.INDEX_VALUE,0)) / coalesce(t6.INDEX_VALUE,0) ,6)
               end                            as RATE_LAST_YEAR_PER     --比上年百分比
         ,case when coalesce(t7.INDEX_VALUE ,0) =0 then 0
               else round((coalesce(t2.index_val,0) - coalesce(t7.INDEX_VALUE,0)) / coalesce(t7.INDEX_VALUE,0),6)
               end                            as RATE_LAST_PERIOD_PER   --同比百分比
         ,row_number()over(partition by t2.org_no order by   t2.index_val desc ) as  INDEX_RANKING    --当前排名
         ,row_number()over(partition by t2.org_no order by   t2.index_val desc )  -  t4.INDEX_RANKING  as INDEX_RANKING_CHA                --排名变动
         ,t8.index_val                        as INDEX_VALUE_AVG     --均值
         ,t9.sup_value                        as INDEX_VALUE_LIMIT   --阀值
         ,0                                   as RATIO_INDEX         --结构占比
         ,case when coalesce(t8.sum_index_val  ,0) =0 then 0
          else t2.index_val/t8.sum_index_val
          end                                 as RATIO_ORG           --分行贡献度
         ,t1.UNIT                                                    --单位
         ,t1.FREQUENCY                                               --频度
         ,t2.INDEX_MEASURE                    as MEASURE_NO          --度量编号
         ,'JX'                               as SOURCE_SYS
         ,case when t2.index_measure = '013' then '月年化'
               when t2.index_measure = '014' then '季年化'
               when t2.index_measure = '015' then '累计月年化'
               when t2.index_measure = '001' then '原始统计值'
               when t2.index_measure = '002' then '月日均'
               when t2.index_measure = '003' then '季日均'
               when t2.index_measure = '004' then '年日均'
             end                              as INDEX_MEASURE      --度量名称
	     ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp
       ,case when substr(t1.index_no_mcs,1,4)='GM05'
             then coalesce(t2.index_val,0) - coalesce(t10.INDEX_VALUE,0)
               else 0
               end                                                    as RATE_LAST_QUATER          --比上季
       ,case when substr(t1.index_no_mcs,1,4)='GM05'
             then (case when coalesce(t10.INDEX_VALUE ,0) =0 then 0
               else  round((coalesce(t2.index_val,0) - coalesce(t10.INDEX_VALUE,0)) / coalesce(t10.INDEX_VALUE,0),6)
               end)
          else 0
             end                             as RATE_LAST_QUATER_PER   --比上季百分比   
 from  mc_index_define t1
 inner   join   mc_index_fact_fdw_temp04_jx t2
        on   trim(t1.index_no) = trim(t2.index_no)
       and   t2.etl_dt = to_date('${batch_date}','yyyymmdd')
       and   t2.INDEX_MEASURE in   ('001','002','003','004','013','014','015','007')
 inner join mtl_fml_f99_int_org_info_new t3
       on t2.org_no = t3.org_id
      and ((t3.admin_super_org_id ='000000'  or t3.admin_super_org_id ='999999') or (to_date('${batch_date}','yyyymmdd') <=to_date('20250101','yyyymmdd') and t3.org_id='800993'))
      and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
 left join  ${idl_schema}.mc_index_fact_fdw_temp05_jx t4            --上日
       on  trim(t1.index_no_mcs) = trim(t4.index_no)
      and  t2.org_no = t4.org_no
      and  t2.curr_cd =t4.CURR_NO
      and  t2.INDEX_MEASURE =t4.measure_no
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
 left join  ${idl_schema}.mc_index_fact_fdw_temp05_jx t5            --上月末
       on  trim(t1.index_no_mcs) = trim(t5.index_no)
      and  t2.org_no = t5.org_no
      and  t2.curr_cd =t5.CURR_NO
      and  t2.INDEX_MEASURE =t5.measure_no
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact_fdw_temp05_jx t6            --上年末
       on  trim(t1.index_no_mcs) = trim(t6.index_no)
      and  t2.org_no = t6.org_no
      and  t2.curr_cd =t6.CURR_NO
      and  t2.INDEX_MEASURE =t6.measure_no
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1
  left join  ${idl_schema}.mc_index_fact_fdw_temp05_jx t7            --同比
       on  trim(t1.index_no_mcs)  = trim(t7.index_no)
      and  t2.org_no = t7.org_no
      and  t2.curr_cd =t7.CURR_NO
      and  t2.INDEX_MEASURE =t7.measure_no
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)
   left join  ${idl_schema}.mc_index_fact_fdw_temp05_jx t10            --上季
       on  trim(t1.index_no_mcs) = trim(t10.index_no)
      and  t2.org_no = t10.org_no
      and  t2.curr_cd =t10.CURR_NO
      and  t2.INDEX_MEASURE =t10.measure_no
      and  t10.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'Q') -1
 left join  (select index_no
                   ,curr_cd
                   ,index_measure
                   ,avg(coalesce(index_val,0))   as index_val
                   ,sum(coalesce(index_val,0))  as sum_index_val
               from mc_index_fact_fdw_temp04_jx
              where etl_dt = to_date('${batch_date}','yyyymmdd')
              -- and    BATCH_FREQ  = 'M'
              --  and index_measure ='001'
               group by index_no
                       ,curr_cd
                       ,index_measure
              )t8  on t2.index_no = t8.index_no        --均值
      and t2.curr_cd =t8.curr_cd
      and t2.INDEX_MEASURE =t8.INDEX_MEASURE
 left join ${idl_schema}.MC_SUP_PARA  t9
       on trim(t1.index_no_mcs)  = trim(t9.index_no)
 where  (t1.source_system in ( '财务集市（绩效）')
   and  t1.index_clsaa_f_mcs = '盈利类'
   and  t2.INDEX_MEASURE in ('001','013','014','015','007')
   and ( (T1.index_clsaa_s_mcs  IN ( '收入状况','利润状况','支出状况')
   and  T1.unit = '%') OR  T1.index_clsaa_s_mcs NOT IN ( '收入状况','利润状况','支出状况') ))
   OR (t1.source_system in ( '财务集市（绩效）')
   and  t1.index_clsaa_f_mcs = '规模类'
   and   t2.INDEX_MEASURE in ('001','002','003','004'))
   OR (t1.source_system in ( '财务集市（绩效）')
   and  t1.index_clsaa_f_mcs = '客户类'
   and   t2.INDEX_MEASURE in ('001'))
;
 commit;

-- 总体计算结构占比
-- 建临时表
create table  ${idl_schema}.mc_index_fact_fdw_temp02_jx compress
as
select INDEX_NO
     ,ORG_NO
     ,ETL_DT
     ,CURR_NO
     ,MEASURE_NO
     ,RATIO_INDEX
from ${idl_schema}.mc_index_fact
where 1=2 ;

-- 新绩效：按“机构”+“日期”+“币种”+“度量”，该指标指标值/存款总额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02_jx
select  t1.INDEX_NO                       -- 指标编号
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0
          else t1.index_value/t2.index_value
          end  as RATIO_INDEX             -- 结构占比
from mc_index_fact_fdw_temp01_jx t1
left join mc_index_fact_fdw_temp01_jx t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'JX01000117'    -- 存款总额指标值
where t1.INDEX_NO in ( 'JX01000118','JX01000124','JX02000131')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd')
;
commit ;
-- 新绩效：按“机构”+“日期”+“币种”+“度量”，该指标指标值/公司存款余额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02_jx
select  t1.INDEX_NO                       -- 指标编号
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0
          else t1.index_value/t2.index_value
          end  as RATIO_INDEX             -- 结构占比
from mc_index_fact_fdw_temp01_jx t1
left join mc_index_fact_fdw_temp01_jx t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'JX01000118'    -- 公司存款余额指标值
where t1.INDEX_NO in ('JX01000119','JX01000120','JX01000121','JX01000122','JX01000123')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd')
;
commit;
-- 新绩效：按“机构”+“日期”+“币种”+“度量”，该指标指标值/零售存款余额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02_jx
select  t1.INDEX_NO                       -- 指标编号
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0
          else t1.index_value/t2.index_value
          end  as RATIO_INDEX             -- 结构占比
from mc_index_fact_fdw_temp01_jx t1
left join mc_index_fact_fdw_temp01_jx t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'JX01000124'    -- 零售存款余额指标值
where t1.INDEX_NO in ('JX01000125','JX01000126','JX01000127','JX01000128')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd')
;
commit;
-- 新绩效：按“机构”+“日期”+“币种”+“度量”，表内指标值/信用证、承兑汇票、保函、非保本理财
insert into    ${idl_schema}.mc_index_fact_fdw_temp02_jx
select  t1.INDEX_NO                       -- 指标编号
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(sum(t2.index_value),0) =0 then 0
          else t1.index_value/sum(t2.index_value)
          end  as RATIO_INDEX             -- 结构占比
from mc_index_fact_fdw_temp01_jx t1
left join mc_index_fact_fdw_temp01_jx t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO in ('JX01001201','JX01001202','JX01001203','JX01001204')    -- 信用证、承兑汇票、保函、非保本理财
where t1.INDEX_NO in ('JX01001201','JX01001202','JX01001203','JX01001204')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd')
    group by t1.INDEX_NO, t1.ORG_NO, t1.ETL_DT, t1.CURR_NO, t1.MEASURE_NO, t1.index_value
;
commit;

-- 	YL04040001	存贷比	JXI0000001贷款总额_绩效/JXI0000007存款总额_绩效
INSERT INTO  ${idl_schema}.mc_index_fact_fdw_temp01_jx
(ETL_DT,INDEX_NO,INDEX_NAME,ORG_NO,ORG_NAME,SUPER_ORG_NO,ORG_SORT,CURR_NO,CURR_NAME,INDEX_VALUE,MEASURE_NO,SOURCE_SYS,INDEX_MEASURE,UNIT)                                                                                
SELECT T1.ETL_DT
      ,'YL04040001'                           AS INDEX_NO
      ,'存贷比'                     AS INDEX_NAME
      ,T1.ORG_NO
      ,T1.ORG_NAME
      ,T1.SUPER_ORG_NO
      ,T1.ORG_SORT
      ,T1.CURR_NO
      ,T1.CURR_NAME
      ,CASE WHEN SUM( CASE WHEN T1.INDEX_NO = 'JX01000117' THEN COALESCE(T1.INDEX_VALUE,0) ELSE 0 END  ) = 0 THEN 0 
            ELSE ROUND(  SUM(CASE WHEN T1.INDEX_NO = 'JX01000111' THEN COALESCE(T1.INDEX_VALUE,0) ELSE 0 END)
                        /SUM(CASE WHEN T1.INDEX_NO = 'JX01000117' THEN COALESCE(T1.INDEX_VALUE,0) ELSE 0 END)
                    ,6)
       END                                    AS INDEX_VALUE             -- 存贷比（含贴现）指标值
      ,'001'                                  AS MEASURE_NO              -- 度量编号   
      ,'JX'                                  AS SOURCE_SYS                                                
      ,'原始统计值'                           AS INDEX_MEASURE           -- 度量名称
      ,'%'                                    AS UNIT
from ${idl_schema}.mc_index_fact_fdw_temp01_jx T1
WHERE T1.INDEX_NO in ( 'JX01000111','JX01000117')
  AND T1.MEASURE_NO = '001'                                              -- 001_原始统计值 
  AND T1.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
GROUP BY T1.ETL_DT
      ,T1.ORG_NO
      ,T1.ORG_NAME
      ,T1.SUPER_ORG_NO
      ,T1.ORG_SORT
      ,T1.CURR_NO
      ,T1.CURR_NAME
;
COMMIT ;

-- 	JX01000150	公司条线资产余额	JXI0000004公司贷款余额+JXI0000036类信贷（公司）
INSERT INTO  ${idl_schema}.mc_index_fact_fdw_temp01_jx
(ETL_DT,INDEX_NO,INDEX_NAME,ORG_NO,ORG_NAME,SUPER_ORG_NO,ORG_SORT,CURR_NO,CURR_NAME,INDEX_VALUE,MEASURE_NO,SOURCE_SYS,INDEX_MEASURE,UNIT)                                                                                
SELECT T1.ETL_DT
      ,'JX01000150'                           AS INDEX_NO
      ,'公司条线资产余额'                     AS INDEX_NAME
      ,T1.ORG_NO
      ,T1.ORG_NAME
      ,T1.SUPER_ORG_NO
      ,T1.ORG_SORT
      ,T1.CURR_NO
      ,T1.CURR_NAME
      ,sum(t1.INDEX_VALUE)                    AS INDEX_VALUE             -- 公司条线资产余额指标值
      ,'001'                                  AS MEASURE_NO              -- 度量编号   
      ,'JX'                                  AS SOURCE_SYS                                                
      ,'原始统计值'                           AS INDEX_MEASURE           -- 度量名称
      ,'总行亿元、分行万元'                                    AS UNIT
from ${idl_schema}.mc_index_fact_fdw_temp01_jx T1
WHERE T1.INDEX_NO in ( 'JX01000114','JX01000146')
  AND T1.MEASURE_NO = '001'                                              -- 001_原始统计值 
  AND T1.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
GROUP BY T1.ETL_DT
      ,T1.ORG_NO
      ,T1.ORG_NAME
      ,T1.SUPER_ORG_NO
      ,T1.ORG_SORT
      ,T1.CURR_NO
      ,T1.CURR_NAME
;
COMMIT ;

create table  ${idl_schema}.mc_index_fact_fdw_temp03_jx compress
as
select *
 from ${idl_schema}.mc_index_fact
where 1=2 ;
insert into    ${idl_schema}.mc_index_fact_fdw_temp03_jx
select  t1.ETL_DT
       ,t1.INDEX_NO
       ,t1.INDEX_NAME
       ,t1.ORG_NO
       ,t1.ORG_NAME
       ,t1.SUPER_ORG_NO
       ,t1.ORG_SORT
       ,t1.CURR_NO
       ,t1.CURR_NAME
       ,t1.INDEX_VALUE
       ,t1.ACCU_INDEX_VALUE_M   AS ACCU_INDEX_VALUE_M      -- 当月累计
       ,t1.ACCU_INDEX_VALUE_Y   AS ACCU_INDEX_VALUE_Y      -- 当年累计
       ,coalesce(t1.INDEX_VALUE,0) - coalesce(t5.INDEX_VALUE,0) AS RATE_UP_DAY             -- 比上日
       ,COALESCE(T1.INDEX_VALUE,0)-COALESCE(T2.INDEX_VALUE,0) 
                                              AS RATE_LAST_MONTH         -- 比上月
       ,COALESCE(T1.INDEX_VALUE,0)-COALESCE(T3.INDEX_VALUE,0) 
                                              AS RATE_LAST_YEAR          -- 比上年
       ,COALESCE(T1.INDEX_VALUE,0)-COALESCE(T4.INDEX_VALUE,0) 
                                              AS RATE_LAST_PERIOD        -- 同比
	   ,case when coalesce(t5.INDEX_VALUE ,0) =0 then 0
               else  round((coalesce(t1.INDEX_VALUE,0) - coalesce(t5.INDEX_VALUE,0)) / coalesce(t5.INDEX_VALUE,0),6)
               end                            as RATE_UP_DAY_PER        --比上日百分比
       ,case when coalesce(t2.INDEX_VALUE ,0) =0 then 0
               else  round((coalesce(t1.INDEX_VALUE,0) - coalesce(t2.INDEX_VALUE,0)) / coalesce(t2.INDEX_VALUE,0),6)
               end                            as RATE_LAST_MONTH_PER    --比上月百分比
       ,case when coalesce(t3.INDEX_VALUE ,0) =0 then 0
               else round((coalesce(t1.INDEX_VALUE,0) - coalesce(t3.INDEX_VALUE,0)) / coalesce(t3.INDEX_VALUE,0) ,6)
               end                            as RATE_LAST_YEAR_PER     --比上年百分比
       ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0
               else round((coalesce(t1.INDEX_VALUE,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6)
               end                            as RATE_LAST_PERIOD_PER   --同比百分比									  
       ,t1.INDEX_RANKING
       ,t1.INDEX_RANKING_CHA
       ,t1.INDEX_VALUE_AVG
       ,t1.INDEX_VALUE_LIMIT
       ,coalesce(t2.RATIO_INDEX ,t1.RATIO_INDEX) as  RATIO_INDEX
       ,t1.RATIO_ORG
       ,t1.UNIT as UNIT
       ,t1.FREQUENCY
       ,t1.MEASURE_NO
       ,t1.SOURCE_SYS
       ,t1.INDEX_MEASURE
       ,t1.ETL_TIMESTAMP
       ,t1.RATE_LAST_QUATER
       ,t1.RATE_LAST_QUATER_PER
       ,null							                    AS SUPERVISION_REQUIRE -- 监管要求
	   ,null							                    AS LIMIT_VALUE  -- 限额值
	   ,null							                    AS PREWARNING_VALUE  -- 预警值
       ,null																	AS INTRV_TYPE -- 区间类型
       ,0                                    AS RATE_LAST_WEEK      --比上周               
from mc_index_fact_fdw_temp01_jx t1
LEFT JOIN  ${idl_schema}.mc_index_fact_fdw_temp05_jx T2                               
   ON T1.INDEX_NO = T2.INDEX_NO
  AND T1.MEASURE_NO = T2.MEASURE_NO
  AND T1.CURR_NO = T2.CURR_NO
  AND T1.ORG_NO = T2.ORG_NO
  AND T2.ETL_DT = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1     -- 上月
LEFT JOIN  ${idl_schema}.mc_index_fact_fdw_temp05_jx T3                               
   ON T3.INDEX_NO  = T1.INDEX_NO
  AND T1.MEASURE_NO = T3.MEASURE_NO
  AND T1.CURR_NO = T3.CURR_NO
  AND T1.ORG_NO = T3.ORG_NO
  AND T3.ETL_DT = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1     -- 上年
LEFT JOIN  ${idl_schema}.mc_index_fact_fdw_temp05_jx T4                              
   ON T4.INDEX_NO = T1.INDEX_NO
  AND T1.MEASURE_NO = T4.MEASURE_NO
  AND T1.CURR_NO = T4.CURR_NO
  AND T1.ORG_NO = T4.ORG_NO
  AND T4.ETL_DT = ADD_MONTHS(TO_DATE('${batch_date}','yyyymmdd'),-12)    -- 上年同期
left join  ${idl_schema}.mc_index_fact_fdw_temp05_jx t5            --上日
   ON T5.INDEX_NO = T1.INDEX_NO
  AND T1.MEASURE_NO = T5.MEASURE_NO
  AND T1.CURR_NO = T5.CURR_NO
  AND T1.ORG_NO = T5.ORG_NO
  and  t5.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
;
commit ;


	  alter table ${idl_schema}.mc_index_fact exchange subpartition p_${batch_date}_jx with table ${idl_schema}.mc_index_fact_fdw_temp03_jx ;
	  commit;
--alter index fact_all_index rebuild online;

whenever sqlerror continue none;
--drop table ${idl_schema}.mc_index_fact_fdw_temp01_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp02_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp03_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp04_jx purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp05_jx purge;
-- 3.1 gather table status
--exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact',partname => 'p_${batch_date}_jx', granularity => 'SUBPARTITION', degree => 8, cascade => true);
