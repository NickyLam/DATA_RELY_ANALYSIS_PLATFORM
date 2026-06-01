/*
purpose:    共性加工层-联合网贷额度信息 : 联合网贷额度信息：包括所有联合贷款业务的授信额度信息，包含花呗、借呗、网商贷、微粒贷、京东贷、借呗三期等产品的申请数据。数据来源于综合信贷管理系统ICMS。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_lmt_info
createdate: 20200703
logs:       20200703 建表人 谢宁
            20210330 谢  宁 借呗【额度合同】t1.crdt_appl_id --》substr(t1.appl_id,7)
            20210330 谢  宁 京东【激活标志】t1.actv_lab --> t1.apv_status_cd
            20210401 谢  宁 京东【额度状态】'-' --> decode(t1.apv_status_cd,'997','01','998','00','111','00','','-')
            20211011 陈伟峰  新增字段【提额额度】
            20220427 李森辉 1、取数数据源调整，调整花呗、借呗、京东贷、网商贷的取数源，由旧零售信贷系统调整为综合信贷管理系统。微粒贷取数源保持不变。
                            2、调整第一组字段【业务品种名称】的取数逻辑；
                            3、【第五组借呗三期】合并到【第二组借呗】
            20220512 李森辉 新增第五组【蚂蚁借呗三期】的映射
            20220728 温旺清 修改cust_type_cd 中文名：客户类型代码-->证件类型代码	
            20230113 陈伟峰 调整【产品编号】加工逻辑	
            20230512 曹永茂 新增第七组-综合信贷微粒贷
            20230625 徐子豪 根据映射调整第七组-综合信贷微粒贷
	          20230912 陈伟峰 应急调整网商贷、蚂蚁借呗3期的状态代码，新增映射新增 111审批中-->Approving审批中,997通过-->Finished审批通过,998否决(不同意)-->Reject审批否决,991收回-->TakeBackTask主动收回
	          20230921 徐子豪 根据M层调整蚂蚁花呗结清数据存放分区,同步修改取值方式为 job_cd in ('myhbf1','myhbf2')
	          20230925 陈伟峰 调整【激活标志、状态代码】加工逻辑，根据M层转码重新映射
	          20231121 徐子豪 增加联合网贷完成标识
	          20231227 陈伟峰 调整网商贷部分【激活标志、状态代码】加工逻辑，取信贷系统BALSTATUS额度状态
	          20250108 谢  宁 新增字节小微贷业务
			      20250108 谢  宁 新增微业贷业务
			      20250720 谢  宁 新增唯品合作贷
            20250730 陈伟峰 新增乐分期
            20251127 陈伟峰 调整微业贷一组的额度起始日期、期限 加工逻辑，使用信贷登记日期rgst_dt，原取值字段为额度在第三方的生效日期，非我行生效日期
            20260112 陈伟峰 新增富民联合网贷
            20260306 陈  凭 调整第九组微业贷加工逻辑，更新【账务机构编号、管理机构编号】取数逻辑
			20260402 谭钧泽 调整临时表创建规则
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

whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_01 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_02 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_03 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_04 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_05 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_06 purge;


-- 1.2 insert data to temp table 花呗
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_01
nologging
compress ${option_switch} for query high
as
select t2.crdt_appl_id as crdt_appl_id
      ,t1.used_amt as used_amt
      from ${iml_schema}.agt_acp_dubil t2
left join (select cc.agt_id , sum(cc.bal) as used_amt from ${iml_schema}.agt_bal_h cc
      where cc.job_cd = 'myhbf1'
      and cc.start_dt <= to_date('${batch_date}','yyyymmdd')
      and cc.end_dt > to_date('${batch_date}','yyyymmdd')
      and cc.bal_type_cd in ('005007','005006')
      group by cc.agt_id) t1
      on t1.agt_id = t2.agt_id
      where t2.create_dt <= to_date('${batch_date}','yyyymmdd')
      and t2.job_cd in ('myhbf1','myhbf2')
      and t2.id_mark <>'D';
commit;

-- 1.3 insert data to temp table 借呗
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_02
nologging
compress ${option_switch} for query high
as
select t2.crdt_appl_id as crdt_appl_id
      ,t1.used_amt as used_amt
from ${iml_schema}.agt_ajb_dubil t2
  left join (select cc.agt_id,sum(cc.bal) as used_amt from ${iml_schema}.agt_bal_h cc
    where cc.job_cd = 'myjbf2'
       and cc.start_dt <= to_date('${batch_date}','yyyymmdd')
       and cc.end_dt > to_date('${batch_date}','yyyymmdd')
       and cc.bal_type_cd in ('005007','005006')
       group by cc.agt_id) t1
       on t1.agt_id = t2.agt_id
       and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
       and t2.job_cd ='myjbf2'
       and t2.id_mark <>'D';
commit;

-- 1.4 insert data to temp table 网商贷
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_03
nologging
compress ${option_switch} for query high
as
select t2.crdt_appl_id as crdt_appl_id
      ,t1.used_amt as used_amt
from ${iml_schema}.agt_myloan_dubil t2
  left join (select cc.agt_id , sum(cc.bal) as used_amt from ${iml_schema}.agt_bal_h cc
    where cc.job_cd = 'mybkf1'
     and cc.start_dt <= to_date('${batch_date}','yyyymmdd')
     and cc.end_dt > to_date('${batch_date}','yyyymmdd')
     and cc.bal_type_cd in ('005007','005006')
     group by cc.agt_id) t1
     on t1.agt_id = t2.agt_id
     and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
     and t2.job_cd = 'mybkf1'
       and t2.id_mark <>'D';
commit;

-- 1.2 insert data to temp table 微粒贷-中台
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_04
nologging
compress ${option_switch} for query high
as
select t2.agt_id as crdt_appl_id
      ,t1.used_amt as used_amt
      ,t2.cust_lmt_id as cust_limit_id
      from ${iml_schema}.agt_wld_acct t2
left join (select cc.agt_id , sum(cc.bal) as used_amt from ${iml_schema}.agt_bal_h cc
      where cc.job_cd = 'mpcsf1'
      and cc.start_dt <= to_date('${batch_date}','yyyymmdd')
      and cc.end_dt > to_date('${batch_date}','yyyymmdd')
      and cc.bal_type_cd in ('005007','005006')
      group by cc.agt_id) t1
      on t1.agt_id = t2.agt_id
      and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
      and t2.job_cd = 'mpcsf1'
       and t2.id_mark <>'D';
commit;

-- 1.6 insert data to temp table 借呗三期

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_05
nologging
compress ${option_switch} for query high
as
select t2.loan_crdt_appl_id as crdt_appl_id
      ,t1.used_amt as used_amt
from ${iml_schema}.agt_ajb_ped_3_dubil t2
left join (select cc.agt_id , sum(cc.bal) as used_amt from ${iml_schema}.agt_bal_h cc
    where cc.job_cd = 'myjbf3'
    and cc.start_dt <= to_date('${batch_date}','yyyymmdd')
    and cc.end_dt > to_date('${batch_date}','yyyymmdd')
    and cc.bal_type_cd in ('005007','005006')
    group by cc.agt_id) t1
     on t1.agt_id = t2.agt_id
    and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'myjbf3'
    and t2.id_mark <>'D';
commit;

-- 1.7 insert data to temp table 京东
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_06
nologging
compress ${option_switch} for query high
as
select t2.cont_id as crdt_appl_id
      ,t1.used_amt as used_amt
from ${iml_schema}.agt_jd_loan_dubil_info t2
  left join (select cc.agt_id , sum(cc.bal) as used_amt from ${iml_schema}.agt_bal_h cc
    where cc.job_cd = 'jdjrf1'
     and cc.start_dt <= to_date('${batch_date}','yyyymmdd')
     and cc.end_dt > to_date('${batch_date}','yyyymmdd')
     and cc.bal_type_cd in ('005007','005006')
    group by cc.agt_id) t1
     on t1.agt_id = t2.agt_id
    and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'jdjrf1'
    and t2.id_mark <>'D';
commit;

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

--第一组（共十二组） 蚂蚁花呗HB
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
        etl_dt                           -- 数据日期
        ,lp_id                           -- 法人编号
        ,lmt_cont_id                     -- 额度合同编号
        ,lmt_rela_appl_id                -- 额度关联申请编号
        ,cust_id                         -- 客户编号
        ,bus_breed_id                    -- 业务品种编号
        ,actv_flg                        -- 激活标志
        ,circl_flg                       -- 循环标志
        ,low_risk_bus_flg                -- 低风险业务标志
        ,cust_type_cd                    -- 证件类型代码
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
select to_date('${batch_date}','yyyymmdd')                                							       -- 数据日期        --> etl_dt
        ,t1.lp_id                                                         							       -- 法人编号        --> lp_id
        ,t1.crdt_appl_id                                                                       -- 额度合同编号    --> lmt_cont_id
        ,t1.appl_flow_num                                                                      -- 额度关联申请编号--> lmt_rela_appl_id
        ,t1.cust_id                                                                            -- 客户编号        --> cust_id
        ,'202010100003'                                                                        -- 业务品种编号    --> bus_breed_id
        ,case when t2.appl_status_cd = 'Finished' and t1.apved_dt is not null then '1' else '0' end -- 激活标志        --> actv_flg
        ,'1'                                                                                   -- 循环标志        --> circl_flg
        ,'0'                                                                                   -- 低风险业务标志  --> low_risk_bus_flg
        ,t1.cert_type_cd                                                                       -- 证件类型代码    --> cust_type_cd
        ,'CNY'                                                                                 -- 币种代码        --> curr_cd
        ,decode(t2.appl_status_cd,'Finished','01','Reject','00','','-','Approving','00')       -- 状态代码        --> status_cd
        ,'蚂蚁花呗联合贷款'                                                                    -- 业务品种名称    --> bus_breed_name
        ,''                                                                                    -- 期限            --> tenor
        ,trunc(t1.apved_dt)                                                                    -- 起始日期        --> begin_dt
        ,''                                                                                    -- 变更日期        --> modif_dt
        ,to_date('20991231','yyyymmdd')                                                        -- 到期日期        --> exp_dt
        ,t1.director_org_id                                                                    -- 所属机构编号    --> belong_org_id
        ,substr(t1.director_org_id,1,3)                                                        -- 所属分行编号    --> belong_brch_id
        ,t1.director_org_id                                                                    -- 账务机构编号    --> acct_instit_id
        ,t1.director_org_id                                                                    -- 管理机构编号    --> mgmt_org_id
        ,t3.amt                                                                                -- 授信额度        --> crdt_lmt
        ,nvl(t5.apply_credit,0)                                                                -- 提额额度
        ,nvl(t4.used_amt,0)                                                                    -- 已占用授信额度  --> occu_crdt_lmt
        ,nvl(t3.amt,0)-nvl(t4.used_amt,0）                                                     -- 剩余授信额度    --> surp_crdt_lmt
        ,t3.amt                                                                                -- 授信敞口金额    --> crdt_open_amt
        ,t1.job_cd                                                                             -- 任务代码        --> job_cd
        ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                       -- etl处理时间戳   --> etl_timestamp
from ${iml_schema}.agt_acp_crdt_appl t1
  left join ${iml_schema}.agt_appl_status_h t2
    on t1.appl_id = t2.appl_id
   and t2.appl_status_type_cd ='CD2601'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'myhbf1'
  left join ${iml_schema}.agt_amt_h t3
 	  on t1.appl_id = t3.agt_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'myhbf1'
  left join (select cc.crdt_appl_id as crdt_appl_id
                    ,sum(cc.used_amt) as used_amt from ${icl_schema}.tmp_cmm_unite_wl_lmt_info_01 cc
               group by cc.crdt_appl_id) t4
    on t1.crdt_appl_id = t4.crdt_appl_id
  left join (select t.*,
                   rank() over(partition by credit_no order by credit_adjust_date desc) rn
               from ${iol_schema}.rcrs_myhb_adjust_lmt_info t
              where t.start_dt <= to_date('${batch_date}','yyyymmdd')
                and t.end_dt > to_date('${batch_date}','yyyymmdd')) t5
    on t1.crdt_appl_id = t5.credit_no
   and t5.rn=1
 where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myhbf1'
   and t1.id_mark <> 'D';
  commit;

--第二组（共十二组） 蚂蚁借呗JB
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
        etl_dt                           -- 数据日期
        ,lp_id                           -- 法人编号
        ,lmt_cont_id                     -- 额度合同编号
        ,lmt_rela_appl_id                -- 额度关联申请编号
        ,cust_id                         -- 客户编号
        ,bus_breed_id                    -- 业务品种编号
        ,actv_flg                        -- 激活标志
        ,circl_flg                       -- 循环标志
        ,low_risk_bus_flg                -- 低风险业务标志
        ,cust_type_cd                    -- 证件类型代码
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
select to_date('${batch_date}','yyyymmdd')                                                     -- 数据日期        --> etl_dt
        ,t1.lp_id                                                                              -- 法人编号        --> lp_id
				,t1.crdt_appl_id                                                                       -- 额度合同编号    --> lmt_cont_id
				,t1.crdt_appl_id                                                                       -- 额度关联申请编号--> lmt_rela_appl_id
				,t1.cust_id                                                                            -- 客户编号        --> cust_id
				,'202010100001'                                                                        -- 业务品种编号    --> bus_breed_id
				,case when t2.appl_status_cd = 'Finished' and t1.apv_end_tm is not null then '1' else '0' end -- 激活标志        --> actv_flg
				,'1'                                                                                   -- 循环标志        --> circl_flg
				,'0'                                                                                   -- 低风险业务标志  --> low_risk_bus_flg
				,'1010'                                                                                -- 证件类型代码    --> cust_type_cd
				,'CNY'                                                                                 -- 币种代码        --> curr_cd
				,decode(t2.appl_status_cd,'Finished','01','Reject','00','','-','Approving','00')       -- 状态代码        --> status_cd
				,t1.prod_name                                                                          -- 业务品种名称    --> bus_breed_name
				,''                                                       														 -- 期限            --> tenor
				,trunc(t1.apv_end_tm)                                                                  -- 起始日期        --> begin_dt
				,''                                                                                    -- 变更日期        --> modif_dt
				,''                                                       														 -- 到期日期        --> exp_dt
				,'897001'                                                                              -- 所属机构编号    --> belong_org_id
				,'897'                                                                                 -- 所属分行编号    --> belong_brch_id
				,'897001'                                                                              -- 账务机构编号    --> acct_instit_id
				,'897001'                                                                              -- 管理机构编号    --> mgmt_org_id
				,t1.crdt_lmt                                                                           -- 授信额度        --> crdt_lmt
				,0                                                                                     -- 提额额度
				,t3.used_amt                                                                           -- 已占用授信额度  --> occu_crdt_lmt
				,nvl(t1.crdt_lmt,0)-nvl(t3.used_amt,0)                                                 -- 剩余授信额度    --> surp_crdt_lmt
        ,t1.crdt_lmt                                                                           -- 授信敞口金额    --> crdt_open_amt
        ,t1.job_cd                                                        										 -- 任务代码        --> job_cd
        ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                       -- 数据处理时间    --> etl_timestamp
from ${iml_schema}.agt_ajb_crdt_appl t1
  left join ${iml_schema}.agt_appl_status_h t2
    on t1.appl_id = t2.appl_id
   and t2.appl_status_type_cd = 'CD2601'
	 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
	 and t2.job_cd = 'myjbf2'
	left join (select cc.crdt_appl_id as crdt_appl_id
                    ,sum(cc.used_amt) as used_amt from ${icl_schema}.tmp_cmm_unite_wl_lmt_info_02 cc
               group by cc.crdt_appl_id) t3
	  on t1.crdt_appl_id = t3.crdt_appl_id
  where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myjbf2'
   and t1.id_mark <> 'D';
commit;

--第三组（共十二组） 网商贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
                 etl_dt                         -- 数据日期
                ,lp_id                          -- 法人编号
     	        ,lmt_cont_id                    -- 额度合同编号
 				,lmt_rela_appl_id               -- 额度关联申请编号
 				,cust_id                        -- 客户编号
 				,bus_breed_id                   -- 业务品种编号
 				,actv_flg                       -- 激活标志
 				,circl_flg                      -- 循环标志
 				,low_risk_bus_flg               -- 低风险业务标志
 				,cust_type_cd                   -- 证件类型代码
 				,curr_cd                        -- 币种代码
 				,status_cd                      -- 状态代码
 				,bus_breed_name                 -- 业务品种名称
 				,tenor                          -- 期限
 				,begin_dt                       -- 起始日期
 				,modif_dt                       -- 变更日期
 				,exp_dt                         -- 到期日期
 				,belong_org_id                  -- 所属机构编号
 				,belong_brch_id                 -- 所属分行编号
 				,acct_instit_id                 -- 账务机构编号
 				,mgmt_org_id                    -- 管理机构编号
 				,crdt_lmt                       -- 授信额度
                ,incr_lmt_lmt                   -- 提额额度
 		 		,occu_crdt_lmt                  -- 已占用授信额度
 				,surp_crdt_lmt                  -- 剩余授信额度
 				,crdt_open_amt                  -- 授信敞口金额
                ,job_cd                         -- 任务代码
                ,etl_timestamp                  -- 数据处理时间
)
	select to_date('${batch_date}','yyyymmdd')                               								-- 数据日期        --> etl_dt
	       ,t1.lp_id                                                         								-- 法人编号        --> lp_id
				 ,t1.crdt_appl_id                                                                       	-- 额度合同编号    --> lmt_cont_id
				 ,t1.appl_flow_num                                                                       	-- 额度关联申请编号--> lmt_rela_appl_id
				 ,t1.cust_id                                                                            	-- 客户编号        --> cust_id
				 ,t1.prod_id                                                                            	-- 业务品种编号    --> bus_breed_id
				 ,case when t1.lmt_status_cd = 'Finished' and t1.apv_end_tm is not null then '1' else '0' end -- 激活标志        --> actv_flg
				 ,'1'                                                                                   	-- 循环标志        --> circl_flg
				 ,'0'                                                                                   	-- 低风险业务标志  --> low_risk_bus_flg
				 ,'1010'                                                                                	-- 证件类型代码    --> cust_type_cd
				 ,'CNY'                                                                                 	-- 币种代码        --> curr_cd
				 ,decode(t1.lmt_status_cd,'Finished','01','Reject','00','','-','Approving','00','Invalid','03','00')         -- 状态代码        --> status_cd
				 ,t1.prod_name                                                                          	-- 业务品种名称    --> bus_breed_name
				 ,''                                                        								-- 期限            --> tenor
				 ,trunc(t1.apv_end_tm)                                                                  	-- 起始日期        --> begin_dt
				 ,''                                                                                    	-- 变更日期        --> modif_dt
				 ,''                                                        								-- 到期日期        --> exp_dt
				 ,t1.rgst_org_id                                                                        	-- 所属机构编号    --> belong_org_id
				 ,substr(t1.rgst_org_id,1,3)                                                            	-- 所属分行编号    --> belong_brch_id
				 ,t1.rgst_org_id                                                                        	-- 账务机构编号    --> acct_instit_id
				 ,t1.rgst_org_id                                                                        	-- 管理机构编号    --> mgmt_org_id
				 ,t1.crdt_lmt                                                                           	-- 授信额度        --> crdt_lmt
				 ,0                                                                                         -- 提额额度
				 ,t3.used_amt                                                                               -- 已占用授信额度  --> occu_crdt_lmt
				 ,nvl(t1.crdt_lmt,0)-nvl(t3.used_amt,0)                                                     -- 剩余授信额度    --> surp_crdt_lmt
				 ,t1.crdt_lmt                                                                           	-- 授信敞口金额    --> crdt_open_amt
	       ,t1.job_cd                                                       								-- 任务代码        --> job_cd
	       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') 								-- 数据处理时间    --> etl_timestamp
from ${iml_schema}.agt_myloan_crdt_appl t1
/*	left join  ${iml_schema}.agt_appl_status_h t2
	  on t1.appl_id = t2.appl_id
	 and t2.appl_status_type_cd = 'CD2601'
	 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
	 and t2.job_cd = 'mybkf1' */
	 left join (select cc.crdt_appl_id as crdt_appl_id
                    ,sum(cc.used_amt) as used_amt from ${icl_schema}.tmp_cmm_unite_wl_lmt_info_03 cc
               group by cc.crdt_appl_id) t3
	  on t1.crdt_appl_id = t3.crdt_appl_id
	where  t1.create_dt <= to_date('${batch_date}','yyyymmdd')
	 and t1.job_cd = 'mybkf1'
	 and t1.id_mark <> 'D';

