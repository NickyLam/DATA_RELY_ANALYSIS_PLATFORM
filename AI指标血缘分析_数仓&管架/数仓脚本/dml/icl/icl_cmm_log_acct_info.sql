/*
Purpose:    共性加工层-保函账户信息：包括我行的所有境内保函和涉外保函，通过协议编号可以关联保证金账号，但允许一个协议编号对应多个保证金账号。可以通过保函合同编号关联对公贷款借据信息的借据号获取相关的借据信息。境内保函数据来源于新核心系统NCBS，涉外保函数据来源于国结系统ISBS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_log_acct_info
CreateDate: 20190808
Logs:
            20200110 翟若平 调整.ref_cny_fori_exch_mdl_p_h表取数口径
            20200424 周沁晖 调整字段[受益人名称、受益人账号]的取数逻辑、增加字段[业务编号]
            20200627 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额】
            20200828 周沁晖 增加字段【标准产品编号】
            20210104 陈伟峰 调整agt_dep_acct算法
            20210426 谢  宁 增加字段【正常利率，垫款利率】
            20210804 何桐金 调整第一组【期限代码】逻辑
            20211107 何桐金 【agt_loan_acct】增加job_cd过滤条件
            20220412 李森辉 1、调整第一组的取数数据源，由旧核心系统调整为新核心系统；
                            2、新增字段【保证金子户号】
                            3、调整第二组字段【出账账号、信贷合同号、科目代码、垫款标志、垫款借据编号、担保方式代码、逾期利率、保证金账号、保证金币种、保证金比例、保证金金额】的取数逻辑
                            4、调整第二组T2（借据信息）取数来源表：旧对公信贷 -> 新信贷、T16（汇率牌价）取数来源表：旧核心 -> 新核心。
            20220412 李森辉 1、调整第一组【境内保函】中字段【科目代码、保函种类代码、开立日期、注销日期、开立流水、注销流水、赔付金额】的取数口径
                            2、调整第二组【涉外保函】中字段【标准产品编号、科目代码】的取数口径
                            3、置空第一组【境内保函】中字段【注销方式代码、逾期利率】
            20220517 李森辉 调整第二组境外保函的【T20-核算映射关系】临时表的取数过滤条件，由ISB->ISBX
			      20220627 温旺清 1、调整第一组的字段【科目代码、保证金账号、保证金子户号、保证金币种、保证金比例、保证金金额】的加工口径
                            2、调整第二组的字段【科目代码】的加工口径
			      20220718 温旺清	1、增加字段【受益人国家代码】
			      20220805 温旺清 1、新增字段【代开行BIC、通知行BIC、最终受益行BIC、交易完成时间、折美元交易金额】
            20220805 李森辉 调整fin_accti_prod_rela_info取数条件，t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
			      20220808 温旺清【保函账户信息】：新增字段【代开行BIC、通知行BIC、最终受益行BIC、交易完成时间、折美元交易金额】
			      20220824 刘维勇 境外保函对T8表做子查询去重处理
            20221118 温旺清 调整第一组【保证金比例、保证金金额】口径
            20221223 陈伟峰 调整第一组【保证金金额】口径
            20221229 陈伟峰 调整BASE_ACCT_NO，做首位去0判断
            20230306 陈伟峰 调整第一组基数字段关联逻辑，增加投产日判断
            20230516 陈伟峰 调整第一组【当期余额、折本币当期余额】加工逻辑，当状态为04时余额置为0
            20230518 陈伟峰 调整字段中文名称【保函合同编号-》信贷借据编号】
                            调整字段【信贷借据编号】的加工口径
            20230522 翟若平 调整字段【保证金金额、保证金比例】的加工口径
            20230523 翟若平 调整字段【垫款标志、垫款借据编号】的加工口径
            20231107 徐子豪 新增字段【客户编号】
            20221223 陈伟峰 调整第一组cmm_prod_and_subj_map_rela关联条件，bus_type_cd in ('NCBS') ->bus_type_cd in ('LN')
			20250408 陈  凭 新增字段【经办柜员编号、经办柜员名称、复核柜员编号、复核柜员名称】
*/                          

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_log_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_log_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_log_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_log_acct_info_02 purge;
-- 1.3 insert data to tmp table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_log_acct_info_01
nologging
compress ${option_switch} for query high
as
select 
      clbr.log_id
      ,clbr.froz_id
      ,clbr.margin_acct_num
      ,clbr.margin_acct_sub_acct_num
      ,clbr.margin_acct_curr_cd
	    ,clbr.margin_amt
      ,rn 
from
(select m.log_id
        ,m.froz_id
        ,m.margin_acct_num
        ,m.margin_acct_sub_acct_num
        ,m.margin_acct_curr_cd
        ,nvl(rr.acct_lmt_amt, 0) as margin_amt
        ,row_number() over(partition by m.log_id order by m.froz_id asc, m.margin_acct_num asc) as rn 
   from ${iml_schema}.agt_log_and_margin_acct_rela_h m
   left join ${iol_schema}.ncbs_rb_acct_client_relation ra
     on m.margin_acct_num = (case when substr(ra.base_acct_no,1,1) = '0' then substr(ra.base_acct_no,2) else ra.base_acct_no end)
    and m.margin_acct_sub_acct_num = ra.acct_seq_no
    and m.margin_prod_id = ra.prod_type
    and m.margin_acct_curr_cd = ra.acct_ccy
    and ra.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and ra.end_dt > to_date('${batch_date}', 'yyyymmdd')
   left join ${iml_schema}.agt_dep_acct_lmt_info_h rr
     on m.froz_id = rr.lmt_id
    and ra.internal_key = rr.acct_id 
    and rr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and rr.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and rr.job_cd = 'ncbsf1'
    and rr.acct_lmt_status_cd = 'A'
  where m.start_dt <= to_date('${batch_date}','yyyymmdd')
    and m.end_dt > to_date('${batch_date}','yyyymmdd')
    and m.job_cd = 'ncbsf1') clbr
  where rn = 1
 ;
 commit;
 

