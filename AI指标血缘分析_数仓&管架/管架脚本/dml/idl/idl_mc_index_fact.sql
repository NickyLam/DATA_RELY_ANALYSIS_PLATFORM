set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

alter table ${idl_schema}.mc_index_fact add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
drop table ${idl_schema}.mc_index_fact_temp01 purge ;
drop table ${idl_schema}.mc_index_fact_temp02 purge;
drop table ${idl_schema}.mc_index_fact_temp03 purge;
drop table ${idl_schema}.mc_index_fact_temp04 purge;
drop table ${idl_schema}.mc_index_fact_temp05 purge;
whenever sqlerror exit sql.sqlcode; 

alter table ${idl_schema}.mc_index_fact truncate partition p_${batch_date};
-- 2.1 insert data to table

---YL 开头的才有当月累计，当年累计
----财务集市
create table  ${idl_schema}.mc_index_fact_temp01
as                                                                                            
select    t1.index_no_mcs  as INDEX_NO   --指标编码                                                           
         ,t1.index_name_mcs  as INDEX_NAME --指标名称                                                          
         ,t2.org_no            --机构编码                                                          
         ,t3.org_abbr    as ORG_NAME     --机构名称                                                          
         ,t3.super_org_no	   --上级机构编号                                                                         
         ,'null'  as ORG_SORT            --机构分类                                                          
         ,t2.curr_cd  as CURR_NO                --币种编号                                                          
         ,'null'      as CURR_NAME      --币种名称
         ,t2.index_val as INDEX_VALUE      --指标值                                                           
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'mm') =  to_date('${batch_date}','yyyymmdd') 
               then t2.index_val 
               else t2.index_val  +  t4.ACCU_INDEX_VALUE_M
                end as  ACCU_INDEX_VALUE_M       --当月累计                                                          
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'yy') =  to_date('${batch_date}','yyyymmdd') 
               then t2.index_val 
               else t2.index_val  +  t4.ACCU_INDEX_VALUE_Y
                end as  ACCU_INDEX_VALUE_Y                 --当年累计                                                         
         ,t2.index_val - t4.INDEX_VALUE       RATE_UP_DAY                     --比上日   
         ,t2.index_val - t5.INDEX_VALUE       RATE_LAST_MONTH                 --比上月                                                                                                                             --比上月                                                           
         ,t2.index_val - t6.INDEX_VALUE       RATE_LAST_YEAR                  --比上年                                                           
         ,t2.index_val - t7.INDEX_VALUE       RATE_LAST_PERIOD                 --同比                                                            
         ,case when nvl(t4.INDEX_VALUE ,0) =0 then 0 
               else  (t2.index_val - t4.INDEX_VALUE) / t4.INDEX_VALUE 
               end  as RATE_UP_DAY_PER        --比上日百分比                                                        
         ,case when nvl(t5.INDEX_VALUE ,0) =0 then 0 
               else  (t2.index_val - t5.INDEX_VALUE) / t5.INDEX_VALUE 
               end as RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,case when nvl(t6.INDEX_VALUE ,0) =0 then 0 
               else (t2.index_val - t6.INDEX_VALUE) / t6.INDEX_VALUE 
               end as RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,case when nvl(t7.INDEX_VALUE ,0) =0 then 0 
               else (t2.index_val - t7.INDEX_VALUE) / t7.INDEX_VALUE 
               end as RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,row_number()over(partition by t2.org_no order by   t2.index_val desc ) as  INDEX_RANKING    --当前排名                                                          
         ,row_number()over(partition by t2.org_no order by   t2.index_val desc )  -  t4.INDEX_RANKING  as INDEX_RANKING_CHA                --排名变动                                                          
         ,t8.index_val    as INDEX_VALUE_AVG     --均值                                                            
         ,t9.sup_value     as INDEX_VALUE_LIMIT    --阀值                                                            
         ,0 as RATIO_INDEX        --结构占比                                                           
         ,case when nvl(t8.sum_index_val  ,0) =0 then 0 
          else t2.index_val/t8.sum_index_val 
          end  as RATIO_ORG           --分行贡献度                                                         
         ,t1.UNIT      --单位                                                            
         ,t1.FREQUENCY        --频度    
         ,t2.INDEX_MEASURE  as MEASURE_NO ---度量编号
         ,case when t2.index_measure = '001' then '原始统计值'
               when t2.index_measure = '005' then '人均'
               when t2.index_measure = '006' then '网均'
               when t2.index_measure = '015' then '累计月年化'
             end as INDEX_MEASURE --度量名称                                                          
       ,to_date('${batch_date}','yyyymmdd') as etl_dt 
	     ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp 
 from  mc_index_define t1
 inner   join   mtl_fdl_idx_index_data t2
        on   trim(t1.index_no) = trim(t2.index_no)
       and   t2.etl_dt = to_date('${batch_date}','yyyymmdd') 
     --  and   t2.INDEX_MEASURE ='001'
 inner join mtl_fml_f99_int_org_info t3
       on t2.org_no = t3.org_no
      and (t3.super_org_no ='000000'  or t3.super_org_no ='999999')
      and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
 left join  ${idl_schema}.mc_index_fact t4            ---上日
       on  trim(t2.index_no) = trim(t4.index_no)  
      and  t2.org_no = t4.org_no
      and  t2.curr_cd =t4.CURR_NO 
      and  t2.INDEX_MEASURE =t4.INDEX_MEASURE 
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
 left join  ${idl_schema}.mc_index_fact t5            ---上月   
       on  trim(t2.index_no) = trim(t5.index_no)              
      and  t2.org_no = t5.org_no                              
      and  t2.curr_cd =t5.CURR_NO                             
      and  t2.INDEX_MEASURE =t5.INDEX_MEASURE                 
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            ---上年             
       on  trim(t2.index_no) = trim(t6.index_no)                        
      and  t2.org_no = t6.org_no                                        
      and  t2.curr_cd =t6.CURR_NO                                       
      and  t2.INDEX_MEASURE =t6.INDEX_MEASURE                           
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 
  left join  ${idl_schema}.mc_index_fact t7            ---同比            
       on  trim(t2.index_no) = trim(t7.index_no)                        
      and  t2.org_no = t7.org_no                                        
      and  t2.curr_cd =t7.CURR_NO                                       
      and  t2.INDEX_MEASURE =t7.INDEX_MEASURE                           
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)      
 left join  (select index_no
                   ,curr_cd
                   ,index_measure 
                   ,avg(index_val)  as index_val
                   ,sum(index_val)  as sum_index_val
               from mtl_fdl_idx_index_data 
              where etl_dt = to_date('${batch_date}','yyyymmdd') 
              ---  and index_measure ='001'  
               group by index_no
                       ,curr_cd
                       ,index_measure 
              )t8  on t2.index_no = t8.index_no         ---均值
      and t2.curr_cd =t8.curr_cd                                       
      and t2.INDEX_MEASURE =t8.INDEX_MEASURE 
 left join ${idl_schema}.MC_SUP_PARA  t9
       on trim(t1.index_no) = trim(t9.index_no) 
 where  t1.source_system = '财务集市'
   and  t2.INDEX_MEASURE in ('001','005','006','015','002')
   ;
 commit;
 


