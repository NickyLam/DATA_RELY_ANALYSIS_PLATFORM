set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
--python $ETL_HOME/script/main.py yyyymmdd idl_mc_index_fact_fdw
-- 以下为依赖了上游的表 :
-- mtl_fdl_idx_index_data
-- mtl_fml_f99_int_org_info_new
-- 以下为依赖的参数表 :
-- mc_index_define           -- 指标表清单
-- mc_sup_para

-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_index_fact add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_fdw values ('FDW')
                                              )
;
alter table ${idl_schema}.mc_index_fact modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_fdw values ('FDW')
;
drop table ${idl_schema}.mc_index_fact_fdw_temp01 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp02 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp03 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp04 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp05 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp06 purge;


whenever sqlerror exit sql.sqlcode; 

alter table ${idl_schema}.mc_index_fact truncate subpartition p_${batch_date}_fdw;
commit;
-- 2.1 insert data to table
create table  ${idl_schema}.mc_index_fact_fdw_temp04 compress 
as   
select t1.index_no
      ,t1.org_no
      ,t1.biz_strip_line_cd
      ,t1.dim_cd1
      ,t1.dim_cd2
      ,t1.dim_cd3
      ,t1.batch_freq
      ,t1.index_measure
      ,t1.curr_cd
      ,case
         when t2.unit = '%' then
          round(t1.index_val, 4)
         else
          t1.index_val
       end as index_val
      ,t1.etl_dt
  from ${idl_schema}.mtl_fdl_idx_index_data t1
 inner join mc_index_define t2 on trim(t1.index_no) = trim(t2.index_no)
                                  and   nvl(t2.etl_dt,to_date('${batch_date}','yyyymmdd'))<>date'2025-04-29'
                                  and t1.index_measure in ('001', '002', '003', '004', '013', '014', '015', '007')
 where t1.etl_dt in (to_date('${batch_date}', 'yyyymmdd')
                    ,to_date('${batch_date}', 'yyyymmdd') - 1
                    ,trunc(to_date('${batch_date}', 'yyyymmdd'), 'mm') - 1
                    ,trunc(add_months(to_date('${batch_date}', 'yyyymmdd'), -1), 'mm') - 1);
create table  ${idl_schema}.mc_index_fact_fdw_temp05 compress 
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
      ,case
         when t1.unit = '%' then
          round(index_value, 4)
         else
          index_value
       end as index_value
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
  from ${idl_schema}.mc_index_fact t1
 where t1.etl_dt in (to_date('${batch_date}', 'yyyymmdd') - 1
                    ,trunc(to_date('${batch_date}', 'yyyymmdd'), 'mm') - 1
                    ,trunc(to_date('${batch_date}', 'yyyymmdd'), 'yy') - 1
                    ,add_months(to_date('${batch_date}', 'yyyymmdd'), -12)
                    ,add_months(to_date('${batch_date}', 'yyyymmdd'), -1)
                    ,trunc(to_date('${batch_date}', 'yyyymmdd'), 'Q') - 1);

--YL 开头的才有当月累计，当年累计
---财务集市,规模类：余额，月日均
create table  ${idl_schema}.mc_index_fact_fdw_temp01 compress 
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
 from     
${idl_schema}.mc_index_fact 
where 1=2 ;

