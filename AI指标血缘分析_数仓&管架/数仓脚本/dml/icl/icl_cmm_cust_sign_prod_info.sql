/*
Purpose:    共性加工层-客户签约产品信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20230521 icl_cmm_cust_sign_prod_info
CreateDate: 20210316
Logs:
     20210719 何桐金 调整【签约产品状态代码】取数逻辑，
                     调整第二组【签约日期】取数逻辑
     20210727 何桐金 新增第十一组支付宝快捷支付签约信息
     20210803 何桐金 更新中台客户号原赋''的逻辑
                     调整第六组【签约协议编号】取数逻辑
     20210805 何桐金 调整中台客户号取数逻辑：优先取主表，主表为空时取次表
     20210914 何桐金 调整BZ022签约协议编号t1.cld_card_id||to_char(t1.oper_tm,'yyyymmddhh24miss')
     20211207 陈伟峰 调整【签约产品状态代码】加工逻辑，统一代码，引用CD2308-签约状态代码 0	无效 ,1	有效, 2	创建, 3	待生效, A	待解约, B	解约, -	未知                    
	 20220414 朱觉军 1.调整第一组的取数逻辑  2.新增一组MPCS：第三方存管签约
	 20210425 朱觉军 新增字段【签约渠道编号】		
     20220513 朱觉军 第十八组第三方存管签约取数数据源表调整，由mpcs_a35tassignconfirm调整为mpcs_a35tassignhist	
     20220518 温旺清 第十八组第三方存管签约取数数据源表，由iml.evt_tps_sucs_sign_dtl 调整为iol.mpcs_a35tassignhist		
     20221220 翟若平 增加第十七组【核心-资金池签约信息】			
     20221227 温旺清 调整第九组【签约机构编号、机构名称】的取数口径，取最新一条	 
     20221229 陈伟峰 调整BASE_ACCT_NO，做首位去0判断
     20230526 陈伟峰 调整mpcs_a51ubsmallamtlimit表updtime加工条件
     20230531 陈伟峰 新增第十八组【PPP网联签约信息】
     20231031 徐子豪 新增第十九组【PPP银联签约信息】,修复原【PPP网联签约信息】组B-解约转码问题。
     20230531 陈伟峰 调整第一组【签约产品状态代码】，添加S-暂停为有效
     20250307 陈伟峰 调整第十六组 三方存管签约，增加row_number排序取一条
     20250822 陈伟峰 剔除第四组中台系统(综合签约)--SV014三方存管协议
     20250825 陈伟峰 调整【签约渠道编号】字段逻辑，映射为行内6位标准渠道码
     20250903 陈伟峰 增加第二十组【微信绑定签约】
     20251117 陈伟峰 优化统一支付系统银联签约部分的签约客户号取值逻辑
     20251225 陈伟峰 调整第17组核心资金池签约取数源为现金管理系统
	 20260407 周文龙 修改临时表的创建规则
*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_cust_sign_prod_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_cust_sign_prod_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cust_sign_prod_info_ex purge;
drop table ${icl_schema}.tmp_cmm_cust_sign_prod_info_01 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cust_sign_prod_info_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_cust_sign_prod_info where 0=1;

-- Create table
create table ${icl_schema}.tmp_cmm_cust_sign_prod_info_01
nologging compress ${option_switch} for query high
as      
select 
       t3.cust_id as party_id --所属客户编号
      ,t3.cust_acct_num  as acctno --账户编号  
  from ${iml_schema}.agt_dep_main_acct_info_h t3 -- 存款账户信息历史
 where  t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'  
;
commit;
-- 第一组（共十八组）新核心
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                          --数据日期
   ,t1.lp_id                                                    --法人编号
   ,t1.sign_agt_id                                              --签约协议编号
   ,t1.cust_id                                                  --客户编号
   ,t1.cust_acct_num                                            --签约账户编号
   ,t1.sign_org_id                                              --签约机构编号
   ,t1.sign_teller_id                                           --签约柜员编号
   ,t2.org_name                                                 --签约机构名称
   ,t1.sign_agt_type_cd                                         --签约产品类型代码
   ,decode(t1.sign_agt_status_cd,'A','1','S','1','E','0','-')   --签约产品状态代码
   ,t1.tran_sign_dt                                             --签约日期
   ,t1.rels_dt                                                  --解约日期
   ,case when trim(t1.rels_dt) is not null then t1.sign_org_id end    --解约机构编号
   ,t1.rels_teller_id                                           --解约柜员编号
   ,case when trim(t1.rels_dt) is not null then t2.org_name end       --解约机构名称
   ,''                                                          --签约手机号
   ,t1.sign_chn_id                                              --签约渠道编号
   ,t1.job_cd                                                            -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')       -- etl处理时间戳
from ${iml_schema}.agt_dep_sign_agt_h t1
inner join ${iml_schema}.org_int_org t2
 on t1.sign_org_id = t2.org_id
and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
and t2.job_cd = 'uussf1'
and t2.id_mark <> 'D'
where t1.job_cd = 'ncbsf1'
and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 第二组（共十八组）票据系统
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                           -- 数据日期
   ,lp_id	                           -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                     -- 数据日期
   ,t1.lp_id	                                                             -- 法人编号
   ,t1.src_agt_id                                                          -- 签约协议编号
   ,t1.cust_id                                                             -- 客户编号
   ,t1.sign_acct_id                                                        -- 签约账户编号
   ,t1.sign_org_id                                                         -- 签约机构编号
   ,''                                                                     -- 签约柜员编号
   ,t2.org_name                                                            -- 签约机构名称
   ,'BD001'                                                                -- 签约产品类型代码
   ,case when t1a.agt_status_cd='0' then '1' --有效
         when t1a.agt_status_cd='1' then '0' --无效
         else '-'
    end                                                  -- 签约产品状态代码   -未知  0 已签约  1  未签约
   ,t1.sign_dt                                                             -- 签约日期
   ,t1.revo_dt                                                             -- 解约日期
   ,case when t1a.agt_status_cd='0' then t1.sign_org_id end                -- 解约机构编号
   ,''                                                                     -- 解约柜员编号
   ,case when t1a.agt_status_cd='0' then t2.org_name end                   -- 解约机构名称
   ,''                                                                     -- 签约手机号
   ,''                                                                     --签约渠道编号
   ,t1.job_cd                                                              -- 任务代码
	,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_bill_cust_sign_info t1
 left join ${iml_schema}.agt_status_h t1a
   on t1.agt_id = t1a.agt_id
  and t1a.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1a.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1a.agt_status_type_cd = 'CD2277'   
  and t1a.job_cd = 'bdmsf1'
inner join ${iml_schema}.org_int_org t2
   on t1.sign_org_id = t2.org_id
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'uussf1'
  and t2.id_mark <> 'D'
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'bdmsf1'
  and t1.id_mark <> 'D'
;
commit;

-- 第三组（共十八组）中台
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号  
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.equip_card_no||to_char(t1.oper_tm,'yyyymmddhh24miss')       -- 签约协议编号
   ,nvl(trim(t1.cust_id),t3.party_id)  -- 客户编号
   ,t1.main_acct_id                    -- 签约账户编号
   ,''                                 -- 签约机构编号
   ,''                                 -- 签约柜员编号
   ,''                                 -- 签约机构名称
   ,'BZ027'                            -- 签约产品类型代码
   ,decode(t1.equip_card_status_cd,'1','1','0','0','-') -- 签约产品状态代码   --A初始，1正常，B锁定，0注销，-未知
   ,t1.oper_tm                         -- 签约日期
   ,to_date('29991231','yyyymmdd')     -- 解约日期
   ,''                                 -- 解约机构编号
   ,''                                 -- 解约柜员编号
   ,''                                 -- 解约机构名称
   ,''                                 -- 签约手机号
   ,''                                 --签约渠道编号
   ,'mpcsi13'                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.ref_user_move_equip_para_h t1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t3
   on t1.main_acct_id=t3.acctno  
where t1.equip_card_status_cd <> 'A'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mpcsf1'
;
commit;


-- 第四组（共十八组）中台(综合签约、签约企业网银,只是提供有效的签约记录)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id                           -- 法人编号
   ,t1.sign_id                         -- 签约协议编号
   ,nvl(trim(t1.cust_id),t3.party_id)  -- 客户编号
   ,t1.acct_id                         -- 签约账户编号
   ,t1.sign_org_id                     -- 签约机构编号
   ,t1.sign_teller_id                  -- 签约柜员编号
   ,'' as sign_org_id                  -- 签约机构名称
   ,t1.sign_agt_cd                     -- 签约产品类型代码
   ,decode(t1.sign_status_cd,'0','1','1','0','-')   -- 签约产品状态代码  --0正常  1解约 2换卡 9未知
   ,t1.sign_dt                        -- 签约日期
   ,t1.rels_dt                        -- 解约日期
   ,t1.rels_org_id                    -- 解约机构编号
   ,t1.rels_teller_id                 -- 解约柜员编号
   ,''                                -- 解约机构名称
   ,''                                -- 签约手机号
   ,t1.chn_id                         --签约渠道编号
   ,'mpcsf14'                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from (select
           lp_id
           ,sign_id
           ,cust_id
           ,acct_id
           ,sign_dt
           ,sign_org_id
           ,sign_status_cd
           ,rels_dt
           ,sign_teller_id
           ,rels_org_id
           ,rels_teller_id
           ,sign_agt_cd
           ,chn_id
           ,row_number() over(partition by sign_id,acct_id,sign_dt,sign_agt_cd ,sign_status_cd order by sign_id ) rn
     from ${iml_schema}.agt_syn_cnter_sign_h 
    where (sign_agt_cd<>'SV006' or (sign_agt_cd='SV006' and sign_status_cd = '0'))
      and job_cd = 'mpcsf1'
      and start_dt <= to_date('${batch_date}','yyyymmdd')
      and end_dt > to_date('${batch_date}','yyyymmdd')      
        )  t1
    left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t3
       on t1.acct_id = t3.acctno    
    where t1.rn=1
      and t1.sign_agt_cd <>'SV014'   --剔除三方存管
;
commit;


-- 第五组（共十八组）中台(代发工资客户签约信息)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.sign_id                         -- 签约协议编号
   ,nvl(trim(t1.cust_id),t3.party_id)                        -- 客户编号 --MODIFIED BY LYX IN 20210804
   ,t1.entr_acct_id                    -- 签约账户编号
   ,t1.sign_org_id                     -- 签约机构编号
   ,t1.sign_teller_id                  -- 签约柜员编号
   ,t2.instname                        -- 签约机构名称
   ,'BZ008'                            -- 签约产品类型代码
   ,decode(t1.agt_status_cd,'0','0','1','1','-') -- 签约产品状态代码
   ,t1.sign_dt                         -- 签约日期
   ,to_date('29991231','yyyymmdd')     -- 解约日期
   ,''                                 -- 解约机构编号
   ,''                                 -- 解约柜员编号
   ,''                                 -- 解约机构名称
   ,case when length(t1.tel_num) <= 11 then t1.tel_num
         when length(t1.tel_num) > 11 then ''
        end                            -- 签约手机号
   ,t1.tran_chn_cd                       --签约渠道编号
   ,'mpcsi15'                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_payoff_sign_info_h t1
 left join ${iol_schema}.mpcs_cpmtinst  t2
   on t2.instno = t1.sign_org_id
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t3
   on t1.entr_acct_id = t3.acctno
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mpcsf1'
;
commit;

-- 第六组（共十八组）中台(跨境资金池主办企业账户表)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id                           -- 法人编号
   ,t1.init_agt_id                     -- 签约协议编号
   ,nvl(trim(t1.cust_id),t3.party_id)  -- 客户编号
   ,t1.acct_id                         -- 签约账户编号
   ,''                                 -- 签约机构编号
   ,''                                 -- 签约柜员编号
   ,''                                 -- 签约机构名称
   ,'KJ001'                            -- 签约产品类型代码
   ,decode(t1.agt_status_cd,'0','0','1','1','-') -- 签约产品状态代码   1正常  0关闭  -未知
   ,t1.insto_dt                        -- 签约日期
   ,case when t1.agt_status_cd = '3'
         then to_date(substr(t1.final_modif_tm,1,8), 'YYYY-MM-DD')
          end                          -- 解约日期
   ,''                                 -- 解约机构编号
   ,''                                 -- 解约柜员编号
   ,''                                 -- 解约机构名称
   ,''                                 -- 签约手机号
   ,''                                 --签约渠道编号
   ,'mpcsi16'                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_cross_pool_acct_info_h T1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t3
   on t1.acct_id=t3.acctno
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mpcsf1'
;
commit;

-- 第七组（共十八组）中台(银企直联签约)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id                           -- 法人编号
   ,t1.sign_id                         -- 签约协议编号
   ,nvl(trim(t1.cust_id),t4.party_id)  -- 客户编号
   ,t1.acct_id                         -- 签约账户编号
   ,t2.sign_org_id                     -- 签约机构编号
   ,''                                 -- 签约柜员编号
   ,t3.instname                        -- 签约机构名称
   ,'BZ014'                            -- 签约产品类型代码
   ,decode(t1.acct_sign_status_cd,'0','0','1','1','-')-- 签约产品状态代码  1正常 0销户  -未知
   ,t2.sign_dt                         -- 签约日期
   ,to_date('29991231','yyyymmdd')     -- 解约日期
   ,''                                 -- 解约机构编号
   ,''                                 -- 解约柜员编号
   ,''                                 -- 解约机构名称
   ,''                                 -- 签约手机号
   ,''                                 --签约渠道编号
   ,'mpcsi17'                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_bcdl_acct_sign_info t1
 inner join ${iml_schema}.agt_bcdl_cust_sign_info t2
   on ( t1.sign_id = t2.sign_id)
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.job_cd= 'mpcsf1'
 left join ${iol_schema}.mpcs_cpmtinst  t3
   on t3.instno = t2.sign_org_id
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t4
   on t1.acct_id=t4.acctno
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mpcsf1'
;
commit;

-- 第八组（共十八组）中台系统(云闪付签约信息)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                   -- 数据日期
   ,t1.lp_id	                                           -- 法人编号
   ,t1.cld_card_id||to_char(t1.oper_tm,'yyyymmddhh24miss')       -- 签约协议编号
   ,nvl(trim(t1.cust_id),t4.party_id)                    -- 客户编号
   ,t1.main_acct_id                                      -- 签约账户编号
   ,''                                                   -- 签约机构编号
   ,''                                                   -- 签约柜员编号
   ,''                                                   -- 签约机构名称
   ,'BZ022'                                              -- 签约产品类型代码
   ,decode(t1.cld_card_status_cd,'0','1','1','0','-')    -- 签约产品状态代码
   ,to_date(to_char(t1.oper_tm,'yyyymmdd'),'yyyymmdd')   -- 签约日期
   ,to_date('29991231','yyyymmdd')                       -- 解约日期
   ,''                                                   -- 解约机构编号
   ,''                                                   -- 解约柜员编号
   ,''                                                   -- 解约机构名称
   ,t1.mobile_no                                         -- 签约手机号
   ,''                        --签约渠道编号
   ,'mpcsi18'                                            -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.evt_hce_acct_rgst_info t1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t4
   on t1.main_acct_id=t4.acctno
where to_date(to_char(t1.oper_tm,'yyyymmdd'),'yyyymmdd')<=to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mpcsi1'
;
commit;

-- 第九组（共十八组）中台系统(银结通签约信息)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,'9999'	                           -- 法人编号
   ,t1.protocolno                      -- 签约协议编号
   ,t3.party_id                        -- 客户编号
   ,t1.payeracc                        -- 签约账户编号
   ,t2.instno                          -- 签约机构编号
   ,t1.userid                          -- 签约柜员编号
   ,t2.instname                        -- 签约机构名称
   ,'BZ009'                            -- 签约产品类型代码
   ,decode(t1.signst,'00','1','0')     -- 签约产品状态代码  --00 签约成功 01发送失败 02发送成功 03已撤销 04撤销发送成功 05签约失败
   ,to_date(trim(t1.signdt), 'yyyymmdd')     -- 签约日期
   ,to_date(trim(t1.frsgdt), 'yyyymmdd')     -- 解约日期
   ,''                                 -- 解约机构编号
   ,''                                 -- 解约柜员编号
   ,''                                 -- 解约机构名称
   ,t1.contactusertel                  -- 签约手机号
   ,''                        --签约渠道编号
   ,'mpcsi19'                           -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from (select protocolno
             ,payeracc
             ,userid
             ,signst
             ,signdt
             ,frsgdt
             ,payerbank
             ,case substr(replace(replace(contactusertel, '-', ''),'+',''),0, 2)   --移除号码中的'+''-',假如是以86开头，则移除86；最长11位
              when '86' then substr(replace(replace(contactusertel, '-', ''),'+',''),3,11)
              else substr(replace(replace(contactusertel, '-', ''),'+',''),0,11)
               end as contactusertel
            ,row_number() over(partition by protocolno,payeracc,signdt,signst order by protocolno,signdt desc ) rn
         from ${iol_schema}.mpcs_a49tefrepsign
        where to_date(signdt, 'yyyymmdd')<=to_date('${batch_date}','yyyymmdd')) t1
 left join (select row_number() over(partition by t.bankno order by t.start_dt desc ) rn,t.* 
              from ${iol_schema}.mpcs_cpmtinst t
             where t.start_dt <= to_date('${batch_date}','yyyymmdd')
               and t.end_dt > to_date('${batch_date}','yyyymmdd')) t2
   on t2.bankno = t1.payerbank
  and t2.rn = 1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t3
 on t1.payeracc=t3.acctno
where t1.rn=1
;
commit;

-- 第十组（共十八组）中台系统(银联二维码)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')         -- 数据日期
   ,t1.lp_id	                                 -- 法人编号
   ,t1.bind_flow_num                           -- 签约协议编号
   ,nvl(trim(t1.cust_id),t4.party_id)          -- 客户编号
   ,t1.enty_c_acct_id                          -- 签约账户编号
   ,t1.tran_org_id                             -- 签约机构编号
   ,t1.tran_teller_id                          -- 签约柜员编号
   ,''                                         -- 签约机构名称
   ,'BZ026'                                    -- 签约产品类型代码
   ,decode(t1.bd_card_status_cd,'0','1','1','0','-')-- 签约产品状态代码
   ,to_date(to_char(t1.bd_card_tm,'yyyymmdd'),'yyyymmdd')   -- 签约日期
   ,to_date('29991231','yyyymmdd')             -- 解约日期
   ,''                                         -- 解约机构编号
   ,''                                         -- 解约柜员编号
   ,''                                         -- 解约机构名称
   ,''                                         -- 签约手机号
   ,decode(t1.tran_chn_cd,'OGW','901001','1022','302001',t1.tran_chn_cd)   --签约渠道编号
   ,'mpcsi110'                                 -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iml_schema}.evt_mbank_code_bd_card_dtl t1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t4
   on t1.enty_c_acct_id=t4.acctno
where to_date(to_char(t1.bd_card_tm,'yyyymmdd'),'yyyymmdd')<=to_date('${batch_date}','yyyymmdd')
  and t1.job_cd ='mpcsf1' 
  and t1.data_kind_cd='B'
;
commit;

-- 第十一组（共十八组）中台系统(支付宝快捷支付签约信息)
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,'9999' as lp_id	                   -- 法人编号
   ,t1.msgid                           -- 签约协议编号
   ,t2.party_id                        -- 客户编号
   ,t1.acctno                          -- 签约账户编号
   ,''                                 -- 签约机构编号
   ,''                                 -- 签约柜员编号
   ,''                                 -- 签约机构名称
   ,'BZ019'                            -- 签约产品类型代码
   ,case when t1.custstatus = '0' then '1'
         when t1.custstatus = '2' then '0'
         else '-' end                  -- 签约产品状态代码   --客户状态(0:正常，1:冻结，2:销户，默认为"0")
   ,to_date(substr(t1.chnltime,1,8), 'yyyymmdd') -- 签约日期
   ,to_date('29991231','yyyymmdd')             -- 解约日期
   ,''                                         -- 解约机构编号
   ,''                                         -- 解约柜员编号
   ,''                                         -- 解约机构名称
   ,t1.mobile                                  -- 签约手机号
   ,decode(t1.chnlid,'01','403001',t1.chnlid)           --签约渠道编号
   ,'mpcsi111'                                 -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iol_schema}.mpcs_a22signvalidateinfo t1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t2
  on t1.acctno=t2.acctno
 
 ;
commit;

-- 第十二组（共十八组）ecif
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')          -- 数据日期
   ,'9999' as lp_id	                            -- 法人编号
   ,t1.agreement_id                             -- 签约协议编号
   ,t3.cust_num                                 -- 客户编号
   ,t1.acct_num                                 -- 签约账户编号
   ,t2.sp_id                                    -- 签约机构编号
   ,t1.create_te                                -- 签约柜员编号
   ,t2.sp_name                                  -- 签约机构名称
   ,decode(t1.product_id,'zj001','BZ001',
                         'yl001','BZ002',
                         'hx001','BZ003',
                         'ldys001','BZ004',
                         'tenpay','BZ005',
                         'byd001','BZ020',
                         '0900500100204','BZ021',
                         'reapal','BZ023',
                         'reapal001','BZ024',
                         '0900500100205','BZ025',
                         'DK001','DK001',
                         'Limit','SV008','XXXXX')          -- 签约产品类型代码
   ,decode(t1.sign_status,'02','0','01','1','-')           -- 签约产品状态代码   01-签约 02-解约  03-委托在途04-撤销在途 05-备案 06-冲正 Z-其他
   ,to_date(nvl(trim(t1.open_date),'19000101'),'yyyymmdd') -- 签约日期
   ,to_date('29991231','yyyymmdd')                         -- 解约日期
   ,''                                                     -- 解约机构编号
   ,''                                                     -- 解约柜员编号
   ,''                                                     -- 解约机构名称
   ,''                                                     -- 签约手机号
   ,''                        --签约渠道编号
   ,'eifsf1' as job_cd                                     -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.eifs_t05_pub_summary_sign t1
 inner join ${iol_schema}.eifs_t05_pub_product_sign t2
   on t1.agreement_id=t2.agreement_id
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.eifs_t00_party_pub_info t3
   on t3.party_id=t1.party_id
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.product_id in ('zj001',
                         'byd001',
                         '0900500100204',
                         'hx001',
                         'ldys001',
                         'reapal',
                         'reapal001',
                         '0900500100205',
                         'DK001',
                         'Limit',
                         'yl001',
                         'tenpay')
 and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 第十三组（共十八组）小额免密限额登记表
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')         -- 数据日期
   ,'9999' as lp_id	                           -- 法人编号
   ,t1.acctno||t1.updtime                      -- 签约协议编号
   ,t2.party_id                                -- 客户编号
   ,t1.acctno                                  -- 签约账户编号
   ,t1.brchno                                  -- 签约机构编号
   ,t1.opid                                    -- 签约柜员编号
   ,''                                         -- 签约机构名称
   ,'DW001'                                    -- 签约产品类型代码
   ,'1'                                        -- 签约产品状态代码
   ,${iml_schema}.dateformat_min(t1.updtime)   -- 签约日期
   ,to_date('29991231','yyyymmdd')             -- 解约日期
   ,''                                         -- 解约机构编号
   ,''                                         -- 解约柜员编号
   ,''                                         -- 解约机构名称
   ,''                                         -- 签约手机号
   ,decode(t1.chnlid,'VTM','201002'      --VTM	201002	智慧柜台
                   ,'EDB','901001'          --EDB	901001	内部渠道
                   ,'CNT','100001'          --CNT	100001	柜面
                   ,'SCP','100001'          --SCP	100001	柜面
                   ,'IBS','100001'          --IBS	100001	柜面
                   ,'TEL','100003'          --TEL	100003	客户服务应答
                   ,'NPB','301001'          --NPB	301001	个人网上银行
                   ,'NMB','302001'          --NMB	302001	个人手机银行
                   ,'EBK','301001'          --EBK	301001	个人网上银行
                   ,t1.chnlid)                 --签约渠道编号
   ,'mpcsi113'                                 -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳
 from ${iol_schema}.mpcs_a51ubsmallamtlimit t1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t2
 on t1.acctno=t2.acctno
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.quotamt<>'0.00'
;
commit;

-- 第十四组（共十八组）委托关系限额表
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')            -- 数据日期
   ,'9999' as lp_id	                              -- 法人编号
   ,t1.priacct||t1.opendt                         -- 签约协议编号
   ,t2.party_id                                   -- 客户编号
   ,t1.priacct                                    -- 签约账户编号
   ,''                                            -- 签约机构编号
   ,t1.mttlrnbr                                   -- 签约柜员编号
   ,t1.mtbrnnbr                                   -- 签约机构名称
   ,'DW002'                                       -- 签约产品类型代码
   ,case when t1.status<>'0' then '1' else '0' end      -- 签约产品状态代码  --状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
   ,to_date(trim(substr(t1.opendt,1,8)),'yyyy/mm/dd') -- 签约日期
   ,to_date(trim(substr(t1.closdt,1,8)),'yyyy/mm/dd') -- 解约日期
   ,''                                            -- 解约机构编号
   ,''                                            -- 解约柜员编号
   ,''                                            -- 解约机构名称
   ,t1.paymodeno                                  -- 签约手机号
   ,decode(t1.channels,'CUP','401002','CNT','100001',t1.channels)                                   -- 签约渠道编号
   ,'mpcsi114'                                    -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.mpcs_a51ubrelationreg t1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t2
 on t1.priacct=t2.acctno
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.relbusitype='09'
  and t1.status<>'0'
;
commit;

-- 第十五组（共十八组）快捷支付签约信息
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,sign_agt_id                        -- 签约协议编号
   ,cust_id                            -- 客户编号
   ,sign_acct_id                       -- 签约账户编号
   ,sign_org_id                        -- 签约机构编号
   ,sign_teller_id                     -- 签约柜员编号
   ,sign_org_name                      -- 签约机构名称
   ,sign_prod_type_cd                  -- 签约产品类型代码
   ,sign_prod_status_cd                -- 签约产品状态代码
   ,sign_dt                            -- 签约日期
   ,rels_dt                            -- 解约日期
   ,rels_org_id                        -- 解约机构编号
   ,rels_teller_id                     -- 解约柜员编号
   ,rels_org_name                      -- 解约机构名称
   ,sign_mobile_no                     -- 签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')            -- 数据日期
   ,'9999' as lp_id	                              -- 法人编号
   ,t1.priacct||t1.opendt                         -- 签约协议编号
   ,t2.party_id                                   -- 客户编号
   ,t1.priacct                                    -- 签约账户编号
   ,''                                            -- 签约机构编号
   ,t1.mttlrnbr                                   -- 签约柜员编号
   ,t1.mtbrnnbr                                   -- 签约机构名称
   ,'DW003'                                       -- 签约产品类型代码
   ,case when t1.status<>'0' then '1' else '0' end      -- 签约产品状态代码  --状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
   ,to_date(trim(substr(t1.opendt,1,8)),'yyyy/mm/dd') -- 签约日期
   ,to_date(trim(substr(t1.closdt,1,8)),'yyyy/mm/dd') -- 解约日期
   ,''                                            -- 解约机构编号
   ,''                                            -- 解约柜员编号
   ,''                                            -- 解约机构名称
   ,t1.paymodeno                                  -- 签约手机号
   ,T1.CHANNELS                                   --签约渠道编号
   ,'mpcsi115'                                    -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.mpcs_a51ubrelationreg t1
 left join ${icl_schema}.tmp_cmm_cust_sign_prod_info_01  t2
   on t1.priacct=t2.acctno
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.relbusitype='02'
  and t1.status<>'0'
;
commit;

-- 第十六组（共十八组）第三方存管签约
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
   etl_dt                    --数据日期
   ,lp_id                    --法人编号
   ,sign_agt_id              --签约协议编号
   ,cust_id                  --客户编号
   ,sign_acct_id             --签约账户编号
   ,sign_org_id              --签约机构编号
   ,sign_teller_id           --签约柜员编号
   ,sign_org_name            --签约机构名称
   ,sign_prod_type_cd        --签约产品类型代码
   ,sign_prod_status_cd      --签约产品状态代码
   ,sign_dt                  --签约日期
   ,rels_dt                  --解约日期
   ,rels_org_id              --解约机构编号
   ,rels_teller_id           --解约柜员编号
   ,rels_org_name            --解约机构名称
   ,sign_mobile_no           --签约手机号
   ,sign_chn_id                        --签约渠道编号
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select distinct 
    to_date('${batch_date}','yyyymmdd')                                      --数据日期
   ,'9999'                                                                   --法人编号
   ,t1.acctno||t1.seccd||t1.capitalacctno||t1.brcno||t1.confirmstatus        --签约协议编号
   ,t1.custno                                                                --客户编号
   ,t1.acctno                                                                --签约账户编号
   ,t1.brcno                                                                 --签约机构编号
   ,''                                                                       --签约柜员编号
   ,t1.brcname                                                               --签约机构名称
   ,'CG001'                                                                  --签约产品类型代码
   ,nvl(trim(t1.confirmstatus),'-')                                          --签约产品状态代码
   ,to_date(substr(trim(t1.signtm), 1, 8), 'yyyymmdd')                       --签约日期
   ,''                                                                       --解约日期
   ,''                                                                       --解约机构编号
   ,''                                                                       --解约柜员编号
   ,''                                                                       --解约机构名称
   ,''                                                                       --签约手机号
   ,t1.reserve4                                                              --签约渠道编号
   ,'mpcsi116'                             -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')             -- etl处理时间戳
from (select t.*
                     ,row_number() over(partition by acctno,seccd,capitalacctno,brcno,confirmstatus  order by signtm desc ) as rn
              from ${iol_schema}.mpcs_a35tassignconfirm t
            where  to_date(substr(trim(t.signtm), 1, 8), 'yyyymmdd') <= to_date('${batch_date}','yyyymmdd') 
           )t1
where t1.rn=1
;
commit;	


/*
-- 第十七组（共十八组）核心-资金池签约信息
insert  into ${icl_schema}.cmm_cust_sign_prod_info_ex(
   etl_dt                    -- 数据日期
   ,lp_id                    -- 法人编号
   ,sign_agt_id              -- 签约协议编号
   ,cust_id                  -- 客户编号
   ,sign_acct_id             -- 签约账户编号
   ,sign_org_id              -- 签约机构编号
   ,sign_teller_id           -- 签约柜员编号
   ,sign_org_name            -- 签约机构名称
   ,sign_prod_type_cd        -- 签约产品类型代码
   ,sign_prod_status_cd      -- 签约产品状态代码
   ,sign_dt                  -- 签约日期
   ,rels_dt                  -- 解约日期
   ,rels_org_id              -- 解约机构编号
   ,rels_teller_id           -- 解约柜员编号
   ,rels_org_name            -- 解约机构名称
   ,sign_mobile_no           -- 签约手机号
   ,sign_chn_id              -- 签约渠道编号
   ,job_cd                   -- 任务代码
   ,etl_timestamp            -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd') as etl_dt                             -- 数据日期     
       ,'9999' as lp_id                                                          -- 法人编号     
       ,t1.agreement_id as sign_agt_id                                           -- 签约协议编号   
       ,t1.client_no as cust_id                                                  -- 客户编号     
       ,case when substr(t1.base_acct_no,1,1)='0' then substr(t1.base_acct_no,2) else t1.base_acct_no end as sign_acct_id                                          -- 签约账户编号   
       ,nvl(t3.tran_branch, t1.tran_branch) as sign_org_id                       -- 签约机构编号   
       ,nvl(t3.user_id, t1.user_id) as sign_teller_id                            -- 签约柜员编号   
       ,t2.organcnshortname as sign_org_name                                     -- 签约机构名称   
       ,'PCP' as sign_prod_type_cd                                               -- 签约产品类型代码 
       ,decode(t1.agreement_status, 'A', '1', 'E', '0') as sign_prod_status_cd   -- 签约产品状态代码 
       ,nvl(t3.tran_date, t1.effect_date) as sign_dt                             -- 签约日期     
       ,t4.tran_date as rels_dt                                                  -- 解约日期     
       ,t4.tran_branch as rels_org_id                                            -- 解约机构编号   
       ,t4.user_id as rels_teller_id                                             -- 解约柜员编号   
       ,t5.organcnshortname as rels_org_name                                     -- 解约机构名称   
       ,'' as sign_mobile_no                                                     -- 签约手机号    
       ,t3.source_type as sign_chn_id                                            -- 签约渠道编号
       ,'ncbsf1'                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
  from ${iol_schema}.ncbs_rb_pcp_agreement t1
  left join (select rpa.*,
                    row_number() over(partition by agreement_id order by tran_date desc) rn
               from ${iol_schema}.ncbs_rb_pcp_agreement_hist rpa
              where rpa.tran_date <= to_date('${batch_date}', 'YYYYMMDD')
                and rpa.agreement_operate_type = '01') t3
    on t1.agreement_id = t3.agreement_id
   and t3.rn = 1
  left join ${iol_schema}.uuss_uus_organ t2
    on nvl(t3.tran_branch, t1.tran_branch) = t2.organcode
   and t2.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
   and t2.end_dt > to_date('${batch_date}', 'YYYYMMDD')
  left join (select rpa.*,
                    row_number() over(partition by agreement_id order by tran_date desc) rn
               from ${iol_schema}.ncbs_rb_pcp_agreement_hist rpa
              where rpa.tran_date <= to_date('${batch_date}', 'YYYYMMDD')
                and rpa.agreement_operate_type = '03') t4
    on t1.agreement_id = t4.agreement_id
   and t4.rn = 1
  left join ${iol_schema}.uuss_uus_organ t5
    on t4.tran_branch = t5.organcode
   and t5.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
   and t5.end_dt > to_date('${batch_date}', 'YYYYMMDD')
 where t1.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
   and t1.end_dt > to_date('${batch_date}', 'YYYYMMDD')
;
commit;
*/

