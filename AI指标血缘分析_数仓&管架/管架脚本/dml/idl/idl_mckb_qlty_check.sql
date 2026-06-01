/*
Purpose:    客户经理放款看板T+1:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_cust_mgr_distr
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_cust_mgr_distr
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
drop table ${idl_schema}.mckb_cust_mgr_distr_tmp_01 purge ;
drop table ${idl_schema}.mckb_cust_mgr_distr_tmp_02 purge ;

alter table ${idl_schema}.mckb_cust_mgr_distr add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_cust_mgr_distr_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_distr
where 1=2 ;
create table  ${idl_schema}.mckb_cust_mgr_distr_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_distr
where 1=2 ;

-- 2.1 insert into table
INSERT /*+ append */
INTO ${idl_schema}.mckb_cust_mgr_distr_tmp_01
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
               to_date('${batch_date}','yyyymmdd') as etl_dt
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
			   and putoutdate <= to_date('${batch_date}','yyyymmdd')
         group by bd.inputorgid,bd.inputuserid

         union all
         --日
         select 
               to_date('${batch_date}','yyyymmdd') as etl_dt
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
               to_date('${batch_date}','yyyymmdd') as etl_dt
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
               to_date('${batch_date}','yyyymmdd') as etl_dt
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
               to_date('${batch_date}','yyyymmdd') as etl_dt
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
         select to_date('${batch_date}','yyyymmdd') as etl_dt
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
          where bd.putoutdate <= to_date('${batch_date}', 'yyyymmdd')
          group by bd.inputorgid,bd.inputuserid

         union all
        --日
           select to_date('${batch_date}','yyyymmdd') as etl_dt
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
           select to_date('${batch_date}','yyyymmdd') as etl_dt
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
           select to_date('${batch_date}','yyyymmdd') as etl_dt
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
           select to_date('${batch_date}','yyyymmdd') as etl_dt
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
INTO ${idl_schema}.mckb_cust_mgr_distr_tmp_01
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
           from mckb_cust_mgr_distr_tmp_01 t1
           group by t1.ped_no,t1.ped_name,t1.etl_dt,t1.org_no,t1.mgr_no;
     commit;
     INSERT /*+ append */
INTO ${idl_schema}.mckb_cust_mgr_distr_tmp_02
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
     SELECT to_date('${batch_date}', 'yyyymmdd') etl_dt --数据日期
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
      FROM  mckb_cust_mgr_distr_tmp_01 t1
      LEFT JOIN mtl_cmm_intnal_org_info t2
      ON     t2.org_id=t1.org_no
	  	AND  t2.etl_dt=to_date('${batch_date}', 'yyyymmdd')
      LEFT JOIN mtl_pty_emply t3 
	  ON     t3.emply_id=t1.mgr_no
	    AND  t3.etl_dt=to_date('${batch_date}', 'yyyymmdd');
COMMIT;

--只展示前十名
--delete mckb_cust_mgr_distr_tmp_02 where rank>10;
--COMMIT;

-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.mckb_cust_mgr_distr truncate partition p_${batch_date} reuse storage;

-- 3.3 exchage tm table and target table
alter table ${idl_schema}.mckb_cust_mgr_distr exchange partition p_${batch_date} with table mckb_cust_mgr_distr_tmp_02;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.mckb_cust_mgr_distr to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.mckb_cust_mgr_distr_tmp_01 purge ;
drop table ${idl_schema}.mckb_cust_mgr_distr_tmp_02 purge ;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mckb_cust_mgr_distr', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

           
            