insert into    ${idl_schema}.mc_index_fact_fdw_temp01                                                                                             
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
         ,t2.index_measure                    as MEASURE_NO          --度量编号
         ,'FDW'                               as SOURCE_SYS
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
 inner   join   mc_index_fact_fdw_temp04 t2
        on   trim(t1.index_no) = trim(t2.index_no)
       and   t2.etl_dt = to_date('${batch_date}','yyyymmdd') 
       and   t2.INDEX_MEASURE in  ('001','002','003','004','013','014','015','007')
 inner join mtl_fml_f99_int_org_info_new t3
       on t2.org_no = t3.org_id
      and (t3.admin_super_org_id ='000000'  or t3.admin_super_org_id ='999999')
      and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
 left join  ${idl_schema}.mc_index_fact_fdw_temp05 t4            --上日
       on  trim(t1.index_no_mcs) = trim(t4.index_no)  
      and  t2.org_no = t4.org_no
      and  t2.curr_cd =t4.CURR_NO 
      and  t2.INDEX_MEASURE =t4.measure_no 
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
 left join  ${idl_schema}.mc_index_fact_fdw_temp05 t5            --上月末   
       on  trim(t1.index_no_mcs) = trim(t5.index_no)              
      and  t2.org_no = t5.org_no                              
      and  t2.curr_cd =t5.CURR_NO                             
      and  t2.INDEX_MEASURE =t5.measure_no                
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact_fdw_temp05 t6            --上年末             
       on  trim(t1.index_no_mcs) = trim(t6.index_no)                        
      and  t2.org_no = t6.org_no                                        
      and  t2.curr_cd =t6.CURR_NO                                       
      and  t2.INDEX_MEASURE =t6.measure_no                           
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 
  left join  ${idl_schema}.mc_index_fact_fdw_temp05 t7            --同比            
       on  trim(t1.index_no_mcs)  = trim(t7.index_no)                        
      and  t2.org_no = t7.org_no                                        
      and  t2.curr_cd =t7.CURR_NO                                       
      and  t2.INDEX_MEASURE =t7.measure_no                           
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)
   left join  ${idl_schema}.mc_index_fact_fdw_temp05 t10            --上季   
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
               from mc_index_fact_fdw_temp04 
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
 where  ((t1.source_system in ( '财务集市','财务集市/监管集市')
   and  t1.index_clsaa_f_mcs = '盈利类' 
   and  t2.INDEX_MEASURE in ('001','013','014','015','007')
   and ( (T1.index_clsaa_s_mcs  IN ( '收入状况','利润状况','支出状况') 
   and  T1.unit = '%') OR  T1.index_clsaa_s_mcs NOT IN ( '收入状况','利润状况','支出状况') ))
   OR (t1.source_system in ( '财务集市','财务集市/监管集市')
   and  t1.index_clsaa_f_mcs = '规模类' 
   and   t2.INDEX_MEASURE in ('001','002','003','004'))
   OR(t1.source_system = '财务集市' 
   and T1.index_clsaa_s_mcs = '流动性风险'
   and t2.INDEX_MEASURE ='001'))
   and nvl(t1.etl_dt,to_date('${batch_date}','yyyymmdd'))<>date'2025-04-29' 
   ;
 commit; 



-- 营业净收入、净利润、净利息收入、非利息净收入、营业费用 特殊处理  ：指标值、月累计值、年累计值  
-- 年累计值    

