/*
purpose:    共性加工层-联合网贷申请信息：包括所有联合贷款业务的申请信息，包含花呗、借呗、网商贷、微粒贷、京东贷、借呗三期等产品的申请数据。数据来源于综合信贷管理系统ICMS。
author:     sunline
usage:      python $ETL_HOME/script/main.py 20230512 ICL_CMM_UNITE_WL_APPL_INFO
createdate: 20200326
logs:       新增字段【关联申请流水号】
            20220428 李森辉 1、取数数据源调整，调整花呗、借呗、京东贷、网商贷的取数源，由旧零售信贷系统调整为综合信贷管理系统。微粒贷取数源保持不变。
                            2、调整第一组字段【产品名称】的取数逻辑；
                            3、【第五组借呗三期】合并到【第二组借呗】
            20220512 李森辉 1、新增第五组【蚂蚁借呗三期】的映射
                            2、新增字段【客群经营标签_人行口径、客群经营标签_银监口径】
            20230113 陈伟峰 调整【产品编号】加工逻辑
            20230131 陈伟峰 调整网商贷部分【证件类型代码、证件编号、联系号码】加工逻辑，关联回O层表取，申请失败部分的数据客户号是空的，不能关联M层证件表获取。
            20230511 陈伟峰 新增第七组-综合信贷微粒贷数据
	          20230912 陈伟峰 应急调整网商贷、蚂蚁借呗3期的审批状态代码，新增映射新增 111审批中-->Approving审批中,997通过-->Finished审批通过,998否决(不同意)-->Reject审批否决,991收回-->TakeBackTask主动收回
            20230914 陈伟峰 调整网商贷部分【证件类型代码、证件编号、联系号码】加工逻辑
	          20230925 陈伟峰 调整【审批状态代码】，引用CD2601
            20231010 陈伟峰 调整网商贷部分【证件类型代码、证件编号】加工逻辑,增加助贷来源
            20241028 谢  宁 增加完成状态表
            20250108 谢  宁 增加字节小微贷产品
		    20250109 陈伟峰 调整网商贷部分逻辑，过滤房抵贷数据
			20250219 谢  宁 增加微业贷产品
            20250513 陈伟峰 调整微业贷审批状态码值，默认为成功Finished
			20250513 谢  宁 增加唯品会合作贷产品
            20250730 陈伟峰 新增乐分期
            20251118 陈伟峰 调整中台微粒贷一组取数逻辑，去掉ETL_DT日期
                            调整中台、信贷微粒贷两组字段【申请日期】加工逻辑，使用审批日期APV_DT加工
            20251223 陈伟峰 补充微业贷3.0申请信息
            20260112 陈伟峰 新增富民联合网贷
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



--第一组（共十二组） 花呗
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
       ,t1.crdt_appl_id                                                  -- 业务流水号       
       ,t1.appl_flow_num                                                 -- 合作方申请编号     
       ,'202010100003'                                                   -- 产品编号        
       ,t1.prod_name                                                     -- 产品名称        
       ,'897001'                                                         -- 所属机构编号      
       ,t1.cust_id                                                       -- 客户编号        
       ,t1.cust_name                                                     -- 客户姓名        
       ,t1.cert_type_cd                                                  -- 证件类型代码      
       ,t1.cert_no                                                       -- 证件编号        
       ,t1.mobile_no                                                     -- 联系号码        
       ,decode(trim(t1.check_blklist_flg),1,1,0)                         -- 我行黑名单标志     
       ,t1.netw_vrfction_status_cd                                       -- 征信查询标志      
       ,''                                                               -- 评分分值        
       ,t1.check_anti_fraud_flg                                          -- 反欺诈校验标志     
       ,t1.solv_rating                                                   -- 偿债能力评级标志    
       ,t1.apv_rest_flg                                                  -- 合作方审批结果     
       ,t1.acp_lmt_flg                                                   -- 其他花呗额度标志    
       ,t1.appl_dt                                                       -- 申请日期        
       ,t1.crdt_lmt                                                      -- 申请金额        
       ,t1.apv_start_tm                                                  -- 审批开始时间      
       ,t2.appl_status_cd                                                -- 审批状态代码      
       ,t1.crdt_lmt                                                      -- 审批金额        
       ,t1.apv_end_tm                                                    -- 审批结束时间      
       ,t1.apv_end_tm                                                    -- 终审结束时间      
       ,t1.final_jud_advise_sucs_flg                                     -- 通知成功标志      
       ,t1.refuse_rs                                                     -- 拒绝原因
       ,t1.crdt_appl_id                                                  -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_acp_crdt_appl t1
  left join ${iml_schema}.agt_appl_status_h t2
    on t1.appl_id = t2.appl_id
   and t2.appl_status_type_cd = 'CD2601'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'myhbf1'
   and t2.id_mark <> 'D'    
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'myhbf1'
   and t1.id_mark <> 'D';
commit;

--第二组（共五组） 借呗
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
       ,t1.crdt_appl_id                                                  -- 业务流水号
       ,t2.appl_id                                                       -- 合作方申请编号
       ,'202010100001'                                                   -- 产品编号
       ,t1.prod_name                                                     -- 产品名称
       ,'897001'                                                         -- 所属机构编号
       ,t1.cust_id                                                       -- 客户编号
       ,t3.party_name                                                    -- 客户姓名
       ,t4.cert_type_cd                                                  -- 证件类型代码
       ,t4.cert_num                                                      -- 证件编号
       ,t5.elec_addr                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,t1.netw_vrfction_status_cd                                       -- 征信查询标志
       ,''                                                               -- 评分分值
       ,t1.check_anti_fraud_flg                                          -- 反欺诈校验标志
       ,t1.solv_rating                                                   -- 偿债能力评级标志
       ,t1.apv_rest_flg                                                  -- 合作方审批结果
       ,t1.ajb_lmt_flg                                                   -- 其他花呗额度标志
       ,t1.appl_dt                                                       -- 申请日期
       ,''                                                               -- 申请金额
       ,t1.apv_start_tm                                                  -- 审批开始时间
       ,t2.appl_status_cd                                                -- 审批状态代码
       ,t1.crdt_lmt                                                      -- 审批金额
       ,t1.apv_end_tm                                                    -- 审批结束时间
       ,t1.apved_dt                                                      -- 终审结束时间
       ,t1.final_jud_advise_sucs_flg                                     -- 通知成功标志
       ,t1.refuse_rs_descb                                               -- 拒绝原因
       ,t1.crdt_appl_id                                                  -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_ajb_crdt_appl t1
  left join ${iml_schema}.agt_appl_status_h t2
    on t1.appl_id = t2.appl_id
   and t2.appl_status_type_cd = 'CD2601'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'myjbf2'
  left join ${iml_schema}.pty_party_name_h t3
    on t1.cust_id = t3.party_id
   and party_name_type_cd = '01'
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'eifsf1'
  left join ${iml_schema}.pty_party_cert_info_h t4
    on t1.cust_id = t4.party_id
   and t4.cert_type_cd = '1010'
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'eifsf1'
  left join ${iml_schema}.pty_party_elec_addr_h t5
    on t1.cust_id = t5.party_id
   and t5.elec_addr_type_cd = '006011'
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'eifsf1'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'myjbf2'
   and t1.id_mark <> 'D';
commit;

--第三组（共十二组） 网商贷
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
       ,t1.crdt_appl_id                                                  -- 业务流水号
       ,t1.appl_flow_num                                                 -- 合作方申请编号
       ,decode(t1.prod_id, '1900010_lhd', '202020200004', '202020100001')  -- 产品编号
       ,t1.prod_name                                                     -- 产品名称
       ,'897001'                                                         -- 所属机构编号
       ,t1.cust_id                                                       -- 客户编号
       ,t1.cust_name                                                     -- 客户姓名
       ,coalesce(t2.certtype,t3.certtype,t5.certtype)                    -- 证件类型代码
       ,coalesce(t2.certcode,t3.certcode,t5.certcode)                    -- 证件编号
       ,t1.mobile_no                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,to_char(t1.netw_vrfction_status_cd)                              -- 征信查询标志
       ,''                                                               -- 评分分值
       ,''                                                               -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,''                                                               -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.appl_dt                                                       -- 申请日期
       ,t1.crdt_sugst_lmt                                                -- 申请金额
       ,t1.apv_start_tm                                                  -- 审批开始时间
       ,t4.appl_status_cd                                                -- 审批状态代码
       ,t1.crdt_lmt                                                      -- 审批金额
       ,t1.apv_end_tm                                                    -- 审批结束时间
       ,t1.final_jud_advise_tm                                           -- 终审结束时间
       ,t1.final_jud_advise_sucs_flg                                     -- 通知成功标志
       ,t1.refuse_rs                                                     -- 拒绝原因
       ,concat('MYBK',t1.cust_id)                                        -- 关联申请流水号
       ,t1.pbc_custs_mang_lab                                            -- 客群经营标签_人行口径
       ,t1.bank_supv_custs_mang_lab                                      -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_myloan_crdt_appl t1
/*  left join ${iml_schema}.pty_party_cert_info_h t2
    on t1.cust_id = t2.party_id
   and t2.main_cert_no_flg = '1'
   and t2.cert_type_cd = '1010'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'eifsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.pty_party_elec_addr_h t3
    on t1.cust_id = t3.party_id
   and t3.elec_addr_type_cd = '006011'
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'eifsf1'
   and t3.id_mark <> 'D' */
  left join ${iol_schema}.icms_mybk_iqp_loan_app t2
    on t2.serialno=t1.crdt_appl_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.prdcode<>'201020100057'   --房抵贷
  left join ${iol_schema}.icms_mybkzq_iqp_loan_app t3
    on t3.serialno=t1.crdt_appl_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   left join  ${iml_schema}.agt_appl_status_h t4
    on t1.crdt_appl_id = SUBSTR(t4.appl_id,7)
   and t4.appl_status_type_cd = 'CD2601'
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'mybkf1'
  left join ${iol_schema}.icms_mybkzd_iqp_loan_app t5
    on t5.serialno=t1.crdt_appl_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'mybkf1'
   and t1.id_mark <> 'D';
