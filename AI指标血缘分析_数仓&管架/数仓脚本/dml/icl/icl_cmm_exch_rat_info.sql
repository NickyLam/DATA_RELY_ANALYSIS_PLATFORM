/*
Purpose:    共性加工层-汇率信息：折算汇率信息表，数据来源于新核心系统，数据需要初始化
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_exch_rat_info
CreateDate: 20220318
Logs:       20220714 翟若平 新增字段【钞买价、钞卖价、汇买价、汇卖价、换算单位】
            20220903 曹永茂 调整字段【中间价、基准价、钞买价、钞卖价、汇买价、汇卖价】的为100.
            20220906 曹永茂 调整t6的关联条件：t.exch_rat_type_cd = 'EER' -> t.exch_rat_type_cd = 'ZBD'
            20230519 陈伟峰 调整t6表关联条件，使用EFFECT_TM排序
            20240527 饶雅    新增字段 【汇率中间价】
            20240716 陈伟峰 优化节假日函数用法
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_exch_rat_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_exch_rat_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_exch_rat_info_ex purge;
drop table ${icl_schema}.cmm_exch_rat_info_01_tmp purge;

-- 2.1 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_exch_rat_info_ex nologging
compress
as select * from ${icl_schema}.cmm_exch_rat_info where 0=1;

create table ${icl_schema}.cmm_exch_rat_info_01_tmp nologging
compress
as select /*+ materialize */ ${icl_schema}.fn_get_before_holidays(to_date('${batch_date}', 'yyyymmdd')) dt 
from dual;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_exch_rat_info_ex(
       etl_dt            -- 数据日期
       ,lp_id            -- 法人编号
       ,curr_cd          -- 币种代码            
       ,curr_name        -- 币种名称
       ,mdl_price        -- 中间价
       ,exch_rat_mdl_price  -- 汇率中间价
       ,base_price       -- 基准价   
       ,cash_buy_price   -- 钞买价
       ,cash_sell_price  -- 钞卖价
       ,exch_buy_price   -- 汇买价
       ,exch_sell_price  -- 汇卖价
       ,convt_corp       -- 换算单位   
       ,cny_exch_rat     -- 折人民币汇率
       ,usd_exch_rat     -- 折美元汇率
       ,eur_exch_rat     -- 折欧元汇率
       ,job_cd           -- 任务代码
       ,etl_timestamp    -- 数据处理时间
)
select to_date('${batch_date}', 'yyyymmdd')                              -- 数据日期
       ,'9999'                                                           -- 法人编号
       ,t1.curr_cd                                                       -- 币种代码
       ,t2.cd_descb                                                      -- 币种名称   
       ,t6.exch_rat_mdl_price*100                                        -- 中间价
       ,t7.exch_rat_mdl_price*100                                        -- 汇率中间价
       ,t6.base_exch_rat*100                                             -- 基准价
       ,t6.fcurr_cash_buy_price*100                                      -- 钞买价
       ,t6.fcurr_cash_sell_price*100                                     -- 钞卖价
       ,t6.realtm_exch_rat_exch_buy_price*100                            -- 汇买价
       ,t6.realtm_exch_rat_exch_sell_price*100                           -- 汇卖价
       ,100                                                              -- 换算单位 
       ,t1.convt_cny_exch_rat                                            -- 折人民币汇率
       ,case when nvl(t3.convt_cny_exch_rat, 0) = 0 then 0               
             else t1.convt_cny_exch_rat / t3.convt_cny_exch_rat          
        end                                                              -- 折美元汇率
       ,case when nvl(t4.convt_cny_exch_rat, 0) = 0 then 0               
             else t1.convt_cny_exch_rat / t4.convt_cny_exch_rat          
        end                                                              -- 折欧元汇率
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.ref_cny_fori_exch_mdl_p_h t1
  left join ${iml_schema}.ref_curr_cd t2
    on t1.curr_cd = t2.cd_val
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t3
    on t3.curr_cd = 'USD'
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ncbsf1'
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t4
    on t4.curr_cd = 'EUR'
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ncbsf1'
    /*left join ${iml_schema}.ref_exch_rat_h t5
    on t1.curr_cd = t5.curr_cd
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'ncbsf1'
   and t5.id_mark = 'D'*/
  left join (select t.*,
                    row_number() over(partition by t.curr_cd order by t.effect_tm desc) as rn
               from ${iml_schema}.ref_exch_rat_quot_h t ,${icl_schema}.cmm_exch_rat_info_01_tmp holi
              where t.exch_rat_type_cd = 'ZBD'
                and t.quot_type_cd = 'D'
                and t.effect_dt <= holi.dt
                and t.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd') 
                and t.job_cd = 'ncbsf1') t6
    on t1.curr_cd = t6.curr_cd
   and t6.rn = 1
   left join (select t.*,
                    row_number() over(partition by t.curr_cd order by t.effect_tm desc) as rn
               from ${iml_schema}.ref_exch_rat_quot_h t ,${icl_schema}.cmm_exch_rat_info_01_tmp holi
              where t.exch_rat_type_cd = 'EER'
                and t.quot_type_cd = 'D'
                and t.effect_dt <= holi.dt
                and t.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd') 
                and t.job_cd = 'ncbsf1') t7
    on t1.curr_cd = t7.curr_cd
   and t7.rn = 1  
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsf1';
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_exch_rat_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_exch_rat_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_exch_rat_info_ex purge;
drop table ${icl_schema}.cmm_exch_rat_info_01_tmp purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_exch_rat_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