insert into ${idl_schema}.mc_index_fact_fdw_temp01                                                                                             
select to_date('${batch_date}', 'yyyymmdd') as etl_dt
      ,t1.index_no_mcs as index_no --指标编码                                                           
      ,t1.index_name_mcs as index_name --指标名称                                                          
      ,t2.org_no --机构编码                                                          
      ,t3.org_abbr as org_name --机构名称                                                          
      ,t3.admin_super_org_id as super_org_no --上级机构编号                                                                         
      ,'null' as org_sort --机构分类                                                          
      ,t2.curr_cd as curr_no --币种编号                                                          
      ,'null' as curr_name --币种名称
      ,case
         when substr('${batch_date}', 5, 4) = '0101' then
          coalesce(t2.index_val, 0)
         else
          coalesce(t2.index_val, 0) - coalesce(t51.index_val, 0)
       end as index_value --指标值                                                           
      ,case
         when substr('${batch_date}', 5, 2) = '01' then
          coalesce(t2.index_val, 0)
         else
          coalesce(t2.index_val, 0) - coalesce(t52.index_val, 0)
       end as accu_index_value_m --当月累计                                                          
      ,coalesce(t2.index_val, 0) as accu_index_value_y --当年累计                                                         
      ,coalesce(t2.index_val, 0) - coalesce(t51.index_val, 0) - coalesce(t4.index_value, 0) as rate_up_day --比上日 
      ,case
         when substr('${batch_date}', 5, 2) = '01' then
          coalesce(t2.index_val, 0) - coalesce(t5.accu_index_value_m, 0)
         else
          coalesce(t2.index_val, 0) - coalesce(t52.index_val, 0) - coalesce(t5.accu_index_value_m, 0)
       end as rate_last_month --比上月
      ,coalesce(t2.index_val, 0) - coalesce(t6.accu_index_value_y, 0) as rate_last_year --比上年                                                           
      ,coalesce(t2.index_val, 0) - coalesce(t7.accu_index_value_y, 0) as rate_last_period --同比                                                            
      ,case
         when coalesce(t4.index_value, 0) = 0 then
          0
         else
          (coalesce(t2.index_val, 0) - coalesce(t51.index_val, 0) - coalesce(t4.index_value, 0)) / coalesce(t4.index_value, 0)
       end as rate_up_day_per --比上日百分比                                                        
      ,case
         when coalesce(t5.accu_index_value_m, 0) = 0 then
          0
         else
          case
            when substr('${batch_date}', 5, 2) = '01' then
             round((coalesce(t2.index_val, 0) - coalesce(t5.accu_index_value_m, 0)) / coalesce(t5.accu_index_value_m, 0), 6)
            else
             round((coalesce(t2.index_val, 0) - coalesce(t52.index_val, 0) - coalesce(t5.accu_index_value_m, 0)) / coalesce(t5.accu_index_value_m, 0), 6)
          end
       end as rate_last_month_per --比上月百分比                                                        
      ,case
         when coalesce(t6.accu_index_value_y, 0) = 0 then
          0
         else
          round((coalesce(t2.index_val, 0) - coalesce(t6.accu_index_value_y, 0)) / coalesce(t6.accu_index_value_y, 0), 6)
       end as rate_last_year_per --比上年百分比                                                        
      ,case
         when coalesce(t7.accu_index_value_y, 0) = 0 then
          0
         else
          round((coalesce(t2.index_val, 0) - coalesce(t7.accu_index_value_y, 0)) / coalesce(t7.accu_index_value_y, 0), 6)
       end as rate_last_period_per --同比百分比                                                         
      ,0 as index_ranking --当前排名                                                          
      ,0 as index_ranking_cha --排名变动                                                          
      ,t8.index_val as index_value_avg --均值                                                            
      ,t9.sup_value as index_value_limit --阀值                                                            
      ,0 as ratio_index --结构占比                                                           
      ,case
         when coalesce(t8.sum_index_val, 0) = 0 then
          0
         else
          t2.index_val / t8.sum_index_val
       end as ratio_org --分行贡献度                                                         
      ,t1.unit --单位                                                            
      ,t1.frequency --频度    
      ,t2.index_measure as measure_no --度量编号
      ,'FDW' as source_sys
      ,case
         when t2.index_measure = '013' then
          '月年化'
         when t2.index_measure = '014' then
          '季年化'
         when t2.index_measure = '015' then
          '累计月年化'
       end as index_measure --度量名称                                                          
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp
      ,0 as rate_last_quater --比上季
      ,0 as rate_last_quater_per --比上季百分比 
  from mc_index_define t1
 inner join mc_index_fact_fdw_temp04 t2 on trim(t1.index_no) = trim(t2.index_no)
                                           and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                                           and t2.index_measure in ('001', '013', '014', '015')
 inner join mtl_fml_f99_int_org_info_new t3 on t2.org_no = t3.org_id
                                               and (t3.admin_super_org_id = '000000' or t3.admin_super_org_id = '999999')
                                               and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${idl_schema}.mc_index_fact_fdw_temp05 t4 --上日
on trim(t1.index_no_mcs) = trim(t4.index_no)
   and t2.org_no = t4.org_no
   and t2.curr_cd = t4.curr_no
   and t2.index_measure = t4.measure_no
   and t4.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
  left join ${idl_schema}.mc_index_fact_fdw_temp05 t5 --上月(上月同期)   
on trim(t1.index_no_mcs) = trim(t5.index_no)
   and t2.org_no = t5.org_no
   and t2.curr_cd = t5.curr_no
   and t2.index_measure = t5.measure_no
   and t5.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -1)
  left join ${idl_schema}.mc_index_fact_fdw_temp04 t52 --上月 