commit;

--第四组（共十二组） 微粒贷-中台
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
        etl_dt                           -- 数据日期
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
select to_date('${batch_date}','yyyymmdd')                                -- 数据日期        --> etl_dt
       ,'9999'                                                            -- 法人编号        --> lp_id
			 ,t1.cust_limit_id                              										-- 额度合同编号    --> lmt_cont_id
       ,t1.seqno                                                          -- 额度关联申请编号--> lmt_rela_appl_id
       ,t3.cust_id                                                        -- 客户编号        --> cust_id
       ,'202010100006'                                                    -- 业务品种编号    --> bus_breed_id
       ,''                                                                -- 激活标志        --> actv_flg
       ,'1'                                                               -- 循环标志        --> circl_flg
       ,'0'                                                               -- 低风险业务标志  --> low_risk_bus_flg
       ,'1010'                                                            -- 客户类型代码    --> cust_type_cd
       ,'CNY'                                                             -- 币种代码        --> curr_cd
       ,'-'                                                               -- 状态代码        --> status_cd
       ,''                                                                -- 业务品种名称    --> bus_breed_name
       ,''                                                                -- 期限            --> tenor
       ,trunc(t1.created_datetime)                                        -- 起始日期        --> begin_dt
       ,trunc(t1.last_modified_datetime)                                  -- 变更日期        --> modif_dt
       ,'20991231'                                                        -- 到期日期        --> exp_dt
       ,'897001'                                                          -- 所属机构编号    --> belong_org_id
       ,'897'                                                             -- 所属分行编号    --> belong_brch_id
       ,'897001'                                                          -- 账务机构编号    --> acct_instit_id
       ,'897001'                                                          -- 管理机构编号    --> mgmt_org_id
       ,t1.credit_limit                                                   -- 授信额度        --> crdt_lmt
	 		 ,0                                                           -- 提额额度
       ,t2.bal					                                          -- 已占用授信额度  --> occu_crdt_lmt
       ,nvl(t1.credit_limit,0)-nvl(t2.bal,0)                     		  -- 剩余授信额度    --> surp_crdt_lmt
       ,t1.credit_limit                                                   -- 授信敞口金额    --> crdt_open_amt
			 ,'mpcsf1'                                                    -- 任务代码        --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 数据处理时间    --> etl_timestamp