-- 创建临时表
create table ${icl_schema}.tmp_cmm_log_acct_info_02 
nologging
compress ${option_switch} for query high
as 
select coalesce(trim(t3.sellbl_prod_id), t4.sellbl_prod_id,t2.base_prod_id) as prod_id,
       t1.amt_type_cd as amt_type_cd,
       t1.subj_id as pric_subj_id
  from ${iml_schema}.fin_accti_subj_rela_h t1
 inner join ${iml_schema}.fin_accti_prod_rela_info t2
    on t1.accti_id = t2.accti_id
   and t1.sob_id = t2.sob_id
   and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'tglsi1' 
  left join ${iml_schema}.prd_prod_catlg_h	t3			 
    on t2.base_prod_id = t3.sellbl_prod_id	
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')	
   and t3.job_cd = 'ncbsf1'	
  left join ${iml_schema}.prd_prod_catlg_h	t4			 
    on t2.base_prod_id = t4.base_prod_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')	
   and t4.job_cd = 'ncbsf1'	   
   and trim(t4.sellbl_prod_id) is not null
   and t4.sellbl_prod_id not in (select distinct pkp.paracd
                                  from ${iol_schema}.tgls_pcmc_knp_para pkp
                                 where pkp.subscd = 'RB'
                                   and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
                                   and pkp.paracd != '%'
                                   and pkp.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
                                   and pkp.end_dt > to_date('${batch_date}', 'YYYYMMDD')
                                )
 where t1.sob_id = 2
   and t1.job_cd = 'tglsf1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.bus_type_cd in ('NCBS', 'LN', 'BDMX', 'IFSX', 'ISBX')
   and t2.base_prod_id not like '5%'  --手续费	
   and t1.bus_type_cd = 'ISBX'	
   and t1.amt_type_cd in ('PRI', 'TYJE006', 'TYJE007', 'TYJE001', 'ISBX001', 'TYJE007', 'ISBX002','ISBX003', 'ISBX004', 'ISBX006', 'TYJE999', 'BAL')
 ;


-- 2.1 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_log_acct_info_ex purge;

-- 2.2 insert data to ex table
create table ${icl_schema}.cmm_log_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_log_acct_info where 0=1;

