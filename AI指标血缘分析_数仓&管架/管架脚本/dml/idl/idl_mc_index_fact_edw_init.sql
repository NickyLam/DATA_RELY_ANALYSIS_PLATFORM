set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
-- python $ETL_HOME/script/main.py yyyymmdd idl_mc_index_fact_edw
-- 以下为依赖了上游的表：
-- itl_edw_alms_rp_alm_rrs_b01_report_result
-- itl_edw_alms_rp_alm_rrs_liquidity_report_result
-- itl_edw_rrps_rpt_report_result_archive_data
-- 以下为依赖的参数表
-- mc_index_define    -- 指标表清单

-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_index_fact add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_edw_zz values ('EDW-ZZ')
                                              ,subpartition p_${batch_date}_edw_jg values ('EDW-JG')
                                              )
;
alter table ${idl_schema}.mc_index_fact modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_edw_zz values ('EDW-ZZ')
;
alter table ${idl_schema}.mc_index_fact modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_edw_jg values ('EDW-JG')
;
drop table ${idl_schema}.mc_index_fact_edw_temp01 purge ;
drop table ${idl_schema}.mc_index_fact_edw_temp02 purge ;
drop table ${idl_schema}.mc_index_fact_edw_temp03 purge ;
drop table ${idl_schema}.rrps_index_data_tmp01 purge ;

whenever sqlerror exit sql.sqlcode; 

alter table ${idl_schema}.mc_index_fact truncate subpartition p_${batch_date}_edw_zz;
alter table ${idl_schema}.mc_index_fact truncate subpartition p_${batch_date}_edw_jg; 

-- 2.1 insert data to table

--资债来源指标临时表
create table  ${idl_schema}.mc_index_fact_edw_temp01 compress
AS 
select * from ${idl_schema}.mc_index_fact
where 1=2 ;

--资债来源指标临时表(存放T-3周频指标月末数据)
create table  ${idl_schema}.mc_index_fact_edw_temp03 compress
AS 
select * from ${idl_schema}.mc_index_fact
where 1=2 ;
--监管来源指标临时表
create table  ${idl_schema}.mc_index_fact_edw_temp02 compress
AS 
select * from ${idl_schema}.mc_index_fact
where 1=2 ;

--第1.1组 资债T-2指标