from ${iol_schema}.mpcs_a0ntm_cust_limit_o t1
  left join (select cc.cust_lmt_id  as cust_limit_id
                   ,max(cc.cust_id) as cust_id
              from ${iml_schema}.agt_wld_acct cc
              where cc.create_dt <= to_date('${batch_date}','yyyymmdd')
                and cc.job_cd = 'mpcsf1'
                and cc.id_mark <>'D'
              group by cc.cust_lmt_id) t3
    on t1.cust_limit_id = t3.cust_limit_id
  left join (select dd.cust_limit_id as cust_limit_id
                    ,sum(dd.used_amt) as bal
              from ${icl_schema}.tmp_cmm_unite_wl_lmt_info_04 dd
              group by dd.cust_limit_id) t2
    on t2.cust_limit_id = t1.cust_limit_id
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;

commit;

--第五组（共十二组）蚂蚁借呗三期

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
				etl_dt                          -- 数据日期
				,lp_id                          -- 法人编号
				,lmt_cont_id      							-- 额度合同编号
				,lmt_rela_appl_id 							-- 额度关联申请编号
				,cust_id          							-- 客户编号
				,bus_breed_id     							-- 业务品种编号
				,actv_flg         							-- 激活标志
				,circl_flg        							-- 循环标志
				,low_risk_bus_flg 							-- 低风险业务标志
				,cust_type_cd     							-- 客户类型代码
				,curr_cd          							-- 币种代码
				,status_cd        							-- 状态代码
				,bus_breed_name   							-- 业务品种名称
				,tenor            							-- 期限
				,begin_dt         							-- 起始日期
				,modif_dt         							-- 变更日期
				,exp_dt           							-- 到期日期
				,belong_org_id    							-- 所属机构编号
				,belong_brch_id   							-- 所属分行编号
				,acct_instit_id   							-- 账务机构编号
				,mgmt_org_id      							-- 管理机构编号
				,crdt_lmt         							-- 授信额度
        ,incr_lmt_lmt                   -- 提额额度
				,occu_crdt_lmt    							-- 已占用授信额度
				,surp_crdt_lmt    							-- 剩余授信额度
				,crdt_open_amt    							-- 授信敞口金额
				,job_cd                         -- 任务代码
				,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                             													-- 数据日期        --> etl_dt
       ,t1.lp_id                                                       													-- 法人编号        --> lp_id
       ,substr(t1.appl_id,7)                                                                    -- 额度合同编号    --> lmt_cont_id
       ,t1.appl_flow_num                                                                     		-- 额度关联申请编号--> lmt_rela_appl_id
       ,t1.cust_id                                                                          		-- 客户编号        --> cust_id
       ,'202010100002'                                                                    		-- 业务品种编号    --> bus_breed_id
       ,case when t2.appl_status_cd = 'Finished' and t1.apv_end_tm is not null then '1' else '0' end -- 激活标志        --> actv_flg
       ,'1'                                                                                     -- 循环标志        --> circl_flg
       ,'0'                                                                                     -- 低风险业务标志  --> low_risk_bus_flg
       ,'1010'                                                                                  -- 客户类型代码    --> cust_type_cd
       ,'CNY'                                                                                   -- 币种代码        --> curr_cd
       ,decode(t2.appl_status_cd,'Finished','01','Reject','00','','-','Approving','00')         -- 状态代码        --> status_cd
       ,t1.prod_name                                                                            -- 业务品种名称    --> bus_breed_name
       ,''                                                                                      -- 期限            --> tenor
       ,t1.apv_end_tm                                                                           -- 起始日期        --> begin_dt
       ,''                                                                                      -- 变更日期        --> modif_dt
       ,''                                                                                      -- 到期日期        --> exp_dt
       ,t1.rgst_org_id                                                                          -- 所属机构编号    --> belong_org_id
       ,substr(t1.rgst_org_id,1,3)                                                              -- 所属分行编号    --> belong_brch_id
       ,t1.rgst_org_id                                                                          -- 账务机构编号    --> acct_instit_id
       ,t1.rgst_org_id                                                                          -- 管理机构编号    --> mgmt_org_id
       ,t1.crdt_lmt                                                                             -- 授信额度        --> crdt_lmt
			 ,0                                                                                       -- 提额额度
       ,t3.used_amt                                                                             -- 已占用授信额度  --> occu_crdt_lmt
       ,nvl(t1.crdt_lmt,0)-nvl(t3.used_amt,0)                                                   -- 剩余授信额度    --> surp_crdt_lmt
       ,t1.crdt_lmt                                                                             -- 授信敞口金额    --> crdt_open_amt
       ,t1.job_cd                                                      											    -- 任务代码        --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')											    -- 数据处理时间    --> etl_timestamp