on trim(t1.index_no) = trim(t52.index_no)
   and t52.etl_dt = trunc(to_date('${batch_date}', 'yyyymmdd'), 'mm') - 1
   and t52.index_measure in ('001', '013', '014', '015')
   and t2.index_measure = t52.index_measure
   and t2.org_no = t52.org_no
   and t2.curr_cd = t52.curr_cd
  left join ${idl_schema}.mc_index_fact_fdw_temp04 t51 --上日 
on trim(t1.index_no) = trim(t51.index_no)
   and t51.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and t51.index_measure in ('001', '013', '014', '015')
   and t2.index_measure = t51.index_measure
   and t2.org_no = t51.org_no
   and t2.curr_cd = t51.curr_cd
  left join ${idl_schema}.mc_index_fact_fdw_temp05 t6 --上年             
on trim(t1.index_no_mcs) = trim(t6.index_no)
   and t2.org_no = t6.org_no
   and t2.curr_cd = t6.curr_no
   and t2.index_measure = t6.measure_no
   and t6.etl_dt = trunc(to_date('${batch_date}', 'yyyymmdd'), 'yy') - 1
  left join ${idl_schema}.mc_index_fact_fdw_temp05 t7 --同比            
on trim(t1.index_no_mcs) = trim(t7.index_no)
   and t2.org_no = t7.org_no
   and t2.curr_cd = t7.curr_no
   and t2.index_measure = t7.measure_no
   and t7.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -12)
  left join (select index_no
                   ,curr_cd
                   ,index_measure 
                   ,avg(index_val)  as index_val
                   ,sum(index_val)  as sum_index_val
               from mc_index_fact_fdw_temp04 
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
   where  t1.source_system in ( '财务集市','财务集市/监管集市')
     and  t1.index_clsaa_f_mcs = '盈利类' 
     and  t2.INDEX_MEASURE in ('001','013','014','015')
     and  T1.index_clsaa_s_mcs IN ( '收入状况','利润状况','支出状况') 
     and  T1.unit <> '%'
   ;
 commit; 




 
-- 总体计算结构占比
-- 建临时表
create table  ${idl_schema}.mc_index_fact_fdw_temp02 compress 
as   
select INDEX_NO 
     ,ORG_NO    
     ,ETL_DT    
     ,CURR_NO   
     ,MEASURE_NO
     ,RATIO_INDEX
from ${idl_schema}.mc_index_fact 
where 1=2 ; 
 
-- 按“机构”+“日期”+“币种”+“度量”，该指标指标值/存款总额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02
select  t1.INDEX_NO                       -- 指标编号  
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0 
          else t1.index_value/t2.index_value 
          end  as RATIO_INDEX             -- 结构占比            
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp01 t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'GM02011000'    -- 存款总额指标值
where t1.INDEX_NO in ( 'GM02011100','GM02011200','GM02011300','GM02011400','GM02011480','GM02011481')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd') 
;
commit ;

-- 按“机构”+“日期”+“币种”+“度量”，该指标指标值/负债总额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02
select  t1.INDEX_NO                       -- 指标编号  
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0 
          else t1.index_value/t2.index_value 
          end  as RATIO_INDEX             -- 结构占比            
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp01 t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'GM02000000'    -- 负债总额指标值
where t1.INDEX_NO in ( 'GM02010000','GM02011000','GM02012000','GM02013000','GM02013100','GM02020000','GM02012200')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd') 
;
commit;
-- 按“机构”+“日期”+“币种”+“度量”，该指标指标值/公司存款余额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02
select  t1.INDEX_NO                       -- 指标编号  
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0 
          else t1.index_value/t2.index_value 
          end  as RATIO_INDEX             -- 结构占比            
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp01 t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'GM02011300'    -- 公司存款余额指标值
where t1.INDEX_NO in ('GM02011310','GM02011320','GM02011330','GM02011340','GM02011350','GM02011360','GM02011370','GM02011380','GM02011390')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd') 
;
commit;
-- 按“机构”+“日期”+“币种”+“度量”，该指标指标值/零售存款余额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02
select  t1.INDEX_NO                       -- 指标编号  
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0 
          else t1.index_value/t2.index_value 
          end  as RATIO_INDEX             -- 结构占比            
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp01 t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'GM02011400'    -- 零售存款余额指标值
where t1.INDEX_NO in ( 'GM02011410','GM02011420','GM02011430','GM02011440','GM02011450','GM02011460','GM02011470')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd') 
;
commit;

--  按“机构”+“日期”+“币种”+“度量”，该指标指标值/资产总额指标值
insert into    ${idl_schema}.mc_index_fact_fdw_temp02
select  t1.INDEX_NO                       -- 指标编号  
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0 
          else t1.index_value/t2.index_value 
          end  as RATIO_INDEX             -- 结构占比            
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp01 t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'GM01000000'    -- 资产总额指标值
where t1.INDEX_NO in ('GM01010000','GM01011000','GM01011500','GM01011200','GM01011210','GM01011300','GM01012000','GM01012100','GM01013100','GM01013000','GM01013110','GM01013120','GM01013210','GM01013220','GM01013221','GM01013230','GM01013240','GM01015000','GM01015100','GM01021000','GM01014000','GM01015200','GM01016000','GM01020000','GM01013242','GM01013241','GM01013211','GM01013222','GM01021020','GM01021030','GM01021010','GM01014001','GM01021080','GM01021070','GM01021060','GM01021090','GM01021040','GM01021050')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd') 
    and t1.MEASURE_NO not in ('002','004') --月日均和年日均单独计算
;
commit;

--  贷款月日均
insert into    ${idl_schema}.mc_index_fact_fdw_temp02
select  t1.INDEX_NO                       -- 指标编号  
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0 
          else t1.index_value/t2.index_value 
          end  as RATIO_INDEX             -- 结构占比            
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp01 t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'GM01015300'    -- 资产总额指标值
where t1.INDEX_NO in ('GM01011500','GM01012100','GM01013120')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd') 
    and t1.MEASURE_NO ='002' --月日均
;
commit;

--  贷款年日均
insert into    ${idl_schema}.mc_index_fact_fdw_temp02
select  t1.INDEX_NO                       -- 指标编号  
    ,t1.ORG_NO                            -- 机构
    ,t1.ETL_DT                            -- 日期
    ,t1.CURR_NO                           -- 币种
    ,t1.MEASURE_NO                        -- 度量
    ,case when coalesce(t2.index_value,0) =0 then 0 
          else t1.index_value/t2.index_value 
          end  as RATIO_INDEX             -- 结构占比            
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp01 t2
      on  t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
      and t2.INDEX_NO   = 'GM01015300'    -- 资产总额指标值
where t1.INDEX_NO in ('GM01011500','GM01012100','GM01013120')
    and t1.ETL_DT = to_date('${batch_date}','yyyymmdd') 
    and t1.MEASURE_NO ='004' --年日均
;    
commit;


create table  ${idl_schema}.mc_index_fact_fdw_temp03 compress 
as   
select 
   *
 from   ${idl_schema}.mc_index_fact 
where 1=2 ;
insert into ${idl_schema}.mc_index_fact_fdw_temp03 
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
       ,t1.ACCU_INDEX_VALUE_M
       ,t1.ACCU_INDEX_VALUE_Y
       ,t1.RATE_UP_DAY 
       ,t1.RATE_LAST_MONTH 
       ,t1.RATE_LAST_YEAR
       ,t1.RATE_LAST_PERIOD
       ,t1.RATE_UP_DAY_PER 
       ,t1.RATE_LAST_MONTH_PER 
       ,t1.RATE_LAST_YEAR_PER
       ,t1.RATE_LAST_PERIOD_PER
       ,t1.INDEX_RANKING 
       ,t1.INDEX_RANKING_CHA 
       ,t1.INDEX_VALUE_AVG 
       ,t1.INDEX_VALUE_LIMIT 
       ,coalesce(t2.RATIO_INDEX ,t1.RATIO_INDEX) as  RATIO_INDEX
       ,t1.RATIO_ORG 
       ,t1.UNIT
       ,t1.FREQUENCY 
       ,t1.MEASURE_NO
       ,t1.SOURCE_SYS
       ,t1.INDEX_MEASURE 
       ,t1.ETL_TIMESTAMP
       ,t1.RATE_LAST_QUATER
       ,t1.RATE_LAST_QUATER_PER
       /*
       特殊处理：YL04040000存贷比不要展示监管要求
       */
      ,case when t1.index_no='YL04040000' then '/' else replace(replace(nvl(trim(t5.v_supervision_require),'/'),'亿',''),'%','')	end AS SUPERVISION_REQUIRE -- 监管要求
	 		,replace(replace(nvl(trim(t5.v_limit_value),'/'),'亿',''),'%','')             AS LIMIT_VALUE  -- 限额值
			,replace(replace(nvl(trim(t5.v_prewarning_value),'/'),'亿',''),'%','')        AS PREWARNING_VALUE  -- 预警值
    	/* 以下是区间类型的业务判断口径,运算符优先取监管要求再取限额
				≥： <限额值，红灯；[限额值，预警值]，黄灯；>预警值，绿灯 
				≤： >限额值，红灯；[预警值，限额值]，黄灯；<预警值，绿灯 
				*/
    	,case when trim(t5.v_limit_value) is not null and trim(t5.v_prewarning_value) is not null and 
    		    nvl(regexp_substr(t5.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t5.v_limit_value,'[><]=?',1,1,'i')) is not null  --运算符必须有值才可以判断红黄绿灯
    		 then 
    		  case when nvl(regexp_substr(t5.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t5.v_limit_value,'[><]=?',1,1,'i'))='>=' then
    		      (case when t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]','')) then '03'  
    		            when t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]',''))
                      and t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '02'		      
    		            when t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '01'                                       
               end)
    		       when nvl(regexp_substr(t5.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t5.v_limit_value,'[><]=?',1,1,'i'))='<=' then
    		       (case when t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]','')) then '03'  
    		            when t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]',''))
                      and t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '02'		      
    		            when t1.INDEX_VALUE/decode(t1.unit,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '01'                                       
               end)
    		  end 
    	   end																	AS INTRV_TYPE -- 区间类型     01.绿 02.黄 03.红 04.深红 
    	 ,0                                    AS RATE_LAST_WEEK      --比上周         