-- 第一组（共二组）境内保函
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_log_acct_info_ex(
       etl_dt                    -- 数据日期
       ,lp_id                    -- 法人编号
       ,acct_id                  -- 账户编号
       ,cust_id                  -- 客户编号
       ,bus_id                   -- 业务编号
       ,log_cont_id              -- 信贷借据编号
       ,log_acct_num             -- 保函账号
       ,std_prod_id              -- 标准产品编号
       ,out_acct_acct_num        -- 出账账号
       ,stl_acct_num             -- 结算账号
       ,crdt_contr_no            -- 信贷合同号
       ,recvbl_num               -- 收款账号
       ,subj_cd                  -- 科目代码
       ,log_kind_cd              -- 保函种类代码
       ,fin_log_flg              -- 融资性保函标志
       ,overs_log_flg            -- 境外保函标志
       ,advc_flg                 -- 垫款标志
       ,advc_dubil_id            -- 垫款借据编号
       ,log_status               -- 保函状态
       ,wrtoff_way               -- 注销方式
       ,guar_way_cd              -- 担保方式代码
       ,tenor                    -- 期限
       ,benefc_name              -- 受益人名称
       ,benefc_acct_num          -- 受益人账号
       ,benefc_open_bank_name    -- 受益人开户行名称
	   ,benefc_cty_cd            -- 受益人国家代码
       ,oper_teller_id	         -- 经办柜员编号
       ,oper_teller_name	     -- 经办柜员名称
       ,check_teller_id        	 -- 复核柜员编号
       ,check_teller_name	     -- 复核柜员名称
       ,open_bk_bic              -- 代开行BIC
       ,advise_bank_bic          -- 通知行BIC
       ,final_bnft_bk_bic        -- 最终受益行BIC
       ,tran_cmplt_tm            -- 交易完成时间
       ,usd_tran_amt             -- 折美元交易金额
       ,guar_org_id              -- 担保机构编号
       ,acct_instit_id           -- 账务机构编号
       ,mgmt_org_id              -- 管理机构编号
       ,oper_org_id              -- 经办机构编号
       ,open_dt                  -- 开立日期
       ,wrtoff_dt                -- 注销日期
       ,start_dt                 -- 起始日期
       ,exp_dt                   -- 到期日期
       ,open_flow                -- 开立流水
       ,wrtoff_flow              -- 注销流水
       ,curr_cd                  -- 币种代码
       ,nomal_int_rat            -- 正常利率
       ,ovdue_int_rat            -- 逾期利率
       ,advc_int_rat             -- 垫款利率
       ,comm_fee_rat             -- 手续费费率
       ,comm_fee_amt             -- 手续费金额
       ,compens_amt              -- 赔付金额
       ,advc_amt                 -- 垫款金额
       ,margin_acct_num          -- 保证金账号
       ,margin_sub_acct_num      -- 保证金子户号
       ,margin_curr              -- 保证金币种
       ,margin_ratio             -- 保证金比例
       ,margin_amt               -- 保证金金额
       ,log_amt                  -- 保函金额
       ,currt_bal                -- 当期余额
       ,cl_curr_currt_bal        -- 折本币当期余额
       ,ear_d_bal                -- 日初余额
       ,ear_m_bal                -- 月初余额
       ,ear_s_bal                -- 季初余额
       ,ear_y_bal                -- 年初余额
       ,y_acm_bal                -- 年累计余额
       ,s_acm_bal                -- 季累计余额
       ,m_acm_bal                -- 月累计余额
       ,cl_curr_ear_d_bal        -- 折本币日初余额
       ,cl_curr_ear_m_bal        -- 折本币月初余额
       ,cl_curr_ear_s_bal        -- 折本币季初余额
       ,cl_curr_ear_y_bal        -- 折本币年初余额
       ,cl_curr_y_acm_bal        -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal        -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal        -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
       ,y_avg_bal                -- 年日均余额
       ,q_avg_bal                -- 季日均余额
       ,m_avg_bal                -- 月日均余额
       ,cl_curr_y_avg_bal        -- 折本币年日均余额
       ,cl_curr_q_avg_bal        -- 折本币季日均余额
       ,cl_curr_m_avg_bal        -- 折本币月日均余额
       ,job_cd                   -- 任务代码
       ,etl_timestamp            -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                                                                    -- 数据日期
       ,t1.lp_id                                                                                                                              -- 法人编号
       ,t1.acct_id                                                                                                                            -- 账户编号
       ,t1.cust_id                                                                                                                            -- 客户编号
       ,''                                                                                                                                    -- 业务编号
       ,t1.dubil_id                                                                                                                           -- 信贷借据编号
       ,t1.log_id                                                                                                                             -- 保函账号
       ,t1.prod_id                                                                                                                            -- 标准产品编号
       ,t2.rela_out_acct_flow_num                                                                                                             -- 出账账号
       ,t1.pbc_clear_acct_num                                                                                                                 -- 结算账号
       ,t2.rela_cont_id                                                                                                                       -- 信贷合同号
       ,t1.benefc_acct_id                                                                                                                     -- 收款账号
       ,nvl(trim(t9.pric_subj_id), '71180101')                                                                                                -- 科目代码
       ,t1.prod_id                                                                                                                            -- 保函种类代码
       ,case when substr(t1.prod_id,1,7) = '6010301' then '1' else '0' end                                                                    -- 融资性保函标志
       ,'0'                                                                                                                                   -- 境外保函标志
       ,decode(nvl(trim(t11.advc_flg), '0'), '-', '0', nvl(trim(t11.advc_flg), '0')) as advc_flg                                              -- 垫款标志
       ,t11.dubil_id                                                                                                                          -- 垫款借据编号
       ,t1.log_status_cd                                                                                                                      -- 保函状态代码
       ,''                                                                                                                                    -- 注销方式代码
       ,t10.main_guar_way_cd                                                                                                                  -- 担保方式代码
       ,trunc(months_between(t1.exp_dt, t1.begin_dt))                                                                                         -- 期限
       ,t1.benefc_name                                                                                                                        -- 受益人名称
       ,t1.benefc_acct_id                                                                                                                     -- 受益人账号
       ,''                                                                                                                                    -- 受益人开户行名称
       ,'XXX'                                                                                                                                 -- 受益人国家代码
       ,''                                                                                                                                    -- 经办柜员编号                                                                                              
       ,''                                                                                                                                    -- 经办柜员名称                                                                                              
       ,''   	        	                                                                                                                  -- 复核柜员编号                                                                                              
       ,''                                                                                                                                    -- 复核柜员名称                                                                                              
       ,''                                                                                                                                    -- 代开行BIC
       ,''                                                                                                                                    -- 通知行BIC
       ,''                                                                                                                                    -- 最终受益行BIC
       ,''                                                                                                                                    -- 交易完成时间
       ,''                                                                                                                                    -- 折美元交易金额	   
       ,t1.guar_org_id                                                                                                                        -- 担保机构编号
       ,t1.guar_org_id                                                                                                                        -- 账务机构编号
       ,t1.guar_org_id                                                                                                                        -- 管理机构编号
       ,t1.guar_org_id                                                                                                                        -- 经办机构编号
       ,t1.begin_dt                                                                                                                           -- 开立日期
       --,t1.exp_dt                                                                                                                           -- 注销日期
       ,null                                                                                                                                  -- 注销日期
       ,t1.begin_dt                                                                                                                           -- 起始日期
       ,t1.exp_dt                                                                                                                             -- 到期日期
       ,coalesce(t5.open_flow,t5_1.open_flow,t6.tran_ref_no)                                                                                  -- 开立流水
       ,coalesce(t5.wrtoff_flow,t5_1.wrtoff_flow,t7.tran_ref_no)                                                                              -- 注销流水
       ,t1.curr_cd                                                                                                                            -- 币种代码
       ,''                                                                                                                                    -- 正常利率，C层未维护数据映射的字段
       ,''                                                                                                                                    -- 逾期利率
       ,''                                                                                                                                    -- 垫款利率，C层未维护数据映射的字段
       ,t3.comm_fee_rat                                                                                                                       -- 手续费费率
       ,round(nvl(t3.comm_fee_rat, 0) * nvl(t1.log_amt, 0) / 100, 2)                                                                          -- 手续费金额
       ,nvl(t1.log_amt, 0) - nvl(t1.surp_compens_amt, 0)                                                                                      -- 赔付金额
       ,t1.advc_amt                                                                                                                           -- 垫款金额
	     ,t8.margin_acct_num                                                                                                                  -- 保证金账号，
       ,t8.margin_acct_sub_acct_num                                                                                                           -- 保证金子户号
       ,t8.margin_acct_curr_cd                                                                                                                -- 保证金币种
       ,round(t8.margin_amt / t1.log_amt * 100, 2)                                                                                            -- 保证金比例
       ,t8.margin_amt                                                                                                                         -- 保证金金额
       ,nvl(t1.log_amt, 0)                                                                                                                    -- 保函金额
       ,decode(t1.log_status_cd,'05',0,'04',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0))                                            -- 当期余额
       ,decode(t1.log_status_cd,'05',0,'04',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1)            -- 折本币当期余额  
       ,coalesce(t5.currt_bal,t5_1.currt_bal, 0)                                                                                              -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t5.currt_bal,t5_1.currt_bal, 0) else coalesce(t5.ear_m_bal,t5_1.ear_m_bal, 0) end                                                  -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t5.currt_bal,t5_1.currt_bal, 0) else coalesce(t5.ear_s_bal,t5_1.ear_s_bal, 0) end                        -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t5.currt_bal,t5_1.currt_bal, 0) else coalesce(t5.ear_y_bal,t5_1.ear_y_bal, 0) end                                                -- 年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) else coalesce(t5.y_acm_bal,t5_1.y_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) end                             -- 年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) else coalesce(t5.s_acm_bal,t5_1.s_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) end     -- 季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) else coalesce(t5.m_acm_bal,t5_1.m_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) end                               -- 月累计余额
       ,coalesce(t5.cl_curr_currt_bal,t5_1.cl_curr_currt_bal, 0)                                                                                                                          -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t5.cl_curr_currt_bal,t5_1.cl_curr_currt_bal, 0) else coalesce(t5.cl_curr_ear_m_bal,t5_1.cl_curr_ear_m_bal, 0) end                                  -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t5.cl_curr_currt_bal,t5_1.cl_curr_currt_bal, 0) else coalesce(t5.cl_curr_ear_s_bal,t5_1.cl_curr_ear_s_bal, 0) end        -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t5.cl_curr_currt_bal,t5_1.cl_curr_currt_bal, 0) else coalesce(t5.cl_curr_ear_y_bal,t5_1.cl_curr_ear_y_bal, 0) end                                -- 折本币年初余额    
       ,case when substr('${batch_date}',5,4) = '0101' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) else coalesce(t5.cl_curr_y_acm_bal,t5_1.cl_curr_y_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) end  -- 折本币年累计余额
       ,coalesce(t5.cl_curr_y_acm_bal,t5_1.cl_curr_y_acm_bal, 0)                                                                                                                          -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t5.cl_curr_y_acm_bal,t5_1.cl_curr_y_acm_bal, 0) else coalesce(t5.cl_curr_ear_m_y_acm_bal,t5_1.cl_curr_ear_m_y_acm_bal, 0) end                            -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t5.cl_curr_y_acm_bal,t5_1.cl_curr_y_acm_bal, 0) else coalesce(t5.cl_curr_ear_s_y_acm_bal,t5_1.cl_curr_ear_s_y_acm_bal, 0) end  -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t5.cl_curr_y_acm_bal,t5_1.cl_curr_y_acm_bal, 0) else coalesce(t5.cl_curr_ear_y_y_acm_bal,t5_1.cl_curr_ear_y_y_acm_bal, 0) end                          -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) else coalesce(t5.cl_curr_s_acm_bal,t5_1.cl_curr_s_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) end  -- 折本币季累计余额
       ,coalesce(t5.cl_curr_s_acm_bal,t5_1.cl_curr_s_acm_bal, 0)                                                                                                                          -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t5.cl_curr_s_acm_bal,t5_1.cl_curr_s_acm_bal, 0) else coalesce(t5.cl_curr_ear_s_s_acm_bal,t5_1.cl_curr_ear_s_s_acm_bal, 0) end  -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t5.cl_curr_s_acm_bal,t5_1.cl_curr_s_acm_bal, 0) else coalesce(t5.cl_curr_ear_y_s_acm_bal, t5_1.cl_curr_ear_y_s_acm_bal,0) end                          -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) else coalesce(t5.cl_curr_m_acm_bal,t5_1.cl_curr_m_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) end  -- 折本币月累计余额
       ,coalesce(t5.cl_curr_m_acm_bal,t5_1.cl_curr_m_acm_bal, 0)                                                                                                                          -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t5.cl_curr_m_acm_bal,t5_1.cl_curr_m_acm_bal, 0) else coalesce(t5.cl_curr_ear_m_m_acm_bal,t5_1.cl_curr_ear_m_m_acm_bal, 0) end                            -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t5.cl_curr_m_acm_bal,t5_1.cl_curr_m_acm_bal, 0) else coalesce(t5.cl_curr_ear_y_m_acm_bal,t5_1.cl_curr_ear_y_m_acm_bal, 0) end                          -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) else coalesce(t5.y_acm_bal,t5_1.y_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) else coalesce(t5.s_acm_bal,t5_1.s_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) else coalesce(t5.m_acm_bal,t5_1.m_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) end) / to_number(substr('${batch_date}', 7, 2))  -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) else coalesce(t5.cl_curr_y_acm_bal,t5_1.cl_curr_y_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) else coalesce(t5.cl_curr_s_acm_bal,t5_1.cl_curr_s_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then decode(t1.log_status_cd,'05',0,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) else coalesce(t5.cl_curr_m_acm_bal,t5_1.cl_curr_m_acm_bal, 0) + decode(t1.log_status_cd,'01',nvl(t1.log_amt, 0),nvl(t1.surp_compens_amt, 0)) * nvl(t4.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2))  -- 折本币月日均余额
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_log_acct_h t1
  left join ${iml_schema}.agt_loan_dubil_info_h t2
    on t1.dubil_id = t2.dubil_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_out_acct_appl_h t3
    on t2.rela_out_acct_flow_num = t3.out_acct_flow_num
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t4
    on t1.curr_cd = t4.curr_cd
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_log_acct_info t5  -- 取前一天数据
    on t1.lp_id = t5.lp_id
   and t1.acct_id = t5.acct_id
   and t5.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  >to_date('20230502', 'yyyymmdd')    --新一代投产时0501为旧数据，0502为新数据，0502日前的数据关联前一日需使用借据号关联(包括0502)，0503日后的数据需使用账号关联
  left join ${icl_schema}.cmm_log_acct_info t5_1  -- 取前一天数据
    on t1.lp_id = t5_1.lp_id
   and t1.log_cont_id = t5_1.log_cont_id  --初始化使用
   and t5_1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  <=to_date('20230502', 'yyyymmdd')    --新一代投产时0501为旧数据，0502为新数据，0502日前的数据关联前一日需使用借据号关联(包括0502)，0503日后的数据需使用账号关联
  left join 
  (select t.*,
       row_number() over(partition by t.acct_id order by t.tran_flow_num desc) rn
  from ${iml_schema}.evt_log_tran_flow t
 where t.job_cd = 'ncbsi1'
   and t.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t.log_status_cd = '01'
  ) t6
    on t1.acct_id = t6.acct_id
   and t6.rn = 1
  left join 
  (select t.*,
       row_number() over(partition by t.acct_id order by t.tran_flow_num desc) rn
  from ${iml_schema}.evt_log_tran_flow t
 where t.job_cd = 'ncbsi1'
   and t.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t.log_status_cd = '05'
  ) t7
    on t1.acct_id = t7.acct_id
   and t7.rn = 1
  left join ${icl_schema}.tmp_cmm_log_acct_info_01 t8
    on t1.log_id = t8.log_id
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t9	
    on t1.prod_id = t9.sellbl_prod_id			
   and t9.bus_type_cd in ('LN')	  -- 临时处理，lsh：去掉'LN' 2022-8-5 21:21:58
   and t9.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_loan_cont_info_h t10
    on t2.rela_cont_id = t10.cont_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_dubil_info_h t11
    on t11.init_dubil_id = t2.dubil_id
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'icmsf1'
  /*left join ${iml_schema}.pty_teller_info_h t12
    on t1.tran_teller_id = t12.teller_id
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.pty_teller_info_h t13
    on t1.check_teller_id = t13.teller_id
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')*/
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
   and trim(t1.acct_id) is not null
