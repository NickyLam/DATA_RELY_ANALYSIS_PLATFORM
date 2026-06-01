/*
Purpose:    客户经理放款看板准实时:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔15分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_cust_mgr_distr_realtime
-- 以下为依赖了上游的表 (OGG实时表):
msl_icms_business_duebill
msl_icms_hqd_ipc_legalperson_app
msl_icms_business_approve
msl_icms_business_contract
*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01 purge ;
drop table ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_02 purge ;

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_distr_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_distr_realtime
where 1=2 ;

set serveroutput on 
DECLARE

	CURSOR  CUR_RUN_LOGS IS 
	SELECT log_id
      ,index_no
      ,sum_start_time
      ,sum_end_time
      ,(CASE
           WHEN run_sts = '1' THEN
            '补跑'
           ELSE
            '正常'
       END) AS run_flag --批次类型判断
FROM   mcyy_realtime_run_log
WHERE  etl_dt = to_date('${batch_date}' ,'yyyymmdd')
AND    ((run_sts = 0) --正常批次                     
      OR run_sts = 1 AND to_char(SYSDATE,'HH24MI') -
      to_char(start_time,'HH24MI') >= 15) --补跑批次
AND    to_date(sum_end_time,'yyyy-mm-dd hh24:mi:ss') <= SYSDATE
AND    index_no ='MCKB_CUST_MGR_DISTR_REALTIME'
ORDER  BY sum_end_time,index_no;

BEGIN
       FOR REC_RUN_LOGS IN CUR_RUN_LOGS LOOP

-- 1.1 update log table
UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1:运行中
SET    run_sts = 1, start_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND    index_no ='MCKB_CUST_MGR_DISTR_REALTIME';
 
COMMIT;
delete mckb_cust_mgr_distr_realtime_tmp_01;
commit;
-- 2.1 insert into realtime table
INSERT /*+ append */
INTO ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01
    (etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    --,grouping --分组
    ,org_no --机构编号
    --,org_name --机构名称
	,mgr_no --客户经理编号
    ,distr_amt --放款金额
    --,acvmnt_data_target --业绩数据目标
    --,acvmnt_data_arrive_rat --业绩数据达成率
    ,lp_cls_id --法人分类编号
    ,lp_cls_name --法人分类名称
    --,etl_timestamp --etl处理时间戳
     )
     --累计
        select 
               rec_run_logs.sum_end_time as etl_dt
               ,'099' as ped_no
               ,'累计' as ped_name
               ,bd.inputorgid as org_no
			   ,bd.inputuserid as mgr_no
               ,sum(bd.businesssum) as distr_amt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
          from msl_icms_business_duebill bd
         where inputorgid is not null
               and productid = '201020100054'
         group by bd.inputorgid,bd.inputuserid
         union all
         --日
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'001' as ped_no
               ,'当日' as ped_name
               ,bd.inputorgid as org_no
			   ,bd.inputuserid as mgr_no               
			   ,sum(bd.businesssum) as distr_amt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
          from msl_icms_business_duebill bd
         where inputorgid is not null
               and productid = '201020100054'
               and putoutdate= to_date('${batch_date}','yyyymmdd')
         group by bd.inputorgid,bd.inputuserid
          union all
         --月
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'002' as ped_no
               ,'当月' as ped_name
               ,bd.inputorgid as org_no
			   ,bd.inputuserid as mgr_no              
               ,sum(bd.businesssum) as distr_amt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
          from msl_icms_business_duebill bd
         where inputorgid is not null
               and productid = '201020100054'
               and putoutdate>= to_date('${month_start}','yyyymmdd')
               and putoutdate<= to_date('${batch_date}','yyyymmdd')
         group by bd.inputorgid,bd.inputuserid
          union all
         --年
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'004' as ped_no
               ,'当年' as ped_name
			   ,bd.inputorgid as org_no
			   ,bd.inputuserid as mgr_no                          
			   ,sum(bd.businesssum) as distr_amt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
          from msl_icms_business_duebill bd
         where inputorgid is not null
               and productid = '201020100054'
               and putoutdate>= to_date('${year_start}','yyyymmdd')
               and putoutdate<= to_date('${batch_date}','yyyymmdd')
         group by bd.inputorgid,bd.inputuserid
		  union all
         --周
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'005' as ped_no
               ,'当周' as ped_name
               ,bd.inputorgid as org_no
			   ,bd.inputuserid as mgr_no           
               ,sum(bd.businesssum) as distr_amt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
          from msl_icms_business_duebill bd
         where inputorgid is not null
               and productid = '201020100054'
               and putoutdate>= to_date('${week_start}','yyyymmdd')
               and putoutdate<= to_date('${batch_date}','yyyymmdd')
         group by bd.inputorgid,bd.inputuserid
         union all
         --累计
         select rec_run_logs.sum_end_time as etl_dt
               ,'099' as ped_no
               ,'累计' as ped_name
               ,bd.inputorgid as org_no
			   ,bd.inputuserid as mgr_no    
               ,sum(bd.businesssum) as distr_amt
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
           from msl_icms_hqd_ipc_legalperson_app hila
           left join msl_icms_business_approve ba on ba.baserialno = hila.baserialno
           left join msl_icms_business_contract bc on bc.bapserialno = ba.serialno 
           inner join msl_icms_business_duebill bd on bd.contractserialno = bc.serialno
          where 1 = 1
         group by bd.inputorgid,bd.inputuserid
         union all
         --日
           select rec_run_logs.sum_end_time as etl_dt
                 ,'001' as ped_no
                 ,'当日' as ped_name
                 ,bd.inputorgid as org_no
			     ,bd.inputuserid as mgr_no    
                 ,sum(bd.businesssum) as distr_amt
                 ,'1' as lp_cls_id
                 ,'企业' as lp_cls_name
             from msl_icms_hqd_ipc_legalperson_app hila
             left join msl_icms_business_approve ba on ba.baserialno = hila.baserialno
             left join msl_icms_business_contract bc on bc.bapserialno = ba.serialno 
             inner join msl_icms_business_duebill bd on bd.contractserialno = bc.serialno
            where bd.putoutdate = to_date('${batch_date}', 'yyyymmdd')
         group by bd.inputorgid,bd.inputuserid
         union all
         --月
           select rec_run_logs.sum_end_time as etl_dt
                 ,'002' as ped_no
                 ,'当月' as ped_name
                 ,bd.inputorgid as org_no
			     ,bd.inputuserid as mgr_no    
                 ,sum(bd.businesssum) as distr_amt
                 ,'1' as lp_cls_id
                 ,'企业' as lp_cls_name
             from msl_icms_hqd_ipc_legalperson_app hila
             left join msl_icms_business_approve ba on ba.baserialno = hila.baserialno
             left join msl_icms_business_contract bc on bc.bapserialno = ba.serialno 
             inner join msl_icms_business_duebill bd on bd.contractserialno = bc.serialno
            where bd.putoutdate >= to_date('${month_start}', 'yyyymmdd')
                  and bd.putoutdate <= to_date('${batch_date}', 'yyyymmdd')
         group by bd.inputorgid,bd.inputuserid
         union all
         --年
           select rec_run_logs.sum_end_time as etl_dt
                 ,'004' as ped_no
                 ,'当年' as ped_name
                 ,bd.inputorgid as org_no
			     ,bd.inputuserid as mgr_no    
                 ,sum(bd.businesssum) as distr_amt
                 ,'1' as lp_cls_id
                 ,'企业' as lp_cls_name
             from msl_icms_hqd_ipc_legalperson_app hila
             left join msl_icms_business_approve ba on ba.baserialno = hila.baserialno
             left join msl_icms_business_contract bc on bc.bapserialno = ba.serialno 
             inner join msl_icms_business_duebill bd on bd.contractserialno = bc.serialno
            where bd.putoutdate >= to_date('${year_start}', 'yyyymmdd')
                  and bd.putoutdate <= to_date('${batch_date}', 'yyyymmdd')
           group by bd.inputorgid,bd.inputuserid
			 union all
         --周
           select rec_run_logs.sum_end_time as etl_dt
                 ,'005' as ped_no
                 ,'当周' as ped_name
                 ,bd.inputorgid as org_no
			     ,bd.inputuserid as mgr_no    
                 ,sum(bd.businesssum) as distr_amt
                 ,'1' as lp_cls_id
                 ,'企业' as lp_cls_name
             from msl_icms_hqd_ipc_legalperson_app hila
             left join msl_icms_business_approve ba on ba.baserialno = hila.baserialno
             left join msl_icms_business_contract bc on bc.bapserialno = ba.serialno 
             inner join msl_icms_business_duebill bd on bd.contractserialno = bc.serialno
            where bd.putoutdate >= to_date('${week_start}', 'yyyymmdd')
                  and bd.putoutdate <= to_date('${batch_date}', 'yyyymmdd')
           group by bd.inputorgid,bd.inputuserid;
      commit;
     INSERT /*+ append */