from mc_index_fact_fdw_temp01 t1
left join mc_index_fact_fdw_temp02 t2
      on  t1.INDEX_NO   = t2.INDEX_NO
      and t1.ETL_DT     = t2.ETL_DT
      and t1.ORG_NO     = t2.ORG_NO
      and t1.CURR_NO    = t2.CURR_NO
      and t1.MEASURE_NO = t2.MEASURE_NO
--新增限额获取，后续考虑单独新增限额作业拆分
left join itl_edw_alms_rp_alm_rrs_liquidity_report_result t5
    on decode(trim(t5.n_rep_line_cd),'401042','FX03014000','401014','YL04040000','88888888')=trim(t1.index_no) --报表项编码
    and t5.etl_dt = to_date('${batch_date}','yyyymmdd') 
    and t5.n_rep_line_cd in ('401014','401042') --存贷比、存款偏离度
;
commit ;

create table  ${idl_schema}.mc_index_fact_fdw_temp06 compress
AS 
select ETL_DT
      ,INDEX_NO
      ,INDEX_NAME
      ,ORG_NO
      ,ORG_NAME
      ,SUPER_ORG_NO
      ,ORG_SORT
      ,CURR_NO
      ,CURR_NAME
      ,INDEX_VALUE
      ,MEASURE_NO
      ,SOURCE_SYS
      ,INDEX_MEASURE
