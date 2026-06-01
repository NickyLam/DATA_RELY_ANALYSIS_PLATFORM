/*
Purpose:    共性加工层-联合网贷担保合同信息：包括联合网贷中网商贷部分业务的担保合同的信息，来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_guar_cont_info
CreateDate: 20230928
Logs:       20241118 谢  宁 增加完成状态表
            20251222 陈伟峰 新增对公微业贷203050100002

          
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_guar_cont_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_guar_cont_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_guar_cont_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_guar_cont_info_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_guar_cont_info where 0=1;

-- 第一组  微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_guar_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,guar_cont_id                             -- 担保合同编号
       ,guar_cont_type_cd                        -- 担保合同类型代码
       ,guar_way_cd                              -- 担保方式代码
       ,guar_kind_cd                             -- 保证种类代码
       ,status_cd                                -- 状态代码
       ,curr_cd                                  -- 币种代码
       ,sign_dt                                  -- 签订日期
       ,effect_dt                                -- 生效日期
       ,exp_dt                                   -- 到期日期
       ,cust_id                                  -- 客户编号
       ,guartor_cust_id                          -- 担保人客户编号
       ,guartor_name                             -- 担保人名称
       ,guartor_cert_type_cd                     -- 担保人证件类型代码
       ,guartor_cert_no                          -- 担保人证件号码
       ,guar_amt                                 -- 担保金额
       ,gover_fin_guar_corp_guar_flg             -- 政府性融资担保公司保证标志
       ,rev_guar_flg                             -- 反担保标志
       ,guar_org_name                            -- 担保机构名称
       ,guar_item_promis_id                      -- 担保事项承诺书编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgstrat_id                               -- 登记人编号
       ,rgst_dt                                  -- 登记日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')      -- 数据日期
       ,t1.lp_id                                -- 法人编号
       ,t1.guar_cont_id                         -- 担保合同编号
       ,t1.guar_cont_type_cd                    -- 担保合同类型代码
       ,t1.guar_way_cd                          -- 担保方式代码
       ,t1.guar_form_cd                         -- 保证种类代码
       ,case when t1.effect_flg = '1' then '2' 
	           when t1.effect_flg = '0' then '4'
	    	else '-' end                            -- 状态代码
       ,t1.curr_cd                              -- 币种代码
       ,t1.sign_dt                              -- 签订日期
       ,t1.sign_dt                              -- 生效日期
       ,t1.exp_dt                               -- 到期日期
       ,t2.cust_id                              -- 客户编号
       ,t1.cust_id                              -- 担保人客户编号
       ,t1.guartor_cust_name                    -- 担保人名称
       ,t1.guartor_cert_type_cd                 -- 担保人证件类型代码
       ,t1.guartor_cert_no                      -- 担保人证件号码
       ,t1.guar_amt                             -- 担保金额
       ,''                                      -- 政府性融资担保公司保证标志**
       ,''                                      -- 反担保标志
       ,''                                      -- 担保机构名称
       ,''                                      -- 担保事项承诺书编号
       ,t1.rgst_org_id                          -- 登记机构编号
       ,t1.rgst_teller_id                       -- 登记人编号
       ,t1.rgst_dt                              -- 登记日期
       ,t1.job_cd                               -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
  from ${iml_schema}.agt_wyd_guar_cont_h t1
  left join (select t.*,row_number() over(partition by t.lmt_id order by t.lmt_id) rn
               from ${iml_schema}.agt_wyd_loan_cont_h t 
              where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                and t.job_cd ='icmsf1') t2
    on t1.lmt_id = t2.lmt_id
   and t2.rn=1
 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='icmsf1'
   and t1.prod_id in ('201020100063','203050100002') --微业贷3.0\对公微业贷
;
commit;

-- 第二组  分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_guar_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,guar_cont_id                             -- 担保合同编号
       ,guar_cont_type_cd                        -- 担保合同类型代码
       ,guar_way_cd                              -- 担保方式代码
       ,guar_kind_cd                             -- 保证种类代码
       ,status_cd                                -- 状态代码
       ,curr_cd                                  -- 币种代码
       ,sign_dt                                  -- 签订日期
       ,effect_dt                                -- 生效日期
       ,exp_dt                                   -- 到期日期
       ,cust_id                                  -- 客户编号
       ,guartor_cust_id                          -- 担保人客户编号
       ,guartor_name                             -- 担保人名称
       ,guartor_cert_type_cd                     -- 担保人证件类型代码
       ,guartor_cert_no                          -- 担保人证件号码
       ,guar_amt                                 -- 担保金额
       ,gover_fin_guar_corp_guar_flg             -- 政府性融资担保公司保证标志
       ,rev_guar_flg                             -- 反担保标志
       ,guar_org_name                            -- 担保机构名称
       ,guar_item_promis_id                      -- 担保事项承诺书编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgstrat_id                               -- 登记人编号
       ,rgst_dt                                  -- 登记日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')         -- 数据日期
       ,t1.lp_id                                      -- 法人编号
       ,t1.guar_cont_id                               --担保合同编号
       ,t1.guar_cont_type_cd                          --担保合同类型代码
       ,t1.guar_way_cd                                --担保方式代码
       ,decode (t1.guar_way_cd,'A','40','B','30','C','20','D','10','-')       --保证种类代码                                      --保证种类代码
       ,decode(t1.cont_status_cd,'101','2' ,'104','3' ,'110','1','112','2','111','4','-')              --状态代码
       ,t1.guar_curr_cd                               --币种代码
       ,t1.cont_sign_dt                               --签订日期
       ,t1.cont_effect_dt                             --生效日期
       ,t1.cont_exp_dt                                --到期日期
       ,t1.cust_id                                    --客户编号
       ,t1.guartor_id                                 --担保人客户编号
       ,t1.guartor_name                               --担保人名称
       ,t1.guartor_cert_type_cd                       --担保人证件类型代码
       ,t1.guartor_cert_no                            --担保人证件号码
       ,t1.guar_tot_amt                               --担保金额
       ,t1.gover_fin_guar_corp_guar_flg               --政府性融资担保公司保证标志
       ,t1.rev_guar_flg                               --反担保标志
       ,''                                            --担保机构名称
       ,''                                            --担保事项承诺书编号
       ,t1.rgst_org_id                                --登记机构编号
       ,t1.rgst_teller_id                             --登记人编号
       ,t1.rgst_dt                                    --登记日期
       ,t1.job_cd                                     -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_guar_cont_info_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='icmsf1'
   and t1.guar_cont_id like 'LX%'   --分期乐
;
commit;




delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_guar_cont_info_morning';
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
   ,'cmm_unite_wl_guar_cont_info_morning'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_guar_cont_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_guar_cont_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_guar_cont_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_guar_cont_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
