set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
-- python $ETL_HOME/script/main.py yyyymmdd idl_mc_index_fact_rwa
-- 以下为依赖了上游的表：
-- itl_edw_rwas_pb_report_data_arc
-- itl_edw_rwas_pb_report_approve
-- 以下为依赖的参数表
-- mc_index_define    -- 指标表清单

-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_index_fact add partition p_${last_month_end} values (to_date('${last_month_end}','yyyymmdd'))(
                                              subpartition p_${last_month_end}_edw_rwa values ('EDW-RWA'));
alter table ${idl_schema}.mc_index_fact modify partition p_${last_month_end} 
                                             add subpartition p_${last_month_end}_edw_rwa values ('EDW-RWA');

drop table ${idl_schema}.rwas_index_data_tmp01 purge ;
drop table ${idl_schema}.mc_index_fact_rwa_temp02 purge ;

whenever sqlerror exit sql.sqlcode; 
--用于清空之前风险集市、监管集市获取的指标数据
delete mc_index_fact where index_no in (
'FX01010000',
'FX01011000',
'FX01011100',
'FX01020000',
'FX01030000',
'FX01031000',
'FX01032000',
'FX01040000'
) and etl_dt=to_date('${last_month_end}','yyyymmdd')
  and etl_dt<=to_date('20250621','yyyymmdd');
commit;
alter table ${idl_schema}.mc_index_fact truncate subpartition p_${last_month_end}_edw_rwa; 

-- 2.1 insert data to table
--rwa来源指标临时表
create table  ${idl_schema}.mc_index_fact_rwa_temp02 compress
AS 
select * from ${idl_schema}.mc_index_fact
where 1=2 ;

--第一组 rwa
--将rwa结果表提取为临时表 
create table rwas_index_data_tmp01 
as
--基础指标
select c.index_no_mcs as index_no_mcs
      ,case
         when c.unit = '%' then
          to_number(a.item_c)
         else
          to_number(a.item_c) * 10000
       end as index_val
      ,a.data_date as data_date
  from itl_edw_rwas_pb_report_data_arc a --公共报表数据表-归档数据
  left join itl_edw_rwas_pb_report_data_arc b on a.data_date = b.data_date
                                                 and a.item_cd = b.item_cd
                                                 and b.version = '1'
                                                 and a.line_number = b.line_number
                                                 and b.etl_dt = a.etl_dt
 inner join mc_index_define c on c.source_system = '数仓-RWA'
                                 and b.item_cd = substr(c.index_no, 1, instr(c.index_no, '.') - 1)
                                 and b.line_number = substr(c.index_no, instr(c.index_no, '.', -1) + 1)
 where a.data_date = '${last_month_end}'
       and a.etl_dt = (case
         when to_date('${batch_date}', 'yyyymmdd') <= to_date('20250623', 'yyyymmdd') then
          to_date('20250623', 'yyyymmdd')
         else
          to_date('${batch_date}', 'yyyymmdd')
       end)
       and (a.version, a.item_cd) in (select max(version)
                                            ,item_cd
                                        from itl_edw_rwas_pb_report_approve --报表管理-报表版本及流程状态表
                                       where data_date = a.data_date
                                             and etl_dt = a.etl_dt
                                             and item_cd = a.item_cd
                                             and version_status in (3, 4)
                                       group by item_cd)
;
   