insert into  ${idl_schema}.mc_index_fact_edw_temp01                                                                                
select    to_date('${batch_date}','yyyymmdd')  AS etl_dt
         ,t1.index_no_mcs                     AS INDEX_NO     --指标编码                                                           
         ,t1.index_name_mcs                   AS INDEX_NAME   --指标名称                                                          
         ,'000000'                            AS ORG_NO       --机构编码                                                          
         ,'广东华兴银行'                      AS ORG_NAME     --机构名称                                                          
         ,'999999'                            AS SUPER_ORG_NO --上级机构编号                                                                         
         ,'null'                              AS ORG_SORT     --机构分类                                                          
         ,'BWB'                               AS CURR_NO      --币种编号 1:人民币;2:外币折人民币;3:本外币合计   默认人民币                                                       
         ,'null'                              AS CURR_NAME    --币种名称 1:人民币;2:外币折人民币;3:本外币合计   默认人民币
         ,nvl(t2.n_rep_line_value,0)          AS INDEX_VALUE  --指标值                                                           
         ,NULL                                AS ACCU_INDEX_VALUE_M   --当月累计                                                          
         ,NULL                                AS ACCU_INDEX_VALUE_Y   --当年累计                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t4.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t4.index_value,0) end AS RATE_UP_DAY         --比上日   
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t5.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t5.index_value,0) end AS RATE_LAST_MONTH     --比上月                                                                                                                                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t6.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t6.index_value,0) end AS RATE_LAST_YEAR      --比上年                                                           
         ,0                                   AS RATE_LAST_PERIOD         --同比                                                            
         ,0                                   AS RATE_UP_DAY_PER        --比上日百分比                                                        
         ,0                                   AS RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,0                                   AS RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,0                                   AS RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,0                                   AS INDEX_RANKING         --当前排名                                                          
         ,0                                   AS INDEX_RANKING_CHA      --排名变动                                                          
         ,0                                   AS INDEX_VALUE_AVG        --均值                                                            
         ,0                                   AS INDEX_VALUE_LIMIT      --阀值                                                            
         ,0                                   AS RATIO_INDEX            --结构占比                                                           
         ,0                                   AS RATIO_ORG              --分行贡献度                                                         
         ,t1.UNIT                                                      --单位                                                            
         ,t1.FREQUENCY                                                 --频度                                                            
         ,'001'                               AS MEASURE_NO             --度量编号   
         ,'EDW-ZZ'                            AS SOURCE_SYS                                                
         ,'原始统计值'                        AS INDEX_MEASURE          --度量名称    
	       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp          --数据加载时间
        ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t7.index_value,0),4) 
           else coalesce(t2.n_rep_line_value,0) - coalesce(t7.index_value,0)  end  AS RATE_LAST_QUATER          --比上季
        ,0                                    AS RATE_LAST_QUATER_PER      --比上季百分比
    		,replace(replace(nvl(trim(t3.v_supervision_require),'/'),'亿',''),'%','')			AS SUPERVISION_REQUIRE -- 监管要求
				,replace(replace(nvl(trim(t3.v_limit_value),'/'),'亿',''),'%','')             AS LIMIT_VALUE  -- 限额值
				,replace(replace(nvl(trim(t3.v_prewarning_value),'/'),'亿',''),'%','')        AS PREWARNING_VALUE  -- 预警值
				/* 以下是区间类型的业务判断口径,运算符优先取监管要求再取限额
				≥： <限额值，红灯；[限额值，预警值]，黄灯；>预警值，绿灯 
				≤： >限额值，红灯；[预警值，限额值]，黄灯；<预警值，绿灯 
				*/
    		,case when trim(t3.v_limit_value) is not null and trim(t3.v_prewarning_value) is not null and 
    		    nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i')) is not null  --运算符必须有值才可以判断红黄绿灯
    		 then 
    		  case when nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i'))='>=' then
    		      (case when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t3.v_limit_value,'[^0-9-]','')) then '03'  
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t3.v_limit_value,'[^0-9-]',''))
                      and t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		       when nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i'))='<=' then
    		       (case when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t3.v_limit_value,'[^0-9-]','')) then '03'  
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t3.v_limit_value,'[^0-9-]',''))
                      and t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		  end 
    	   end																	AS INTRV_TYPE -- 区间类型     01.绿 02.黄 03.红 04.深红 
    		,0          AS RATE_LAST_WEEK      --比上周  周批指标源系统会在这个字段加入比上周        
 from  mc_index_define t1
 left  join  itl_edw_alms_rp_alm_rrs_b01_report_result t2
        on   trim(t1.index_no) = trim(t2.n_rep_line_cd) --报表项编码
       and   t2.as_of_date = to_date('${batch_date}','yyyymmdd')  --T+2数据  
       --and   t2.n_forecast_point_skey='0'   -- 时间窗口键值：0：当前时点
 left join itl_edw_alms_rp_alm_rrs_liquidity_report_result t3
      on trim(t3.n_rep_line_cd)=trim(t1.index_no) --报表项编码
      and t3.etl_dt = to_date('20241024','yyyymmdd') 
 left join  ${idl_schema}.mc_index_fact t4            --上日
       on trim(t1.index_no_mcs)  = trim(t4.index_no)  
      --and  t2.org_no = t4.org_no
      and  t4.etl_dt = t2.as_of_date - 1
 left join  ${idl_schema}.mc_index_fact t5            --上月   
       on  trim(t1.index_no_mcs) = trim(t5.index_no)              
      --and  t2.org_no = t5.org_no                                          
      and  t5.etl_dt = trunc(t2.as_of_date,'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            --上年             
       on  trim(t1.index_no_mcs) = trim(t6.index_no)   
      and  t6.etl_dt = trunc(t2.as_of_date,'yy') -1 
      --and  t2.org_no = t6.org_no                                        
 left join  ${idl_schema}.mc_index_fact t7            --上季           
       on  trim(t1.index_no_mcs) = trim(t7.index_no)
      and  t7.etl_dt = add_months(t2.as_of_date,-3) 
 where  t1.source_system = '数仓-资债'
    and t1.frequency<>'周'; 
 commit;
 
--第1.2组 资债周指标(周五批、月中批)

insert into  ${idl_schema}.mc_index_fact_edw_temp01                                                                                
select    to_date('${batch_date}','yyyymmdd')  AS etl_dt
         ,t1.index_no_mcs                     AS INDEX_NO     --指标编码                                                           
         ,t1.index_name_mcs                   AS INDEX_NAME   --指标名称                                                          
         ,'000000'                            AS ORG_NO       --机构编码                                                          
         ,'广东华兴银行'                      AS ORG_NAME     --机构名称                                                          
         ,'999999'                            AS SUPER_ORG_NO --上级机构编号                                                                         
         ,'null'                              AS ORG_SORT     --机构分类                                                          
         ,'BWB'                               AS CURR_NO      --币种编号 1:人民币;2:外币折人民币;3:本外币合计   默认人民币                                                       
         ,'null'                              AS CURR_NAME    --币种名称 1:人民币;2:外币折人民币;3:本外币合计   默认人民币
         ,nvl(t2.n_rep_line_value,0)          AS INDEX_VALUE  --指标值                                                           
         ,NULL                                AS ACCU_INDEX_VALUE_M   --当月累计                                                          
         ,NULL                                AS ACCU_INDEX_VALUE_Y   --当年累计                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t4.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t4.index_value,0) end AS RATE_UP_DAY         --比上日   
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t5.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t5.index_value,0) end AS RATE_LAST_MONTH     --比上月                                                                                                                                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t6.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t6.index_value,0) end AS RATE_LAST_YEAR      --比上年                                                           
         ,0                                   AS RATE_LAST_PERIOD         --同比                                                            
         ,0                                   AS RATE_UP_DAY_PER        --比上日百分比                                                        
         ,0                                   AS RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,0                                   AS RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,0                                   AS RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,0                                   AS INDEX_RANKING         --当前排名                                                          
         ,0                                   AS INDEX_RANKING_CHA      --排名变动                                                          
         ,0                                   AS INDEX_VALUE_AVG        --均值                                                            
         ,0                                   AS INDEX_VALUE_LIMIT      --阀值                                                            
         ,0                                   AS RATIO_INDEX            --结构占比                                                           
         ,0                                   AS RATIO_ORG              --分行贡献度                                                         
         ,t1.UNIT                                                      --单位                                                            
         ,t1.FREQUENCY                                                 --频度                                                            
         ,'001'                               AS MEASURE_NO             --度量编号   
         ,'EDW-ZZ'                            AS SOURCE_SYS                                                
         ,'原始统计值'                        AS INDEX_MEASURE          --度量名称    
	       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp          --数据加载时间
        ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t7.index_value,0),4) 
           else coalesce(t2.n_rep_line_value,0) - coalesce(t7.index_value,0)  end  AS RATE_LAST_QUATER          --比上季
        ,0                                    AS RATE_LAST_QUATER_PER      --比上季百分比
    		,replace(replace(nvl(trim(t3.v_supervision_require),'/'),'亿',''),'%','')			AS SUPERVISION_REQUIRE -- 监管要求
				,replace(replace(nvl(trim(t3.v_limit_value),'/'),'亿',''),'%','')             AS LIMIT_VALUE  -- 限额值
				,replace(replace(nvl(trim(t3.v_prewarning_value),'/'),'亿',''),'%','')        AS PREWARNING_VALUE  -- 预警值
				/* 以下是区间类型的业务判断口径,运算符优先取监管要求再取限额
				≥： <限额值，红灯；[限额值，预警值]，黄灯；>预警值，绿灯 
				≤： >限额值，红灯；[预警值，限额值]，黄灯；<预警值，绿灯 
				*/
    		,case when trim(t3.v_limit_value) is not null and trim(t3.v_prewarning_value) is not null and 
    		    nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i')) is not null  --运算符必须有值才可以判断红黄绿灯
    		 then 
    		  case when nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i'))='>=' then
    		      (case when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t3.v_limit_value,'[^0-9-]','')) then '03'  
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t3.v_limit_value,'[^0-9-]',''))
                      and t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		       when nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i'))='<=' then
    		       (case when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t3.v_limit_value,'[^0-9-]','')) then '03'  
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t3.v_limit_value,'[^0-9-]',''))
                      and t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		  end 
    	   end																	AS INTRV_TYPE -- 区间类型     01.绿 02.黄 03.红 04.深红 
    		,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t8.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t8.index_value,0) end AS RATE_LAST_WEEK      --比上周  周批指标源系统会在这个字段加入比上周        
 from  mc_index_define t1
 inner  join  itl_edw_alms_rp_alm_rrs_b01_report_result t2
        on   trim(t1.index_no) = trim(t2.n_rep_line_cd) --报表项编码
       and   t2.as_of_date = to_date('${batch_date}','yyyymmdd')  --T+2数据
       and   t2.as_of_date<>last_day(t2.as_of_date) --只获取每周五、每月中数据
       --and   t2.n_forecast_point_skey='0'   -- 时间窗口键值：0：当前时点
 left join itl_edw_alms_rp_alm_rrs_liquidity_report_result t3
      on trim(t3.n_rep_line_cd)=trim(t1.index_no) --报表项编码
      and t3.etl_dt = to_date('20241024','yyyymmdd') 
 left join  ${idl_schema}.mc_index_fact t4            --上日
       on trim(t1.index_no_mcs)  = trim(t4.index_no)  
      --and  t2.org_no = t4.org_no
      and  t4.etl_dt = t2.as_of_date - 1
 left join  ${idl_schema}.mc_index_fact t5            --上月   
       on  trim(t1.index_no_mcs) = trim(t5.index_no)              
      --and  t2.org_no = t5.org_no                                          
      and  t5.etl_dt = trunc(t2.as_of_date,'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            --上年             
       on  trim(t1.index_no_mcs) = trim(t6.index_no)   
      and  t6.etl_dt = trunc(t2.as_of_date,'yy') -1 
      --and  t2.org_no = t6.org_no                                        
 left join  ${idl_schema}.mc_index_fact t7            --上季           
       on  trim(t1.index_no_mcs) = trim(t7.index_no)
      and  t7.etl_dt = add_months(t2.as_of_date,-3)
 left join  ${idl_schema}.mc_index_fact t8            --上周           
       on  trim(t1.index_no_mcs) = trim(t8.index_no)
      and  t8.etl_dt = trunc(t2.as_of_date, 'IW') -3
 where  t1.source_system = '数仓-资债'
    and t1.frequency='周'; 
 commit;

--第1.3组 资债周指标(月末批)

insert into  ${idl_schema}.mc_index_fact_edw_temp03                                                                                
select    to_date('${batch_date}','yyyymmdd') AS etl_dt
         ,t1.index_no_mcs                     AS INDEX_NO     --指标编码                                                           
         ,t1.index_name_mcs                   AS INDEX_NAME   --指标名称                                                          
         ,'000000'                            AS ORG_NO       --机构编码                                                          
         ,'广东华兴银行'                      AS ORG_NAME     --机构名称                                                          
         ,'999999'                            AS SUPER_ORG_NO --上级机构编号                                                                         
         ,'null'                              AS ORG_SORT     --机构分类                                                          
         ,'BWB'                               AS CURR_NO      --币种编号 1:人民币;2:外币折人民币;3:本外币合计   默认人民币                                                       
         ,'null'                              AS CURR_NAME    --币种名称 1:人民币;2:外币折人民币;3:本外币合计   默认人民币
         ,nvl(t2.n_rep_line_value,0)          AS INDEX_VALUE  --指标值                                                           
         ,NULL                                AS ACCU_INDEX_VALUE_M   --当月累计                                                          
         ,NULL                                AS ACCU_INDEX_VALUE_Y   --当年累计                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t4.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t4.index_value,0) end AS RATE_UP_DAY         --比上日   
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t5.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t5.index_value,0) end AS RATE_LAST_MONTH     --比上月                                                                                                                                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t6.index_value,0),4) 
             else coalesce(t2.n_rep_line_value,0) - coalesce(t6.index_value,0) end AS RATE_LAST_YEAR      --比上年                                                           
         ,0                                   AS RATE_LAST_PERIOD         --同比                                                            
         ,0                                   AS RATE_UP_DAY_PER        --比上日百分比                                                        
         ,0                                   AS RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,0                                   AS RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,0                                   AS RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,0                                   AS INDEX_RANKING         --当前排名                                                          
         ,0                                   AS INDEX_RANKING_CHA      --排名变动                                                          
         ,0                                   AS INDEX_VALUE_AVG        --均值                                                            
         ,0                                   AS INDEX_VALUE_LIMIT      --阀值                                                            
         ,0                                   AS RATIO_INDEX            --结构占比                                                           
         ,0                                   AS RATIO_ORG              --分行贡献度                                                         
         ,t1.UNIT                                                      --单位                                                            
         ,t1.FREQUENCY                                                 --频度                                                            
         ,'001'                               AS MEASURE_NO             --度量编号   
         ,'EDW-ZZ'                            AS SOURCE_SYS                                                
         ,'原始统计值'                        AS INDEX_MEASURE          --度量名称    
	       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp          --数据加载时间
        ,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t7.index_value,0),4) 
           else coalesce(t2.n_rep_line_value,0) - coalesce(t7.index_value,0)  end  AS RATE_LAST_QUATER          --比上季
        ,0                                    AS RATE_LAST_QUATER_PER      --比上季百分比
    		,replace(replace(nvl(trim(t3.v_supervision_require),'/'),'亿',''),'%','')			AS SUPERVISION_REQUIRE -- 监管要求
				,replace(replace(nvl(trim(t3.v_limit_value),'/'),'亿',''),'%','')             AS LIMIT_VALUE  -- 限额值
				,replace(replace(nvl(trim(t3.v_prewarning_value),'/'),'亿',''),'%','')        AS PREWARNING_VALUE  -- 预警值
				/* 以下是区间类型的业务判断口径,运算符优先取监管要求再取限额
				≥： <限额值，红灯；[限额值，预警值]，黄灯；>预警值，绿灯 
				≤： >限额值，红灯；[预警值，限额值]，黄灯；<预警值，绿灯 
				*/
    		,case when trim(t3.v_limit_value) is not null and trim(t3.v_prewarning_value) is not null and 
    		    nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i')) is not null  --运算符必须有值才可以判断红黄绿灯
    		 then 
    		  case when nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i'))='>=' then
    		      (case when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t3.v_limit_value,'[^0-9-]','')) then '03'  
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t3.v_limit_value,'[^0-9-]',''))
                      and t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		       when nvl(regexp_substr(t3.v_supervision_require,'[><]=?',1,1,'i'),regexp_substr(t3.v_limit_value,'[><]=?',1,1,'i'))='<=' then
    		       (case when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t3.v_limit_value,'[^0-9-]','')) then '03'  
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t3.v_limit_value,'[^0-9-]',''))
                      and t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.n_rep_line_value/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t3.v_prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		  end 
    	   end																	AS INTRV_TYPE -- 区间类型     01.绿 02.黄 03.红 04.深红 
    		,case when t1.UNIT='%' then round(coalesce(t2.n_rep_line_value,0),4) - round(coalesce(t8.index_value,0),4) 
           else coalesce(t2.n_rep_line_value,0) - coalesce(t8.index_value,0) end AS RATE_LAST_WEEK      --比上周  周批指标源系统会在这个字段加入比上周        
 from  mc_index_define t1
 inner  join  itl_edw_alms_rp_alm_rrs_b01_report_result t2
        on   trim(t1.index_no) = trim(t2.n_rep_line_cd) --报表项编码
       and   t2.as_of_date =  to_date('${batch_date}','yyyymmdd') 
       and   t2.as_of_date=last_day(t2.as_of_date) --只获取每月末数据 
       --and   t2.n_forecast_point_skey='0'   -- 时间窗口键值：0：当前时点
 left join itl_edw_alms_rp_alm_rrs_liquidity_report_result t3
      on trim(t3.n_rep_line_cd)=trim(t1.index_no) --报表项编码
      and t3.etl_dt = to_date('20241024','yyyymmdd')
 left join  ${idl_schema}.mc_index_fact t4            --上日
       on trim(t1.index_no_mcs)  = trim(t4.index_no)  
      --and  t2.org_no = t4.org_no
      and  t4.etl_dt = t2.as_of_date - 1
 left join  ${idl_schema}.mc_index_fact t5            --上月   
       on  trim(t1.index_no_mcs) = trim(t5.index_no)              
      --and  t2.org_no = t5.org_no                                          
      and  t5.etl_dt = trunc(t2.as_of_date,'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            --上年             
       on  trim(t1.index_no_mcs) = trim(t6.index_no)   
      and  t6.etl_dt = trunc(t2.as_of_date,'yy') -1 
      --and  t2.org_no = t6.org_no                                        
 left join  ${idl_schema}.mc_index_fact t7            --上季           
       on  trim(t1.index_no_mcs) = trim(t7.index_no)
      and  t7.etl_dt = add_months(t2.as_of_date,-3)
 left join  ${idl_schema}.mc_index_fact t8            --上周           
       on  trim(t1.index_no_mcs) = trim(t8.index_no)
      and  t8.etl_dt = trunc(t2.as_of_date, 'IW') -3
 where  t1.source_system = '数仓-资债'
    and t1.frequency='周'; 
 commit;
  
  
  --覆盖原有数据
 MERGE INTO mc_index_fact_edw_temp01 a
 USING (SELECT * FROM mc_index_fact_edw_temp03 where INDEX_VALUE is not null) b
 ON (a.index_no = b.index_no 
 AND a.org_no = b.org_no
 AND a.etl_dt = b.etl_dt)
WHEN MATCHED THEN
    UPDATE
    SET    a.index_value       = b.index_value         --指标值
          ,a.rate_up_day       = b.rate_up_day       --比上日   
          ,a.rate_last_month   = b.rate_last_month   --比上月                                                                                                                                                                           
          ,a.rate_last_year    = b.rate_last_year    --比上年
          ,a.rate_last_quater  = b.rate_last_quater  --比上季
          ,a.rate_last_week    = b.rate_last_week      --比上周
          ,a.intrv_type        = b.intrv_type        --区间类型
          ,a.etl_timestamp = b.etl_timestamp
    WHERE  b.etl_dt = a.etl_dt
WHEN NOT MATCHED THEN
    INSERT 
        (etl_dt
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
         ,supervision_require
         ,limit_value
         ,prewarning_value
         ,intrv_type
         ,rate_last_week
)
    VALUES
        ( b.etl_dt
         ,b.index_no
         ,b.index_name
         ,b.org_no
         ,b.org_name
         ,b.super_org_no
         ,b.org_sort
         ,b.curr_no
         ,b.curr_name
         ,b.index_value
         ,b.accu_index_value_m
         ,b.accu_index_value_y
         ,b.rate_up_day
         ,b.rate_last_month
         ,b.rate_last_year
         ,b.rate_last_period
         ,b.rate_up_day_per
         ,b.rate_last_month_per
         ,b.rate_last_year_per
         ,b.rate_last_period_per
         ,b.index_ranking
         ,b.index_ranking_cha
         ,b.index_value_avg
         ,b.index_value_limit
         ,b.ratio_index
         ,b.ratio_org
         ,b.unit
         ,b.frequency
         ,b.measure_no
         ,b.source_sys
         ,b.index_measure
         ,b.etl_timestamp
         ,b.rate_last_quater
         ,b.rate_last_quater_per
         ,b.supervision_require
         ,b.limit_value
         ,b.prewarning_value
         ,b.intrv_type
         ,b.rate_last_week);
COMMIT;


--第二组 监管
--将监管指标结果表提取为临时表 
/*
当前只取上月末、上季末:月末按1104最后一次报送批次13号；季末按1104最后一次报送批次18号
*/
create table rrps_index_data_tmp01 
as
--基础指标
select 
   t2.index_no_mcs,
   t1.index_val,
   t1.data_date
 from itl_edw_rrps_rpt_report_result_archive_data t1
  inner join mc_index_define t2
       on  (trim(t2.index_no)=trim(t1.index_no)
             or trim(t2.manual_adj_index_no)=trim(t1.index_no))
       and (t2.source_system = '数仓-监管' or t2.manual_adj_source_system='数仓-监管')
 where t1.org_no = '00000V1' --广东省
   and t1.etl_dt = to_date('20241024','yyyymmdd') 
   and t1.data_date='${batch_date}' 
   and t1.sys_ind = 'MCS'
union all
--组合指标
--RM0300028
select 
   'RM0300028' as index_no_mcs,
   t1.index_val/t2.index_val as index_val,
   t1.data_date
 from itl_edw_rrps_rpt_report_result_archive_data t1
 left join itl_edw_rrps_rpt_report_result_archive_data t2
 on t2.index_no='G4A00L1_0084001'
 and t2.data_date=t1.data_date
 and t2.etl_dt=t1.etl_dt
 and t2.org_no='00000V1' --广东省
 and t2.sys_ind = 'MCS'
 where t1.org_no = '00000V1' --广东省
   and t1.etl_dt = to_date('20241024','yyyymmdd') 
   and t1.sys_ind = 'MCS'
   and t1.data_date ='${batch_date}' 
   and t1.index_no ='G3301_0055001'
union all
--RM0300024
select 
   'RM0300024' as index_no_mcs,
   t1.index_val/t2.index_val as index_val,
   t1.data_date
 from itl_edw_rrps_rpt_report_result_archive_data t1
 left join itl_edw_rrps_rpt_report_result_archive_data t2
 on t2.index_no='G4A00L1_0085001'
 and t2.data_date=t1.data_date
 and t2.etl_dt=t1.etl_dt
 and t2.org_no='00000V1' --广东省
 and t2.sys_ind = 'MCS'
 where t1.org_no = '00000V1' --广东省
   and t1.etl_dt = to_date('20241024','yyyymmdd') 
   and t1.sys_ind = 'MCS'
   and t1.data_date = '${batch_date}' 
   and t1.index_no ='G3200_0012010'
union all
--RM0300025
select 
   'RM0300025' as index_no_mcs,
   t1.index_val/t2.index_val as index_val,
   t1.data_date
 from itl_edw_rrps_rpt_report_result_archive_data t1
 left join itl_edw_rrps_rpt_report_result_archive_data t2
 on t2.index_no='G4A00L1_0085001'
 and t2.data_date=t1.data_date
 and t2.etl_dt=t1.etl_dt
 and t2.org_no='00000V1' --广东省
 and t2.sys_ind = 'MCS'
 where t1.org_no = '00000V1' --广东省
   and t1.etl_dt = to_date('20241024','yyyymmdd') 
   and t1.sys_ind = 'MCS'
   and t1.data_date ='${batch_date}' 
   and t1.index_no ='G3200_0001010';
   
insert into  ${idl_schema}.mc_index_fact_edw_temp02                                                                               
select    to_date(t2.data_date,'yyyymmdd') AS etl_dt
         ,t1.index_no_mcs                     AS INDEX_NO     --指标编码                                                           
         ,t1.index_name_mcs                   AS INDEX_NAME   --指标名称                                                          
         ,'000000'                            AS ORG_NO       --机构编码                                                          
         ,'广东华兴银行'                      AS ORG_NAME     --机构名称                                                          
         ,'999999'                            AS SUPER_ORG_NO --上级机构编号                                                                         
         ,'null'                              AS ORG_SORT     --机构分类                                                          
         ,'BWB'                               AS CURR_NO      --币种编号                                                          
         ,'null'                              AS CURR_NAME    --币种名称
         ,t2.index_val                        AS INDEX_VALUE  --指标值                                                           
         ,NULL                                AS ACCU_INDEX_VALUE_M   --当月累计                                                          
         ,NULL                                AS ACCU_INDEX_VALUE_Y   --当年累计                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.index_val,0),4) - round(coalesce(t4.index_value,0),4) 
             else coalesce(t2.index_val,0) - coalesce(t4.index_value,0) end AS RATE_UP_DAY         --比上日   
         ,case when t1.UNIT='%' then round(coalesce(t2.index_val,0),4) - round(coalesce(t5.index_value,0),4) 
             else coalesce(t2.index_val,0) - coalesce(t5.index_value,0) end AS RATE_LAST_MONTH     --比上月                                                                                                                                                                         
         ,case when t1.UNIT='%' then round(coalesce(t2.index_val,0),4) - round(coalesce(t6.index_value,0),4) 
             else coalesce(t2.index_val,0) - coalesce(t6.index_value,0) end AS RATE_LAST_YEAR      --比上年                                                      
         ,0                                   AS RATE_LAST_PERIOD         --同比                                                            
         ,0                                   AS RATE_UP_DAY_PER        --比上日百分比                                                        
         ,0                                   AS RATE_LAST_MONTH_PER    --比上月百分比                                                        
         ,0                                   AS RATE_LAST_YEAR_PER     --比上年百分比                                                        
         ,0                                   AS RATE_LAST_PERIOD_PER   --同比百分比                                                         
         ,0                                   AS INDEX_RANKING         --当前排名                                                          
         ,0                                   AS INDEX_RANKING_CHA      --排名变动                                                          
         ,0                                   AS INDEX_VALUE_AVG        --均值                                                            
         ,0                                   AS INDEX_VALUE_LIMIT      --阀值                                                            
         ,0                                   AS RATIO_INDEX            --结构占比                                                           
         ,0                                   AS RATIO_ORG              --分行贡献度                                                         
         ,t1.UNIT                                                      --单位                                                            
         ,t1.FREQUENCY                                                 --频度                                                            
         ,'001'                               AS MEASURE_NO             --度量编号   
         ,'EDW-ZZ'                            AS SOURCE_SYS                                                
         ,'原始统计值'                        AS INDEX_MEASURE          --度量名称    
	       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp          --数据加载时间
        ,case when t1.UNIT='%' then round(coalesce(t2.index_val,0),4) - round(coalesce(t7.index_value,0),4) 
           else coalesce(t2.index_val,0) - coalesce(t7.index_value,0) end AS RATE_LAST_QUATER          --比上季
        ,0                                    AS RATE_LAST_QUATER_PER      --比上季百分比
    		,t8.supervision_require							  AS SUPERVISION_REQUIRE -- 监管要求
				,t8.limit_value							          AS LIMIT_VALUE  -- 限额值
				,t8.prewarning_value							    AS PREWARNING_VALUE  -- 预警值
				/* 以下是区间类型的业务判断口径,运算符优先取监管要求再取限额
				≥： <限额值，红灯；[限额值，预警值]，黄灯；>预警值，绿灯 
				≤： >限额值，红灯；[预警值，限额值]，黄灯；<预警值，绿灯 
				*/
    		,case when trim(t8.limit_value) is not null and trim(t8.prewarning_value) is not null and 
    		    nvl(regexp_substr(t8.supervision_require,'[><]=?',1,1,'i'),regexp_substr(t8.limit_value,'[><]=?',1,1,'i')) is not null  --运算符必须有值才可以判断红黄绿灯
    		 then 
    		  case when nvl(regexp_substr(t8.supervision_require,'[><]=?',1,1,'i'),regexp_substr(t8.limit_value,'[><]=?',1,1,'i'))='>=' then
    		      (case when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t8.limit_value,'[^0-9-]','')) then '03'  
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t8.limit_value,'[^0-9-]',''))
                      and t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t8.prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t8.prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		       when nvl(regexp_substr(t8.supervision_require,'[><]=?',1,1,'i'),regexp_substr(t8.limit_value,'[><]=?',1,1,'i'))='<=' then
    		       (case when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t8.limit_value,'[^0-9-]','')) then '03'  
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t8.limit_value,'[^0-9-]',''))
                      and t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t8.prewarning_value,'[^0-9-]','')) then '02'		      
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t8.prewarning_value,'[^0-9-]','')) then '01'                                       
               end)
    		  end 
    	   end AS INTRV_TYPE -- 区间类型
    		,case when t1.UNIT='%' then round(coalesce(t2.index_val,0),4) - round(coalesce(t9.index_value,0),4) 
             else coalesce(t2.index_val,0) - coalesce(t9.index_value,0) end AS RATE_LAST_WEEK      --比上周        
 from  mc_index_define t1
 inner  join  rrps_index_data_tmp01 t2
        on   t1.index_no_mcs=t2.index_no_mcs
 left join  ${idl_schema}.mc_index_fact t4            --上日
       on trim(t1.index_no_mcs)  = trim(t4.index_no)  
      --and  t2.org_no = t4.org_no
      and  t4.etl_dt = to_date(t2.data_date,'yyyymmdd') - 1
 left join  ${idl_schema}.mc_index_fact t5            --上月   
       on  trim(t1.index_no_mcs) = trim(t5.index_no)              
      --and  t2.org_no = t5.org_no                                          
      and  t5.etl_dt = trunc(to_date(t2.data_date,'yyyymmdd'),'mm') -1
 left join  ${idl_schema}.mc_index_fact t6            --上年             
       on  trim(t1.index_no_mcs) = trim(t6.index_no)   
      and  t6.etl_dt = trunc(to_date(t2.data_date,'yyyymmdd'),'yy') -1 
      --and  t2.org_no = t6.org_no                                        
 left join  ${idl_schema}.mc_index_fact t7            --上季           
       on  trim(t1.index_no_mcs) = trim(t7.index_no)
      and  t7.etl_dt = add_months(to_date(t2.data_date,'yyyymmdd'),-3)                         
      --and  t2.org_no = t7.org_no
 left join  ${idl_schema}.mc_index_fact_edw_temp01 t8            --当日
       on trim(t1.index_no_mcs)  = trim(t8.index_no)  
      --and  t2.org_no = t8.org_no
      and  t8.etl_dt = to_date(t2.data_date,'yyyymmdd')
 left join  ${idl_schema}.mc_index_fact t9            --上周           
       on  trim(t1.index_no_mcs) = trim(t9.index_no)
      and  t9.etl_dt = trunc(to_date(t2.data_date,'yyyymmdd'), 'IW') -3;                                        
 commit;
 
 --用1104报送后数据覆盖原有数据
 
 MERGE INTO mc_index_fact_edw_temp01 a
 USING (SELECT * FROM mc_index_fact_edw_temp02 where INDEX_VALUE is not null) b
 ON (a.index_no = b.index_no 
 AND a.org_no = b.org_no
 AND a.etl_dt = b.etl_dt)