-- 第十七组（共十八组）核心-资金池签约信息
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
   etl_dt                    -- 数据日期
   ,lp_id                    -- 法人编号
   ,sign_agt_id              -- 签约协议编号
   ,cust_id                  -- 客户编号
   ,sign_acct_id             -- 签约账户编号
   ,sign_org_id              -- 签约机构编号
   ,sign_teller_id           -- 签约柜员编号
   ,sign_org_name            -- 签约机构名称
   ,sign_prod_type_cd        -- 签约产品类型代码
   ,sign_prod_status_cd      -- 签约产品状态代码
   ,sign_dt                  -- 签约日期
   ,rels_dt                  -- 解约日期
   ,rels_org_id              -- 解约机构编号
   ,rels_teller_id           -- 解约柜员编号
   ,rels_org_name            -- 解约机构名称
   ,sign_mobile_no           -- 签约手机号
   ,sign_chn_id              -- 签约渠道编号
   ,job_cd                   -- 任务代码
   ,etl_timestamp            -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd') as etl_dt                      -- 数据日期
          ,'9999'  as  lp_id                                                    -- 法人编号
          ,t1.sign_agreement_id||t2.bank_acc_no	                                -- 签约协议编号
          ,t1.tenant_code	                                                     -- 客户编号
          ,t2.bank_acc_no	                                                     -- 签约账户编号
          ,t1.sign_code	                                                         -- 签约机构编号
          ,t1.sign_user_id	                                                     -- 签约柜员编号
          ,t1.sign_name	                                                         -- 签约机构名称
          ,'PCP'	                                                             -- 签约产品类型代码
          ,t1.status	                                                         -- 签约产品状态代码
          ,t1.sign_time	                                                         -- 签约日期
          ,t1.un_sign_time	                                                     -- 解约日期
          ,''	                                                                 -- 解约机构编号
          ,''	                                                                 -- 解约柜员编号
          ,''	                                                                 -- 解约机构名称
          ,t1.tenant_phone	                                                     -- 签约手机号
          ,''                                                                    -- 签约渠道编号
          ,'tmssf1'                                                              -- 任务代码
          ,to_timestamp('${batch_timestamp}','yyyy-mm-ddhh24:mi:ss.ff6')         -- etl处理时间戳
 from ${iol_schema}.tmss_sys_tenant t1
