/*
purpose:    共性加工层-产品与科目映射关系，数据来源包括新核心系统、票据系统、国结系统、微众联合存的产品与科目的映射关系。数据主要来源于核算中台和新核心系统的产品工厂。
author:     sunline
usage:      python $ETL_HOME/script/main.py 20220531 icl_cmm_prod_and_subj_map_rela
createdate: 20210205
logs: 20220623 温旺清  新增模型
      20220705 李森辉 调整本金科目的映射规则：增加金额类型'NCBS018'
	  20220706 翟若平 调整【T1-产品科目映射关系表】的脚本逻辑，主要是修改票据各类科目对应的金额类型							
      20220718 朱觉军	1、新增字段【核算产品属性代码1】
                        2、新增主键字段【核算产品属性代码1】						
      20220724 翟若平	1、新增字段【内部账户本金科目编号】
                        2、调整临时表T1-产品科目映射关系表的加工口径							
      20220729 朱觉军	调整T1表本金科目的映射规则：删除金额类型'NCBS005','NCBS006'	
      20221025 温旺清   1、prd_prod_catlg_h	增加产品状态条件，过滤测试数据，0-待生效，'-'  

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_prod_and_subj_map_rela drop partition p_${retain_day};
alter table ${icl_schema}.cmm_prod_and_subj_map_rela add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_prod_and_subj_map_rela_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_prod_and_subj_map_rela_ex purge;
drop table ${icl_schema}.tmp_cmm_prod_and_subj_map_rela_01 purge;

-- 2.1 create temporary table cmm_prod_and_subj_map_rela_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_prod_and_subj_map_rela_ex         
nologging                                                 
compress ${option_switch} for query high                  
as                                                        
select * from ${icl_schema}.cmm_prod_and_subj_map_rela where 0=1;


--2.1 create tmp_cmm_prod_and_subj_map_rela_info_01 table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_prod_and_subj_map_rela_01(
	bus_type_cd varchar2(30) , 
	prod_id varchar2(30) , 
    accti_prod_attr_cd1 varchar2(30) , 
	pric_subj_id varchar2(30) , 
	intnal_acct_pric_subj_id VARCHAR2(60),
	recvbl_pay_int_subj_id varchar2(30) , 
	recvbl_pay_int_adj_subj_id varchar2(30) , 
	recvbl_uncol_int_subj_id varchar2(30) , 
	int_income_expns_subj_id varchar2(30) , 
	spd_pl_subj_id varchar2(30) , 
	acru_aldy_impam_int_subj_id varchar2(30) , 
	non_acru_int_recvbl_subj_id varchar2(30) , 
	wrt_off_pric_subj_id varchar2(30) , 
	wrt_off_int_subj_id varchar2(30) , 
	impam_loss_subj_id varchar2(30) , 
	deval_resv_subj_id varchar2(30) , 
	oth_acct_recvbl_impam_prep_sub varchar2(30) , 
	output_tax_lmt_subj_id varchar2(30)
	
)
nologging
compress ${option_switch} for query high
;
insert into ${icl_schema}.tmp_cmm_prod_and_subj_map_rela_01(
	bus_type_cd, 
	prod_id, 
    accti_prod_attr_cd1,
	pric_subj_id, 
	intnal_acct_pric_subj_id,
	recvbl_pay_int_subj_id, 
	recvbl_pay_int_adj_subj_id, 
	recvbl_uncol_int_subj_id, 
	int_income_expns_subj_id, 
	spd_pl_subj_id, 
	acru_aldy_impam_int_subj_id, 
	non_acru_int_recvbl_subj_id, 
	wrt_off_pric_subj_id, 
	wrt_off_int_subj_id, 
	impam_loss_subj_id, 
	deval_resv_subj_id, 
	oth_acct_recvbl_impam_prep_sub, 
	output_tax_lmt_subj_id

)
  select sd.bus_type_cd, 
       sdp.base_prod_id as prod_id,
	   replace(sdp.prod_attr_cd,'-','*') as accti_prod_attr_cd1,
       max(case when sd.amt_type_cd in ('BAL', 'OSL', 'PRD', 'PRI', 'NCBS018', 'BDMX003',
                                   'ISBX001', 'ISBX002', 'ISBX003', 'ISBX004', 'ISBX006', 'TYJE001', 'TYJE006', 'TYJE007') 
                then sd.subj_id else '' end) as pric_subj_id,
       max(case when sd.amt_type_cd in ('DOS') 
                then sd.subj_id else '' end) as intnal_acct_pric_subj_id,
       max(case when sd.amt_type_cd in ('INT', 'TYJE002', 'TYJE003') then sd.subj_id else '' end) as recvbl_pay_int_subj_id,
       max(case when sd.amt_type_cd in ('DS', 'BDMX001', 'BDMX004', 'IFSX001') then sd.subj_id else '' end) as recvbl_pay_int_adj_subj_id,
       max(case when sd.amt_type_cd in ('NCBS011') then sd.subj_id else '' end) as recvbl_uncol_int_subj_id,
       max(case when sd.amt_type_cd in ('NCBS003', 'NCBS004', 'NCBS007', 'NCBS008', 'NCBS009', 'TYJE004', 'TYJE005') then sd.subj_id else '' end) as int_income_expns_subj_id,
       max(case when sd.amt_type_cd in ('BDMX005', 'BDMX002') then sd.subj_id else '' end) as spd_pl_subj_id,
       max(case when sd.amt_type_cd in ('NCBS012') then sd.subj_id else '' end) as acru_aldy_impam_int_subj_id,
       max(case when sd.amt_type_cd in ('NCBS013') then sd.subj_id else '' end) as non_acru_int_recvbl_subj_id, 
       max(case when sd.amt_type_cd in ('NCBS014') then sd.subj_id else '' end) as wrt_off_pric_subj_id,
       max(case when sd.amt_type_cd in ('NCBSCL007') then sd.subj_id else '' end) as wrt_off_int_subj_id,
       max(case when sd.amt_type_cd in ('NCBS019') then sd.subj_id else '' end) as impam_loss_subj_id,
       max(case when sd.amt_type_cd in ('NCBS020') then sd.subj_id else '' end) as deval_resv_subj_id,
       max(case when sd.amt_type_cd in ('NCBS021') then sd.subj_id else '' end) as oth_acct_recvbl_impam_prep_subj_id,
       max(case when sd.amt_type_cd in ('TYJE010') then sd.subj_id else '' end) as output_tax_lmt_subj_id
  from ${iml_schema}.fin_accti_subj_rela_h sd
 inner join ${iml_schema}.fin_accti_prod_rela_info sdp
    on sd.accti_id = sdp.accti_id
   and sd.sob_id = sdp.sob_id
   and sdp.etl_dt <=to_date('${batch_date}', 'yyyymmdd')
   and sdp.job_cd = 'tglsi1'
 where sd.sob_id = 2
   and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and sd.bus_type_cd in ('NCBS', 'LN', 'BDMX', 'IFSX', 'ISBX')
   and sdp.base_prod_id not like '5%' --手续费
   and sd.job_cd = 'tglsf1'
 group by sd.bus_type_cd, sdp.base_prod_id,sdp.prod_attr_cd
   ;
   commit;
 
 
-- 2.2 insert into data to temporary table cmm_prod_and_subj_map_rela_ex

--第一组（共一组）产品与科目映射关系

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_prod_and_subj_map_rela_ex(
        etl_dt                                    -- 数据日期               
        ,lp_id                                    -- 法人编号  
	      ,sellbl_prod_id                           -- 可售产品编号
	      ,sellbl_prod_name                         -- 可售产品名称
        ,accti_prod_attr_cd1                      -- 核算产品属性代码1
        ,accti_prod_id                            -- 核算产品编号
        ,accti_prod_name                          -- 核算产品名称
        ,accti_prod_hibchy                        -- 核算产品层级
        ,base_prod_flg                            -- 基础产品标志
        ,bus_type_cd                              -- 业务类型代码
        ,pric_subj_id                             -- 本金科目编号
		    ,intnal_acct_pric_subj_id                --内部账户本金科目编号
        ,recvbl_int_paybl_subj_id                 -- 应收应付利息科目编号
        ,recvbl_int_paybl_adj_subj_id             -- 应收应付利息调整科目编号
        ,recvbl_uncol_int_subj_id                 -- 应收未收利息科目编号
        ,int_bal_pay_subj_id                      -- 利息收支科目编号
        ,spd_pl_subj_id                           -- 价差损益科目编号
        ,acru_aldy_impam_int_subj_id              -- 应计已减值利息科目编号
        ,non_acru_int_recvbl_subj_id              -- 非应计应收利息科目编号
        ,wrtn_off_pric_subj_id                    -- 已核销本金科目编号
        ,wrtn_off_int_subj_id                     -- 已核销利息科目编号
        ,impam_loss_subj_id                       -- 减值损失科目编号
        ,impam_prep_subj_id                       -- 减值准备科目编号
        ,other_acct_recvbl_impam_prep_subj_id     -- 其他应收款减值准备科目编号
        ,output_tax_lmt_subj_id                   -- 销项税额科目编号 
        ,job_cd                                   -- 任务代码            
        ,etl_timestamp                            -- 数据处理时间          
)
select to_date('${batch_date}','yyyymmdd')
       ,'9999'                                                               
       ,coalesce(trim(t2.sellbl_prod_id), t3.sellbl_prod_id,t1.prod_id)      --可售产品编号
       ,nvl(trim(t2.sellbl_prod_name), t3.sellbl_prod_name)                  --可售产品名称
       ,t1.accti_prod_attr_cd1                                               --核算产品属性代码1
       ,t1.prod_id                                                           --核算产品编号
       ,nvl(trim(t2.sellbl_prod_name), t3.base_prod_name)                    --核算产品名称
       ,t2.prod_hibchy                                                       --核算产品层级
       ,case when trim(t3.sellbl_prod_id) is null then '1' else '0' end      --基础产品标志	                                                                        
       ,t1.bus_type_cd                                                       --业务类型代码
       ,t1.pric_subj_id                                                      --本金科目编号
       ,t1.intnal_acct_pric_subj_id                                          --内部账户本金科目编号
       ,t1.recvbl_pay_int_subj_id                                            --应收应付利息科目编号
       ,t1.recvbl_pay_int_adj_subj_id                                        --应收应付利息调整科目编号
       ,t1.recvbl_uncol_int_subj_id                                          --应收未收利息科目编号
       ,t1.int_income_expns_subj_id                                          --利息收支科目编号
       ,t1.spd_pl_subj_id                                                    --价差损益科目编号
       ,t1.acru_aldy_impam_int_subj_id                                       --应计已减值利息科目编号
       ,t1.non_acru_int_recvbl_subj_id                                       --非应计应收利息科目编号
       ,t1.wrt_off_pric_subj_id                                              --已核销本金科目编号
       ,t1.wrt_off_int_subj_id                                               --已核销利息科目编号
       ,t1.impam_loss_subj_id                                                --减值损失科目编号
       ,t1.deval_resv_subj_id                                                --减值准备科目编号
       ,t1.oth_acct_recvbl_impam_prep_sub                                    --其他应收款减值准备科目编号
       ,t1.output_tax_lmt_subj_id                                            --销项税额科目编号
       ,'tglsf1'                                                            -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')      -- etl处理时间戳  
  from ${icl_schema}.tmp_cmm_prod_and_subj_map_rela_01 t1
  left join ${iml_schema}.prd_prod_catlg_h	t2			 
    on t1.prod_id = t2.sellbl_prod_id	
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')	
   and t2.job_cd = 'ncbsf1'	
   and t2.prod_status_cd not in('0','-')  --过滤测试数据，0-待生效,1-生效,2-停办,3-失效,'-'
  left join ${iml_schema}.prd_prod_catlg_h	t3			 
    on t1.prod_id = t3.base_prod_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')	
   and t3.job_cd = 'ncbsf1'	   
   and trim(t3.sellbl_prod_id) is not null
   and t3.prod_status_cd not in('0','-')
   and t3.sellbl_prod_id not in (select distinct pkp.paracd
                                  from ${iol_schema}.tgls_pcmc_knp_para pkp
                                 where pkp.subscd = 'RB'
                                   and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
                                   and pkp.paracd != '%'
                                   and pkp.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
                                   and pkp.end_dt > to_date('${batch_date}', 'YYYYMMDD')
                                )
 where 1 = 1
;   
commit;
	   
-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_prod_and_subj_map_rela exchange partition p_${batch_date} with table ${icl_schema}.cmm_prod_and_subj_map_rela_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_prod_and_subj_map_rela_ex purge;
--drop table ${icl_schema}.tmp_cmm_prod_and_subj_map_rela_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_prod_and_subj_map_rela', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);