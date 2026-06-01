/*
Purpose:    共性加工层-法透签约信息:包括企业法人客户申请法人账户透支签约信息，数据来源于核心系统（CBSS）、信贷系统
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_lp_od_sign_info
Createdate: 20211107 何桐金 新增模型
            20220119 陈伟峰 修改字段中文名称【授信申请编号】->【签约协议编号】
            20220902 温旺清 1、调整取数的数据源，由旧核心系统调整为新核心系统；
                           2、新增字段【旧透支子户编号】
                           3、拆分字段【期限代码-》期限+期限类型代码】
                           4、置空字段【签约流水号、信用状态代码、单笔透支有效天数、透支承诺费】
            20230310 陈伟峰	调整agt_loan_acct_info_h表dubil_id使用逻辑，增加银团贷款'203010400001','602060100002'拼接规则	

					  
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_lp_od_sign_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_lp_od_sign_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_lp_od_sign_info_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_lp_od_sign_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_lp_od_sign_info where 0=1;

--2.2 insert into tmp table

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lp_od_sign_info_ex(
     etl_dt                  --数据日期
    ,lp_id                   --法人编号
    ,crdt_appl_id            --签约协议编号
    ,dubil_id                --借据编号
    ,cont_id                 --合同编号
    ,od_acct_id              --透支账户编号
    ,od_sub_acct_id          --透支子户编号
    ,old_od_sub_acct_id      --旧透支子户编号
    ,cust_id                 --客户编号
    ,loan_org_id             --贷款机构编号
    ,cust_mgr_id             --客户经理编号
    ,sign_flow_num           --签约流水号
    ,int_rat_reval_cd        --利率重定价代码
    ,int_set_way_cd          --结息方式代码
    ,crdt_status_cd          --信用状态代码
    ,od_serv_status_cd       --透支服务状态代码
    ,lp_od_type_cd           --法透类型代码
	  ,tenor                   --期限
	  ,tenor_type_cd           --期限类型代码
    ,base_rat_cd             --基准利率代码
    ,sign_dt                 --签约日期
    ,lmt_start_dt            --额度开始日期
    ,lmt_exp_dt              --额度到期日期
    ,sig_od_valid_days       --单笔透支有效天数
    ,od_lmt_uplmi            --透支额度上限
    ,start_od_amt            --起透金额
    ,od_promis_fee           --透支承诺费
    ,od_lmt                  --透支额度
    ,used_od_lmt             --已用透支额度
    ,surp_od_lmt             --剩余透支额度
    ,nomal_int_rat_fl_rt     --正常利率浮动比例
    ,ovdue_int_rat_fl_rt     --逾期利率浮动比例
    ,nomal_loan_int_rat      --正常贷款利率
    ,ovdue_loan_int_rat      --逾期贷款利率
    ,job_cd
    ,etl_timestamp           --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')    as etl_dt                    --数据日期
      ,'9999'                                 as lp_id                     --法人编号																  
      ,t1.src_agt_id                                                       --签约协议编号
      ,case when t9.prod_id in ('203010400001','602060100002') 
            then t9.dubil_id||t9.distr_flow_num
            else t9.dubil_id 
            end                                                            -- 借据号
	  ,t4.rela_cont_id                                                     --合同编号
      ,t1.cust_acct_num                                                    --透支账户编号
      ,t1.sub_acct_num                                                     --透支子户编号
      ,t5.acct_seq_no_o                                                    --旧透支子户编号
      ,t1.cust_id                                                          --客户编号
      ,t3.sign_org_id                                                      --贷款机构编号
      ,t3.sign_teller_id                                                   --客户经理编号
      ,''                                                                  --签约流水号
      ,t7.int_rat_modif_ped_cd                                             --利率重定价代码
      ,t7.int_set_freq_cd                                                  --结息方式代码
      ,''                                                                  --信用状态代码
      ,t1.agt_status_cd                                                    --透支服务状态代码
      ,decode(t1.prod_id, '401010100001', '2', '103010100001', '0')        --法透类型代码
      ,t1.od_tenor                                                         --期限
      ,t1.od_tenor_type_cd                                                 --期限类型代码
      ,t7.int_rat_type_cd                                                  --基准利率代码
      ,t1.effect_dt                                                        --签约日期
      ,t1.effect_dt                                                        --额度开始日期
      ,t1.invalid_dt                                                       --额度到期日期
      ,null                                                                --单笔透支有效天数
      ,t1.od_lmt                                                           --透支额度上限
      ,t1.start_od_amt                                                     --起透金额
      ,null                                                                --透支承诺费
      ,t1.od_lmt                                                           --透支额度
      ,t1.od_lmt - nvl(t6.acct_od_amt,0)                                   --已用透支额度
      ,t6.acct_od_amt                                                      --剩余透支额度
      ,t7.float_int_rat_ratio                                              --正常利率浮动比例
      ,t8.float_int_rat_ratio                                              --逾期利率浮动比例
      ,t7.exec_int_rat                                                     --正常贷款利率
      ,t8.exec_int_rat                                                     --逾期贷款利率
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间 	  
  from ${iml_schema}.agt_lp_od_sign_h t1						
  left join ${iml_schema}.agt_loan_acct_attach_info_h t2			
    on t1.src_agt_id = t2.cont_id
   and t2.job_cd = 'ncbsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')	
  left join ${iml_schema}.agt_dep_sign_agt_h t3			
    on t1.src_agt_id = t3.sign_agt_id
   and t3.job_cd = 'ncbsf1'
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')	
   left join ${iml_schema}.agt_loan_acct_info_h t9		
    on t2.loan_num =  t9.loan_num 	
   and t9.job_cd = 'ncbsf1'
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')	
  left join ${iml_schema}.agt_loan_dubil_info_h t4			
    on (case when t9.prod_id in ('203010400001','602060100002') 
             then t9.dubil_id||t9.distr_flow_num
             else t9.dubil_id 
             end) = t4.dubil_id
   and t4.job_cd = 'icmsf1'
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ncbs_new_old_seq_no t5			
    on t1.cust_acct_num = t5.base_acct_no   
   and t1.sub_acct_num = t5.acct_seq_no
  left join ${iml_schema}.agt_dep_acct_info_h bp		
    on t1.cust_acct_num = bp.cust_acct_num  
   and t1.sub_acct_num = bp.sub_acct_num	
   and bp.job_cd = 'ncbsf1'
   and bp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and bp.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_dep_acct_bal_h t6		
    on bp.acct_id = t6.acct_id	
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')   
   and t6.job_cd = 'ncbsf1'
  left join ${iml_schema}.agt_loan_int_rat_h t7			
    on t2.loan_num = t7.loan_num		
   and t7.int_cls_cd = 'INT'
   and t7.job_cd = 'ncbsf1'
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')	   
  left join ${iml_schema}.agt_loan_int_rat_h t8			
    on t2.loan_num = t8.loan_num		
   and t8.int_cls_cd = 'ODP'	
   and t8.job_cd = 'ncbsf1'
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')	
  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd = 'ncbsf1'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_lp_od_sign_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_lp_od_sign_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_lp_od_sign_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_lp_od_sign_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);