inner join ${iol_schema}.tmss_sys_tenant_bank_acc t2
   on t1.id=t2.tenant_id
  and t2.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t2.end_dt >to_date('${batch_date}','yyyymmdd')
where t1.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t1.end_dt >to_date('${batch_date}','yyyymmdd')
;
commit;


-- 第十八组（共十八组）PPP网联签约信息
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
   etl_dt                    -- 数据日期
   ,lp_id                    -- 法人编号
   ,sign_agt_id              -- 签约协议编号
   ,cust_id                  -- 客户编号
   ,sign_acct_id             -- 签约账户编号
   ,sign_org_id              -- 签约机构编号
   ,sign_teller_id           -- 签约柜员编号
   ,sign_org_name            -- 签约机构名称
   ,sign_prod_type_cd        -- 签约产品类型代码
   ,sign_prod_status_cd      -- 签约产品状态代码
   ,sign_dt                  -- 签约日期
   ,rels_dt                  -- 解约日期
   ,rels_org_id              -- 解约机构编号
   ,rels_teller_id           -- 解约柜员编号
   ,rels_org_name            -- 解约机构名称
   ,sign_mobile_no           -- 签约手机号
   ,sign_chn_id              -- 签约渠道编号
   ,job_cd                   -- 任务代码
   ,etl_timestamp            -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')               -- 数据日期     
       ,t1.lp_id                                         -- 法人编号     
       ,t1.sign_agt_id                                   -- 签约协议编号   
       ,t2.pty_id                                        -- 客户编号     
       ,t1.sign_acct_id                                  -- 签约账户编号   
       ,' '                                              -- 签约机构编号   
       ,' '                                              -- 签约柜员编号   
       ,' '                                              -- 签约机构名称   
       ,'DW003'                                          -- 签约产品类型代码 
       ,decode(t1.sign_status_cd,'0','1','1','0','2','B','3','0','-')     -- 签约产品状态代码 
       ,t1.sign_dt                                       -- 签约日期     
       ,t1.agt_invalid_dt                                -- 解约日期     
       ,' '                                              -- 解约机构编号   
       ,' '                                              -- 解约柜员编号   
       ,' '                                              -- 解约机构名称   
       ,t1.mobile_no                                     -- 签约手机号    
       ,' '                                              -- 签约渠道编号
       ,t1.job_cd                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
  from ${iml_schema}.agt_epcc_sign_info_h t1
