/*
Purpose:    共性加工层-信贷风险评级信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_crdt_risk_rating_info
Createdate: 20190729
Logs:       20220416 翟若平 新增模型
            20220512 温旺清 1、由原先的八组合并成两组；
			                2、取数数据源调整，由对公信贷、零售信贷、网贷平台调整为综合信贷系统
            20220916 温旺清 调整【人工调整原因描述、自动评级标志】加工逻辑，增加零售信贷的风险分类调整原因                          
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_crdt_risk_rating_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_crdt_risk_rating_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_crdt_risk_rating_info_ex purge;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_crdt_risk_rating_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_crdt_risk_rating_info where 0=1
;
commit;



-- 第一组 对公信贷系统借据（对公信贷和微贷）十级分类（共二组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_crdt_risk_rating_info_ex(
    etl_dt                            --数据日期
    ,lp_id                            --法人编号
    ,dubil_id                         --借据编号
    ,cont_id                          --合同编号
    ,cust_id                          --客户编号
    ,rating_cate_cd                   --评级类别代码
    ,rating_rest_cd                   --评级结果代码
    ,auto_rating_flg                  --自动评级标志
    ,rating_dt                        --评级日期
    ,mgmt_org_id                      --管理机构编号
    ,mgmt_clerk_id                    --管理行员编号
    ,apv_clerk_id                     --审批行员编号
    ,oper_teller_id                   --经办柜员编号
    ,rgst_teller_id                   --登记柜员编号
    ,update_teller_id                 --更新柜员编号
    ,manu_adj_rs_descb                --人工调整原因描述
    ,job_cd                           --任务代码
    ,etl_timestamp                    --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                                          --数据日期      
    ,t1.lp_id                                                                    --法人编号 
    ,t1.dubil_id                                                                 --借据编号
    ,t1.rela_cont_id                                                             --合同编号
    ,t1.cust_id                                                                  --客户编号
    ,'3'                                                                         --评级类别代码
    ,nvl(trim(t1.level11_cls_cd), '99')                                          --评级结果代码
    ,case when t1.level10_cls_manu_med_flg in('1','0')     
          then t1.level10_cls_manu_med_flg
          else (case when trim(t2.remark1) is not null then '1' else '0' end)
      end   		--自动评级标志      
    ,case when t1.level5_cls_dt=to_date('29991231', 'yyyymmdd') then t1.distr_dt
          else t1.level5_cls_dt end                                              -- 评级日期
    ,nvl(trim(t3.lon_post_mgmt_org_id),t1.oper_org_id)                           -- 管理机构编号  
    ,case when t1.prod_id = '202010200003' then ''
          when nvl(trim(t3.lon_post_mgmt_teller_id), trim(t1.bus_oper_teller_id)) is not null then nvl(trim(t3.lon_post_mgmt_teller_id), trim(t1.bus_oper_teller_id))
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else ''
      end as mgmt_org_id                                                         -- 管理行员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as apv_clerk_id                                                        -- 审批行员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as oper_teller_id                                                      -- 经办柜员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as rgst_teller_id                                                      -- 登记柜员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as update_teller_id                                                    -- 更新柜员编号
    ,nvl(trim(t2.remark1),t4.adjustreason)                                       -- 人工调整原因描述
     ,t1.job_cd                                                                  -- 任务代码
    ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')              -- etl处理时间戳
from ${iml_schema}.agt_loan_dubil_info_h t1	
left join(select cr.objectno,
                 ca.remark1,
                 ca.inputuserid,
                 ft.endtime,
                 row_number() over(partition by cr.objectno order by ft.endtime desc) rn
            from ${iol_schema}.icms_classify_relative cr,
                 ${iol_schema}.icms_classify_apply    ca,
                 ${iol_schema}.icms_flow_object       fo,
                 ${iol_schema}.icms_flow_task         ft				 
           where cr.objecttype = 'BusinessContract'
             and cr.serialno = ca.serialno
             and fo.objectno = ca.serialno
             and fo.phaseno = '1000'
             and fo.objectno = ft.objectno
             and fo.objecttype = ft.objecttype
             and fo.flowno in ('HXTYAdjustFlow', 'RectifyClassifyFlow', 'ClassifyFlow1')
             and ca.serialno = fo.objectno
             and ca.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and ca.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and fo.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and fo.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and ft.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and ft.end_dt > to_date('${batch_date}', 'yyyymmdd')) t2
   on t1.rela_cont_id = t2.objectno
  and t2.rn = 1
 left join ${iml_schema}.agt_loan_cont_info_h	t3
   on t1.rela_cont_id=t3.cont_id
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'icmsf1'
 left join (select t.objectno,
                   t.adjustreason,
                   row_number() over(partition by t.objectno order by t.ADJUSTDATE desc) as rn 
              from ${iol_schema}.icms_classify_adjust t
			   where t.start_dt <= to_date('${batch_date}','yyyymmdd')
               and t.end_dt > to_date('${batch_date}','yyyymmdd')
			   and trim(t.adjustreason) is not null --筛选测试数据
			   ) t4
   on t1.dubil_id = t4.objectno
  and t4.rn = 1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'icmsf1'
;
commit;


-- 第二组 对公信贷系统借据（对公信贷和微贷）五级分类（共二组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_crdt_risk_rating_info_ex(
    etl_dt                            --数据日期
    ,lp_id                            --法人编号
    ,dubil_id                         --借据编号
    ,cont_id                          --合同编号
    ,cust_id                          --客户编号
    ,rating_cate_cd                   --评级类别代码
    ,rating_rest_cd                   --评级结果代码
    ,auto_rating_flg                  --自动评级标志
    ,rating_dt                        --评级日期
    ,mgmt_org_id                      --管理机构编号
    ,mgmt_clerk_id                    --管理行员编号
    ,apv_clerk_id                     --审批行员编号
    ,oper_teller_id                   --经办柜员编号
    ,rgst_teller_id                   --登记柜员编号
    ,update_teller_id                 --更新柜员编号
    ,manu_adj_rs_descb                --人工调整原因描述
    ,job_cd                           --任务代码
    ,etl_timestamp                    --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                                         --数据日期      
    ,t1.lp_id                                                                   --法人编号 
    ,t1.dubil_id                                                                --借据编号
    ,t1.rela_cont_id                                                            --合同编号
    ,t1.cust_id                                                                 --客户编号
    ,'2'                                                                        --评级类别代码
    ,nvl(trim(t1.level5_cls_cd), '99')                                          --评级结果代码
    ,case when t1.level10_cls_manu_med_flg in('1','0')     
          then t1.level10_cls_manu_med_flg
          else (case when trim(t2.remark1) is not null then '1' else '0' end)
      end   		                                                                  -- 自动评级标志    
   ,case when t1.level5_cls_dt = to_date('29991231', 'yyyymmdd') then t1.distr_dt
        else t1.level5_cls_dt end                                                 -- 评级日期
   ,nvl(trim(t3.lon_post_mgmt_org_id),t1.oper_org_id)                             -- 管理机构编号  
   ,case when t1.prod_id = '202010200003' then ''
          when nvl(trim(t3.lon_post_mgmt_teller_id), trim(t1.bus_oper_teller_id)) is not null then nvl(trim(t3.lon_post_mgmt_teller_id), trim(t1.bus_oper_teller_id))
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else ''
      end as mgmt_org_id                                                         -- 管理行员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as apv_clerk_id                                                        -- 审批行员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as oper_teller_id                                                      -- 经办柜员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as rgst_teller_id                                                      -- 登记柜员编号
    ,case when t1.prod_id = '202010200003' then ''
          when trim(t2.remark1) is not null and trim(t2.inputuserid) is not null then t2.inputuserid
          when t1.move_remark = 'ILS-3G001-wl_loan_iou' then '00200423'
          else '' 
      end as update_teller_id                                                    -- 更新柜员编号
   ,nvl(trim(t2.remark1),t4.adjustreason)                                        -- 人工调整原因描述
    ,t1.job_cd                                                                   -- 任务代码
    ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')              -- etl处理时间戳
from ${iml_schema}.agt_loan_dubil_info_h t1	
left join(select cr.objectno,
                 ca.remark1,
                 ca.inputuserid,
                 ft.endtime,
                 row_number() over(partition by cr.objectno order by ft.endtime desc) rn
            from ${iol_schema}.icms_classify_relative cr,
                 ${iol_schema}.icms_classify_apply    ca,
                 ${iol_schema}.icms_flow_object       fo,
                 ${iol_schema}.icms_flow_task         ft
           where cr.objecttype = 'BusinessContract'
             and cr.serialno = ca.serialno
             and fo.objectno = ca.serialno
             and fo.phaseno = '1000'
             and fo.objectno = ft.objectno
             and fo.objecttype = ft.objecttype
             and fo.flowno in ('HXTYAdjustFlow', 'RectifyClassifyFlow', 'ClassifyFlow1')
             and ca.serialno = fo.objectno
             and ca.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and ca.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and fo.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and fo.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and ft.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and ft.end_dt > to_date('${batch_date}', 'yyyymmdd')) t2
  on t1.rela_cont_id = t2.objectno
 and t2.rn = 1
 left join ${iml_schema}.agt_loan_cont_info_h	t3
   on t1.rela_cont_id=t3.cont_id
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'icmsf1'
 left join (select t.objectno,
                   t.adjustreason,
                   row_number() over(partition by t.objectno order by t.ADJUSTDATE desc) as rn 
              from ${iol_schema}.icms_classify_adjust t
			   where t.start_dt <= to_date('${batch_date}','yyyymmdd')
               and t.end_dt > to_date('${batch_date}','yyyymmdd')
			   and trim(t.adjustreason) is not null --筛选测试数据
			   ) t4
   on t1.dubil_id = t4.objectno
  and t4.rn = 1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'icmsf1';
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_crdt_risk_rating_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_crdt_risk_rating_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_crdt_risk_rating_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_crdt_risk_rating_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