create table  ${idl_schema}.mc_index_fact_temp02
as                                                                                            
select    t1.index_no_mcs  as INDEX_NO   --指标编码                                                           
         ,t1.index_name_mcs  as INDEX_NAME --指标名称                                                          
         ,t2.org_no            --机构编码                                                          
         ,t3.org_abbr    as ORG_NAME     --机构名称                                                          
         ,t3.super_org_no	   --上级机构编号                                                                         
         ,'null'  as ORG_SORT            --机构分类                                                          
         ,t2.curr_cd  as CURR_NO                --币种编号                                                          
         ,'null'      as CURR_NAME      --币种名称
         ,t2.indx_val as INDEX_VALUE      --指标值                                                           
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'mm') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_M
                end as  ACCU_INDEX_VALUE_M       --当月累计                                                          
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'yy') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_Y
                end as  ACCU_INDEX_VALUE_Y                 --当年累计                                                         
         ,t2.indx_val - t4.INDEX_VALUE       RATE_UP_DAY                     --比上日   
         ,t2.indx_val - t5.INDEX_VALUE       RATE_LAST_MONTH                 --比上月                                                                                                                             --比上月                                                           
         ,t2.indx_val - t6.INDEX_VALUE       RATE_LAST_YEAR                  --比上年                                                           
         ,t2.indx_val - t7.INDEX_VALUE       RATE_LAST_PERIOD                 --同比                                                            
         ,case when nvl(t4.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t4.INDEX_VALUE) / t4.INDEX_VALUE 
               end  as RATE_UP_DAY_PER        --比上日百分比                                                        
         ,case when nvl(t5.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t5.INDEX_VALUE) / t5.INDEX_VALUE 
               end as RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,case when nvl(t6.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t6.INDEX_VALUE) / t6.INDEX_VALUE 
               end as RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,case when nvl(t7.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t7.INDEX_VALUE) / t7.INDEX_VALUE 
               end as RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,row_number()over(partition by t2.org_no order by   t2.indx_val desc ) as  INDEX_RANKING    --当前排名                                                          
         ,row_number()over(partition by t2.org_no order by   t2.indx_val desc )  -  t4.INDEX_RANKING  as INDEX_RANKING_CHA                --排名变动                                                          
         ,t8.index_val    as INDEX_VALUE_AVG     --均值                                                            
         ,t9.sup_value     as INDEX_VALUE_LIMIT    --阀值                                                            
         ,0 as RATIO_INDEX        --结构占比                                                           
         ,case when nvl(t8.sum_index_val  ,0) =0 then 0 
          else t2.indx_val/t8.sum_index_val 
        end  as RATIO_ORG           --分行贡献度                                                         
         ,t1.UNIT      --单位                                                            
         ,t1.FREQUENCY        --频度                                                            
         ,'001'       as MEASURE_NO           --度量编号                                                          
         ,'原始统计值'    as INDEX_MEASURE                 --度量名称                                                          
       ,to_date('${batch_date}','yyyymmdd') as etl_dt                                          --数据日期      
	     ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp          --数据加载时间      
 from  mc_index_define t1
 inner  join   mtl_rdl_idx_indx_data t2
        on   trim(t1.index_no) = trim(t2.indx_no)
       and   t2.etl_dt = to_date('${batch_date}','yyyymmdd') 
       and   trim(t2.INDX_DIMEN_CD) ='ALL'
 left  join mtl_fml_f99_int_org_info t3
       on t2.org_no = t3.org_no
      --and (t3.super_org_no ='000000'  or t3.super_org_no ='999999')
      and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
 left join  ${idl_schema}.mc_index_fact t4            ---上日
       on  trim(t2.indx_no) = trim(t4.index_no)  
      and  t2.org_no = t4.org_no
      and  t2.curr_cd =t4.CURR_NO 
      and  t2.INDEX_MEASURE =t4.INDEX_MEASURE 
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
 left join  ${idl_schema}.mc_index_fact t5            ---上月   
       on  trim(t2.indx_no) = trim(t5.index_no)              
      and  t2.org_no = t5.org_no                              
      and  t2.curr_cd =t5.CURR_NO                             
      and  t2.INDEX_MEASURE =t5.INDEX_MEASURE                 
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            ---上年             
       on  trim(t2.indx_no) = trim(t6.index_no)                        
      and  t2.org_no = t6.org_no                                        
      and  t2.curr_cd =t6.CURR_NO                                       
      and  t2.INDEX_MEASURE =t6.INDEX_MEASURE                           
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 
  left join  ${idl_schema}.mc_index_fact t7            ---同比            
       on  trim(t2.indx_no) = trim(t7.index_no)                        
      and  t2.org_no = t7.org_no                                        
      and  t2.curr_cd =t7.CURR_NO                                       
      and  t2.INDEX_MEASURE =t7.INDEX_MEASURE                           
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)      
 left join  (select indx_no
                   ,curr_cd
                   ,index_measure 
                   ,avg(indx_val)  as index_val
                   ,sum(indx_val)  as sum_index_val
               from MTL_RCL_IDX_INDX_DATA 
              where etl_dt = to_date('${batch_date}','yyyymmdd') 
                and trim(INDX_DIMEN_CD) ='ALL'  
               group by indx_no
                       ,curr_cd
                       ,index_measure 
              )t8  on t2.indx_no = t8.indx_no         ---均值
      and t2.curr_cd =t8.curr_cd                                       
      and t2.INDEX_MEASURE =t8.INDEX_MEASURE 
 left join ${idl_schema}.MC_SUP_PARA  t9
       on trim(t1.index_no) = trim(t9.index_no) 
 where  t1.source_system = '风险集市'   
 ; 
 
 