commit;

--第四组（共十二组） 微粒贷
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
       ,t1.ser_num                                                       -- 业务流水号
       ,''                                                               -- 合作方申请编号
       ,'202010100006'                                                   -- 产品编号
       ,''                                                               -- 产品名称
       ,'897001'                                                         -- 所属机构编号
       ,t3.src_party_id                                                  -- 客户编号
       ,t3.party_name                                                    -- 客户姓名
       ,t4.cert_type_cd                                                  -- 证件类型代码
       ,t4.cert_num                                                      -- 证件编号
       ,t5.elec_addr                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,''                                                               -- 征信查询标志
       ,''                                                               -- 评分分值
       ,''                                                               -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,substr(t1.final_apv_rest,1,3)                                 -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.apv_dt                                                        -- 申请日期
       ,''                                                               -- 申请金额
       ,''                                                               -- 审批开始时间
       ,decode(t1.co_bk_apv_rest,'通过'，'Finished'，'拒绝'，'Reject')   -- 审批状态代码
       ,''                                                               -- 审批金额
       ,''                                                               -- 审批结束时间
       ,''                                                               -- 终审结束时间
       ,''                                                               -- 通知成功标志
       ,''                                                               -- 拒绝原因
       ,t2.cust_lmt_id                                                   -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.evt_wld_crdt_apv_rest t1
  left join  ${iml_schema}.agt_wld_dubil_info t2
    on t1.flow_num = t2.tran_ref_no
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'mpcsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.pty_party t3
    on t3.src_party_id = t2.cust_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'eifsf1'
   and t3.id_mark <> 'D'
   and t3.src_table_name ='eifs_t00_party_pub_info'
  left join ${iml_schema}.pty_party_cert_info_h t4
    on t4.party_id = t3.party_id
   and t4.cert_type_cd = '1010'
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'eifsf1'
  left join ${iml_schema}.pty_party_elec_addr_h t5
    on t5.party_id = t3.party_id
   and t5.seq_num = '1'
   and t5.elec_addr_type_cd = '006011'
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'eifsf1'
 where t1.job_cd = 'mpcsi1';
