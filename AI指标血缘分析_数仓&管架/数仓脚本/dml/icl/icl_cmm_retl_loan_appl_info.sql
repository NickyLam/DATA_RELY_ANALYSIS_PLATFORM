/*
purpose:    共性加工层-零售贷款申请信息：包括所有行内零售贷款业务的申请信息，包含传统零售贷款业务、助学贷款业务、微贷工厂业务、网贷业务、房快贷等业务。数据来源于综合信贷管理系统ICMS。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_retl_loan_appl_info
createdate: 20200326
logs:       20200603 若平测试改动
            20200716 助贷拒绝原因修改截取规则
            20210426 陈伟峰 新增字段【纳税人识别号】，调整第二组网贷【拒绝原因】取数逻辑
            20210519 陈伟峰 调整房快贷组【纳税人识别号、拒绝原因】取数逻辑
            20220308 陈伟峰 新增字段【住房套数代码、房屋首付额、房屋总价】
            20220427 李森辉 1、取数数据源调整，由零售信贷系统调整为综合信贷管理系统
                            2、去掉第二组助贷、第三组微贷、第四组网贷、第五组房快贷，均以整合到零售信贷申请信息
            20220608 温旺清 1、新增字段【首次购房标志、建筑面积、首付比例、贷款比例、评估价格、认定价格、白户标志】
                            2、增加T1表过滤条件【SUBSTR(T1.PRODUCTID, 1, 3) IN ('201', '202') 】
                            3、调整T2表的关联方式【INNER JOIN -> LEFT JOIN】
			      20220711 温旺清 1、调整T1表的过滤条件【T1.BUSINESSFLAG = '2' -》 T1.LOAN_DISTR_TYPE_CD <> '0201'】
                            2、新增字段【授信额度标志】
            20220823 温旺清 新增字段【营销渠道编号、营销单位编号】
            20220905 温旺清 新增字段【营销单位名称、营销渠道名称】
            20221012 温旺清 调整字段【特殊贷款标志、初审审批状态代码】
            20221212 陈伟峰 调整字段【纳税人识别号】加工逻辑
            20230216 温旺清 新增字段【贷款用途细类代码】
            20231218 饶雅   新增字段【登记柜员编号】
            20240126 饶雅   新增字段【入账账户清算银行行号】
            20240327 饶雅   新增字段【收款人帐户编号】、【收款人名称】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_appl_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_appl_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create temp table
drop table ${icl_schema}.tmp_cmm_retl_loan_appl_info_01 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_appl_info_02 purge;

-- 1.3 insert data to temp table
-- 获取业务审批基本信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_appl_info_01
nologging
compress ${option_switch} for query high
as
select t1.agt_id
       ,t1.apv_flow_num
       ,t1.appl_flow_num
       ,t1.happ_dt
       ,row_number() over(partition by t1.appl_flow_num order by t1.happ_dt desc) rn
  from ${iml_schema}.agt_loan_apv_basic_info_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'
;

-- 获取合同信息（接入渠道编号、授信金额、终审审批额度等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_appl_info_02
nologging
compress ${option_switch} for query high
as
select t1.apv_flow_num
       ,t1.cont_amt
       ,t1.out_acct_dt
       ,t2.chn_id
       ,row_number() over(partition by t1.apv_flow_num order by t1.out_acct_dt desc) rn
  from ${iml_schema}.agt_loan_cont_info_h t1
  left join ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h t2
    on t1.agt_id = t2.agt_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'
;

-- 2.1 create temporary table cmm_retl_loan_appl_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_appl_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_appl_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_retl_loan_appl_info where 0=1;

-- 2.2 insert into data to temporary table cmm_retl_loan_appl_info_ex
--第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_appl_info_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,loan_appl_flow_num          -- 贷款申请流水号
       ,bus_flow_num                -- 业务流水号
       ,cust_id                     -- 客户编号
       ,cust_name                   -- 客户姓名
       ,prod_id                     -- 产品编号
       ,prod_name                   -- 产品名称
       ,belong_org_id               -- 所属机构编号
       ,belong_brch_id              -- 所属分行编号
       ,access_chn_id               -- 接入渠道编号
       ,chn_id                      -- 渠道编号
       ,loan_usage_cd               -- 贷款用途代码
       ,loan_usage_subclass_cd      -- 贷款用途细类代码
       ,spec_usage                  -- 具体用途
       ,repay_src_cd                -- 还款来源代码
       ,ghb_emply_flg               -- 本行员工标志
       ,final_jud_advise_sucs_flg   -- 终审通知成功标志
       ,distr_advise_sucs_flg       -- 放款通知成功标志
       ,blip_doc_flg                -- 有影像文件标志
       ,open_acct_sucs_flg          -- 开户成功标志
       ,netw_vrfction_status_flg    -- 联网核查状态标志
       ,crdtc_que_situ_flg          -- 征信查询情况标志
       ,espec_loan_flg              -- 特殊贷款标志
       ,main_debit_ps_cert_type_cd  -- 主借人证件类型代码
       ,main_debit_ps_cert_id       -- 主借人证件编号
       ,tax_num                     -- 纳税人识别号
       ,acct_instit_id              -- 账务机构编号
       ,enter_clear_bk_no           -- 入账账户清算银行行号
       ,recver_acct_id              -- 收款人帐户编号
       ,recver_name                 -- 收款人名称
       ,mgmt_org_id                 -- 管理机构编号
       ,rgst_teller_id              -- 登记柜员编号
       ,housing_cnt_cd              -- 住房套数代码
       ,house_first_pay_amt         -- 房屋首付额
       ,house_tot_price             -- 房屋总价
       ,appl_amt                    -- 申请金额
       ,crdt_amt                    -- 授信金额
       ,score_val                   -- 评分分值
       ,first_trial_apv_status_cd   -- 初审审批状态代码
       ,first_trial_appl_dt         -- 初审申请日期
       ,first_trial_appl_tm         -- 初审申请时间
       ,first_trial_end_tm          -- 初审结束时间
       ,final_jud_appl_dt           -- 终审申请日期
       ,final_jud_appl_tm           -- 终审申请时间
       ,final_jud_apv_lmt           -- 终审审批额度
       ,final_jud_apv_status_cd     -- 终审审批状态代码
       ,apv_opinion                 -- 审批意见
       ,apv_concus                  -- 审批结论
       ,final_jud_end_tm            -- 终审结束时间
       ,refuse_rs                   -- 拒绝原因
       ,fir_buy_flg                 -- 次购房标志
       ,house_arch_area             -- 房屋建筑面积
       ,house_first_pay_ratio       -- 房屋首付比例
       ,loan_ratio                  -- 贷款比例  
       ,estim_price                 -- 评估价格  
       ,idtfy_price                 -- 认定价格  
       ,acct_flg                    -- 白户标志  
	     ,crdt_lmt_use_flg            --授信额度标志
       ,camp_chn_id                 --营销渠道编号
       ,camp_corp_id                --营销单位编号
   	   ,camp_chn_name               --营销单位名称
	     ,camp_corp_name              --营销渠道名称      
       ,job_cd                      -- 任务代码
       ,etl_timestamp               -- 数据处理时间
  )
select to_date('${batch_date}','yyyymmdd')                                                       -- 数据日期
       ,t1.lp_id                                                                                 -- 法人编号
       ,t1.appl_flow_num                                                                         -- 贷款申请流水号
       ,t1.rela_flow_num                                                                         -- 业务流水号
       ,t1.cust_id                                                                               -- 客户编号
       ,t1.cust_name                                                                             -- 客户姓名
       ,t1.prod_id                                                                               -- 产品编号
       ,t2.prod_name                                                                             -- 产品名称
       ,t1.rgst_org_id                                                                           -- 所属机构编号
       ,substr(t1.rgst_org_id, 1, 3)                                                             -- 所属分行编号
       ,nvl(trim(t5.chn_id), t6.access_chn_id)                                                   -- 接入渠道编号
       ,nvl(trim(t3.chn_id), t6.chn_id)                                                          -- 渠道编号
       ,nvl(trim(t1.loan_usage_cd), t7.loan_usage_cd)                                            -- 贷款用途代码
       ,t3.loan_usage_cd                                                                         -- 贷款用途细类代码
       ,t1.usage_descb                                                                           -- 具体用途 
       ,t6.repay_src_cd                                                                          -- 还款来源代码
       ,t6.ghb_emply_flg                                                                         -- 本行员工标志
       ,nvl(trim(t3.rest_advise_sucs_flg), trim(t6.final_jud_advise_sucs_flg))                   -- 终审通知成功标志
       ,nvl(trim(t3.rest_advise_sucs_flg), trim(t6.distr_advise_sucs_flg))                       -- 放款通知成功标志
       ,coalesce(trim(t3.intd_blip_flg), trim(t3.blip_cmplt_upload_flg), trim(t7.blip_doc_flg))  -- 有影像文件标志
       ,nvl(trim(t3.rest_advise_sucs_flg), trim(t7.open_acct_sucs_flg))                          -- 开户成功标志
       ,nvl(trim(t3.rest_advise_sucs_flg), trim(t7.netw_vrfction_status_flg))                    -- 联网核查状态标志
       ,nvl(trim(t3.rest_advise_sucs_flg), trim(t7.crdtc_que_situ_flg))                          -- 征信查询情况标志
       ,t3.expt_lmt_flg                                                                          -- 特殊贷款标志
       ,coalesce(trim(t8.cert_type_cd), trim(t6.main_debit_ps_cert_type_cd), '0000')             -- 主借人证件类型代码
       ,nvl(trim(t8.cert_no), trim(t6.main_debit_ps_cert_id))                                    -- 主借人证件编号
       ,case when t7.tax_type_cd = '1' then nvl(trim(t7.taxpayer_idtfy_num),t3.taxpayer_idtfy_num)
             when t7.tax_type_cd = '2' then nvl(trim(t7.tax_bur_auth_flow_num),t3.taxpayer_idtfy_num)
             else t3.taxpayer_idtfy_num
        end                                                                                      -- 纳税人识别号
       ,t1.core_out_acct_org_id                                                                  -- 账务机构编号
       ,t3.enter_clear_bk_no                                                                     -- 入账账户清算银行行号
       ,t3.recver_acct_id                                                                        -- 收款人帐户编号
       ,t3.recver_name                                                                           -- 收款人名称
       ,t1.rgst_org_id                                                                           -- 管理机构编号
       ,t1.rgst_teller_id                                                                        -- 登记柜员编号
       ,t3.house_cnt                                                                             -- 住房套数代码
       ,t3.first_pay_amt                                                                         -- 房屋首付额
       ,t3.house_tot_price                                                                       -- 房屋总价
       ,t1.appl_amt                                                                              -- 申请金额
       ,nvl(t5.cont_amt, t1.appl_amt)                                                            -- 授信金额
       ,decode (t3.crdt_level,0,t6.score_val,t3.crdt_level)                                      -- 评分分值
       ,t1.apv_status_cd                                                                         -- 初审审批状态代码
       ,nvl(trim(t1.happ_dt), trim(t7.first_trial_appl_dt))                                      -- 初审申请日期
       ,nvl(trim(t1.happ_dt), trim(t7.first_trial_appl_tm))                                      -- 初审申请时间
       ,${iml_schema}.timeformat_max(nvl(trim(t3.apv_tm), trim(t7.apv_end_tm)))                  -- 初审结束时间
       ,nvl(trim(t6.final_jud_appl_dt),trim(t1.happ_dt))                                         -- 终审申请日期
       ,nvl(trim(t6.final_jud_appl_tm),trim(t1.happ_dt))                                         -- 终审申请时间
       ,coalesce(t9.latest_apv_amt, t6.final_jud_apv_lmt, t5.cont_amt, t1.appl_amt)              -- 终审审批额度
       ,t1.apv_status_cd                                                                         -- 终审审批状态代码
       ,coalesce(trim(t3.invstg_opinion_descb), trim(t6.apv_opinion) ,t1.remark)                 -- 审批意见
       ,t6.apv_concus                                                                            -- 审批结论
       ,${iml_schema}.timeformat_max(coalesce(trim(t3.apv_end_tm), trim(t6.apv_end_tm)))         -- 终审结束时间
       ,coalesce(trim(t3.invstg_opinion_descb), t1.remark)                                       -- 拒绝原因
       ,t3.fir_buy_flg                                                                           -- 首次购房标志
       ,t3.arch_area                                                                             -- 房屋建筑面积
       ,t3.first_pay_ratio                                                                       -- 房屋首付比例
       ,t3.loan_ratio                                                                            -- 贷款比例
       ,t3.estim_price                                                                           -- 评估价格
       ,t3.idtfy_price                                                                           -- 认定价格
       ,t3.white_acct_flg                                                                        -- 白户标志 
       ,decode(t1.lmt_cont_flg, '01', '1', '0')                                                  --授信额度标志	
       ,t9.camp_chn_id                                                                           --营销渠道编号
       ,t9.camp_corp_id                                                                          --营销单位编号	
       ,t9.camp_corp_name                                                                        --营销单位名称 
       ,t9.camp_chn_name                                                                         --营销渠道名称  
       ,t1.job_cd                                                                                -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          -- 数据处理时间
  from ${iml_schema}.agt_loan_appl_basic_info_h t1
 inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd in ('2', '4')
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h t3
    on t1.appl_id = t3.appl_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${icl_schema}.tmp_cmm_retl_loan_appl_info_01 t4
    on t1.appl_flow_num = t4.appl_flow_num
   and t4.rn = 1
  left join ${icl_schema}.tmp_cmm_retl_loan_appl_info_02 t5
    on t4.apv_flow_num = t5.apv_flow_num
   and t5.rn = 1
  left join ${iml_schema}.agt_loan_appl_fkd_attach_info_h t6
    on t1.appl_id = t6.appl_id
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_fkd_pre_loan_appl_info t7
    on t6.crdt_appl_flow_num = t7.crdt_appl_flow_num
   and t7.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'icmsf1'
   and t7.id_mark <> 'D'
   and trim(t6.crdt_appl_flow_num) is not null
  left join ${iml_schema}.pty_cust t8
    on t1.cust_id = t8.cust_id
   and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'icmsf1'
   and t8.id_mark <> 'D'
  left join ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h t9
    on t1.appl_id = t9.appl_id
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t9.job_cd = 'icmsf1'
 where t1.loan_distr_type_cd <> '0201'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1';
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_appl_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_appl_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_retl_loan_appl_info_ex purge;

-- 3.2 drop temp table
drop table ${icl_schema}.tmp_cmm_retl_loan_appl_info_01 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_appl_info_02 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_retl_loan_appl_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);