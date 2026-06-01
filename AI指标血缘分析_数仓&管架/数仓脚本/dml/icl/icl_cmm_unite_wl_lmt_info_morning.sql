/*
purpose:    共性加工层-联合网贷额度信息 : 联合网贷额度信息：包括所有联合贷款业务的授信额度信息，包含花呗、借呗、网商贷、微粒贷、京东贷、借呗三期等产品的申请数据。数据来源于综合信贷管理系统ICMS。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_lmt_info
createdate: 20200703
logs:       20250108 谢宁   新增微业贷业务
            20250730 陈伟峰 新增乐分期
            20251127 陈伟峰 调整微业贷一组的额度起始日期、期限 加工逻辑，使用信贷登记日期rgst_dt，原取值字段为额度在第三方的生效日期，非我行生效日期
            20251222 陈伟峰 新增对公微业贷203050100002
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_lmt_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_lmt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.9 drop temporary table cmm_unite_wl_lmt_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_lmt_info_ex purge;

-- 2.1 create temporary table cmm_unite_wl_lmt_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_lmt_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_unite_wl_lmt_info where 0=1;

-- 2.2 insert into data to temporary table cmm_unite_wl_lmt_info_ex

--第一组（共二组） 微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
         etl_dt                          -- 数据日期
        ,lp_id                           -- 法人编号
        ,lmt_cont_id                     -- 额度合同编号
 		,lmt_rela_appl_id                -- 额度关联申请编号
 		,cust_id                         -- 客户编号
 		,bus_breed_id                    -- 业务品种编号
 		,actv_flg                        -- 激活标志
 		,circl_flg                       -- 循环标志
 		,low_risk_bus_flg                -- 低风险业务标志
 		,cust_type_cd                    -- 客户类型代码
 		,curr_cd                         -- 币种代码
 		,status_cd                       -- 状态代码
 		,bus_breed_name                  -- 业务品种名称
 	    ,tenor                           -- 期限
 	    ,begin_dt                        -- 起始日期
 	    ,modif_dt                        -- 变更日期
 		,exp_dt                          -- 到期日期
 		,belong_org_id                   -- 所属机构编号
 		,belong_brch_id                  -- 所属分行编号
 		,acct_instit_id                  -- 账务机构编号
 		,mgmt_org_id                     -- 管理机构编号
 		,crdt_lmt                        -- 授信额度
        ,incr_lmt_lmt                    -- 提额额度
 		,occu_crdt_lmt                   -- 已占用授信额度
 		,surp_crdt_lmt                   -- 剩余授信额度
 		,crdt_open_amt                   -- 授信敞口金额
        ,job_cd                          -- 任务代码
        ,etl_timestamp                   -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                           -- 数据日期        --> etl_dt
       ,'9999'                                                                            -- 法人编号        --> lp_id
       ,t1.limitno                                                                        -- 额度合同编号    -->lmt_cont_id
       ,t1.hxcontractserialno                                                             -- 额度关联申请编号--> lmt_rela_appl_id
       ,t1.customerid                                                                     -- 客户编号        --> cust_id
       ,t1.productid                                                                      -- 业务品种编号    --> bus_breed_id
       ,case when t1.productid='203050100002' then decode(t1.hxstatus,'2','1','0') 
               else decode(t1.balstatus,'2','1','0') end                         -- 激活标志        --> actv_flg**
       ,case when t1.productid='203050100002' then decode(t1.hxiscycle,'N','0','Y','1',' ','-',t1.hxiscycle) 
               else decode(t1.circulflg,'N','0','Y','1',' ','-',t1.circulflg) end                                                                -- 循环标志        --> circl_flg
       ,'0'                                                                            -- 低风险业务标志  --> low_risk_bus_flg
       ,nvl(trim(t1.custidtype),'0000')                                            -- 客户类型代码    --> cust_type_cd
       ,t1.ccycd                                                                       -- 币种代码        --> curr_cd       --> curr_cd
       ,case when t1.productid='203050100002' then decode(t1.hxstatus,'1','00','2','01','3','06','4','03','5','06','9','-','-')  
              else  decode(t1.balstatus,'1','00','2','01','3','06','4','03','5','06','9','-','-')end  -- 状态代码        --> status_cd
       ,case when length(t2.prod_id)=1 then t2.prod_gen_name
              when length(t2.prod_id)=3 then t2.prod_sclass_name
              when length(t2.prod_id)=5 then t2.prod_group_name
              when length(t2.prod_id)=7 then t2.base_prod_name
              else t2.sellbl_prod_name end                                          -- 业务品种名称    --> bus_breed_name
       ,case when t1.productid='203050100002' then ceil(months_between(t1.hxmaturity,t1.hxstartdate))  
               else ceil(months_between(to_date(t1.maturitydate,'YYYY-MM-DD'),to_date(t1.startdate,'YYYY-MM-DD')-1)) end     -- 期限            --> tenor
       ,case when t1.productid='203050100002' then trunc(t1.hxstartdate) 
               else to_date(t1.startdate,'YYYY-MM-DD')-1  end                    -- 起始日期        --> begin_dt
       ,''                                                                             -- 变更日期        --> modif_dt
       ,case when t1.productid='203050100002' then trunc(t1.hxmaturity) 
               else to_date(t1.maturitydate,'YYYY-MM-DD')  end                   -- 到期日期        --> exp_dt
       ,decode(t1.productid,'203050100002',t1.hxoperateorgid, t1.inputorgid)       -- 所属机构编号    --> belong_org_id
       ,decode(t1.productid,'203050100002',substr(t1.hxoperateorgid,1,3), substr(t1.inputorgid,1,3) )       -- 所属分行编号    --> belong_brch_id
       ,decode(t1.productid,'203050100002',t1.hxmanageorgid, t1.inputorgid)        -- 账务机构编号    --> rgst_belong_org_id
       ,decode(t1.productid,'203050100002',t1.hxmanageorgid, t1.inputorgid)        -- 管理机构编号    --> rgst_belong_org_id
       ,t1.creditline                                                                 -- 授信额度        --> crdt_lmt
       ,0                                                                             -- 提额额度
       ,t3.tot_bal                                                                    -- 已占用授信额度  --> occu_crdt_lmt
       ,t1.creditline - t3.tot_bal                                                    -- 剩余授信额度    --> surp_crdt_lmt
       ,t1.creditline                                                                 -- 授信敞口金额    --> crdt_open_amt
       ,'icmsf1'                                                                      -- 任务代码        --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')              -- 数据处理时间    --> etl_timestamp
  from ${iol_schema}.icms_wyd_credit_line t1
  left join ${iml_schema}.prd_prod_catlg_h t2
    on t1.productid = t2.prod_id 
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
  left join (select t1.lmt_id as lmt_id
                    ,sum(t2.loan_bal) as tot_bal
               from ${iml_schema}.agt_wyd_loan_cont_h t1
               left join ${iml_schema}.agt_wyd_dubil_h t2
  			              on t1.cont_id = t2.cont_id
  			             and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  			             and t2.job_cd = 'icmsf1'
  		             where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  			             and t1.job_cd = 'icmsf1'
                group by t1.lmt_id ) t3
    on t1.limitno = t3.lmt_id
 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.productid in ('201020100063','203050100002') --微业贷3.0\对公微业贷
  ;
  commit;

--第二组（共二组） 分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
         etl_dt                          -- 数据日期
        ,lp_id                           -- 法人编号
        ,lmt_cont_id                     -- 额度合同编号
 		,lmt_rela_appl_id                -- 额度关联申请编号
 		,cust_id                         -- 客户编号
 		,bus_breed_id                    -- 业务品种编号
 		,actv_flg                        -- 激活标志
 		,circl_flg                       -- 循环标志
 		,low_risk_bus_flg                -- 低风险业务标志
 		,cust_type_cd                    -- 客户类型代码
 		,curr_cd                         -- 币种代码
 		,status_cd                       -- 状态代码
 		,bus_breed_name                  -- 业务品种名称
 	    ,tenor                           -- 期限
 	    ,begin_dt                        -- 起始日期
 	    ,modif_dt                        -- 变更日期
 		,exp_dt                          -- 到期日期
 		,belong_org_id                   -- 所属机构编号
 		,belong_brch_id                  -- 所属分行编号
 		,acct_instit_id                  -- 账务机构编号
 		,mgmt_org_id                     -- 管理机构编号
 		,crdt_lmt                        -- 授信额度
        ,incr_lmt_lmt                    -- 提额额度
 		,occu_crdt_lmt                   -- 已占用授信额度
 		,surp_crdt_lmt                   -- 剩余授信额度
 		,crdt_open_amt                   -- 授信敞口金额
        ,job_cd                          -- 任务代码
        ,etl_timestamp                   -- 数据处理时间
)
select        
       to_date('${batch_date}','yyyymmdd')                                                  -- 数据日期
       ,t1.lp_id                                                                            -- 法人编号
       ,t1.cont_id                                                                          -- 额度合同编号
       ,t1.crdt_appl_id                                                                     -- 额度关联申请编号
       ,t1.cust_id                                                                          -- 客户编号
       ,t1.prod_id                                                                          -- 业务品种编号
       ,case when t1.cont_status_cd = '2' then '1' else '0' end                             -- 激活标志
       ,t1.lmt_circl_flg                                                                    -- 循环标志
       ,'0'                                                                                 -- 低风险业务标志
       ,'2'                                                                                 -- 客户类型代码
       ,t1.curr_cd                                                                          -- 币种代码
       ,decode (t1.cont_status_cd,'1','00','2','01','3','05','4','03','5','02','-')         -- 状态代码
       ,t2.sellbl_prod_name                                                                 -- 业务品种名称
       ,t1.mon_tenor                                                                        -- 期限
       ,t1.cont_effect_dt                                                                   -- 起始日期
       ,t1.final_update_dt                                                                  -- 变更日期
       ,t1.cont_exp_dt                                                                      -- 到期日期
       ,t1.rgst_org_id                                                                      -- 所属机构编号
       ,t1.rgst_org_id                                                                      -- 所属分行编号
       ,t1.rgst_org_id                                                                      -- 账务机构编号
       ,t1.rgst_org_id                                                                      -- 管理机构编号
       ,t1.cont_amt                                                                         -- 授信额度
       ,t1.distr_amt                                                                        -- 提额额度
       ,t1.loan_bal                                                                         -- 已占用授信额度
       ,t1.aval_lmt                                                                         -- 剩余授信额度
       ,t1.cont_amt                                                                         -- 授信敞口金额
	   ,'icmsf1'                                                                            -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                     -- 数据处理时间
from ${iml_schema}.agt_lx_loan_cont_info_h t1
left join ${iml_schema}.prd_prod_catlg_h t2
  on t1.prod_id = t2.prod_id 
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'ncbsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.cont_type_cd = '01'
;
commit;


delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_lmt_info_morning';
commit;
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_icl_batch_jnl(
     etl_dt                              -- 数据日期
     ,tab_name                           -- 表名
     ,batch_status                       -- 跑批状态
     ,batch_tm                           -- 跑批时间
     ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_lmt_info_morning'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_lmt_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_lmt_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_lmt_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_lmt_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);