from ${idl_schema}.mc_index_fact
where 1=2 ;

-- 	YL04040000	存贷比（含贴现）	贷款总额GM01015000/存款总额GM02011000
INSERT INTO  ${idl_schema}.mc_index_fact_fdw_temp06                                                                                
SELECT T1.ETL_DT
      ,'YL04040000'                           AS INDEX_NO
      ,'存贷比（含贴现）'                     AS INDEX_NAME
      ,T1.ORG_NO
      ,T1.ORG_NAME
      ,T1.SUPER_ORG_NO
      ,T1.ORG_SORT
      ,T1.CURR_NO
      ,T1.CURR_NAME
      ,CASE WHEN SUM( CASE WHEN T1.INDEX_NO = 'GM02011000' THEN COALESCE(T1.INDEX_VALUE,0) ELSE 0 END  ) = 0 THEN 0 
            ELSE ROUND(  SUM(CASE WHEN T1.INDEX_NO = 'GM01015000' THEN COALESCE(T1.INDEX_VALUE,0) ELSE 0 END)
                        /SUM(CASE WHEN T1.INDEX_NO = 'GM02011000' THEN COALESCE(T1.INDEX_VALUE,0) ELSE 0 END)
                    ,6)
       END                                    AS INDEX_VALUE             -- 存贷比（含贴现）指标值
      ,'001'                                  AS MEASURE_NO              -- 度量编号   
      ,'FDW'                                  AS SOURCE_SYS                                                
      ,'原始统计值'                           AS INDEX_MEASURE           -- 度量名称  