commit;

--第五组（共十二组） 借呗三期
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
       ,t1.crdt_appl_id                                                  -- 业务流水号
       ,t1.crdt_appl_id                                                  -- 合作方申请编号
       ,'202010100002'                                                   -- 产品编号
       ,t1.prod_name                                                     -- 产品名称
       ,'897001'                                                         -- 所属机构编号
       ,t1.cust_id                                                       -- 客户编号
       ,t3.party_name                                                    -- 客户姓名
       ,t4.cert_type_cd                                                  -- 证件类型代码
       ,t4.cert_num                                                      -- 证件编号
       ,t5.elec_addr                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,t1.crdtc_acqt_sucs_flg                                           -- 征信查询标志
       ,nvl(trim(t1.score_val),0)                                        -- 评分分值
       ,t1.check_anti_fraud_flg                                          -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,t1.apved_flg                                                     -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.appl_dt                                                       -- 申请日期
       ,t1.crdt_lmt                                                      -- 申请金额
       ,t1.apv_start_tm                                                  -- 审批开始时间
       ,t1.apv_status_cd                                                 -- 审批状态代码
       ,t1.crdt_lmt                                                      -- 审批金额
       ,t1.apv_end_tm                                                    -- 审批结束时间
       ,t1.apv_end_tm                                                    -- 终审结束时间
       ,t1.final_jud_advise_sucs_flg                                     -- 通知成功标志
       ,''                                                               -- 拒绝原因
       ,t1.crdt_appl_id                                                  -- 关联申请流水号
        ,''                                                              -- 客群经营标签_人行口径
        ,''                                                              -- 客群经营标签_银监口径
       ,t1.job_cd                                                               -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_ajb_ped_3_crdt_appl t1 
  left join ${iml_schema}.pty_party_name_h t3
    on t1.cust_id = t3.party_id
   and t3.party_name_type_cd = '03'
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'eifsf1'
  left join ${iml_schema}.pty_party_cert_info_h t4
    on t1.cust_id = t4.party_id
   and t4.cert_type_cd = '1010' 
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'eifsf1'
  left join ${iml_schema}.pty_party_elec_addr_h t5
    on t1.cust_id = t5.party_id
   and t5.elec_addr_type_cd = '006011'
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'eifsf1'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'myjbf3'
   and t1.id_mark <> 'D'
   and t1.crdt_appl_id not in (select t.crdt_appl_id from ${iml_schema}.agt_ajb_crdt_appl t 
                                where t.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                                  and t.job_cd = 'myjbf2'
                                  and t.id_mark <> 'D');