----同业 TY01010000 ,不用自算

create table  ${idl_schema}.mc_index_fact_temp03
as                                                                                            
select    t1.index_no_mcs  as INDEX_NO   --指标编码                                                           
         ,t1.index_name_mcs  as INDEX_NAME --指标名称                                                          
         ,t2.org_no            --机构编码                                                          
         ,t3.S_INFO_COMPNAME    as ORG_NAME     --公司名称                                                        
         ,' '	as super_org_no   --上级机构编号                                                                         
         ,'null'  as ORG_SORT            --机构分类                                                          
         ,t2.CURR_NO  as CURR_NO                --币种编号                                                          
         ,'人民币'      as CURR_NAME      --币种名称
         ,t2.indx_val as INDEX_VALUE      --指标值                                                           
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'mm') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_M
                end as  ACCU_INDEX_VALUE_M       --当月累计                                                          
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'yy') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_Y
                end as  ACCU_INDEX_VALUE_Y                 --当年累计                                                         
         ,t2.indx_val - t4.INDEX_VALUE       RATE_UP_DAY                     --比上日   
         ,t2.indx_val - t5.INDEX_VALUE       RATE_LAST_MONTH                 --比上月                                                                                                                             --比上月                                                           
         ,t2.indx_val - t6.INDEX_VALUE       RATE_LAST_YEAR                  --比上年                                                           
         ,t2.indx_val - t7.INDEX_VALUE       RATE_LAST_PERIOD                 --同比                                                            
         ,case when nvl(t4.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t4.INDEX_VALUE) / t4.INDEX_VALUE 
               end  as RATE_UP_DAY_PER        --比上日百分比                                                        
         ,case when nvl(t5.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t5.INDEX_VALUE) / t5.INDEX_VALUE 
               end as RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,case when nvl(t6.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t6.INDEX_VALUE) / t6.INDEX_VALUE 
               end as RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,case when nvl(t7.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t7.INDEX_VALUE) / t7.INDEX_VALUE 
               end as RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,row_number()over(partition by t1.index_no_mcs,t2.org_no order by   t2.indx_val desc ) as  INDEX_RANKING    --当前排名                                                          
         ,row_number()over(partition by t1.index_no_mcs,t2.org_no order by   t2.indx_val desc )  -  t4.INDEX_RANKING  as INDEX_RANKING_CHA                --排名变动                                                          
         ,cast(null as NUMBER)   as INDEX_VALUE_AVG --t8.index_val    as INDEX_VALUE_AVG     --均值                                                            
         ,cast(null as NUMBER)    as INDEX_VALUE_LIMIT  -- t9.sup_value     as INDEX_VALUE_LIMIT    --阀值                                                            
         ,0 as RATIO_INDEX        --结构占比                                                           
         ,cast (null  as number(20,4)) as RATIO_ORG  /*  case when nvl(t8.sum_index_val  ,0) =0 then 0 
          else t2.indx_val/t8.sum_index_val 
           end  as RATIO_ORG           --分行贡献度
           */                                                         
         ,t1.UNIT      --单位                                                            
         ,t1.FREQUENCY        --频度                                                            
         ,'001'       as MEASURE_NO           --度量编号                                                          
         ,'原始统计值'    as INDEX_MEASURE                 --度量名称                                                          
       ,to_date('${batch_date}','yyyymmdd') as etl_dt                                          --数据日期      
	     ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp          --数据加载时间      
 from  mc_index_define t1 
 inner join (
             select S_INFO_COMPCODE	as org_no--公司ID
                    ,cast( TOT_ASSETS	as  NUMBER(30,8))  as indx_val---资产总计
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY01010000'   as indx_no
             from mtl_WIND_ASHAREBALANCESHEET
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,TOT_ASSETS	    as indx_val---资产总计          
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY01010000'   as indx_no
             from mtl_WIND_UNLISTEDBANKBALANCESHEET
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_WINDCODE	     as org_no--公司ID             
                   ,TOTAL_DEPOSIT	 as indx_val---存款总额         
                   ,CRNCY_CODE	   as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY01011000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,TOTAL_DEPOSIT	  as indx_val---存款总额        
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY01011000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')  
              union all
             select S_INFO_WINDCODE	as org_no--公司ID             
                   ,TOTAL_LOAN	    as indx_val---贷款总额          
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY01021000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')     
              union all
             select S_INFO_COMPCODE	   as org_no--公司ID              S_INFO_WINDCODE	Wind代码
                   ,TOTAL_LOAN	       as indx_val---贷款总额          
                   ,CRNCY_CODE	       as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY01021000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all 
             select S_INFO_COMPCODE	as org_no--公司ID
                    , TOT_SHRHLDR_EQY_INCL_MIN_INT	  as indx_val ---股东权益合计(含少数股东权益)
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY01030000'   as indx_no
             from mtl_WIND_ASHAREBALANCESHEET
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,TOT_SHRHLDR_EQY_INCL_MIN_INT	    as indx_val---股东权益合计(含少数股东权益)          
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY01030000'   as indx_no
             from mtl_WIND_UNLISTEDBANKBALANCESHEET
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
--- WIND_ASHAREBANKINDICATOR ,WIND_UNLISTEDBANKINDICATOR  S_INFO_WINDCODE
union all 
             select S_INFO_WINDCODE	as org_no--公司ID
                    , NET_INTEREST_MARGIN	  as indx_val ---净息差
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY02031000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,NET_INTEREST_MARGIN	    as indx_val---净息差
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY02031000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')   
--- WIND_ASHAREBANKINDICATOR ,WIND_UNLISTEDBANKINDICATOR  S_INFO_WINDCODE                        
 union all 
             select S_INFO_WINDCODE	as org_no--公司ID
                    , NET_INTEREST_SPREAD	  as indx_val ---净利差
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY02032000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,NET_INTEREST_SPREAD	    as indx_val---净利差
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY02032000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
--- WIND_ASHAREBANKINDICATOR ,WIND_UNLISTEDBANKINDICATOR  S_INFO_WINDCODE              
 union all 
             select s_info_windcode	as org_no--公司ID
                    , COST_INCOME_RATIO	  as indx_val ---成本收入比
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY02032000'   as indx_no
             from mtl_wind_asharebankindicator
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,COST_INCOME_RATIO	    as indx_val---成本收入比
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY02032000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')                              
union all 
             select S_INFO_COMPCODE	as org_no--公司ID
                    , TOT_BAL_NET_PROFIT	  as indx_val ---净利润差额
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY02011000'   as indx_no
             from mtl_WIND_ASHAREINCOME
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,TOT_BAL_NET_PROFIT	    as indx_val---净利润差额
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY02011000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINCOME
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
 union all 
             select S_INFO_WINDCODE	as org_no--公司ID
                    , NON_INTEREST_MARGIN	  as indx_val ---非利息收入占比
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY02012000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,NON_INTEREST_MARGIN	    as indx_val---非利息收入占比
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY02012000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')                          
    union all 
             select S_INFO_WINDCODE	as org_no--公司ID
                    , CAPI_ADE_RATIO	  as indx_val ---资本充足率
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY03010000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,CAPI_ADE_RATIO	    as indx_val---资本充足率
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY03010000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')          
 
union all 
             select S_INFO_WINDCODE	as org_no--公司ID
                    , NPL_RATIO	  as indx_val ---不良贷款比例
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY03021000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,NPL_RATIO	    as indx_val---不良贷款比例
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY03021000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')             
union all 
             select S_INFO_WINDCODE	as org_no--公司ID
                    , BAD_LOAD_FIVE_CLASS	  as indx_val ---不良贷款余额（5级分类）
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY03022000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,BAD_LOAD_FIVE_CLASS	    as indx_val---不良贷款余额（5级分类）
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY03022000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             
 union all 
             select S_INFO_WINDCODE	as org_no--公司ID
                    , NPL_PROVISION_COVERAGE	  as indx_val ---不良贷款拨备覆盖率
                    ,CRNCY_CODE	    as CURR_NO --货币代码
                    ,etl_dt
                    ,'TY03023000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR
             where CRNCY_CODE = 'CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd') 
             union all
             select S_INFO_COMPCODE	as org_no--公司ID             
                   ,NPL_PROVISION_COVERAGE	    as indx_val---不良贷款拨备覆盖率
                   ,CRNCY_CODE	    as CURR_NO --货币代码           
                   ,etl_dt
                   ,'TY03023000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR
             where CRNCY_CODE  ='CNY'
             and etl_dt = to_date('${batch_date}','yyyymmdd')              
         union all
                select t1.S_INFO_COMPCODE	as org_no--公司ID             
                   ,t1.NPL_PROVISION_COVERAGE	*NPL_RATIO      as indx_val---拨贷比
                   ,t1.CRNCY_CODE	    as CURR_NO --货币代码           
                   ,t1.etl_dt
                   ,'TY03024000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINDICATOR t1    
             where t1.CRNCY_CODE  ='CNY'
               and t1.etl_dt = to_date('${batch_date}','yyyymmdd')                                    
          ) t2  on t1.index_no_mcs = t2.indx_no
   left  join mtl_WIND_BANKINGFICLASSCBRC t3
          on t2.org_no = t3.S_INFO_COMPCODE
         and t3.etl_dt = to_date('${batch_date}','yyyymmdd') 
   left join  ${idl_schema}.mc_index_fact t4            ---上日
       on  trim(t2.indx_no) = trim(t4.index_no)  
      and  t2.org_no = t4.org_no
      and  t2.CURR_NO =t4.CURR_NO 
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1       
  left join  ${idl_schema}.mc_index_fact t5            ---上月   
       on  trim(t2.indx_no) = trim(t5.index_no)              
      and  t2.org_no = t5.org_no                              
      and  t2.CURR_NO =t5.CURR_NO                                            
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            ---上年             
       on  trim(t2.indx_no) = trim(t6.index_no)                        
      and  t2.org_no = t6.org_no                                        
      and  t2.CURR_NO =t6.CURR_NO                                                                 
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 
  left join  ${idl_schema}.mc_index_fact t7            ---同比            
       on  trim(t2.indx_no) = trim(t7.index_no)                        
      and  t2.org_no = t7.org_no                                        
      and  t2.CURR_NO =t7.CURR_NO                                                                 
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)    
       ;
          