from ${iml_schema}.agt_ajb_ped_3_crdt_appl t1
  left join ${iml_schema}.agt_appl_status_h t2
  	on t1.appl_id = t2.appl_id
   and t2.appl_status_type_cd = 'CD2601'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'myjbf3'
  left join (select cc.crdt_appl_id as crdt_appl_id
                   ,sum(cc.used_amt) as used_amt from ${icl_schema}.tmp_cmm_unite_wl_lmt_info_05 cc
                   group by cc.crdt_appl_id) t3
	  on t1.crdt_appl_id = t3.crdt_appl_id
  where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myjbf3'
   and t1.id_mark <> 'D';

commit;


--第六组（共十二组）京东金融JRJR
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
				etl_dt                          -- 数据日期
				,lp_id                          -- 法人编号
				,lmt_cont_id      							-- 额度合同编号
				,lmt_rela_appl_id 							-- 额度关联申请编号
				,cust_id          							-- 客户编号
				,bus_breed_id     							-- 业务品种编号
				,actv_flg         							-- 激活标志
				,circl_flg        							-- 循环标志
				,low_risk_bus_flg 							-- 低风险业务标志
				,cust_type_cd     							-- 客户类型代码
				,curr_cd          							-- 币种代码
				,status_cd        							-- 状态代码
				,bus_breed_name   							-- 业务品种名称
				,tenor            							-- 期限
				,begin_dt         							-- 起始日期
				,modif_dt         							-- 变更日期
				,exp_dt           							-- 到期日期
				,belong_org_id    							-- 所属机构编号
				,belong_brch_id   							-- 所属分行编号
				,acct_instit_id   							-- 账务机构编号
				,mgmt_org_id      							-- 管理机构编号
				,crdt_lmt         							-- 授信额度
        ,incr_lmt_lmt                   -- 提额额度
				,occu_crdt_lmt    							-- 已占用授信额度
				,surp_crdt_lmt    							-- 剩余授信额度
				,crdt_open_amt    							-- 授信敞口金额
				,job_cd                         -- 任务代码
				,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                -- 数据日期        --> etl_dt
       ,t1.lp_id                                                                          -- 法人编号        --> lp_id
       ,t1.flow_num                                                                       -- 额度合同编号    --> lmt_cont_id
       ,t1.jd_appl_id                                                                     -- 额度关联申请编号--> lmt_rela_appl_id
       ,t1.cust_id                                                                        -- 客户编号        --> cust_id
       ,'202010100004'                                                                  -- 业务品种编号    --> bus_breed_id
       ,case when t1.apv_status_cd = 'Finished' and t1.apv_end_tm is not null then '1' else '0' end -- 激活标志   --> actv_flg
       ,'1'                                                                               -- 循环标志        --> circl_flg
       ,'0'                                                                               -- 低风险业务标志  --> low_risk_bus_flg
       ,t1.cert_type_cd                                                                   -- 客户类型代码    --> cust_type_cd
       ,'CNY'                                                                             -- 币种代码        --> curr_cd
       ,decode(t1.apv_status_cd,'Finished','01','Reject','00','','-','Approving','00')    -- 状态代码        --> status_cd
       ,t1.prod_name                                                                      -- 业务品种名称    --> bus_breed_name
       ,''                                                                                -- 期限            --> tenor
       ,t1.apv_end_tm                                                                     -- 起始日期        --> begin_dt
       ,''                                                                                -- 变更日期        --> modif_dt
       ,'20991231'                                                                        -- 到期日期        --> exp_dt
       ,t1.login_org_id                                                                   -- 所属机构编号    --> belong_org_id
       ,substr(t1.login_org_id,1,3)                                                       -- 所属分行编号    --> belong_brch_id
       ,t1.login_org_id                                                                   -- 账务机构编号    --> acct_instit_id
       ,t1.login_org_id                                                                   -- 管理机构编号    --> mgmt_org_id
       ,t1.appl_lmt                                                                       -- 授信额度        --> crdt_lmt
			 ,0                                                                                 -- 提额额度
       ,t3.used_amt                                                                       -- 已占用授信额度  --> occu_crdt_lmt
       ,nvl(t1.appl_lmt,0)-nvl(t3.used_amt,0)                                             -- 剩余授信额度    --> surp_crdt_lmt
       ,t1.appl_lmt                                                                       -- 授信敞口金额    --> crdt_open_amt
       ,t1.job_cd                                                                         -- 任务代码        --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                   -- 数据处理时间    --> etl_timestamp