;
commit;

-- 第二组（共二组）境外保函
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_log_acct_info_ex(
       etl_dt                    -- 数据日期
       ,lp_id                    -- 法人编号
       ,acct_id                  -- 账户编号
       ,cust_id                  -- 客户编号
       ,bus_id                   -- 业务编号
       ,log_cont_id              -- 信贷借据编号
       ,log_acct_num             -- 保函账号
       ,std_prod_id              -- 标准产品编号
       ,out_acct_acct_num        -- 出账账号
       ,stl_acct_num             -- 结算账号
       ,crdt_contr_no            -- 信贷合同号
       ,recvbl_num               -- 收款账号
       ,subj_cd                  -- 科目代码
       ,log_kind_cd              -- 保函种类代码
       ,fin_log_flg              -- 融资性保函标志
       ,overs_log_flg            -- 境外保函标志
       ,advc_flg                 -- 垫款标志
       ,advc_dubil_id            -- 垫款借据编号
       ,log_status               -- 保函状态
       ,wrtoff_way               -- 注销方式
       ,guar_way_cd              -- 担保方式代码
       ,tenor                    -- 期限
       ,benefc_name              -- 受益人名称
       ,benefc_acct_num          -- 受益人账号
       ,benefc_open_bank_name    -- 受益人开户行名称
	   ,benefc_cty_cd            -- 受益人国家代码
	   ,oper_teller_id	         -- 经办柜员编号
       ,oper_teller_name	     -- 经办柜员名称
       ,check_teller_id        	 -- 复核柜员编号
       ,check_teller_name	     -- 复核柜员名称
       ,open_bk_bic              -- 代开行BIC
       ,advise_bank_bic          -- 通知行BIC
       ,final_bnft_bk_bic        -- 最终受益行BIC
       ,tran_cmplt_tm            -- 交易完成时间
       ,usd_tran_amt             -- 折美元交易金额
       ,guar_org_id              -- 担保机构编号
       ,acct_instit_id           -- 账务机构编号
       ,mgmt_org_id              -- 管理机构编号
       ,oper_org_id              -- 经办机构编号
       ,open_dt                  -- 开立日期
       ,wrtoff_dt                -- 注销日期
       ,start_dt                 -- 起始日期
       ,exp_dt                   -- 到期日期
       ,open_flow                -- 开立流水
       ,wrtoff_flow              -- 注销流水
       ,curr_cd                  -- 币种代码
       ,nomal_int_rat            -- 正常利率
       ,ovdue_int_rat            -- 逾期利率
       ,advc_int_rat             -- 垫款利率
       ,comm_fee_rat             -- 手续费费率
       ,comm_fee_amt             -- 手续费金额
       ,compens_amt              -- 赔付金额
       ,advc_amt                 -- 垫款金额
       ,margin_acct_num          -- 保证金账号
       ,margin_sub_acct_num      -- 保证金子户号
       ,margin_curr              -- 保证金币种
       ,margin_ratio             -- 保证金比例
       ,margin_amt               -- 保证金金额
       ,log_amt                  -- 保函金额
       ,currt_bal                -- 当期余额
       ,cl_curr_currt_bal        -- 折本币当期余额
       ,ear_d_bal                -- 日初余额
       ,ear_m_bal                -- 月初余额
       ,ear_s_bal                -- 季初余额
       ,ear_y_bal                -- 年初余额
       ,y_acm_bal                -- 年累计余额
       ,s_acm_bal                -- 季累计余额
       ,m_acm_bal                -- 月累计余额
       ,cl_curr_ear_d_bal        -- 折本币日初余额
       ,cl_curr_ear_m_bal        -- 折本币月初余额
       ,cl_curr_ear_s_bal        -- 折本币季初余额
       ,cl_curr_ear_y_bal        -- 折本币年初余额
       ,cl_curr_y_acm_bal        -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal        -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal        -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
       ,y_avg_bal                -- 年日均余额
       ,q_avg_bal                -- 季日均余额
       ,m_avg_bal                -- 月日均余额
       ,cl_curr_y_avg_bal        -- 折本币年日均余额
       ,cl_curr_q_avg_bal        -- 折本币季日均余额
       ,cl_curr_m_avg_bal        -- 折本币月日均余额
       ,job_cd                   -- 任务代码
       ,etl_timestamp            -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                                                                                       -- 数据日期
       ,'9999'                                                                                                                                                   -- 法人编号
       ,t1.fincod                                                                                                                                                -- 账户编号
       ,case when t1.ownref like 'AG%' then t23.addr_keyw                                                                                                        
             when t1.ownref like '%LG%' then t5.addr_keyw                                                                                                        
        else '' end                                                                                                                                              -- 客户编号
       ,t1.ownref                                                                                                                                                -- 业务编号
       ,t1.fincod                                                                                                                                                -- 信贷借据编号
       ,t1.inr                                                                                                                                                   -- 保函账号
       ,t21.pdtcod5                                                                                                                                              -- 标准产品编号
       ,t2.rela_out_acct_flow_num                                                                                                                                -- 出账账号
       ,t4.tran_acct_id                                                                                                                                          -- 结算账号
       ,t2.rela_cont_id                                                                                                                                          -- 信贷合同号
       ,t4.tran_acct_id                                                                                                                                          -- 收款账号
       ,t20.pric_subj_id                                                                                                                                         -- 科目代码
       ,nvl(substr(trim(t9.txt),1,4), '99')                                                                                                                      -- 保函种类代码
       ,decode(t1.garfin, '1', '1', '0')                                                                                                                         -- 融资性保函标志
       ,'1'                                                                                                                                                      -- 境外保函标志
       ,decode(nvl(trim(t35.advc_flg), '0'), '-', '0', nvl(trim(t35.advc_flg), 0)) as advc_flg                                                                   -- 垫款标志
       ,t35.dubil_id                                                                                                                                             -- 垫款借据编号
       ,case when trim(t1.clsdat) is not null and t1.clsdat <> to_date('0001/01/01', 'yyyy/mm/dd') then '05' else '01' end                                       -- 保函状态代码
       ,case when trim(t1.clsdat) is not null and t1.clsdat <> to_date('0001/01/01', 'yyyy/mm/dd') then '1' else '0' end                                         -- 注销方式代码
       ,t2.main_guar_way_cd                                                                                                                                      -- 担保方式代码
       ,trunc(months_between(t1.expdat, t1.orddat))                                                                                                              -- 期限
       ,t6.party_name                                                                                                                                            -- 受益人名称
       ,t6.addr_ref_descb                                                                                                                                        -- 受益人账号
       ,''                                                                                                                                                       -- 受益人开户行名称
	   ,t25.target_cd_val                                                                                                                                        -- 受益人国家代码
	   ,nvl(trim(t36.usr),' ')	                                                                                                                                 -- 经办柜员编号
       ,nvl(trim(t36.nam),' ')	 	                                                                                                                             -- 经办柜员名称
       ,nvl(trim(t37.usr),' ')	         	                                                                                                                     -- 复核柜员编号
       ,nvl(trim(t37.nam),' ')	 	                                                                                                                             -- 复核柜员名称
	   ,t31.bic_code                                                                                                                                             -- 代开行BIC
       ,t32.bic_code                                                                                                                                             -- 通知行BIC
       ,t33.bic_code                                                                                                                                             -- 最终受益行BIC
       ,t3.tran_cmplt_tm                                                                                                                                         -- 交易完成时间
       ,decode(t3.curr_cd, 'USD', t3.tran_amt, round(t3.auth_amt * t34.rat, 2))                                                                                  -- 折美元交易金额
       ,''                                                                                                                                                       -- 担保机构编号
       ,t13.org_id                                                                                                                                               -- 账务机构编号
       ,t13.org_id                                                                                                                                               -- 管理机构编号
       ,t14.org_id                                                                                                                                               -- 经办机构编号
       ,t1.credat                                                                                                                                                -- 开立日期
       ,t1.clsdat                                                                                                                                                -- 注销日期
       ,t1.orddat                                                                                                                                                -- 起始日期
       ,t1.expdat                                                                                                                                                -- 到期日期
       ,t3.src_evt_id                                                                                                                                            -- 开立流水
       ,t15.src_evt_id                                                                                                                                           -- 注销流水
       ,nvl(trim(t11.curr_cd), 'CNY')                                                                                                                            -- 币种代码
       ,''                                                                                                                                                       -- 正常利率，C层未维护数据映射的字段
       ,t2.ovdue_int_rat                                                                                                                                         -- 逾期利率
       ,''                                                                                                                                                       -- 垫款利率，C层未维护数据映射的字段
       ,nvl(t7.entry_amt, 0) / nvl(t11.amt, 1) * 100                                                                                                             -- 手续费费率
       ,nvl(t7.entry_amt, 0)                                                                                                                                     -- 手续费金额
       ,0                                                                                                                                                        -- 赔付金额
       ,0                                                                                                                                                        -- 垫款金额
       ,trim(t18.margin_acct_id)                                                                                                                                 -- 保证金账号
       ,t18.margin_sub_acct_num                                                                                                                                  -- 保证金子户号
       ,nvl(decode(trim(t18.margin_curr_cd),'-','CNY',trim(t18.margin_curr_cd)), 'CNY')                                                                          -- 保证金币种
       ,nvl(t18.margin_ratio, 0)                                                                                                                                 -- 保证金比例
       ,nvl(t18.margin_amt, 0)                                                                                                                                   -- 保证金金额
       ,nvl(t11.amt, 0)                                                                                                                                          -- 保函金额
       ,nvl(t10.amt, 0)                                                                                                                                          -- 当期余额
       ,nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1)                                                                                                         -- 折本币当期余额
       ,nvl(t17.currt_bal, 0)                                                                                                                                    -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t17.currt_bal, 0) else nvl(t17.ear_m_bal, 0) end                                                   -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t17.currt_bal, 0) else nvl(t17.ear_s_bal, 0) end                         -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t17.currt_bal, 0) else nvl(t17.ear_y_bal, 0) end                                                 -- 年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t10.amt, 0) else nvl(t17.y_acm_bal, 0) + nvl(t10.amt, 0) end                                     -- 年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t10.amt, 0) else nvl(t17.s_acm_bal, 0) + nvl(t10.amt, 0) end             -- 季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t10.amt, 0) else nvl(t17.m_acm_bal, 0) + nvl(t10.amt, 0) end                                       -- 月累计余额
       ,nvl(t17.cl_curr_currt_bal, 0)  -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t17.cl_curr_currt_bal, 0) else nvl(t17.cl_curr_ear_m_bal, 0) end                                   -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t17.cl_curr_currt_bal, 0) else nvl(t17.cl_curr_ear_s_bal, 0) end         -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t17.cl_curr_currt_bal, 0) else nvl(t17.cl_curr_ear_y_bal, 0) end                                 -- 折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t17.cl_curr_y_acm_bal, 0) + nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) end  -- 折本币年累计余额
       ,nvl(t17.cl_curr_y_acm_bal, 0)  -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t17.cl_curr_y_acm_bal, 0) else nvl(t17.cl_curr_ear_m_y_acm_bal, 0) end                             -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t17.cl_curr_y_acm_bal, 0) else nvl(t17.cl_curr_ear_s_y_acm_bal, 0) end   -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t17.cl_curr_y_acm_bal, 0) else nvl(t17.cl_curr_ear_y_y_acm_bal, 0) end                           -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t17.cl_curr_s_acm_bal, 0) + nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) end  -- 折本币季累计余额
       ,nvl(t17.cl_curr_s_acm_bal, 0)  -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t17.cl_curr_s_acm_bal, 0) else nvl(t17.cl_curr_ear_s_s_acm_bal, 0) end   -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t17.cl_curr_s_acm_bal, 0) else nvl(t17.cl_curr_ear_y_s_acm_bal, 0) end                           -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t17.cl_curr_m_acm_bal, 0) + nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) end  -- 折本币月累计余额
       ,nvl(t17.cl_curr_m_acm_bal, 0)  -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t17.cl_curr_m_acm_bal, 0) else nvl(t17.cl_curr_ear_m_m_acm_bal, 0) end                             -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t17.cl_curr_m_acm_bal, 0) else nvl(t17.cl_curr_ear_y_m_acm_bal, 0) end                           -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t10.amt, 0) else nvl(t17.y_acm_bal, 0) + nvl(t10.amt, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t10.amt, 0) else nvl(t17.s_acm_bal, 0) + nvl(t10.amt, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t10.amt, 0) else nvl(t17.m_acm_bal, 0) + nvl(t10.amt, 0) end) / to_number(substr('${batch_date}', 7, 2))  -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t17.cl_curr_y_acm_bal, 0) + nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)  -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t17.cl_curr_s_acm_bal, 0) + nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) else nvl(t17.cl_curr_m_acm_bal, 0) + nvl(t10.amt, 0) * nvl(t16.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2))  -- 折本币月日均余额
       ,'isbsf1'                               -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iol_schema}.isbs_gid t1 
  left join ${iml_schema}.agt_loan_dubil_info_h t2
    on t1.fincod = t2.dubil_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.evt_intstl_tran_flow_evt t3
    on t3.bus_tab_flow_num = t1.inr
   and t3.bus_table_name = 'GID'
   and t3.tran_code = 'GITOPN'
   and t3.auth_status_cd = 'R'
   --and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'isbsf1' 
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}','yyyymmdd') 
   left join(select t.*,r.rat 
	            from ${iml_schema}.evt_intstl_tran_flow_evt t 
                inner join ${iol_schema}.isbs_rat r
                  on r.mon = (select max(mon) from ${iol_schema}.isbs_rat where cur = 'CNY' and mon <= to_char(t.tran_cmplt_tm, 'yyyymm'))
                 and r.CUR = 'CNY'
                 and r.start_dt <= to_date('${batch_date}','yyyymmdd')        
                 and r.end_dt > to_date('${batch_date}','yyyymmdd') 
               where t.bus_table_name = 'GID' and t.tran_code in ('GITOPN') and t.auth_status_cd = 'R'
               and t.start_dt <= to_date('${batch_date}','yyyymmdd') 
               and t.end_dt > to_date('${batch_date}','yyyymmdd')
                 and t.job_cd = 'isbsf1') t34
	on t34.bus_tab_flow_num = t1.inr	   			   
  left join ${iml_schema}.evt_intstl_acct_ety_tran_evt t4
    on t4.tran_flow_num = t3.src_evt_id
   and t4.dubil_id like 'LO-%'
   and t4.debit_crdt_dir_cd = 'D'
   and t4.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'isbsi1'
  left join ${iml_schema}.agt_intstl_party_rela_h t5
    on t5.src_agt_id = t1.inr
   and t5.bus_table_name = 'GID'
   and t5.role_type_cd = 'APL'
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'isbsf1'
  left join ${iml_schema}.agt_intstl_party_rela_h t6
    on t6.src_agt_id = t1.inr
   and t6.bus_table_name = 'GID'
   and t6.role_type_cd = 'ADV'
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'isbsf1'
  left join ${iml_schema}.evt_intstl_acct_ety_tran_evt t7
    on t7.tran_flow_num = t3.src_evt_id
   and t7.dubil_id = 'SC-GIO'
   and t7.debit_crdt_dir_cd = 'C'
   and t7.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'isbsi1'
  left join 
     (select t.*
            ,row_number()over(partition by t.objinr order by t.inr desc) as rn 
        from iol.isbs_pte t
       where t.start_dt <= to_date('${batch_date}','yyyymmdd') 
         and t.end_dt > to_date('${batch_date}','yyyymmdd') --modify by liuweiyong,provide by lipeng
         and t.objtyp = 'PTS'
      ) t8
    on t8.objinr = t5.rela_id
   and t8.rn =1
  left join ${iol_schema}.isbs_stb t9
    on t1.gartyp = t9.cod
   and t1.giduil = t9.uil
   and t9.tbl='GARTYP'
   and t9.etl_dt<= to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_intstl_bal_h t10 
    on t10.src_agt_id = t8.inr
   and t10.bus_table_name = 'PTE'
   and t10.ext_amt_type = 'AMT1'
   and to_char(t10.amt_vp_end_dt, 'yyyy') = '2299'
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'isbsf1'
  left join ${iml_schema}.agt_intstl_amt_h t11
    on t11.tran_evt_id = t3.src_evt_id
   and t11.src_agt_id = t1.inr
   and t11.bus_table_name = 'GID'
   and t11.ext_amt_type = 'AMT1'
   and t11.amt_type_cd = '053'
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'isbsf1'
  left join ${iml_schema}.agt_intstl_amt_h t12
    on t12.amt_id = t10.cors_amt_src_id
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   and t12.job_cd = 'isbsf1'
  left join ${iml_schema}.org_int_org_rela_h t13
    on t1.branchinr = t13.seq_num
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   and t13.job_cd = 'isbsf1'
  left join ${iml_schema}.org_int_org_rela_h t14
    on t1.bchkeyinr = t14.seq_num
   and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t14.end_dt > to_date('${batch_date}','yyyymmdd')
   and t14.job_cd = 'isbsf1'
  left join ${iml_schema}.evt_intstl_tran_flow_evt t15
    on t15.bus_tab_flow_num = t1.inr
   and t15.bus_table_name = 'GID'
   and t15.tran_code = 'GITCAN'
   and t15.auth_status_cd = 'R'
   and t15.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t15.end_dt > to_date('${batch_date}','yyyymmdd')
   and t15.job_cd = 'isbsf1'
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t16
    on t11.curr_cd = t16.curr_cd
   and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t16.end_dt > to_date('${batch_date}','yyyymmdd')
   and t16.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_log_acct_info t17  -- 取前一天数据
    on t17.lp_id = '9999'
   and t1.fincod = t17.acct_id
   and t17.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
  left join ${iml_schema}.agt_loan_out_acct_appl_h t18
    on t2.rela_out_acct_flow_num = t18.out_acct_flow_num
   and t18.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t18.end_dt > to_date('${batch_date}','yyyymmdd')
   and t18.job_cd = 'icmsf1'
  left join ${iol_schema}.isbs_bus_pdt t21
    on t1.inr = t21.objinr
   and t21.objtyp = 'GID'
 left join ${icl_schema}.tmp_cmm_log_acct_info_02 t20		
    on t21.pdtcod5 = t20.prod_id			
   and t21.amttypcod = t20.amt_type_cd	