WHEN MATCHED THEN
    UPDATE
    SET    a.index_value       = b.index_value         --指标值
          ,a.rate_up_day       = b.rate_up_day       --比上日   
          ,a.rate_last_month   = b.rate_last_month   --比上月                                                                                                                                                                           
          ,a.rate_last_year    = b.rate_last_year    --比上年
          ,a.rate_last_quater  = b.rate_last_quater  --比上季
          ,a.rate_last_week    = b.rate_last_week    --比上周
          ,a.intrv_type        = b.intrv_type        --区间类型
          --,a.source_sys        = b.source_sys        --来源系统
          ,a.etl_timestamp = b.etl_timestamp
    WHERE  b.etl_dt = a.etl_dt
WHEN NOT MATCHED THEN
    INSERT 
        (etl_dt
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
         ,supervision_require
         ,limit_value
         ,prewarning_value
         ,intrv_type
         ,rate_last_week
)
    VALUES
        ( b.etl_dt
         ,b.index_no
         ,b.index_name
         ,b.org_no
         ,b.org_name
         ,b.super_org_no
         ,b.org_sort
         ,b.curr_no
         ,b.curr_name
         ,b.index_value
         ,b.accu_index_value_m
         ,b.accu_index_value_y
         ,b.rate_up_day
         ,b.rate_last_month
         ,b.rate_last_year
         ,b.rate_last_period
         ,b.rate_up_day_per
         ,b.rate_last_month_per
         ,b.rate_last_year_per
         ,b.rate_last_period_per
         ,b.index_ranking
         ,b.index_ranking_cha
         ,b.index_value_avg
         ,b.index_value_limit
         ,b.ratio_index
         ,b.ratio_org
         ,b.unit
         ,b.frequency
         ,b.measure_no
         ,b.source_sys
         ,b.index_measure
         ,b.etl_timestamp
         ,b.rate_last_quater
         ,b.rate_last_quater_per
         ,b.supervision_require
         ,b.limit_value
         ,b.prewarning_value
         ,b.intrv_type
         ,b.rate_last_week);
COMMIT;

--第四组 插入目标表
alter table ${idl_schema}.mc_index_fact exchange subpartition p_${batch_date}_edw_zz with table ${idl_schema}.mc_index_fact_edw_temp01 ;
commit;	  
--alter index fact_all_index rebuild online;
whenever sqlerror continue none;
drop table ${idl_schema}.mc_index_fact_edw_temp01 purge ;
drop table ${idl_schema}.mc_index_fact_edw_temp02 purge ;
drop table ${idl_schema}.mc_index_fact_edw_temp03 purge ;
drop table ${idl_schema}.rrps_index_data_tmp01 purge ;

-- 3.1 gather table status
--exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact', degree => 8, cAScade => true);