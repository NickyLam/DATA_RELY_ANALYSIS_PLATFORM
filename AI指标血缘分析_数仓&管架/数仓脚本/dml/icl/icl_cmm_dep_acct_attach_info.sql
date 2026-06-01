/*
Purpose:    共性加工层-存款分户补充信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_dep_acct_attach_info
CreateDate: 20200219
Logs:       20221107 温旺清 新增模型
            20221118 温旺清 新增字段【外汇账户性质代码、协议存款类型代码、账户许可证号、账户许可证签发日期、源协议编号】
            20221123 温旺清 新增字段【资金性质代码】
            20221129 温旺清 新增字段【账户关闭原因描述】
            20221213 温旺清 新增字段【原始开户日期、原始到期日期】
            20230109 陈伟峰 新增字段【六个月无交易标志】
            20230606 陈伟峰 新增字段【监管类型代码】  
            20230727 曹永茂 调整【六个月无交易标志】取数口径：NCBS_RB_ACCT.NO_TRAN_FLAG -> NCBS_RB_ACCT_ATTACH.CASE_INVOLVED_FLAG
            20231030 徐子豪 新增字段【兴惠存标志、协定存款利率浮动比例、协定存款利率浮动点数、延期付息利息浮动点、同兴赢主协议超档利率、同兴赢子协议协定利率】
            20231214 饶雅   新增字段【资金池协议利率】
            20231214 饶雅   新增字段【久悬金额】
            20240412 饶雅   新增字段【异地开户标志】、【开户省份】、【开户城市】
            20240606 陈伟峰 调整acct_name截取逻辑，按150位截取
            20240624 陈伟峰 调整acct_name截取逻辑，按140位截取
            20240628 陈伟峰 新增【证实书打印标志、预约支取标志、预约支取日期】
            20240829 陈伟峰 调整同兴赢关联表加工逻辑
            20240802 陈伟峰 新增字段【约期金额、约期开始日期、约期结束日期】
            20241012 陈伟峰 新增字段【医保账户标志】延迟版本先置空
            20241021 谢  宁 新增字段 【预约结清日期】
            20241029 谢  宁 新增字段 【旅行通账户标志、旅行通卡有效期】
            20241122 陈伟峰 调整ibms_ttrd_acct_protocol_master过滤条件
            20241029 谢  宁 新增字段 【社保卡下金融账户标志】
            20241227 陈伟峰 调整agt_dep_sign_agt_h关联逻辑，使用valid_dt和invalid_dt判断，去除sign_agt_status_cd = 'A'
			20250123 谢  宁 新增字段【现金管理类产品标志】
			20250227 陈  凭 新增字段【监管标识设置日期、取消监管标识日期】
			20250311 陈伟峰 新增字段【利率审批单单号】
			20250311 陈  凭 新增字段【本息分离标志】
			20260305 陈  凭 新增字段【差异化定价利率、最低留存金额】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_acct_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_dep_acct_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_dep_acct_attach_info_ex purge;
drop table ${icl_schema}.cmm_dep_acct_attach_info_ex1 purge;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert data to ex table
create table ${icl_schema}.cmm_dep_acct_attach_info_ex nologging
compress
as select * from ${icl_schema}.cmm_dep_acct_attach_info where 0=1;

create table ${icl_schema}.cmm_dep_acct_attach_info_ex1 nologging
compress
as select * from ${icl_schema}.cmm_dep_acct_attach_info where 0=1;

--第一组（共一组）核心
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_acct_attach_info_ex(
    etl_dt                         -- 数据日期
   ,lp_id                          -- 法人编号
   ,acct_id                        -- 账户编号
   ,acct_name                      -- 账户名称
   ,cust_id                        -- 客户编号
   ,src_agt_id                     -- 源协议编号
   ,fx_acct_char_cd                -- 外汇账户性质代码
   ,agt_dep_type_cd                -- 协议存款类型代码
   ,supv_type_cd                   -- 监管类型代码
   ,int_rat_apv_form_odd_no        -- 利率审批单单号
   ,acct_lics_num                  -- 账户许可证号
   ,acct_lics_issue_dt             -- 账户许可证签发日期
   ,cap_char_cd                    -- 资金性质代码
   ,acct_close_rs_descb            -- 账户关闭原因描述
   ,init_open_acct_dt              -- 原始开户日期
   ,init_exp_dt                    -- 原始到期日期
   ,pric_int_sept_flg              -- 本息分离标志
   ,l_six_m_no_tran_flg            -- 六个月无交易标志
   ,xhc_flg                        -- 兴惠存标志
   ,remote_open_acct_flg           -- 异地开户标志
   ,cert_print_flg                 -- 证实书打印标志
   ,travel_card_acct_flg           -- 旅行通账户标志
   ,travel_card_valid_dt           -- 旅行通卡有效期
   ,precon_wdraw_flg               -- 预约支取标志
   ,precon_wdraw_dt                -- 预约支取日期
   ,precon_payoff_dt               -- 预约结清日期
   ,supv_idf_set_dt                -- 监管标识设置日期
   ,supv_idf_cancel_dt             -- 监管标识取消日期
   ,heat_insu_acct_flg             -- 医保账户标志
   ,soci_secu_fin_acct_flg         -- 社保卡下金融账户标志
   ,cash_manage_flg                -- 现金管理类产品标志
   ,open_acct_prov                 -- 开户省份
   ,open_acct_city                 -- 开户城市
   ,sub_acct_int_rat_float_ratio   -- 协定存款利率浮动比例
   ,sub_acct_int_rat_float_point   -- 协定存款利率浮动点数
   ,delay_pay_int_int_float_point  -- 延期付息利息浮动点
   ,txy_main_agt_files_int_rat     -- 同兴赢主协议超档利率
   ,txy_sub_agt_agree_int_rat      -- 同兴赢子协议协定利率
   ,cap_pool_agt_rat               -- 资金池协议利率
   ,diff_pricing_int_rat           -- 差异化定价利率
   ,lowt_retnd_amt                 -- 最低留存金额
   ,long_hang_amt                  -- 久悬金额
	 ,apot_tenor_amt                 -- 约期金额
	 ,apot_tenor_start_dt            -- 约期开始日期
	 ,apot_tenor_end_dt              -- 约期结束日期
   ,job_cd                         -- 任务代码
   ,etl_timestamp                  -- etl处理时间戳
)
select to_date('${batch_date}', 'yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                          -- 法人编号
       ,t1.acct_id                                                        -- 账户编号
       ,substrb(nvl(trim(t1.acct_name), ' '),1,140) as  acct_name         -- 账户名称
       ,t1.cust_id                                                        -- 客户编号
	     ,t1.src_agt_id                                                     -- 源协议编号
       ,t2.acct_char_cd                                                   -- 外汇账户性质代码
       ,t2.agt_dep_type_cd                                                -- 协议存款类型代码
       ,t2.supv_type_cd                                                   -- 监管类型代码
       ,t11.int_rate_form_no                                              -- 利率审批单单号
	     ,t1.acct_lics_num                                                  -- 账户许可证号
	     ,t1.acct_lics_issue_dt                                             -- 账户许可证签发日期
       ,t2.cap_char                                                       -- 资金性质代码
	     ,t1.clos_acct_rs                                                   -- 账户关闭原因描述
       ,t1.acct_init_open_acct_dt                                         -- 原始开户日期
       ,t1.acct_init_exp_dt                                               -- 原始到期日期
       ,decode(t11.bal_int_split,'Y','1','0')                             -- 本息分离标志
       ,decode(substr(t2.legal_flg,4,1),'S','1','0')                      -- 六个月无交易标志
       ,decode(trim(t2.pcp_de_int_flag),'1','1','0')                      -- 兴惠存标志
       ,t2.remote_open_acct_flg                                           -- 异地开户标志
       ,t2.print_cert_flg                                                 -- 证实书打印标志
       ,t1.travel_card_flg                                                -- 旅行通账户标志
       ,t1.travel_card_valid_dt                                           -- 旅行通卡有效期
       ,t2.precon_wdraw_flg                                               -- 预约支取标志
       ,t2.precon_wdraw_dt                                                -- 预约支取日期
       ,t2.precon_payoff_day                                              -- 预约结清日期
       ,t11.manage_start_date                                             -- 监管标识设置日期
       ,t11.manage_end_date                                               -- 监管标识取消日期
       ,t1.heat_insu_acct_flg                                             -- 医保账户标志
       ,t1.soci_secu_fin_acct_flg                                         -- 社保卡下金融账户标志
	     ,t2.cash_mgmt_prod_flg                                             -- 现金管理类产品标志
       ,t2.open_acct_prov                                                 -- 开户省份
       ,t2.open_acct_city                                                 -- 开户城市
       ,t4.sub_acct_int_rat_float_ratio                                   -- 协定存款利率浮动比例
       ,t4.sub_acct_int_rat_float_point                                   -- 协定存款利率浮动点数
       ,nvl(t5.int_float_point,0)                                         -- 延期付息利息浮动点
       ,nvl(t6.over_grade_rate,0)                                         -- 同兴赢主协议超档利率
       ,nvl(t7.agree_int_rate,0)                                          -- 同兴赢子协议协定利率
       ,nvl(t8.agree_int_rate,0)                                          -- 资金池协议利率
       ,case when t1.core_acct_type_cd = 'C' then nvl(t12.diff_quote_rate,0)
             when t1.core_acct_type_cd = 'T' then nvl(t13.diff_quote_rate,0)
             else 0 
         end                                                              -- 差异化定价利率
       ,case when t1.core_acct_type_cd = 'C' then nvl(t12.keep_min_bal,0)
             when t1.core_acct_type_cd = 'T' then nvl(t13.keep_min_bal,0)
             else 0 
         end                                                              -- 最低留存金额
       ,nvl(t9.long_hang_amt,0)                                           -- 久悬金额
	     ,nvl(t10.amount,0)                                                 -- 约期金额
	     ,t3.valid_dt                                                       -- 约期开始日期
	     ,t3.invalid_dt                                                     -- 约期结束日期
       ,t1.job_cd                                                         -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
  from ${iml_schema}.agt_dep_acct_info_h t1
  left join ${iml_schema}.agt_dep_acct_assis_info_h t2
  	on t1.agt_id = t2.agt_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
  left join (select t.*,row_number() over(partition by t.agt_key order by t.valid_dt desc) as rn 
               from ${iml_schema}.agt_dep_sign_agt_h t
              where t.sign_agt_type_cd = 'TXY' 
                and t.agt_key_type_cd = 'IK' 
                and t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t.valid_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
                and t.job_cd = 'ncbsf1'
                and exists (select 1 from ${iol_schema}.ncbs_rb_agreement_txy tt where tt.agreement_id=t.sign_agt_id and tt.main_flag = 'M')
                )t3
    on t1.acct_id = t3.agt_key
   and t3.rn=1
  left join ${iml_schema}.agt_agree_dep_agt_h t4
    on t3.agt_id = t4.agt_id
   and t4.sign_agt_status_cd ='A'
   and t4.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ncbsf1'
  left join ${iml_schema}.agt_delay_pay_int_info_h t5
    on t1.acct_id = t5.acct_id
   and t5.status_cd='A' 
   and t5.effect_dt <=to_date('${batch_date}', 'yyyymmdd') 
   and t5.invalid_dt >to_date('${batch_date}', 'yyyymmdd')
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'ncbsf1'
  left join ${iol_schema}.ncbs_rb_agreement_txy t6
    on t3.sign_agt_id = t6.agreement_id
   and t6.main_flag = 'M'
  left join ${iol_schema}.ncbs_rb_agreement_txy t7
    on t3.sign_agt_id = t7.main_agreement_id
  left join ${iol_schema}.ncbs_rb_pcp_agreement t8
    on t1.acct_id = t8.internal_key
   and t8.agreement_status = 'A'
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_dep_acct_bal_h t9
    on t1.agt_id = t9.agt_id
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t9.job_cd = 'ncbsf1'
  left join ${iol_schema}.ibms_ttrd_acct_protocol_master t10
    on t3.sign_agt_id=t10.contract_no
   and replace(t10.start_date,'-','')<='${batch_date}'
   and replace(t10.expire_date,'-','')>'${batch_date}'
	 and t10.usable_flag <> '2'                                    -- 只取有效的数据
   and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ncbs_rb_acct_attach t11
  	on t1.acct_id = t11.internal_key
   and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select t.*
                   ,row_number() over(partition by base_acct_no, client_no order by int_rate_form_no desc) as rn
               from ${iol_schema}.ncbs_rb_int_rate_form_msg t
              where t.int_agreement_status != 'N'
                and t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')) t12
  	on t1.cust_acct_num = t12.base_acct_no 
   and t1.cust_id = t12.client_no 
   and t12.rn = 1                                                  -- 活期账户
  left join (select t.*
                   ,row_number() over(partition by internal_key order by int_rate_form_no desc) as rn
               from ${iol_schema}.ncbs_rb_int_rate_form_msg t
              where t.start_dt <=to_date('${batch_date}', 'yyyymmdd')
               and t.end_dt >to_date('${batch_date}', 'yyyymmdd')) t13
  	on t1.acct_id = t13.internal_key 
   and t13.rn = 1                                                  -- 定期账户
 where 1 = 1
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
   and t1.src_module_type_cd = 'RB'
   and t1.acct_init_open_acct_dt <= to_date('${batch_date}','yyyymmdd')
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_acct_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_acct_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_acct_attach_info_ex purge;
drop table ${icl_schema}.cmm_dep_acct_attach_info_ex1 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_dep_acct_attach_info',partname => 'p_${batch_date}', degree => 8, cascade => true);