----同业 TY01010000 ,自算，半年

create table  ${idl_schema}.mc_index_fact_temp04
as                                                                                            
select    t1.index_no_mcs  as INDEX_NO   --指标编码                                                           
         ,t1.index_name_mcs  as INDEX_NAME --指标名称                                                          
         ,t2.org_no            --机构编码                                                          
         ,t3.S_INFO_COMPNAME    as ORG_NAME     --公司名称                                                        
         ,' '	as super_org_no   --上级机构编号                                                                         
         ,'null'  as ORG_SORT            --机构分类                                                          
         ,t2.CURR_NO  as CURR_NO                --币种编号                                                          
         ,'人民币'      as CURR_NAME      --币种名称
         ,t2.indx_val as INDEX_VALUE      --指标值                                                           
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'mm') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_M
                end as  ACCU_INDEX_VALUE_M       --当月累计                                                          
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'yy') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_Y
                end as  ACCU_INDEX_VALUE_Y                 --当年累计                                                         
         ,t2.indx_val - t4.INDEX_VALUE       RATE_UP_DAY                     --比上日   
         ,t2.indx_val - t5.INDEX_VALUE       RATE_LAST_MONTH                 --比上月                                                                                                                             --比上月                                                           
         ,t2.indx_val - t6.INDEX_VALUE       RATE_LAST_YEAR                  --比上年                                                           
         ,t2.indx_val - t7.INDEX_VALUE       RATE_LAST_PERIOD                 --同比                                                            
         ,case when nvl(t4.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t4.INDEX_VALUE) / t4.INDEX_VALUE 
               end  as RATE_UP_DAY_PER        --比上日百分比                                                        
         ,case when nvl(t5.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t5.INDEX_VALUE) / t5.INDEX_VALUE 
               end as RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,case when nvl(t6.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t6.INDEX_VALUE) / t6.INDEX_VALUE 
               end as RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,case when nvl(t7.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t7.INDEX_VALUE) / t7.INDEX_VALUE 
               end as RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,row_number()over(partition by t1.index_no_mcs,t2.org_no order by   t2.indx_val desc ) as  INDEX_RANKING    --当前排名                                                          
         ,row_number()over(partition by t1.index_no_mcs,t2.org_no order by   t2.indx_val desc )  -  t4.INDEX_RANKING  as INDEX_RANKING_CHA                --排名变动                                                          
         ,cast(null as NUMBER)   as INDEX_VALUE_AVG --t8.index_val    as INDEX_VALUE_AVG     --均值                                                            
         ,cast(null as NUMBER)    as INDEX_VALUE_LIMIT  -- t9.sup_value     as INDEX_VALUE_LIMIT    --阀值                                                          
         ,0 as RATIO_INDEX        --结构占比                                                           
         ,cast (null  as number(20,4)) as RATIO_ORG  /*  case when nvl(t8.sum_index_val  ,0) =0 then 0 
          else t2.indx_val/t8.sum_index_val 
           end  as RATIO_ORG           --分行贡献度
           */                                                         
         ,t1.UNIT      --单位                                                            
         ,t1.FREQUENCY        --频度                                                            
         ,'001'       as MEASURE_NO           --度量编号                                                          
         ,'原始统计值'    as INDEX_MEASURE                 --度量名称                                                          
       ,to_date('${batch_date}','yyyymmdd') as etl_dt                                          --数据日期      
	     ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp          --数据加载时间      
 from  mc_index_define t1 
 inner join (
  select t1.S_INFO_COMPCODE	as org_no--公司ID             
                   ,cast(t1.NET_PROFIT_INCL_MIN_INT_INC	* 2 /(t2.TOT_ASSETS + t3.TOT_ASSETS) as  NUMBER(30,8))     as indx_val---总资产收益率（ROAA）
                   ,t1.CRNCY_CODE	    as CURR_NO --货币代码           
                   ,t1.etl_dt
                   ,'TY02021000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINCOME t1
             left join mtl_WIND_UNLISTEDBANKBALANCESHEET t2
                    on t1.S_INFO_COMPCODE = t2.S_INFO_COMPCODE
                   and t1.CRNCY_CODE	= t2.CRNCY_CODE	
                   and t2.etl_dt =  to_date('${batch_date}','yyyymmdd')      
             left join mtl_WIND_UNLISTEDBANKBALANCESHEET t3
                    on t1.S_INFO_COMPCODE = t3.S_INFO_COMPCODE
                   and t1.CRNCY_CODE	= t3.CRNCY_CODE	
                   and t3.etl_dt =  add_months (to_date('${batch_date}','yyyymmdd') ,-6 )    
             where t1.CRNCY_CODE  ='CNY'
               and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
               union all
              select t1.S_INFO_COMPCODE	as org_no--公司ID             
                   ,t1.NET_PROFIT_INCL_MIN_INT_INC	* 2 /(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT + t3.TOT_SHRHLDR_EQY_INCL_MIN_INT )    as indx_val---净资产收益率（ROAE）
                   ,t1.CRNCY_CODE	    as CURR_NO --货币代码           
                   ,t1.etl_dt
                   ,'TY02022000'   as indx_no
             from mtl_WIND_UNLISTEDBANKINCOME t1
             left join mtl_WIND_UNLISTEDBANKBALANCESHEET t2
                    on t1.S_INFO_COMPCODE = t2.S_INFO_COMPCODE
                   and t1.CRNCY_CODE	= t2.CRNCY_CODE	
                   and t2.etl_dt =  to_date('${batch_date}','yyyymmdd')      
             left join mtl_WIND_UNLISTEDBANKBALANCESHEET t3
                    on t1.S_INFO_COMPCODE = t3.S_INFO_COMPCODE
                   and t1.CRNCY_CODE	= t3.CRNCY_CODE	
                   and t3.etl_dt =  add_months (to_date('${batch_date}','yyyymmdd') ,-6 )    
             where t1.CRNCY_CODE  ='CNY'
               and t1.etl_dt = to_date('${batch_date}','yyyymmdd')  
                    union all
                select t1.S_INFO_WINDCODE	as org_no--公司ID             
                   ,t1.NPL_PROVISION_COVERAGE	*NPL_RATIO      as indx_val---拨贷比
                   ,t1.CRNCY_CODE	    as CURR_NO --货币代码           
                   ,t1.etl_dt
                   ,'TY03024000'   as indx_no
             from mtl_WIND_ASHAREBANKINDICATOR t1      
             where t1.CRNCY_CODE  ='CNY'
               and t1.etl_dt = to_date('${batch_date}','yyyymmdd')                
          ) t2  on t1.index_no_mcs = t2.indx_no
   left  join mtl_WIND_BANKINGFICLASSCBRC t3
          on t2.org_no = t3.S_INFO_COMPCODE
         and t3.etl_dt = to_date('${batch_date}','yyyymmdd') 
   left join  ${idl_schema}.mc_index_fact t4            ---上日
       on  trim(t2.indx_no) = trim(t4.index_no)  
      and  t2.org_no = t4.org_no
      and  t2.CURR_NO =t4.CURR_NO 
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1       
  left join  ${idl_schema}.mc_index_fact t5            ---上月   
       on  trim(t2.indx_no) = trim(t5.index_no)              
      and  t2.org_no = t5.org_no                              
      and  t2.CURR_NO =t5.CURR_NO                                            
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            ---上年             
       on  trim(t2.indx_no) = trim(t6.index_no)                        
      and  t2.org_no = t6.org_no                                        
      and  t2.CURR_NO =t6.CURR_NO                                                                 
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 
  left join  ${idl_schema}.mc_index_fact t7            ---同比            
       on  trim(t2.indx_no) = trim(t7.index_no)                        
      and  t2.org_no = t7.org_no                                        
      and  t2.CURR_NO =t7.CURR_NO                                                                 
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)    
       ;
       