/*  left join (select cust_id as party_id --所属客户编号
                   ,cust_acct_num  as acctno --账户编号  
               from ${iml_schema}.agt_dep_main_acct_info_h -- 存款账户信息历史
             where start_dt <= to_date('${batch_date}','yyyymmdd')
               and end_dt > to_date('${batch_date}','yyyymmdd')
               and job_cd = 'ncbsf1')t2
    on t1.sign_acct_id=t2.acctno */
 left join ${iol_schema}.ppps_e_contract t2
    on t2.sgn_no=t1.sign_agt_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='pppsf1'
;
commit;


-- 第十九组（共二十组）PPP银联签约信息
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
   etl_dt                    -- 数据日期
   ,lp_id                    -- 法人编号
   ,sign_agt_id              -- 签约协议编号
   ,cust_id                  -- 客户编号
   ,sign_acct_id             -- 签约账户编号
   ,sign_org_id              -- 签约机构编号
   ,sign_teller_id           -- 签约柜员编号
   ,sign_org_name            -- 签约机构名称
   ,sign_prod_type_cd        -- 签约产品类型代码
   ,sign_prod_status_cd      -- 签约产品状态代码
   ,sign_dt                  -- 签约日期
   ,rels_dt                  -- 解约日期
   ,rels_org_id              -- 解约机构编号
   ,rels_teller_id           -- 解约柜员编号
   ,rels_org_name            -- 解约机构名称
   ,sign_mobile_no           -- 签约手机号
   ,sign_chn_id              -- 签约渠道编号
   ,job_cd                   -- 任务代码
   ,etl_timestamp            -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')               -- 数据日期     
       ,t1.lp_id                                         -- 法人编号     
       ,t1.sign_agt_id                                   -- 签约协议编号   
       ,t2.pty_id                                        -- 客户编号     
       ,t1.sign_acct_id                                  -- 签约账户编号   
       ,' '                                              -- 签约机构编号   
       ,' '                                              -- 签约柜员编号   
       ,' '                                              -- 签约机构名称   
       ,'BZ002'                                          -- 签约产品类型代码 
       ,decode(t1.sign_status_cd,'0','1','1','0','2','B','3','0','-')     -- 签约产品状态代码 
       ,t1.sign_dt                                       -- 签约日期     
       ,t1.agt_invalid_dt                                -- 解约日期     
       ,' '                                              -- 解约机构编号   
       ,' '                                              -- 解约柜员编号   
       ,' '                                              -- 解约机构名称   
       ,t1.mobile_no                                     -- 签约手机号    
       ,' '                                              -- 签约渠道编号
       ,t1.job_cd                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
  from ${iml_schema}.agt_unionpay_sign_info_h t1
 /* left join (select cust_id as party_id --所属客户编号
                   ,cust_acct_num  as acctno --账户编号  
               from ${iml_schema}.agt_dep_main_acct_info_h -- 存款账户信息历史
             where start_dt <= to_date('${batch_date}','yyyymmdd')
               and end_dt > to_date('${batch_date}','yyyymmdd')
               and job_cd = 'ncbsf1')t2
    on t1.sign_acct_id=t2.acctno */
 left join ${iol_schema}.ppps_u_contract t2
    on t2.sgn_no=t1.sign_agt_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='pppsf1'