commit;

--第六组（共十二组） 京东贷
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
       ,t1.flow_num                                                      -- 业务流水号
       ,nvl(t1.jd_appl_id,'-')                                           -- 合作方申请编号
       ,'202010100004'                                                 -- 产品编号
       ,t1.prod_name                                                     -- 产品名称
       ,'897001'                                                         -- 所属机构编号
       ,t1.cust_id                                                       -- 客户编号
       ,t1.cust_name                                                     -- 客户姓名
       ,t1.cert_type_cd                                                  -- 证件类型代码
       ,t1.id_card_num                                                   -- 证件编号
       ,t1.mobile_no                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,t1.crdtc_flg                                                     -- 征信查询标志
       ,t1.score_val                                                     -- 评分分值
       ,t1.rev_fraud_check_flg                                           -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,''                                                               -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.appl_tm                                                       -- 申请日期
       ,t1.appl_lmt                                                      -- 申请金额
       ,t1.apv_start_tm                                                  -- 审批开始时间
       ,t1.apv_status_cd                                                 -- 审批状态代码
       ,t1.appl_lmt                                                      -- 审批金额
       ,t1.apv_end_tm                                                    -- 审批结束时间
       ,t1.apv_end_tm                                                    -- 终审结束时间
       ,t1.advise_flg                                                    -- 通知成功标志
       ,t1.refuse_rs                                                     -- 拒绝原因
       ,concat(t1.user_idf,'_03')                                        -- 关联申请流水号
        ,''                                                              -- 客群经营标签_人行口径
        ,''                                                              -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_jd_appl  t1
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'jdjrf1'
   and t1.id_mark <> 'D';
commit;