----同业 TY01010000 ,自算，季度

create table  ${idl_schema}.mc_index_fact_temp05
as                                                                                            
select    t1.index_no_mcs  as INDEX_NO   --指标编码                                                           
         ,t1.index_name_mcs  as INDEX_NAME --指标名称                                                          
         ,t2.org_no            --机构编码                                                          
         ,t3.S_INFO_COMPNAME    as ORG_NAME     --公司名称                                                        
         ,' '	as super_org_no   --上级机构编号                                                                         
         ,'null'  as ORG_SORT            --机构分类                                                          
         ,t2.CURR_NO  as CURR_NO                --币种编号                                                          
         ,'人民币'      as CURR_NAME      --币种名称
         ,t2.indx_val as INDEX_VALUE      --指标值                                                           
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'mm') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_M
                end as  ACCU_INDEX_VALUE_M       --当月累计                                                          
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'yy') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else t2.indx_val  +  t4.ACCU_INDEX_VALUE_Y
                end as  ACCU_INDEX_VALUE_Y                 --当年累计                                                         
         ,t2.indx_val - t4.INDEX_VALUE       RATE_UP_DAY                     --比上日   
         ,t2.indx_val - t5.INDEX_VALUE       RATE_LAST_MONTH                 --比上月                                                                                                                             --比上月                                                           
         ,t2.indx_val - t6.INDEX_VALUE       RATE_LAST_YEAR                  --比上年                                                           
         ,t2.indx_val - t7.INDEX_VALUE       RATE_LAST_PERIOD                 --同比                                                            
         ,case when nvl(t4.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t4.INDEX_VALUE) / t4.INDEX_VALUE 
               end  as RATE_UP_DAY_PER        --比上日百分比                                                        
         ,case when nvl(t5.INDEX_VALUE ,0) =0 then 0 
               else  (t2.indx_val - t5.INDEX_VALUE) / t5.INDEX_VALUE 
               end as RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,case when nvl(t6.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t6.INDEX_VALUE) / t6.INDEX_VALUE 
               end as RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,case when nvl(t7.INDEX_VALUE ,0) =0 then 0 
               else (t2.indx_val - t7.INDEX_VALUE) / t7.INDEX_VALUE 
               end as RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,row_number()over(partition by t2.org_no order by   t2.indx_val desc ) as  INDEX_RANKING    --当前排名                                                          
         ,row_number()over(partition by t2.org_no order by   t2.indx_val desc )  -  t4.INDEX_RANKING  as INDEX_RANKING_CHA                --排名变动                                                          
         ,cast(null as NUMBER)   as INDEX_VALUE_AVG --t8.index_val    as INDEX_VALUE_AVG     --均值                                                            
         ,cast(null as NUMBER)    as INDEX_VALUE_LIMIT  -- t9.sup_value     as INDEX_VALUE_LIMIT    --阀值                                                         
         ,0 as RATIO_INDEX        --结构占比                                                           
         ,cast (null  as number(20,4)) as RATIO_ORG  /*  case when nvl(t8.sum_index_val  ,0) =0 then 0 
          else t2.indx_val/t8.sum_index_val 
           end  as RATIO_ORG           --分行贡献度
           */                                                         
         ,t1.UNIT      --单位                                                            
         ,t1.FREQUENCY        --频度                                                            
         ,'001'       as MEASURE_NO           --度量编号                                                          
         ,'原始统计值'    as INDEX_MEASURE                 --度量名称                                                          
       ,to_date('${batch_date}','yyyymmdd') as etl_dt                                          --数据日期      
	     ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp          --数据加载时间      
 from  mc_index_define t1 
 inner join (
  select t1.S_INFO_WINDCODE	as org_no--公司ID             
                   ,cast(t1.NET_PROFIT_INCL_MIN_INT_INC	* 2 /(t2.TOT_ASSETS + t3.TOT_ASSETS)  as NUMBER(30,8))  as indx_val---总资产收益率（ROAA）
                   ,t1.CRNCY_CODE	    as CURR_NO --货币代码           
                   ,t1.etl_dt
                   ,'TY02021000'   as indx_no
             from mtl_WIND_ASHAREINCOME t1
             left join mtl_WIND_ASHAREBALANCESHEET t2
                    on t1.S_INFO_WINDCODE = t2.S_INFO_WINDCODE
                   and t1.CRNCY_CODE	= t2.CRNCY_CODE	
                   and t2.etl_dt =  to_date('${batch_date}','yyyymmdd')      
             left join mtl_WIND_ASHAREBALANCESHEET t3
                    on t1.S_INFO_WINDCODE = t3.S_INFO_WINDCODE
                   and t1.CRNCY_CODE	= t3.CRNCY_CODE	
                   and t3.etl_dt =  add_months (to_date('${batch_date}','yyyymmdd') ,-3 )    
             where t1.CRNCY_CODE  ='CNY'
               and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
               union all
              select t1.S_INFO_WINDCODE	as org_no--公司ID             
                   ,t1.NET_PROFIT_INCL_MIN_INT_INC	* 2 /(t2.TOT_SHRHLDR_EQY_INCL_MIN_INT + t3.TOT_SHRHLDR_EQY_INCL_MIN_INT )    as indx_val---净资产收益率（ROAE）
                   ,t1.CRNCY_CODE	    as CURR_NO --货币代码           
                   ,t1.etl_dt
                   ,'TY02022000'   as indx_no
             from mtl_WIND_ASHAREINCOME t1
             left join mtl_WIND_ASHAREBALANCESHEET t2
                    on t1.S_INFO_WINDCODE = t2.S_INFO_WINDCODE
                   and t1.CRNCY_CODE	= t2.CRNCY_CODE	
                   and t2.etl_dt =  to_date('${batch_date}','yyyymmdd')      
             left join mtl_WIND_ASHAREBALANCESHEET t3
                    on t1.S_INFO_WINDCODE = t3.S_INFO_WINDCODE
                   and t1.CRNCY_CODE	= t3.CRNCY_CODE	
                   and t3.etl_dt =  add_months (to_date('${batch_date}','yyyymmdd') ,-3 )    
             where t1.CRNCY_CODE  ='CNY'
               and t1.etl_dt = to_date('${batch_date}','yyyymmdd')                       
          ) t2  on t1.index_no_mcs = t2.indx_no
   left  join mtl_WIND_BANKINGFICLASSCBRC t3
          on t2.org_no = t3.S_INFO_COMPCODE
         and t3.etl_dt = to_date('${batch_date}','yyyymmdd') 
   left join  ${idl_schema}.mc_index_fact t4            ---上日
       on  trim(t2.indx_no) = trim(t4.index_no)  
      and  t2.org_no = t4.org_no
      and  t2.CURR_NO =t4.CURR_NO 
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1       
  left join  ${idl_schema}.mc_index_fact t5            ---上月   
       on  trim(t2.indx_no) = trim(t5.index_no)              
      and  t2.org_no = t5.org_no                              
      and  t2.CURR_NO =t5.CURR_NO                                            
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            ---上年             
       on  trim(t2.indx_no) = trim(t6.index_no)                        
      and  t2.org_no = t6.org_no                                        
      and  t2.CURR_NO =t6.CURR_NO                                                                 
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 
  left join  ${idl_schema}.mc_index_fact t7            ---同比            
       on  trim(t2.indx_no) = trim(t7.index_no)                        
      and  t2.org_no = t7.org_no                                        
      and  t2.CURR_NO =t7.CURR_NO                                                                 
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)    
       ;
       

 
 insert into ${idl_schema}.mc_index_fact
   (
    INDEX_NO                 --指标编码 
   ,INDEX_NAME                --指标名称 
   ,ORG_NO                    --机构编码 
   ,ORG_NAME                  --机构名称 
   ,SUPER_ORG_NO              --上级机构编码 
   ,ORG_SORT                  --机构分类 
   ,CURR_NO                   --币种编号 
   ,CURR_NAME                 --币种名称 
   ,INDEX_VALUE               --指标值   
   ,ACCU_INDEX_VALUE_M        --当月累计 
   ,ACCU_INDEX_VALUE_Y        --当年累计 
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
   ,INDEX_VALUE_AVG           --均值     
   ,INDEX_VALUE_LIMIT         --阀值     
   ,RATIO_INDEX               --结构占比 
   ,RATIO_ORG                 --分行贡献度 
   ,UNIT                      --单位     
   ,FREQUENCY                 --频度     
   ,MEASURE_NO                --度量编号 
   ,INDEX_MEASURE             --度量名称 
   ,ETL_DT               --- ETL处理日期             
   ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    ) 
    select INDEX_NO                 --指标编码 
          ,INDEX_NAME                --指标名称 
          ,ORG_NO                    --机构编码 
          ,ORG_NAME                  --机构名称 
          ,SUPER_ORG_NO              --上级机构编码 
          ,ORG_SORT                  --机构分类 
          ,CURR_NO                   --币种编号 
          ,CURR_NAME                 --币种名称 
          ,INDEX_VALUE               --指标值   
          ,ACCU_INDEX_VALUE_M        --当月累计 
          ,ACCU_INDEX_VALUE_Y        --当年累计 
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
          ,INDEX_VALUE_AVG           --均值     
          ,INDEX_VALUE_LIMIT         --阀值     
          ,RATIO_INDEX               --结构占比 
          ,RATIO_ORG                 --分行贡献度 
          ,UNIT                      --单位     
          ,FREQUENCY                 --频度     
          ,MEASURE_NO                --度量编号 
          ,INDEX_MEASURE             --度量名称 
          ,ETL_DT               --- ETL处理日期             
          ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    from mc_index_fact_temp01
    ;
	  commit;
	  

 insert into ${idl_schema}.mc_index_fact
   (
    INDEX_NO                 --指标编码 
   ,INDEX_NAME                --指标名称 
   ,ORG_NO                    --机构编码 
   ,ORG_NAME                  --机构名称 
   ,SUPER_ORG_NO              --上级机构编码 
   ,ORG_SORT                  --机构分类 
   ,CURR_NO                   --币种编号 
   ,CURR_NAME                 --币种名称 
   ,INDEX_VALUE               --指标值   
   ,ACCU_INDEX_VALUE_M        --当月累计 
   ,ACCU_INDEX_VALUE_Y        --当年累计 
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
   ,INDEX_VALUE_AVG           --均值     
   ,INDEX_VALUE_LIMIT         --阀值     
   ,RATIO_INDEX               --结构占比 
   ,RATIO_ORG                 --分行贡献度 
   ,UNIT                      --单位     
   ,FREQUENCY                 --频度     
   ,MEASURE_NO                --度量编号 
   ,INDEX_MEASURE             --度量名称 
   ,ETL_DT               --- ETL处理日期             
   ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    ) 
    select INDEX_NO                 --指标编码 
          ,INDEX_NAME                --指标名称 
          ,ORG_NO                    --机构编码 
          ,ORG_NAME                  --机构名称 
          ,SUPER_ORG_NO              --上级机构编码 
          ,ORG_SORT                  --机构分类 
          ,CURR_NO                   --币种编号 
          ,CURR_NAME                 --币种名称 
          ,INDEX_VALUE               --指标值   
          ,ACCU_INDEX_VALUE_M        --当月累计 
          ,ACCU_INDEX_VALUE_Y        --当年累计 
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
          ,INDEX_VALUE_AVG           --均值     
          ,INDEX_VALUE_LIMIT         --阀值     
          ,RATIO_INDEX               --结构占比 
          ,RATIO_ORG                 --分行贡献度 
          ,UNIT                      --单位     
          ,FREQUENCY                 --频度     
          ,MEASURE_NO                --度量编号 
          ,INDEX_MEASURE             --度量名称 
          ,ETL_DT               --- ETL处理日期             
          ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    from mc_index_fact_temp02
    ;
	  commit;
	  
	  
 insert into ${idl_schema}.mc_index_fact
   (
    INDEX_NO                 --指标编码 
   ,INDEX_NAME                --指标名称 
   ,ORG_NO                    --机构编码 
   ,ORG_NAME                  --机构名称 
   ,SUPER_ORG_NO              --上级机构编码 
   ,ORG_SORT                  --机构分类 
   ,CURR_NO                   --币种编号 
   ,CURR_NAME                 --币种名称 
   ,INDEX_VALUE               --指标值   
   ,ACCU_INDEX_VALUE_M        --当月累计 
   ,ACCU_INDEX_VALUE_Y        --当年累计 
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
   ,INDEX_VALUE_AVG           --均值     
   ,INDEX_VALUE_LIMIT         --阀值     
   ,RATIO_INDEX               --结构占比 
   ,RATIO_ORG                 --分行贡献度 
   ,UNIT                      --单位     
   ,FREQUENCY                 --频度     
   ,MEASURE_NO                --度量编号 
   ,INDEX_MEASURE             --度量名称 
   ,ETL_DT               --- ETL处理日期             
   ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    ) 
    select INDEX_NO                 --指标编码 
          ,INDEX_NAME                --指标名称 
          ,ORG_NO                    --机构编码 
          ,ORG_NAME                  --机构名称 
          ,SUPER_ORG_NO              --上级机构编码 
          ,ORG_SORT                  --机构分类 
          ,CURR_NO                   --币种编号 
          ,CURR_NAME                 --币种名称 
          ,INDEX_VALUE               --指标值   
          ,ACCU_INDEX_VALUE_M        --当月累计 
          ,ACCU_INDEX_VALUE_Y        --当年累计 
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
          ,INDEX_VALUE_AVG           --均值     
          ,INDEX_VALUE_LIMIT         --阀值     
          ,RATIO_INDEX               --结构占比 
          ,RATIO_ORG                 --分行贡献度 
          ,UNIT                      --单位     
          ,FREQUENCY                 --频度     
          ,MEASURE_NO                --度量编号 
          ,INDEX_MEASURE             --度量名称 
          ,ETL_DT               --- ETL处理日期             
          ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    from mc_index_fact_temp03
    ;
	  commit;
	  	  
 insert into ${idl_schema}.mc_index_fact
   (
    INDEX_NO                 --指标编码 
   ,INDEX_NAME                --指标名称 
   ,ORG_NO                    --机构编码 
   ,ORG_NAME                  --机构名称 
   ,SUPER_ORG_NO              --上级机构编码 
   ,ORG_SORT                  --机构分类 
   ,CURR_NO                   --币种编号 
   ,CURR_NAME                 --币种名称 
   ,INDEX_VALUE               --指标值   
   ,ACCU_INDEX_VALUE_M        --当月累计 
   ,ACCU_INDEX_VALUE_Y        --当年累计 
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
   ,INDEX_VALUE_AVG           --均值     
   ,INDEX_VALUE_LIMIT         --阀值     
   ,RATIO_INDEX               --结构占比 
   ,RATIO_ORG                 --分行贡献度 
   ,UNIT                      --单位     
   ,FREQUENCY                 --频度     
   ,MEASURE_NO                --度量编号 
   ,INDEX_MEASURE             --度量名称 
   ,ETL_DT               --- ETL处理日期             
   ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    ) 
    select INDEX_NO                 --指标编码 
          ,INDEX_NAME                --指标名称 
          ,ORG_NO                    --机构编码 
          ,ORG_NAME                  --机构名称 
          ,SUPER_ORG_NO              --上级机构编码 
          ,ORG_SORT                  --机构分类 
          ,CURR_NO                   --币种编号 
          ,CURR_NAME                 --币种名称 
          ,INDEX_VALUE               --指标值   
          ,ACCU_INDEX_VALUE_M        --当月累计 
          ,ACCU_INDEX_VALUE_Y        --当年累计 
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
          ,INDEX_VALUE_AVG           --均值     
          ,INDEX_VALUE_LIMIT         --阀值     
          ,RATIO_INDEX               --结构占比 
          ,RATIO_ORG                 --分行贡献度 
          ,UNIT                      --单位     
          ,FREQUENCY                 --频度     
          ,MEASURE_NO                --度量编号 
          ,INDEX_MEASURE             --度量名称 
          ,ETL_DT               --- ETL处理日期             
          ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    from mc_index_fact_temp04
    ;
	  commit;	  
	  
	  	  
 insert into ${idl_schema}.mc_index_fact
   (
    INDEX_NO                 --指标编码 
   ,INDEX_NAME                --指标名称 
   ,ORG_NO                    --机构编码 
   ,ORG_NAME                  --机构名称 
   ,SUPER_ORG_NO              --上级机构编码 
   ,ORG_SORT                  --机构分类 
   ,CURR_NO                   --币种编号 
   ,CURR_NAME                 --币种名称 
   ,INDEX_VALUE               --指标值   
   ,ACCU_INDEX_VALUE_M        --当月累计 
   ,ACCU_INDEX_VALUE_Y        --当年累计 
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
   ,INDEX_VALUE_AVG           --均值     
   ,INDEX_VALUE_LIMIT         --阀值     
   ,RATIO_INDEX               --结构占比 
   ,RATIO_ORG                 --分行贡献度 
   ,UNIT                      --单位     
   ,FREQUENCY                 --频度     
   ,MEASURE_NO                --度量编号 
   ,INDEX_MEASURE             --度量名称 
   ,ETL_DT               --- ETL处理日期             
   ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    ) 
    select INDEX_NO                 --指标编码 
          ,INDEX_NAME                --指标名称 
          ,ORG_NO                    --机构编码 
          ,ORG_NAME                  --机构名称 
          ,SUPER_ORG_NO              --上级机构编码 
          ,ORG_SORT                  --机构分类 
          ,CURR_NO                   --币种编号 
          ,CURR_NAME                 --币种名称 
          ,INDEX_VALUE               --指标值   
          ,ACCU_INDEX_VALUE_M        --当月累计 
          ,ACCU_INDEX_VALUE_Y        --当年累计 
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
          ,INDEX_VALUE_AVG           --均值     
          ,INDEX_VALUE_LIMIT         --阀值     
          ,RATIO_INDEX               --结构占比 
          ,RATIO_ORG                 --分行贡献度 
          ,UNIT                      --单位     
          ,FREQUENCY                 --频度     
          ,MEASURE_NO                --度量编号 
          ,INDEX_MEASURE             --度量名称 
          ,ETL_DT               --- ETL处理日期             
          ,ETL_TIMESTAMP        --- ETL处理时间戳                    
    from mc_index_fact_temp05
    ;
	  commit;	  
alter index fact_all_index rebuild online;
	  
-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact', degree => 8, cascade => true);