from ${idl_schema}.mc_index_fact_fdw_temp03 T1
WHERE T1.INDEX_NO in ( 'GM02011000','GM01015000')
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


INSERT INTO  ${idl_schema}.mc_index_fact_fdw_temp03                                                                                
SELECT T1.ETL_DT
      ,T1.INDEX_NO
      ,T1.INDEX_NAME
      ,T1.ORG_NO
      ,T1.ORG_NAME
      ,T1.SUPER_ORG_NO
      ,T1.ORG_SORT
      ,T1.CURR_NO
      ,T1.CURR_NAME
      ,T1.INDEX_VALUE                         AS INDEX_VALUE             -- 指标值
      ,0                                      AS ACCU_INDEX_VALUE_M      -- 当月累计
      ,0                                      AS ACCU_INDEX_VALUE_Y      -- 当年累计
      ,0                                      AS RATE_UP_DAY             -- 比上日
      ,COALESCE(T1.INDEX_VALUE,0)-COALESCE(T2.INDEX_VALUE,0) 
                                              AS RATE_LAST_MONTH         -- 比上月
      ,COALESCE(T1.INDEX_VALUE,0)-COALESCE(T3.INDEX_VALUE,0) 
                                              AS RATE_LAST_YEAR          -- 比上年
      ,COALESCE(T1.INDEX_VALUE,0)-COALESCE(T4.INDEX_VALUE,0) 
                                              AS RATE_LAST_PERIOD        -- 同比
      ,0                                      AS RATE_UP_DAY_PER         -- 比上日百分比
      ,0                                      AS RATE_LAST_MONTH_PER     -- 比上月百分比
      ,0                                      AS RATE_LAST_YEAR_PER      -- 比上年百分比
      ,0                                      AS RATE_LAST_PERIOD_PER    -- 同比百分比
      ,0                                      AS INDEX_RANKING           -- 当前排名
      ,0                                      AS INDEX_RANKING_CHA       -- 排名变动
      ,0                                      AS INDEX_VALUE_AVG         -- 均值
      ,0                                      AS INDEX_VALUE_LIMIT       -- 阀值
      ,0                                      AS RATIO_INDEX             -- 结构占比
      ,0                                      AS RATIO_ORG               -- 分行贡献度
      ,'%'                                    AS UNIT                    -- 单位
      ,'月'                                   AS FREQUENCY               -- 频度
      ,T1.MEASURE_NO                          AS MEASURE_NO              -- 度量编号
      ,'FDW'                                  AS SOURCE_SYS                
      ,'原始统计值'                           AS INDEX_MEASURE           -- 度量名称
      ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
      ,0                                      AS RATE_LAST_QUATER        --比上季
      ,0                                      AS RATE_LAST_QUATER_PER    --比上季百分比
      /*
       特殊处理：YL04040000存贷比不要展示监管要求
       */
      ,case when t1.index_no='YL04040000' then '/' else replace(replace(nvl(trim(t5.v_supervision_require),'/'),'亿',''),'%','')	end AS SUPERVISION_REQUIRE -- 监管要求
	 		,replace(replace(nvl(trim(t5.v_limit_value),'/'),'亿',''),'%','')             AS LIMIT_VALUE  -- 限额值
			,replace(replace(nvl(trim(t5.v_prewarning_value),'/'),'亿',''),'%','')        AS PREWARNING_VALUE  -- 预警值
    	/* 以下是区间类型的业务判断口径,运算符优先取监管要求再取限额
				≥： <限额值，红灯；[限额值，预警值]，黄灯；>预警值，绿灯 
				≤： >限额值，红灯；[预警值，限额值]，黄灯；<预警值，绿灯 
				*/
    	,case when trim(t5.v_limit_value) is not null and trim(t5.v_prewarning_value) is not null and 
    		    nvl(regexp_substr(t5.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t5.v_limit_value,'[><]=?',1,1,'i')) is not null  --运算符必须有值才可以判断红黄绿灯
    		 then 
    		  case when nvl(regexp_substr(t5.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t5.v_limit_value,'[><]=?',1,1,'i'))='>=' then
    		      (case when t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) < to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]','')) then '03'  
    		            when t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) >= to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]',''))
                      and t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) <= to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '02'		      
    		            when t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) > to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '01'                                       
               end)
    		       when nvl(regexp_substr(t5.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t5.v_limit_value,'[><]=?',1,1,'i'))='<=' then
    		       (case when t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) > to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]','')) then '03'  
    		            when t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) <= to_number(regexp_replace(t5.v_limit_value,'[^0-9.-]',''))
                      and t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) >= to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '02'		      
    		            when t1.INDEX_VALUE/decode('%','亿元',100000000,'%',0.01) < to_number(regexp_replace(t5.v_prewarning_value,'[^0-9.-]','')) then '01'                                       
               end)
    		  end 
    	   end																	AS INTRV_TYPE -- 区间类型     01.绿 02.黄 03.红 04.深红 
    	,0                                    AS RATE_LAST_WEEK      --比上周              