;
commit;

-- 第二十组（共二十组）微信签约信息
insert /*+ append */ into ${icl_schema}.cmm_cust_sign_prod_info_ex(
   etl_dt                    -- 数据日期
   ,lp_id                    -- 法人编号
   ,sign_agt_id              -- 签约协议编号
   ,cust_id                  -- 客户编号
   ,sign_acct_id             -- 签约账户编号
   ,sign_org_id              -- 签约机构编号
   ,sign_teller_id           -- 签约柜员编号
   ,sign_org_name            -- 签约机构名称
   ,sign_prod_type_cd        -- 签约产品类型代码
   ,sign_prod_status_cd      -- 签约产品状态代码
   ,sign_dt                  -- 签约日期
   ,rels_dt                  -- 解约日期
   ,rels_org_id              -- 解约机构编号
   ,rels_teller_id           -- 解约柜员编号
   ,rels_org_name            -- 解约机构名称
   ,sign_mobile_no           -- 签约手机号
   ,sign_chn_id              -- 签约渠道编号
   ,job_cd                   -- 任务代码
   ,etl_timestamp            -- etl处理时间戳
)
select distinct to_date('${batch_date}','yyyymmdd')          -- 数据日期     
       ,'9999'                                           -- 法人编号     
       ,t1.cwb_cstno||t1.cwb_accno||t1.cwb_bindstatus||t1.cwb_firsttime           -- 签约协议编号   
       ,t1.cwb_cstno                                     -- 客户编号     
       ,t1.cwb_accno                                     -- 签约账户编号   
       ,' '                                              -- 签约机构编号   
       ,' '                                              -- 签约柜员编号   
       ,' '                                              -- 签约机构名称   
       ,'WE001'                                          -- 签约产品类型代码 
       ,decode(t1.cwb_bindstatus,'1','1','0')         -- 签约产品状态代码  绑定状态（0失败 1正常 2未绑定 3异常）
       ,${iml_schema}.dateformat_min(t1.cwb_firsttime)  -- 签约日期     
       ,''                                               -- 解约日期     
       ,' '                                              -- 解约机构编号   
       ,' '                                              -- 解约柜员编号   
       ,' '                                              -- 解约机构名称   
       ,''                                               -- 签约手机号    
       ,' '                                              -- 签约渠道编号
       ,'tbpsf120'                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
  from ${iol_schema}.tbps_cpr_wx_bindinf t1
 where 1=1
;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_cust_sign_prod_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_cust_sign_prod_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_cust_sign_prod_info_ex purge;
drop table ${icl_schema}.tmp_cmm_cust_sign_prod_info_01 purge;
-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_cust_sign_prod_info',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);