set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 以下为依赖了上游的表：
-- mtl_rdl_idx_indx_data
-- mtl_fml_f99_int_org_info_new
-- 以下为依赖的参数表
-- mc_index_define    -- 指标表清单

-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_index_fact add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_rdw values ('RDW')
                                              )
;
alter table ${idl_schema}.mc_index_fact modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_rdw values ('RDW')
;
drop table ${idl_schema}.mc_index_fact_rdw_temp01 purge ;

whenever sqlerror exit sql.sqlcode; 

alter table ${idl_schema}.mc_index_fact truncate subpartition p_${batch_date}_rdw;
-- 2.1 insert data to table

create table  ${idl_schema}.mc_index_fact_rdw_temp01 compress
AS 
select * from ${idl_schema}.mc_index_fact
where 1=2 ;
       
insert into  ${idl_schema}.mc_index_fact_rdw_temp01                                                                                
select    to_date('${batch_date}','yyyymmdd') AS etl_dt
         ,t1.index_no_mcs                     AS INDEX_NO     --指标编码                                                           
         ,t1.index_name_mcs                   AS INDEX_NAME   --指标名称                                                          
         ,decode(t2.org_no,'999999','000000',t2.org_no)               --机构编码                                                          
         ,t3.org_abbr                         AS ORG_NAME     --机构名称                                                          
         ,t3.admin_super_org_id               AS SUPER_ORG_NO --上级机构编号                                                                         
         ,'null'                              AS ORG_SORT     --机构分类                                                          
         ,t2.curr_cd                          AS CURR_NO      --币种编号                                                          
         ,'null'                              AS CURR_NAME    --币种名称
         ,case when t1.unit='%' then round(t2.indx_val,4) else t2.indx_val end AS INDEX_VALUE  --指标值                                                
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'mm') =  to_date('${batch_date}','yyyymmdd') 
               then t2.indx_val 
               else coalesce(t2.indx_val,0)  +  coalesce(t4.ACCU_INDEX_VALUE_M,0)
                end                           AS  ACCU_INDEX_VALUE_M   --当月累计                                                          
         ,case when  trunc(to_date('${batch_date}','yyyymmdd'),'yy') =  to_date('${batch_date}','yyyymmdd') 
               then coalesce(t2.indx_val,0) 
               else coalesce(t2.indx_val,0)  +  coalesce(t4.ACCU_INDEX_VALUE_Y,0)
                end                           AS  ACCU_INDEX_VALUE_Y   --当年累计
         ,case when t1.unit='%' then coalesce(coalesce(round(t2.indx_val,4),0) - coalesce(round(t4.INDEX_VALUE,4),0),round(t10.indx_val,4))
		       else coalesce(coalesce(t2.indx_val,0) - coalesce(t4.INDEX_VALUE,0),t10.indx_val) end RATE_UP_DAY              --比上日   
         ,case when t1.unit='%' then coalesce(coalesce(round(t2.indx_val,4),0) - coalesce(round(t5.INDEX_VALUE,4),0),round(t11.indx_val,4))
		       else coalesce(coalesce(t2.indx_val,0) - coalesce(t5.INDEX_VALUE,0),t11.indx_val)  end      RATE_LAST_MONTH          --比上月                                                                                                                             --比上月                
         ,case when t1.unit='%' then coalesce(coalesce(round(t2.indx_val,4),0) - coalesce(round(t6.INDEX_VALUE,4),0),round(t12.indx_val,4))
		       else coalesce(coalesce(t2.indx_val,0) - coalesce(t6.INDEX_VALUE,0),t12.indx_val)  end     RATE_LAST_YEAR           --比上年                 
         ,case when t1.unit='%' then coalesce(coalesce(round(t2.indx_val,4),0) - coalesce(round(t7.INDEX_VALUE,4),0),round(t13.indx_val,4))
		       else coalesce(coalesce(t2.indx_val,0) - coalesce(t7.INDEX_VALUE,0),t13.indx_val) end RATE_LAST_PERIOD         --同比                
         ,case
         when round(coalesce(t4.index_value, 0), 4) = 0 then
          0
         else
          (case
            when t1.unit = '%' then
             coalesce(round(t10.indx_val, 4), coalesce(round(t2.indx_val, 4), 0) - coalesce(round(t4.index_value, 4), 0))
            else
             coalesce(t10.indx_val, coalesce(t2.indx_val, 0) - coalesce(t4.index_value, 0))
          end) / (case
            when t1.unit = '%' then
             round(coalesce(t4.index_value, 0), 4)
            else
             coalesce(t4.index_value, 0)
          end)
       end AS RATE_UP_DAY_PER        --比上日百分比                                                        
         ,case
         when round(coalesce(t5.index_value, 0), 4) = 0 then
          0
         else
          (case
            when t1.unit = '%' then
             coalesce(round(t11.indx_val, 4), coalesce(round(t2.indx_val, 4), 0) - coalesce(round(t5.index_value, 4), 0))
            else
             coalesce(t11.indx_val, coalesce(t2.indx_val, 0) - coalesce(t5.index_value, 0))
          end) / (case
            when t1.unit = '%' then
             round(coalesce(t5.index_value, 0), 4)
            else
             coalesce(t5.index_value, 0)
          end)
       end AS RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,case
         when round(coalesce(t6.index_value, 0), 4) = 0 then
          0
         else
          (case
            when t1.unit = '%' then
             coalesce(round(t12.indx_val, 4), coalesce(round(t2.indx_val, 4), 0) - coalesce(round(t6.index_value, 4), 0))
            else
             coalesce(t12.indx_val, coalesce(t2.indx_val, 0) - coalesce(t6.index_value, 0))
          end) / (case
            when t1.unit = '%' then
             round(coalesce(t6.index_value, 0), 4)
            else
             coalesce(t6.index_value, 0)
          end)
       end  AS RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,case
         when round(coalesce(t7.index_value, 0), 4) = 0 then
          0
         else
          (case
            when t1.unit = '%' then
             coalesce(round(t13.indx_val, 4), coalesce(round(t2.indx_val, 4), 0) - coalesce(round(t7.index_value, 4), 0))
            else
             coalesce(t13.indx_val, coalesce(t2.indx_val, 0) - coalesce(t7.index_value, 0))
          end) / (case
            when t1.unit = '%' then
             round(coalesce(t7.index_value, 0), 4)
            else
             coalesce(t7.index_value, 0)
          end)
       end AS RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,row_number()over(partition by t2.org_no order by   t2.indx_val desc ) AS  INDEX_RANKING                           --当前排名                                                          
         ,row_number()over(partition by t2.org_no order by   t2.indx_val desc )  -  t4.INDEX_RANKING  AS INDEX_RANKING_CHA  --排名变动                                                          
         ,t8.index_val                       AS INDEX_VALUE_AVG        --均值                                                            
         ,t9.sup_value                       AS INDEX_VALUE_LIMIT      --阀值                                                            
         ,0                                  AS RATIO_INDEX            --结构占比                                                           
         ,case when coalesce(t8.sum_index_val  ,0) =0 then 0 
          else t2.indx_val/t8.sum_index_val 
        end                                  AS RATIO_ORG              --分行贡献度                                                         
         ,t1.UNIT                                                      --单位                                                            
         ,t1.FREQUENCY                                                 --频度                                                            
         ,t2.INDEX_MEASURE                   AS MEASURE_NO             --度量编号   
         ,'RDW'                              AS SOURCE_SYS                                                
         ,case when t2.index_measure = '030' then '较上日'
               when t2.index_measure = '031' then '较上月同期'
               when t2.index_measure = '032' then '较上月末'
               when t2.index_measure = '001' then '当前值'
               when t2.index_measure = '033' then '较上季末'
               when t2.index_measure = '034' then '较上年同期'
               when t2.index_measure = '035' then '较上年末'
             end                           AS INDEX_MEASURE          --度量名称    
	       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp          --数据加载时间
        ,0                                                         as RATE_LAST_QUATER          --比上季
        ,0                                                         as RATE_LAST_QUATER_PER      --比上季百分比
        ,null							                    AS SUPERVISION_REQUIRE -- 监管要求
				,null							                    AS LIMIT_VALUE  -- 限额值
				,null							                    AS PREWARNING_VALUE  -- 预警值
    		,null																	AS INTRV_TYPE -- 区间类型
    		,0                                    AS RATE_LAST_WEEK      --比上周              
 from  mc_index_define t1
 inner  join   mtl_rdl_idx_indx_data t2
        on   trim(t1.index_no) = trim(t2.indx_no)
       and   t2.etl_dt = to_date('${batch_date}','yyyymmdd') 
       and   trim(t2.INDX_DIMEN_CD) ='ALL'
 inner  join mtl_fml_f99_int_org_info_new t3
       on decode(t2.org_no,'999999','000000',t2.org_no) = t3.org_id
      and (t3.admin_super_org_id ='000000'  or t3.admin_super_org_id ='999999')
      and t3.etl_dt = to_date('${batch_date}','yyyymmdd')  
 left join  ${idl_schema}.mc_index_fact t4            --上日
       on trim(t1.index_no_mcs)  = trim(t4.index_no)  
      and  decode(t2.org_no,'999999','000000',t2.org_no) = t4.org_no
      and  t2.curr_cd =t4.CURR_NO 
      and  t2.INDEX_MEASURE =t4.MEASURE_NO 
      and  t4.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
 left join  ${idl_schema}.mc_index_fact t5            --上月   
       on  trim(t1.index_no_mcs) = trim(t5.index_no)              
      and  decode(t2.org_no,'999999','000000',t2.org_no) = t5.org_no                              
      and  t2.curr_cd =t5.CURR_NO                             
      and  t2.INDEX_MEASURE =t5.MEASURE_NO                 
      and  t5.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            --上年             
       on  trim(t1.index_no_mcs) = trim(t6.index_no)                        
      and  decode(t2.org_no,'999999','000000',t2.org_no) = t6.org_no                                        
      and  t2.curr_cd =t6.CURR_NO                                       
      and  t2.INDEX_MEASURE =t6.MEASURE_NO                           
      and  t6.etl_dt = trunc(to_date('${batch_date}','yyyymmdd'),'yy') -1 
  left join  ${idl_schema}.mc_index_fact t7            --同比            
       on  trim(t1.index_no_mcs) = trim(t7.index_no)                        
      and  decode(t2.org_no,'999999','000000',t2.org_no) = t7.org_no                                        
      and  t2.curr_cd =t7.CURR_NO                                       
     and  t2.INDEX_MEASURE =t7.MEASURE_NO                           
      and  t7.etl_dt = add_months(to_date('${batch_date}','yyyymmdd'),-12)      
 left join  (select indx_no
                   ,curr_cd
                   ,INDEX_MEASURE 
                   ,avg(indx_val)  AS index_val
                   ,sum(indx_val)  AS sum_index_val
               from mtl_rdl_idx_indx_data 
              where etl_dt = to_date('${batch_date}','yyyymmdd') 
                and trim(INDX_DIMEN_CD) ='ALL'  
               group by indx_no
                       ,curr_cd
                       ,INDEX_MEASURE 
              )t8  on t2.indx_no = t8.indx_no         --均值
      and t2.curr_cd =t8.curr_cd                                       
     and t2.INDEX_MEASURE =t8.INDEX_MEASURE 
 left join ${idl_schema}.MC_SUP_PARA  t9
       on trim(t1.index_no_mcs) = trim(t9.index_no) 
 left  join  mtl_rdl_idx_indx_data t10
        on   trim(t10.indx_no) = (case when t1.index_clsaa_s like '%新发%' then trim(t1.index_no_mcs) else trim(t1.index_no) end)
       and   t10.etl_dt = to_date('${batch_date}','yyyymmdd') 
       and   trim(t10.INDX_DIMEN_CD) ='ALL'
       and   t10.org_no=t2.org_no
       and   t10.curr_cd=t2.curr_cd
       and   t10.index_measure ='030' --较上日
 left  join  mtl_rdl_idx_indx_data t11
        on   trim(t11.indx_no) =  (case when t1.index_clsaa_s like '%新发%' then trim(t1.index_no_mcs) else trim(t1.index_no) end)
       and   t11.etl_dt = to_date('${batch_date}','yyyymmdd') 
       and   trim(t11.INDX_DIMEN_CD) ='ALL'
       and   t11.org_no=t2.org_no
       and   t11.curr_cd=t2.curr_cd
       and   t11.index_measure ='032' --较上月
  left  join  mtl_rdl_idx_indx_data t12
        on   trim(t12.indx_no) =  (case when t1.index_clsaa_s like '%新发%' then trim(t1.index_no_mcs) else trim(t1.index_no) end)
       and   t12.etl_dt = to_date('${batch_date}','yyyymmdd') 
       and   trim(t12.INDX_DIMEN_CD) ='ALL'
       and   t12.org_no=t2.org_no
       and   t12.curr_cd=t2.curr_cd
       and   t12.index_measure ='035' --较上年
  left  join  mtl_rdl_idx_indx_data t13
        on   trim(t13.indx_no) =  (case when t1.index_clsaa_s like '%新发%' then trim(t1.index_no_mcs) else trim(t1.index_no) end)
       and   t13.etl_dt = to_date('${batch_date}','yyyymmdd') 
       and   trim(t13.INDX_DIMEN_CD) ='ALL'
       and   t13.org_no=t2.org_no
       and   t13.curr_cd=t2.curr_cd
       and   t13.index_measure ='034' --较上年同期
 where  t1.source_system = '风险集市'
       and trim(t1.index_no_mcs) not in ('FX03014000','YL04040000')   
 ; 
 commit;
 

 
alter table ${idl_schema}.mc_index_fact exchange subpartition p_${batch_date}_rdw with table ${idl_schema}.mc_index_fact_rdw_temp01 ;
	  commit;	  
--alter index fact_all_index rebuild online;
whenever sqlerror continue none;
drop table ${idl_schema}.mc_index_fact_rdw_temp01 purge ;
-- 3.1 gather table status
--exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact', degree => 8, cAScade => true);