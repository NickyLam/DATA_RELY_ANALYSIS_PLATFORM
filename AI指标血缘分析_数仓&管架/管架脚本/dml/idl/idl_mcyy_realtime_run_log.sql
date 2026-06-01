/*
purpose:    手动生成准实时跑数日志d层-准实时跑数计划日志表
author:     sunline/郑沛隆
usage:      由etl调度配置，每天凌晨0点自动调起运行1次  python $etl_home/script/main.py yyyymmdd idl_mcyy_realtime_run_log
createdate: 20210112
logs:

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;

--alter table ${idl_schema}.mcyy_realtime_run_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 truncate timeout tables
whenever sqlerror continue none ;
--清空计划日志表
truncate table ${idl_schema}.mcyy_realtime_run_log ;

--清空业务分析实时表
truncate table ${idl_schema}.mcyy_bu_analysis_realtime ;

--人员及风险分析实时表
truncate table ${idl_schema}.mcyy_human_risk_realtime ;


set serveroutput  on 

declare
  v_curr_id number(4);          --日志编号
  v_sum_frequency number(4);    --频率
  v_curr_start_time timestamp(6);--统计开始时点
  v_curr_end_time timestamp(6);--统计结束时点
  v_tomorrow_time timestamp(6);--明天时点  
  
  cursor cur_result is  --获取【准实时跑数配置表】中每天需要生成跑批计划的指标
    select cfg_id,cfg_desc,index_no,index_name,sum_frequency
      from ${idl_schema}.mcyy_realtime_conf
     where sts=1
       and val_time<sysdate
       and exp_time>sysdate;
begin  
  for rec_result in cur_result loop
    
    v_curr_start_time:=to_date('${batch_date}'||' 00:00:00','yyyymmdd hh24:mi:ss');--当前
    v_tomorrow_time:=to_date('${batch_date}'||' 00:00:00','yyyymmdd hh24:mi:ss')+1;--明天
    v_curr_id := 1 ;
    
    while v_curr_start_time < v_tomorrow_time loop  --小于明天的00:00就继续循环按频率生成每一条计划
    
      v_curr_end_time:=v_curr_start_time + rec_result.sum_frequency /(24*60);--从统计开始时间加上频率得到结束时间
       
      insert into mcyy_realtime_run_log(
         etl_dt
        ,log_id
        ,cfg_id
        ,cfg_desc
        ,index_no
        ,index_name
        ,sum_frequency
        ,sum_start_time
        ,sum_end_time
        ,sum_count
        ,run_sts
        ,start_time
        ,end_time
        ,remark)
        values(
        to_date('${batch_date}','yyyymmdd')
        ,'${batch_date}'||rec_result.index_no||substr(to_char(10000+v_curr_id),2)  --生成序号
        ,rec_result.cfg_id
        ,rec_result.cfg_desc
        ,rec_result.index_no
        ,rec_result.index_name
        ,rec_result.sum_frequency
        ,to_char(v_curr_start_time,'yyyymmdd  hh24:mi:ss')
        ,to_char(v_curr_end_time,'yyyymmdd  hh24:mi:ss')
        ,0
        ,0
        ,null
        ,null
        ,''
        );      
      commit;
      v_curr_start_time := v_curr_end_time; --把结束时间作为下次的开始时间
      v_curr_id := v_curr_id +1 ; --递增
    end loop;    
  end loop;
  
exception
  when others then
    rollback;
    dbms_output.put_line('生成准实时跑数日志出错' || sqlerrm);


end;
/