from ${idl_schema}.mc_index_fact_fdw_temp06 T1
LEFT JOIN  ${idl_schema}.mc_index_fact_fdw_temp05 T2                               
   ON T1.INDEX_NO = T2.INDEX_NO
  AND T1.MEASURE_NO = T2.MEASURE_NO
  AND T1.CURR_NO = T2.CURR_NO
  AND T1.ORG_NO = T2.ORG_NO
  AND T2.ETL_DT = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1     -- 上月
LEFT JOIN  ${idl_schema}.mc_index_fact_fdw_temp05 T3                               
   ON T3.INDEX_NO  = T1.INDEX_NO
  AND T1.MEASURE_NO = T3.MEASURE_NO
  AND T1.CURR_NO = T3.CURR_NO
  AND T1.ORG_NO = T3.ORG_NO
  AND T3.ETL_DT = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1     -- 上年
LEFT JOIN  ${idl_schema}.mc_index_fact_fdw_temp05 T4                              
   ON T4.INDEX_NO = T1.INDEX_NO
  AND T1.MEASURE_NO = T4.MEASURE_NO
  AND T1.CURR_NO = T4.CURR_NO
  AND T1.ORG_NO = T4.ORG_NO
  AND T4.ETL_DT = ADD_MONTHS(TO_DATE('${batch_date}','yyyymmdd'),-12)    -- 上年同期
--新增限额获取，后续考虑单独新增限额作业拆分
left join itl_edw_alms_rp_alm_rrs_liquidity_report_result t5
    on decode(trim(t5.n_rep_line_cd),'401042','FX03014000','401014','YL04040000','88888888')=trim(t1.index_no) --报表项编码
    and t5.etl_dt = to_date('${batch_date}','yyyymmdd') 
    and t5.n_rep_line_cd in ('401014','401042') --存贷比、存款偏离度
WHERE T1.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
;
COMMIT ;

 
	  alter table ${idl_schema}.mc_index_fact exchange subpartition p_${batch_date}_fdw with table ${idl_schema}.mc_index_fact_fdw_temp03 ;
	  commit;
--alter index fact_all_index rebuild online;

whenever sqlerror continue none;
drop table ${idl_schema}.mc_index_fact_fdw_temp01 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp02 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp03 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp04 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp05 purge;
drop table ${idl_schema}.mc_index_fact_fdw_temp06 purge;
-- 3.1 gather table status
--exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact', degree => 8, cascade => true);