INTO ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01
    (etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    --,grouping --分组
    ,org_no --机构编号
	,mgr_no --客户经理编号
    --,org_name --机构名称
    ,distr_amt --放款金额
    --,acvmnt_data_target --业绩数据目标
    --,acvmnt_data_arrive_rat --业绩数据达成率
    ,lp_cls_id --法人分类编号
    ,lp_cls_name --法人分类名称
    --,etl_timestamp --etl处理时间戳
     )
      select 
                 t1.etl_dt as etl_dt
                 ,t1.ped_no as ped_no
                 ,t1.ped_name as ped_name
                 ,t1.org_no as org_no
				 ,t1.mgr_no as mgr_no
                 ,sum(t1.distr_amt) as distr_amt
                 ,'0' as lp_cls_id
                 ,'合计' as lp_cls_name
           from mckb_cust_mgr_distr_realtime_tmp_01 t1
           group by t1.ped_no,t1.ped_name,t1.etl_dt,t1.org_no,t1.mgr_no;
     commit;
delete mckb_cust_mgr_distr_realtime;
commit;
     INSERT /*+ append */
INTO ${idl_schema}.mckb_cust_mgr_distr_realtime
    (etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    ,rank --排名
    ,org_no --机构编号
    ,org_name --机构名称
	,mgr_no -- 客户经理编号
    ,mgr_name -- 客户经理名称
    ,distr_amt --放款金额
    --,acvmnt_data_target --业绩数据目标
    --,acvmnt_data_arrive_rat --业绩数据达成率
    ,lp_cls_id --法人分类编号
    ,lp_cls_name --法人分类名称
    ,etl_timestamp --etl处理时间戳
     )
     SELECT rec_run_logs.sum_end_time etl_dt --数据日期
            ,t1.ped_no --周期编号
            ,t1.ped_name --周期名称
            ,row_number() over(partition by t1.ped_no,t1.lp_cls_id order by t1.distr_amt desc) as rank --排名
            ,t1.org_no --机构编号
            ,t2.org_name --机构名称
			,t1.mgr_no --客户经理编号
			,t3.LAST_NAME||t3.FIRST_NAME  as mgr_name--客户经理名称
            ,nvl(t1.distr_amt,0) --放款金额
            ,t1.lp_cls_id --法人分类编号
            ,t1.lp_cls_name --法人分类名称
            ,sysdate --etl处理时间戳
      FROM  mckb_cust_mgr_distr_realtime_tmp_01 t1
      LEFT JOIN mtl_cmm_intnal_org_info t2
      ON     t2.org_id=t1.org_no
	  	AND  t2.etl_dt=to_date('${last_date}', 'yyyymmdd')
      LEFT JOIN mtl_pty_emply t3 
	  ON     t3.emply_id=t1.mgr_no
	    AND  t3.etl_dt=to_date('${last_date}', 'yyyymmdd');
COMMIT;
--只展示前十名
--delete mckb_cust_mgr_distr_realtime where rank>10;
--COMMIT;

-- 2.2 update log table 

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND   index_no ='MCKB_CUST_MGR_DISTR_REALTIME';

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mckb_cust_mgr_distr_realtime出错' || SQLERRM);
    
END;

/
           
            
