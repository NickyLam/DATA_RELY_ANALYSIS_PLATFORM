/*
purpose:    共性加工层-联合网贷申请信息：包括所有联合贷款业务的申请信息，包含花呗、借呗、网商贷、微粒贷、京东贷、借呗三期等产品的申请数据。数据来源于综合信贷管理系统ICMS。
author:     sunline
usage:      python $ETL_HOME/script/main.py 20230512 icl_cmm_unite_wl_appl_info
createdate: 20200326
logs:       20250219 谢  宁 增加微业贷产品
            20250730 陈伟峰 新增乐分期
            20251222 陈伟峰 新增对公微业贷203050100002

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;



-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_appl_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_appl_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_unite_wl_appl_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_appl_info_ex purge;

-- 2.1 create temporary table cmm_unite_wl_appl_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_appl_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_unite_wl_appl_info where 0=1;

-- 2.2 insert into data to temporary table cmm_unite_wl_appl_info_ex

----第一组（共二组） 微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_appl_info_ex(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,loan_appl_flow_num             -- 贷款申请流水号
       ,partner_appl_flow_num          -- 合作方申请流水号
       ,prod_id                        -- 产品编号
       ,prod_name                      -- 产品名称
       ,belong_org_id                  -- 所属机构编号
       ,cust_id                        -- 客户编号
       ,cust_name                      -- 客户姓名
       ,cert_type_cd                   -- 证件类型代码
       ,cert_id                        -- 证件编号
       ,cont_num                       -- 联系号码
       ,hxb_blklist_flg                -- 我行黑名单标志
       ,crdtc_que_flg                  -- 征信查询标志
       ,score_val                      -- 评分分值
       ,anti_fraud_check_flg           -- 反欺诈校验标志
       ,solv_rating_flg                -- 偿债能力评级标志
       ,partner_apv_rest_flg           -- 合作方审批结果
       ,other_acp_lmt_flg              -- 其他花呗额度标志
       ,appl_dt                        -- 申请日期
       ,appl_amt                       -- 申请金额
       ,apv_start_tm                   -- 审批开始时间
       ,apv_status_cd                  -- 审批状态代码
       ,apv_amt                        -- 审批金额
       ,apv_end_tm                     -- 审批结束时间
       ,final_jud_end_tm               -- 终审结束时间
       ,advise_sucs_flg                -- 通知成功标志
       ,refuse_rs                      -- 拒绝原因
       ,rela_appl_flow_num             -- 关联申请流水号
       ,custs_mang_lab_pbc_cali        -- 客群经营标签_人行口径
       ,custs_mang_lab_bank_supv_cali  -- 客群经营标签_银监口径
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,substr(t1.appl_id,7)                                             -- 业务流水号
       ,t1.out_acct_flow_num                                             -- 合作方申请编号
       ,t1.prod_id                                                       -- 产品编号
       ,case when length(t2.prod_id)=1 then t2.prod_gen_name
             when length(t2.prod_id)=3 then t2.prod_sclass_name
             when length(t2.prod_id)=5 then t2.prod_group_name
             when length(t2.prod_id)=7 then t2.base_prod_name
        else t2.sellbl_prod_name end                                     -- 产品名称
       ,t1.rgst_belong_org_id                                            -- 所属机构编号
       ,t1.cust_id                                                       -- 客户编号
       ,t1.cust_name                                                     -- 客户姓名
       ,'2313'                                                           -- 证件类型代码
       ,t1.bus_lics_id                                                   -- 证件编号
       ,t1.tel_num                                                       -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,replace(t1.crdtc_rest_cd,'-','')                                 -- 征信查询标志
       ,to_number(decode(t1.intnal_rating_cd,'-',null,'',null,' ',null,t1.intnal_rating_cd)) -- 评分分值
       ,''                                                               -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,''                                                               -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.appl_tm                                                       -- 申请日期
       ,t1.cont_amt                                                      -- 申请金额
       ,t1.lp_crdtc_auth_sign_dt                                         -- 审批开始时间
       ,'Finished'                                                       -- 审批状态代码
       ,nvl(t1.cont_amt,0)                                               -- 审批金额
       ,null                                                             -- 审批结束时间
       ,t1.precon_distr_dt                                               -- 终审结束时间
       ,''                                                               -- 通知成功标志
       ,''                                                               -- 拒绝原因
       ,t1.out_acct_flow_num                                             -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_wyd_out_acct_appl t1
left join ${iml_schema}.prd_prod_catlg_h t2
  on t1.prod_id = t2.prod_id 
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'ncbsf1'
where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.tran_status_cd = '1' --放款成功
  and t1.prod_id in ('201020100063','203050100002') --微业贷3.0\对公微业贷
  ;
  commit;



--20251223 补充微业贷3.0
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_appl_info_ex(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,loan_appl_flow_num             -- 贷款申请流水号
       ,partner_appl_flow_num          -- 合作方申请流水号
       ,prod_id                        -- 产品编号
       ,prod_name                      -- 产品名称
       ,belong_org_id                  -- 所属机构编号
       ,cust_id                        -- 客户编号
       ,cust_name                      -- 客户姓名
       ,cert_type_cd                   -- 证件类型代码
       ,cert_id                        -- 证件编号
       ,cont_num                       -- 联系号码
       ,hxb_blklist_flg                -- 我行黑名单标志
       ,crdtc_que_flg                  -- 征信查询标志
       ,score_val                      -- 评分分值
       ,anti_fraud_check_flg           -- 反欺诈校验标志
       ,solv_rating_flg                -- 偿债能力评级标志
       ,partner_apv_rest_flg           -- 合作方审批结果
       ,other_acp_lmt_flg              -- 其他花呗额度标志
       ,appl_dt                        -- 申请日期
       ,appl_amt                       -- 申请金额
       ,apv_start_tm                   -- 审批开始时间
       ,apv_status_cd                  -- 审批状态代码
       ,apv_amt                        -- 审批金额
       ,apv_end_tm                     -- 审批结束时间
       ,final_jud_end_tm               -- 终审结束时间
       ,advise_sucs_flg                -- 通知成功标志
       ,refuse_rs                      -- 拒绝原因
       ,rela_appl_flow_num             -- 关联申请流水号
       ,custs_mang_lab_pbc_cali        -- 客群经营标签_人行口径
       ,custs_mang_lab_bank_supv_cali  -- 客群经营标签_银监口径
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,'9999'                                                         -- 法人编号
       ,t1.serialno                                             -- 业务流水号
       ,t1.applseqnum                                             -- 合作方申请编号
       ,t3.prod_id                                                       -- 产品编号
       ,case when length(t2.prod_id)=1 then t2.prod_gen_name
             when length(t2.prod_id)=3 then t2.prod_sclass_name
             when length(t2.prod_id)=5 then t2.prod_group_name
             when length(t2.prod_id)=7 then t2.base_prod_name
        else t2.sellbl_prod_name end                                     -- 产品名称
       ,''                                            -- 所属机构编号
       ,t1.customerid                                                       -- 客户编号
       ,t1.lpname                                                     -- 客户姓名
       ,'2313'                                                           -- 证件类型代码
       ,t1.csldsocicrdtid                                                   -- 证件编号
       ,t1.certcephnum                                                       -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,''                                                               -- 征信查询标志
       ,''                                                                -- 评分分值
       ,''                                                               -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,''                                                               -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t3.rgst_dt                                                       -- 申请日期
       ,t1.contramt                                                      -- 申请金额
       ,''                                                                -- 审批开始时间
       ,'Finished'                                                        -- 审批状态代码
       ,t1.contramt                                                     -- 审批金额
       ,''                                                             -- 审批结束时间
       ,''                                                                -- 终审结束时间
       ,''                                                               -- 通知成功标志
       ,''                                                               -- 拒绝原因
       ,t1.applseqnum                                                 -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,'icmsf1'                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iol_schema}.icms_wyd_with_drawal t1
 inner join  ${iml_schema}.agt_wyd_dubil_h t3
     on  t3.out_acct_flow_num=t1.applseqnum
   and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.prd_prod_catlg_h t2
  on t3.prod_id = t2.prod_id 
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'ncbsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t1.end_dt > to_date('${batch_date}', 'yyyymmdd');
commit;




--第二组（共二组） 分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_appl_info_ex(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,loan_appl_flow_num             -- 贷款申请流水号
       ,partner_appl_flow_num          -- 合作方申请流水号
       ,prod_id                        -- 产品编号
       ,prod_name                      -- 产品名称
       ,belong_org_id                  -- 所属机构编号
       ,cust_id                        -- 客户编号
       ,cust_name                      -- 客户姓名
       ,cert_type_cd                   -- 证件类型代码
       ,cert_id                        -- 证件编号
       ,cont_num                       -- 联系号码
       ,hxb_blklist_flg                -- 我行黑名单标志
       ,crdtc_que_flg                  -- 征信查询标志
       ,score_val                      -- 评分分值
       ,anti_fraud_check_flg           -- 反欺诈校验标志
       ,solv_rating_flg                -- 偿债能力评级标志
       ,partner_apv_rest_flg           -- 合作方审批结果
       ,other_acp_lmt_flg              -- 其他花呗额度标志
       ,appl_dt                        -- 申请日期
       ,appl_amt                       -- 申请金额
       ,apv_start_tm                   -- 审批开始时间
       ,apv_status_cd                  -- 审批状态代码
       ,apv_amt                        -- 审批金额
       ,apv_end_tm                     -- 审批结束时间
       ,final_jud_end_tm               -- 终审结束时间
       ,advise_sucs_flg                -- 通知成功标志
       ,refuse_rs                      -- 拒绝原因
       ,rela_appl_flow_num             -- 关联申请流水号
       ,custs_mang_lab_pbc_cali        -- 客群经营标签_人行口径
       ,custs_mang_lab_bank_supv_cali  -- 客群经营标签_银监口径
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select        
       to_date('${batch_date}','yyyymmdd')                                   -- 数据日期
       ,t1.lp_id                                                                -- 法人编号
       ,t1.appl_flow_num                                                        --业务流水号
       ,t1.src_appl_flow_num                                                    --合作方申请编号
       ,t1.prod_id                                                              --产品编号
       ,t2.sellbl_prod_name                                                     --产品名称
       ,t1.rgst_org_id                                                          --所属机构编号
       ,t1.cust_id                                                              --客户编号
       ,t1.cust_name                                                            --客户姓名
       ,t1.cert_type_cd                                                         --证件类型代码
       ,t1.cert_no                                                              --证件编号
       ,t1.mobile_no                                                            --联系号码
       ,'-'                                                                     --我行黑名单标志
       ,'-'                                                                     --征信查询标志
       ,''                                                                      --评分分值
       ,'-'                                                                     --反欺诈校验标志
       ,'-'                                                                     --偿债能力评级标志
       ,''                                                                      --合作方审批结果
       ,'-'                                                                     --其他花呗额度标志
       ,t1.rgst_dt                                                              --申请日期
       ,t1.appl_lmt                                                             --申请金额
       ,t1.rgst_dt                                                              --审批开始时间
       ,t1.appl_status_cd                                                       --审批状态代码
       ,t1.final_jud_apv_lmt                                                    --审批金额
       ,t1.apv_cmplt_dt                                                         --审批结束时间
       ,t1.apv_cmplt_dt                                                         --终审结束时间
       ,'-'                                                                     --通知成功标志
       ,t1.risk_mgmt_remark                                                     --拒绝原因
       ,t1.appl_flow_num                                                        --关联申请流水号
       ,''                                                                      --客群经营标签_人行口径
       ,''                                                                      --客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_lx_crdt_appl t1
left join ${iml_schema}.prd_prod_catlg_h t2
  on t1.prod_id = t2.prod_id 
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'ncbsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t1.job_cd = 'icmsf1'
 ;
commit;

delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_appl_info_morning';
commit;
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_icl_batch_jnl(
    etl_dt	                           -- 数据日期
   ,tab_name                           -- 表名
	 ,batch_status                       -- 跑批状态
	 ,batch_tm                           -- 跑批时间
	 ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_appl_info_morning'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_appl_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_appl_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_appl_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_appl_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);