from ${iml_schema}.agt_jd_appl t1
  left join ${iml_schema}.agt_status_h t2
  	on t1.appl_id = t2.agt_id
   and t2.agt_status_type_cd = 'CD1258'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'jdjrf1'
  left join (select cc.crdt_appl_id as crdt_appl_id
                    ,sum(cc.used_amt) as used_amt from ${icl_schema}.tmp_cmm_unite_wl_lmt_info_06 cc
                    group by cc.crdt_appl_id ) t3
    on t1.jd_appl_id = t3.crdt_appl_id
  where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'jdjrf1'
   and t1.id_mark <> 'D';
commit;



--第七组（共十二组） 微粒贷-综合信贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
        etl_dt                           -- 数据日期
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
select to_date('${batch_date}','yyyymmdd')                                                  -- 数据日期        --> etl_dt
       ,'9999'                                                                              -- 法人编号        --> lp_id
			 ,t1.bizno                                      										                  -- 额度合同编号    --> lmt_cont_id
       ,null                                                                                -- 额度关联申请编号--> lmt_rela_appl_id
       ,t1.custid                                                                           -- 客户编号        --> cust_id
       ,CASE
         WHEN T1.LOANCODE = 'CONS' THEN '202010100008' --个人消费类贷款用途
         WHEN T1.LOANCODE = 'BUSI' THEN '202020100003' --个人经营类贷款用途
         ELSE ' '
        END                                                                                 -- 业务品种编号    --> bus_breed_id
       ,decode(t1.effectiveflag, '2', '1', '0')                                             -- 激活标志        --> actv_flg
       ,'1'                                                                                 -- 循环标志        --> circl_flg
       ,'0'                                                                                 -- 低风险业务标志  --> low_risk_bus_flg
       ,t1.idtype                                                                           -- 客户类型代码    --> cust_type_cd
       ,'CNY'                                                                               -- 币种代码        --> curr_cd
       ,decode(t1.effectiveflag,'1','00','2','01','4','03','-')                             -- 状态代码        --> status_cd
       ,''                                                                                  -- 业务品种名称    --> bus_breed_name
       ,''                                                                                  -- 期限            --> tenor
       ,trunc(t1.applydate)                                                                 -- 起始日期        --> begin_dt
       ,''                                                                                  -- 变更日期        --> modif_dt
       ,decode(t1.settledate,date '0001-01-01',date '2099-12-31',trunc(t1.settledate))      -- 到期日期        --> exp_dt
       ,'805011'                                                                            -- 所属机构编号    --> belong_org_id
       ,'805'                                                                               -- 所属分行编号    --> belong_brch_id
       ,'805011'                                                                            -- 账务机构编号    --> acct_instit_id
       ,'805011'                                                                            -- 管理机构编号    --> mgmt_org_id
       ,t1.limitamount                                                                      -- 授信额度        --> crdt_lmt
	 		 ,0                                                                                   -- 提额额度
       ,t1.limitamount-t1.currentlimit					                                            -- 已占用授信额度  --> occu_crdt_lmt
       ,t1.currentlimit                                         					                  -- 剩余授信额度    --> surp_crdt_lmt
       ,t1.limitamount                                                                      -- 授信敞口金额    --> crdt_open_amt
			 ,'icmsf1'                                                                            -- 任务代码        --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                     -- 数据处理时间    --> etl_timestamp