--第七组（共十二组） 微粒贷
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
       ,t1.ser_num                                                      -- 业务流水号
       ,''                                                               -- 合作方申请编号
       ,t2.prod_id                                                       -- 产品编号
       ,t5.sellbl_prod_name                                              -- 产品名称
       ,'805011'                                                         -- 所属机构编号
       ,t2.cust_id                                                       -- 客户编号
       ,t3.customername                                                  -- 客户姓名
       ,t3.certtype                                                      -- 证件类型代码
       ,t3.certid                                                        -- 证件编号
       ,t3.telephone                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,''                                                               -- 征信查询标志
       ,''                                                               -- 评分分值
       ,''                                                               -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,t1.final_apv_rest                                                -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.apv_dt                                                        -- 申请日期
       ,''                                                               -- 申请金额
       ,''                                                               -- 审批开始时间
       ,decode(t1.co_bk_apv_rest,'通过'，'Finished'，'拒绝'，'Reject')   -- 审批状态代码
       ,''                                                               -- 审批金额
       ,''                                                               -- 审批结束时间
       ,''                                                               -- 终审结束时间
       ,''                                                               -- 通知成功标志
       ,''                                                               -- 拒绝原因
       ,t2.cust_lmt_id                                                   -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.evt_wld_crdt_apv_rest t1
  left join  ${iml_schema}.agt_wld_dubil_info_h t2
    on t1.flow_num = t2.tran_ref_no
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iol_schema}.icms_customer_info_wld t3
    on t2.cust_id = t3.customerid
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_wld_acct_h t4
    on t2.acct_id=t4.acct_id 
   and t2.acct_type_cd=t4.acct_type_cd
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'icmsf1'
  left join ${iml_schema}.prd_prod_catlg_h t5
    on t2.prod_id=t5.prod_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'ncbsf1'
 where t1.job_cd = 'icmsi1';
commit;


--第八组（共十二组） 字节小微贷
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
       ,t1.crdt_appl_flow_num                                            -- 业务流水号
       ,nvl(trim(t1.myloan_req_flow_num),t1.stud_loan_req_flow_num)      -- 合作方申请编号
       ,t1.prod_id                                                       -- 产品编号
       ,case when length(t2.prod_id)=1 then t2.prod_gen_name
             when length(t2.prod_id)=3 then t2.prod_sclass_name
             when length(t2.prod_id)=5 then t2.prod_group_name
             when length(t2.prod_id)=7 then t2.base_prod_name
        else t2.sellbl_prod_name end                                     -- 产品名称
       ,t1.rgst_org_id                                                   -- 所属机构编号
       ,t1.cust_id                                                       -- 客户编号
       ,t1.cust_name                                                     -- 客户姓名
       ,t1.cert_type_cd                                                  -- 证件类型代码
       ,t1.cert_no                                                       -- 证件编号
       ,t1.mobile_no                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,''                                                               -- 征信查询标志
       ,''                                                               -- 评分分值
       ,''                                                               -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,''                                                               -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.rgst_dt                                                       -- 申请日期
       ,t1.crdt_lmt                                                      -- 申请金额
       ,t1.rgst_dt                                                       -- 审批开始时间
       ,t1.crdt_status_cd                                                -- 审批状态代码
       ,t1.actl_lmt                                                      -- 审批金额
       ,t1.risk_mgmt_re_dt                                               -- 审批结束时间
       ,t1.risk_mgmt_re_dt                                               -- 终审结束时间
       ,''                                                               -- 通知成功标志
       ,t1.risk_mgmt_refuse_rs                                           -- 拒绝原因
       ,case when t1.lmt_cont_flg = '01'  then t1.lmt_cont_id 
             when t1.lmt_cont_flg = '02'  then t1.intnal_dubil_id
        else ' ' end                                                     -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_zjdk_crdt_appl_info_h t1
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

--第九组（共十二组） 微业贷
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
       ,'Finished'                                                               -- 审批状态代码
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