insert into  ${idl_schema}.mc_index_fact_rwa_temp02                                                                               
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
         ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0
               else  round((coalesce(t2.index_val,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6)
               end                            as RATE_UP_DAY_PER        --比上日百分比
         ,case when coalesce(t5.INDEX_VALUE ,0) =0 then 0
               else  round((coalesce(t2.index_val,0) - coalesce(t5.INDEX_VALUE,0)) / coalesce(t5.INDEX_VALUE,0),6)
               end                            as RATE_LAST_MONTH_PER    --比上月百分比
         ,case when coalesce(t6.INDEX_VALUE ,0) =0 then 0
               else round((coalesce(t2.index_val,0) - coalesce(t6.INDEX_VALUE,0)) / coalesce(t6.INDEX_VALUE,0) ,6)
               end                            as RATE_LAST_YEAR_PER     --比上年百分比                                                
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
         ,'EDW-RWA'                            AS SOURCE_SYS                                                
         ,'原始统计值'                        AS INDEX_MEASURE          --度量名称    
	       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp          --数据加载时间
        ,case when t1.UNIT='%' then round(coalesce(t2.index_val,0),4) - round(coalesce(t7.index_value,0),4) 
           else coalesce(t2.index_val,0) - coalesce(t7.index_value,0) end AS RATE_LAST_QUATER          --比上季
        ,0                                    AS RATE_LAST_QUATER_PER      --比上季百分比
    		,t8.supervision_require							  AS SUPERVISION_REQUIRE -- rwa要求
				,t8.limit_value							          AS LIMIT_VALUE  -- 限额值
				,t8.prewarning_value							    AS PREWARNING_VALUE  -- 预警值
				/* 以下是区间类型的业务判断口径,运算符优先取rwa要求再取限额
				≥： <限额值，红灯；[限额值，预警值]，黄灯；>预警值，绿灯 
				≤： >限额值，红灯；[预警值，限额值]，黄灯；<预警值，绿灯 
				*/
    		,case when trim(t8.limit_value) is not null and trim(t8.prewarning_value) is not null and 
    		    nvl(regexp_substr(t8.supervision_require,'[><]=?',1,1,'i'),regexp_substr(t8.limit_value,'[><]=?',1,1,'i')) is not null  --运算符必须有值才可以判断红黄绿灯
    		 then 
    		  case when nvl(regexp_substr(t8.supervision_require,'[><]=?',1,1,'i'),regexp_substr(t8.limit_value,'[><]=?',1,1,'i'))='>=' then
    		      (case when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t8.limit_value,'[^0-9.-]','')) then '03'  
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t8.limit_value,'[^0-9.-]',''))
                      and t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t8.prewarning_value,'[^0-9.-]','')) then '02'		      
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t8.prewarning_value,'[^0-9.-]','')) then '01'                                       
               end)
    		       when nvl(regexp_substr(t8.supervision_require,'[><]=?',1,1,'i'),regexp_substr(t8.limit_value,'[><]=?',1,1,'i'))='<=' then
    		       (case when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) > to_number(regexp_replace(t8.limit_value,'[^0-9.-]','')) then '03'  
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) <= to_number(regexp_replace(t8.limit_value,'[^0-9.-]',''))
                      and t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) >= to_number(regexp_replace(t8.prewarning_value,'[^0-9.-]','')) then '02'		      
    		            when t2.index_val/decode(t1.UNIT,'亿元',100000000,'%',0.01) < to_number(regexp_replace(t8.prewarning_value,'[^0-9.-]','')) then '01'                                       
               end)
    		  end 
    	   end AS INTRV_TYPE -- 区间类型
    		,case when t1.UNIT='%' then round(coalesce(t2.index_val,0),4) - round(coalesce(t9.index_value,0),4) 
             else coalesce(t2.index_val,0) - coalesce(t9.index_value,0) end AS RATE_LAST_WEEK      --比上周        
 from  mc_index_define t1
 inner  join  rwas_index_data_tmp01 t2
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
 left join  ${idl_schema}.mc_index_fact t8  --当日
       on trim(t1.index_no_mcs)  = trim(t8.index_no)  
      --and  t2.org_no = t8.org_no
      and  t8.etl_dt = to_date(t2.data_date,'yyyymmdd')
 left join  ${idl_schema}.mc_index_fact t9            --上周           
       on  trim(t1.index_no_mcs) = trim(t9.index_no)
      and  t9.etl_dt = trunc(to_date(t2.data_date,'yyyymmdd'), 'IW') -3;                                        
 commit;
 
alter table ${idl_schema}.mc_index_fact exchange subpartition p_${last_month_end}_edw_rwa with table ${idl_schema}.mc_index_fact_rwa_temp02 ;
commit;	  

alter index fact_all_index rebuild online;
whenever sqlerror continue none;
drop table ${idl_schema}.rwas_index_data_tmp01 purge ;
drop table ${idl_schema}.mc_index_fact_rwa_temp02 purge ;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact',partname => 'p_${last_month_end}_edw_rwa', granularity => 'SUBPARTITION', degree => 8, cascade => true);