/*  left join ${icl_schema}.cmm_prod_and_subj_map_rela t20	
    on t21.pdtcod5 = t20.sellbl_prod_id			
   and t20.bus_type_cd = 'ISBX'	  
   and t20.etl_dt = to_date('${batch_date}', 'yyyymmdd')
*/
 left join ${iml_schema}.agt_intstl_party_rela_h t23
    on t1.inr = t23.src_agt_id
   and t23.bus_table_name = 'GID'
   and t23.role_type_cd = 'BEN'
   and t23.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t23.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t23.job_cd = 'isbsf1'
  left join ${iml_schema}.pty_intstl_addr_rela_h t24
    on t23.party_addr_rela_id = t24.rela_id
   and t24.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t24.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t24.job_cd = 'isbsf1'
  left join ${iol_schema}.isbs_adr t22
    on t24.addr_id=t22.inr
   and t22.start_dt <= to_date('${batch_date}', 'yyyymmdd')     
   and t22.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map t25
    on t22.loccty=t25.src_code_val
   and t25.sorc_sys_cd ='ISBS'    
   and t25.src_field_en_name='STACTY'
   and t25.src_tab_en_name = 'ISBS_GID'  
  left join ${iml_schema}.agt_intstl_party_rela_h t26 
    on t1.inr = t26.src_agt_id 
   and t26.agt_type_cd = '226303' 
   and t26.role_type_cd = 'ISS'
   and t26.job_cd ='isbsf1'
   and t26.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t26.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.agt_intstl_party_rela_h t27 
   on t1.inr = t27.src_agt_id 
  and t27.agt_type_cd = '226303' 
  and t27.role_type_cd = 'AGE'
  and t27.job_cd ='isbsf1'
  and t27.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t27.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.agt_intstl_party_rela_h t28 
   on t1.inr = t28.src_agt_id 
  and t28.agt_type_cd = '226303' 
  and t28.role_type_cd = 'ATB'
  and t28.job_cd ='isbsf1'
  and t28.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t28.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.agt_intstl_party_rela_h t29 
   on t1.inr = t29.src_agt_id 
  and t29.agt_type_cd = '226303' 
  and t29.role_type_cd = 'AT2'
  and t29.job_cd ='isbsf1'
  and t29.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t29.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.agt_intstl_party_rela_h t30 
   on t1.inr = t30.src_agt_id 
  and t30.agt_type_cd = '226303' 
  and t30.role_type_cd = 'BEC'
  and t30.job_cd ='isbsf1'
  and t30.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t30.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.pty_intstl_addr_rela_h t31 
   on t31.rela_id = nvl(trim(t27.party_addr_rela_id),t26.party_addr_rela_id)
  and t31.job_cd ='isbsf1'
  and t31.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t31.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.pty_intstl_addr_rela_h t32 
   on t32.rela_id = coalesce(trim(t29.party_addr_rela_id), trim(t28.party_addr_rela_id),t6.party_addr_rela_id)
  and t32.job_cd ='isbsf1'
  and t32.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t32.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.pty_intstl_addr_rela_h t33 
   on t33.rela_id = nvl(trim(t30.party_addr_rela_id), t23.party_addr_rela_id)
  and t33.job_cd ='isbsf1'
  and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.agt_loan_dubil_info_h t35
    on t35.init_dubil_id = t2.dubil_id
   and t35.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t35.end_dt > to_date('${batch_date}','yyyymmdd')
   and t35.job_cd = 'icmsf1'
 left join ${iol_schema}.isbs_trs t36
    on t3.src_evt_id = t36.objinr
   and t36.objtyp = 'TRN'
   and t36.sigidx = 'SG1' -- 经办人                                                             
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_trs t37
    on t3.src_evt_id = t37.objinr
   and t37.objtyp = 'TRN'
   and t37.sigidx = 'SG2' -- 复核人                                                                
   and t37.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t37.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and trim(t1.fincod) is not null
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_log_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_log_acct_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_log_acct_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_log_acct_info_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_log_acct_info',partname =>'p_${batch_date}', degree => 8, cascade => true);