from ${iol_schema}.icms_wld_joint_credit_line_info t1
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t1.signage='1'
;

commit;

--第八组（共十二组） 字节小微贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_lmt_info_ex(
        etl_dt                           -- 数据日期
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
select to_date('${batch_date}','yyyymmdd')                                                  -- 数据日期        --> etl_dt
       ,'9999'                                                                              -- 法人编号        --> lp_id
			 ,t1.cont_id                                      										                -- 额度合同编号    --> lmt_cont_id
       ,t1.cont_id                                                                          -- 额度关联申请编号--> lmt_rela_appl_id
       ,t1.cust_id                                                                          -- 客户编号        --> cust_id
       ,t1.prod_id                                                                          -- 业务品种编号    --> bus_breed_id
       ,t1.cont_valid_flg                                                                   -- 激活标志        --> actv_flg
       ,'1'                                                                                 -- 循环标志        --> circl_flg
       ,'0'                                                                                 -- 低风险业务标志  --> low_risk_bus_flg
       ,t1.cert_type_cd                                                                     -- 客户类型代码    --> cust_type_cd
       ,t1.curr_cd                                                                          -- 币种代码        --> curr_cd
       ,decode(t1.cont_valid_flg,'1','01','0','05','-')                                     -- 状态代码        --> status_cd
       ,case when trim(t1.myloan_appl_flow_num) is not null then '字节小微贷(联合贷)'
             when trim(t1.stud_loan_appl_flow_num) is not null then '字节小微贷(助贷)'
        else '' end                                                                         -- 业务品种名称    --> bus_breed_name
       ,t1.tenor                                                                            -- 期限            --> tenor
       ,trunc(t1.begin_dt)                                                                  -- 起始日期        --> begin_dt
       ,''                                                                                  -- 变更日期        --> modif_dt
       ,trunc(t1.exp_dt)                                                                    -- 到期日期        --> exp_dt
       ,t3.oper_org_id                                                                      -- 所属机构编号    --> belong_org_id
       ,substr(t3.oper_org_id,1,3)                                                          -- 所属分行编号    --> belong_brch_id
       ,t3.fin_org_id                                                                       -- 账务机构编号    --> acct_instit_id
       ,t3.mgmt_org_id                                                                      -- 管理机构编号    --> mgmt_org_id
       ,t1.cont_amt                                                                         -- 授信额度        --> crdt_lmt
	 		 ,0                                                                             -- 提额额度
       ,t1.cont_bal					                                                        -- 已占用授信额度  --> occu_crdt_lmt
       ,t1.aval_lmt                                         					            -- 剩余授信额度    --> surp_crdt_lmt
       ,t1.cont_amt                                                                         -- 授信敞口金额    --> crdt_open_amt
	   ,'icmsf1'                                                                            -- 任务代码        --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                     -- 数据处理时间    --> etl_timestamp
from ${iml_schema}.agt_zjdk_loan_cont_info_h t1
left join (select t2.lmt_cont_id
                 ,t2.intnal_dubil_id
                 ,row_number() over(partition by t2.lmt_cont_id order by t2.begin_dt asc) as rn
            from ${iml_schema}.agt_zjdk_loan_cont_info_h t2
           where t2.lmt_cont_flg = '02'
             and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and t2.job_cd = 'icmsf1'
          ) t2
  on t1.cont_id = t2.lmt_cont_id
 and t2.rn = 1
left join ${iml_schema}.agt_zjdk_dubil_info_h t3
  on t2.intnal_dubil_id = t3.intnal_dubil_id
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd = 'icmsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.lmt_cont_flg = '01' --额度合同
  and t1.job_cd = 'icmsf1'
;
commit;


--第九组（共十二组） 微业贷
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
  ;
commit;


--第十组（共十二组） 唯品合作贷
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
select to_date('${batch_date}','yyyymmdd')                                                  -- 数据日期        --> etl_dt
       ,'9999'                                                                              -- 法人编号        --> lp_id
	   ,t1.cont_id                                      									-- 额度合同编号    -->lmt_cont_id
       ,t1.crdt_appl_id                                                                     -- 额度关联申请编号--> lmt_rela_appl_id
       ,t1.cust_id                                                                          -- 客户编号        --> cust_id
       ,t1.prod_id                                                                          -- 业务品种编号    --> bus_breed_id
       ,case when t1.cont_status_cd = '2' then '1' else '0' end                             -- 激活标志        --> actv_flg
       ,t1.lmt_circl_flg                                                                    -- 循环标志        --> circl_flg
       ,t1.low_risk_bus_flg                                                                 -- 低风险业务标志  --> low_risk_bus_flg
       ,'1010'                                                                              -- 客户类型代码    --> cust_type_cd
       ,t1.curr_cd                                                                          -- 币种代码        --> curr_cd
       ,decode(t1.cont_status_cd,'1','00','2','01','3','06','4','03','5','06','9','-','-')   -- 状态代码        --> status_cd
       ,case when length(t2.prod_id)=1 then t2.prod_gen_name
             when length(t2.prod_id)=3 then t2.prod_sclass_name
             when length(t2.prod_id)=5 then t2.prod_group_name
             when length(t2.prod_id)=7 then t2.base_prod_name
        else t2.sellbl_prod_name end                                                        -- 业务品种名称    --> bus_breed_name
       ,t1.loan_tenor                                                                       -- 期限            --> tenor
       ,trunc(t1.cont_effect_dt)                                                            -- 起始日期        --> begin_dt
       ,''                                                                                  -- 变更日期        --> modif_dt
       ,trunc(t1.cont_exp_dt)                                                               -- 到期日期        --> exp_dt
       ,t1.out_acct_org_id                                                                  -- 所属机构编号    --> belong_org_id
       ,substr(t1.out_acct_org_id,1,3)                                                      -- 所属分行编号    --> belong_brch_id
       ,t1.out_acct_org_id                                                                  -- 账务机构编号    --> acct_instit_id
       ,t1.out_acct_org_id                                                                  -- 管理机构编号    --> mgmt_org_id
       ,t1.cont_amt                                                                         -- 授信额度        --> crdt_lmt
	   ,0                                                                                   -- 提额额度
       ,t1.aval_lmt					                                                        -- 已占用授信额度  --> occu_crdt_lmt
       ,0                                        					                        -- 剩余授信额度    --> surp_crdt_lmt
       ,0                                                                                   -- 授信敞口金额    --> crdt_open_amt
	   ,'icmsf1'                                                                            -- 任务代码        --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                     -- 数据处理时间    --> etl_timestamp
from ${iml_schema}.agt_wph_loan_cont_info_h t1
left join ${iml_schema}.prd_prod_catlg_h t2
  on t1.prod_id = t2.prod_id 
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'ncbsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.cont_type_cd = '02' --唯品没有额度合同，只有业务合同
  and t1.cont_status_cd = '2'
;
commit;


--第十一组（共十二组） 分期乐
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
       to_date('${batch_date}','yyyymmdd')                                               -- 数据日期
       ,t1.lp_id                                                                            -- 法人编号
       ,t1.cont_id                                                                          --额度合同编号
       ,t1.crdt_appl_id                                                                     --额度关联申请编号
       ,t1.cust_id                                                                          --客户编号
       ,t1.prod_id                                                                          --业务品种编号
       ,case when t1.cont_status_cd = '2' then '1' else '0' end                      --激活标志
       ,t1.lmt_circl_flg                                                                    --循环标志
       ,'0'                                                                                 --低风险业务标志
       ,'2'                                                                                 --客户类型代码
       ,t1.curr_cd                                                                          --币种代码
       ,decode (t1.cont_status_cd,'1','00','2','01','3','05','4','03','5','02','-')     --状态代码
       ,t2.sellbl_prod_name                                                                 --业务品种名称
       ,t1.mon_tenor                                                                        --期限
       ,t1.cont_effect_dt                                                                   --起始日期
       ,t1.final_update_dt                                                                  --变更日期
       ,t1.cont_exp_dt                                                                      --到期日期
       ,t1.rgst_org_id                                                                      --所属机构编号
       ,t1.rgst_org_id                                                                      --所属分行编号
       ,t1.rgst_org_id                                                                      --账务机构编号
       ,t1.rgst_org_id                                                                      --管理机构编号
       ,t1.cont_amt                                                                         --授信额度
       ,t1.distr_amt                                                                        --提额额度
       ,t1.loan_bal                                                                         --已占用授信额度
       ,t1.aval_lmt                                                                         --剩余授信额度
       ,t1.cont_amt                                                                         --授信敞口金额
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

--第十二组（共十二组） 富民联合贷
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
       to_date('${batch_date}','yyyymmdd')                                               --数据日期
       ,t1.lp_id                                                                            --法人编号
       ,t1.crdt_id                                                                          --额度合同编号
       ,t1.partner_ova_flow_num                                                             --额度关联申请编号
       ,t1.cust_id                                                                          --客户编号
       ,t1.prod_id                                                                          --业务品种编号
       ,decode(t1.appl_status_cd,'Finished','1','0')                                     --激活标志
       ,t1.circl_flg                                                                        --循环标志
       ,'-'                                                                                 --低风险业务标志
       ,t3.certtype                                                                         --证件类型代码
       ,t1.curr_cd                                                                          --币种代码
       ,decode(t1.appl_status_cd,'Finished','01','-')                                    --状态代码
       ,t2.sellbl_prod_name                                                                 --业务品种名称
       ,t1.mon_tenor                                                                        --期限
       ,t1.apv_start_dt                                                                     --起始日期
       ,''                                                                                  --变更日期
       ,''                                                                                  --到期日期
       ,t1.rgst_org_id                                                                      --所属机构编号
       ,substr(t1.rgst_org_id,1,3)                                                       --所属分行编号
       ,t1.rgst_org_id                                                                      --账务机构编号
       ,t1.rgst_org_id                                                                      --管理机构编号
       ,t1.risk_mgmt_crdt_lmt                                                               --授信额度
       ,0                                                                                   --提额额度
       ,0                                                                                   --已占用授信额度
       ,0                                                                                   --剩余授信额度
       ,0                                                                                   --授信敞口金额
	   ,'icms_lh'                                                                           --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                     --数据处理时间
from ${iml_schema}.agt_lhwd_crdt_appl t1
left join ${iml_schema}.prd_prod_catlg_h t2
  on t1.prod_id = t2.prod_id 
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'ncbsf1'
left join ${iol_schema}.icms_customer_info_lhdk t3
  on t1.cust_id = t3.customerid
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
;
commit;



delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_lmt_info';
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
   ,'cmm_unite_wl_lmt_info'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_lmt_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_lmt_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_01 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_02 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_03 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_04 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_05 purge;
drop table ${icl_schema}.tmp_cmm_unite_wl_lmt_info_06 purge;
drop table ${icl_schema}.cmm_unite_wl_lmt_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_lmt_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);