--第十组（共十二组） 唯品合作贷
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
       ,t1.appl_flow_num                                                 -- 业务流水号
       ,t1.src_appl_flow_num                                             -- 合作方申请编号
       ,t1.prod_id                                                       -- 产品编号
       ,case when length(t2.prod_id)=1 then t2.prod_gen_name
             when length(t2.prod_id)=3 then t2.prod_sclass_name
             when length(t2.prod_id)=5 then t2.prod_group_name
             when length(t2.prod_id)=7 then t2.base_prod_name
        else t2.sellbl_prod_name end                                     -- 产品名称
       ,t1.rgst_org_id                                                   -- 所属机构编号
       ,t1.cust_id                                                       -- 客户编号
       ,t1.cust_name                                                     -- 客户姓名
       ,t1.cert_type_cd                                                  -- 证件类型代码
       ,t1.cert_no                                                       -- 证件编号
       ,t1.mobile_no                                                     -- 联系号码
       ,''                                                               -- 我行黑名单标志
       ,''                                                               -- 征信查询标志
       ,''                                                               -- 评分分值
       ,''                                                               -- 反欺诈校验标志
       ,''                                                               -- 偿债能力评级标志
       ,''                                                               -- 合作方审批结果
       ,''                                                               -- 其他花呗额度标志
       ,t1.rgst_dt                                                       -- 申请日期
       ,t1.appl_tot_amt                                                  -- 申请金额
       ,t1.rgst_dt                                                       -- 审批开始时间
       ,t1.appl_status_cd                                                -- 审批状态代码
       ,t1.appl_tot_amt                                                  -- 审批金额
       ,null                                                             -- 审批结束时间
       ,null                                                             -- 终审结束时间
       ,''                                                               -- 通知成功标志
       ,t1.risk_mgmt_refuse_rs                                           -- 拒绝原因
       ,t1.appl_flow_num                                                 -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_wph_crdt_appl t1
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

--第十一组（共十二组） 分期乐
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


--第十二组（共十二组） 富民联合贷
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
       to_date('${batch_date}','yyyymmdd')                           -- 数据日期
       ,t1.lp_id                                                        -- 法人编号
       ,t1.crdt_id                                                      -- 业务流水号
       ,t1.partner_ova_flow_num                                         -- 合作方申请编号
       ,t1.prod_id                                                      -- 产品编号
       ,t2.sellbl_prod_name                                             -- 产品名称
       ,t1.rgst_org_id                                                  -- 所属机构编号
       ,t1.cust_id                                                      -- 客户编号
       ,t1.cust_name                                                    -- 客户姓名
       ,t3.certtype                                                     -- 证件类型代码
       ,t3.certid                                                       -- 证件编号
       ,t3.telephone                                                    -- 联系号码
       ,''                                                              -- 我行黑名单标志
       ,''                                                              -- 征信查询标志
       ,''                                                              -- 评分分值
       ,''                                                              -- 反欺诈校验标志
       ,''                                                              -- 偿债能力评级标志
       ,'1'                                                             -- 合作方审批结果
       ,''                                                              -- 其他花呗额度标志
       ,t1.apv_start_dt                                                 -- 申请日期
       ,t1.appl_amt                                                     -- 申请金额
       ,t1.apv_start_dt                                                 -- 审批开始时间
       ,t1.appl_status_cd                                                --  审批状态代码
       ,t1.risk_mgmt_crdt_lmt                                            -- 审批金额
       ,t1.risk_mgmt_return_dt                                           -- 审批结束时间
       ,t1.risk_mgmt_return_dt                                           -- 终审结束时间
       ,''                                                               -- 通知成功标志
       ,t1.risk_mgmt_refuse_rs_descb                                     -- 拒绝原因
       ,t1.partner_ova_flow_num                                          -- 关联申请流水号
       ,''                                                               -- 客群经营标签_人行口径
       ,''                                                               -- 客群经营标签_银监口径
       ,'icms_lh'                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
 from ${iml_schema}.agt_lhwd_crdt_appl t1
 left join ${iml_schema}.prd_prod_catlg_h t2
   on t1.prod_id = t2.prod_id 
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd = 'ncbsf1'
 left join ${iol_schema}.icms_customer_info_lhdk  t3
   on t1.cust_id = t3.customerid
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
 ;
commit;


delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_appl_info';
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
   ,'cmm_unite_wl_appl_info'
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