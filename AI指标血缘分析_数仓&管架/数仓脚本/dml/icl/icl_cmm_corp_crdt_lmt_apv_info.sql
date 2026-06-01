/*
purpose:    共性加工层-对公授信额度审批信息：包括所有对公信贷类业务的业务申请和额度审批信息，包含对公表内贷款业务、表外业务、同业表内业务、同业表外业务等业务。数据来源于综合信贷管理系统ICMS。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_crdt_lmt_apv_info
createdate: 20210121
logs:       20210121 谢  宁 【对公授信额度审批信息表】建模
            20211107 何桐金 新增字段【主担保方式代码,低风险业务标志,低风险业务类型代码,批复类型代码,合同登记标志,
                                     文本合同编号,可用他用额度,他用额度编号,他用额度类型代码,他用额度所有人编号,
                                     集团授信额度公司部分,集团授信敞口公司部分,集团授信额度同业部分,集团授信额度同业部分,关联集团批复编号】							
            20220425 李森辉 1、取数数据源调整，由原对公信贷系统改成新的综合信贷系统
                            2、新增字段【占用他用额度标志】
            20220606 李森辉 1、新增字段【标准产品编号】
                            2、新增字段【关联原合同编号、经办日期】
                            3、调整字段【集团授信标志、低风险业务类型代码】的取数口径
                            4、置空字段【审批通过批复编号-APVED_REPLY_ID】
                            5、增加T1表过滤条件【SUBSTR(T1.PRODUCTID, 1, 3) NOT IN ('201', '202') 】
                            6、调整T2表的关联方式【INNER JOIN -> LEFT JOIN】
            20221226 温旺清 调整【低风险业务标志】取数口径
*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_crdt_lmt_apv_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_crdt_lmt_apv_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_corp_crdt_lmt_apv_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_crdt_lmt_apv_info_ex purge;

-- 2.1 create temporary table cmm_corp_crdt_lmt_apv_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_crdt_lmt_apv_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_crdt_lmt_apv_info where 0=1;

-- 2.2 insert into data to temporary table cmm_corp_crdt_lmt_apv_info_ex

--第一组（共一组）对公申请信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_crdt_lmt_apv_info_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,crdt_lmt_apv_flow_num        -- 授信额度审批流水号
       ,rela_crdt_lmt_apv_flow_num   -- 关联授信额度审批流水号
       ,rela_init_cont_id            -- 关联原合同编号
       ,bus_breed_id                 -- 业务品种编号
       ,std_prod_id                  -- 标准产品编号
       ,cust_id                      -- 客户编号
       ,happ_type_cd                 -- 发生类型代码
       ,crdt_rg_rg_cd                -- 授信区域地区代码
       ,crdt_apv_status_cd           -- 授信审批状态代码
       ,rgst_org_cd                  -- 登记机构代码
       ,rgstrat_id                   -- 登记人编号
       ,oper_org_cd                  -- 经办机构代码
       ,operr_id                     -- 业务业务经办人编号
       ,final_apver_id               -- 最终审批人编号
       ,loan_tenor                   -- 贷款期限
       ,curr_cd                      -- 币种代码
       ,crdt_apv_amt                 -- 授信审批金额
       ,crdt_apv_open_amt            -- 授信审批敞口金额
       ,rgst_dt                      -- 登记日期
       ,oper_dt                      -- 经办日期
       ,apv_dt                       -- 审批日期
       ,apved_dt                     -- 审批通过日期
       ,crdt_lmt_begin_dt            -- 授信额度起始日期
       ,crdt_lmt_exp_dt              -- 授信额度到期日期
       ,apved_reply_id               -- 审批通过批复编号
       ,crdt_lmt_effect_flg          -- 授信额度生效标志
       ,lmt_circl_flg                -- 额度可循环标志
       ,group_crdt_flg               -- 集团授信标志
       ,estate_class_fin_flg         -- 房地产类融资标志
       ,gover_class_fin_flg          -- 政府类融资标志
       ,consm_serv_class_fin_flg     -- 消费服务类融资标志
       ,br_build_class_fin_flg       -- 一带一路建设类融资标志
       ,green_crdt_class_fin_flg     -- 绿色信贷类融资标志
       ,crdt_lmt_apv_opinion         -- 授信额度审批意见
       ,crdt_lmt_usage_descb         -- 授信额度用途描述
       ,crdt_lmt_spent_plan          -- 授信额度用款计划
       ,main_guar_way_cd             -- 主担保方式代码
       ,low_risk_biz_ind             -- 低风险业务标志
       ,low_risk_biz_type_cd         -- 低风险业务类型代码
       ,reply_type_cd                -- 批复类型代码
       ,cont_regi_ind                -- 合同登记标志
       ,text_cont_id                 -- 文本合同编号
       ,aval_o_use_lmt               -- 可用他用额度
       ,ocup_o_use_lmt_flg           -- 占用他用额度标志
       ,o_use_lmt_id                 -- 他用额度编号
       ,o_use_lmt_type_cd            -- 他用额度类型代码
       ,o_use_lmt_all_id             -- 他用额度所有人编号
       ,group_crdt_lmt_corp_part     -- 集团授信额度公司部分
       ,group_crdt_expos_corp_part   -- 集团授信敞口公司部分
       ,group_crdt_lmt_ibank_part    -- 集团授信额度同业部分
       ,group_crdt_expos_ibank_part  -- 集团授信敞口同业部分
       ,rela_group_reply_id          -- 关联集团批复编号
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                              -- 数据日期
       ,t1.lp_id                                                                        -- 法人编号
       ,t1.apv_flow_num                                                                 -- 授信额度审批流水号
       ,t1.appl_flow_num                                                                -- 关联授信额度审批流水号
       ,t1.rela_old_cont_id                                                             -- 关联原合同编号
       ,''                                                                              -- 业务品种编号
       ,t1.prod_id                                                                      -- 标准产品编号
       ,t1.cust_id                                                                      -- 客户编号
       ,t1.loan_distr_type_cd                                                           -- 发生类型代码
       ,nvl(trim(t3.crdt_rg_cd),'00')                                                   -- 授信区域地区代码
	     ,case when t4.phasetype = '1010' then '601'    --提交
             when t4.phasetype = '1020' then '111'    --审批中
             when t4.phasetype = '1030' then '992'    --退回
             when t4.phasetype = '1040' then '997'    --通过
             else '997' 
        end                                           																	--授信审批状态代码		
       ,t1.rgst_org_id                                                                  -- 登记机构代码
       ,t1.rgst_teller_id                                                               -- 登记人编号
       ,t1.oper_org_id                                                                  -- 经办机构代码
       ,t1.oper_teller_id                                                               -- 业务业务经办人编号
       ,case when trim(t5.userid) is not null then t5.userid
             when trim(t6.userid) is not null then t6.userid
             else ''
        end                                                                             -- 最终审批人编号                  
       ,t1.mon_tenor                                                                    -- 贷款期限
       ,nvl(trim(t1.curr_cd),'-')                                                       -- 币种代码
       ,t1.apv_amt                                                                      -- 授信审批金额
       ,t1.lmt_open_amt                                                                 -- 授信审批敞口金额
       ,t1.rgst_dt                                                                      -- 登记日期
       ,t1.oper_dt                                                                      -- 经办日期
       ,t1.modif_dt                                                                     -- 审批日期
       ,t3.apv_dt                                                                       -- 审批通过日期
			,case when t3.apv_dt = to_date('29991231','yyyymmdd') and t1.happ_dt = to_date('00010101','yyyymmdd') then to_date('29991231','yyyymmdd')
            when t3.apv_dt < to_date('29991231','yyyymmdd') then trunc(t3.apv_dt)
            when t1.happ_dt  > to_date('00010101','yyyymmdd') then trunc(t1.happ_dt) 
            else to_date('29991231','yyyymmdd') 
       end	                                                                            -- 授信额度起始日期
			,case when t3.apv_dt = to_date('29991231','yyyymmdd') and t1.happ_dt = to_date('00010101','yyyymmdd') then to_date('29991231','yyyymmdd')
            when t3.apv_dt < to_date('29991231','yyyymmdd') then add_months(t3.apv_dt - 1,t1.mon_tenor)
            when t1.happ_dt  > to_date('00010101','yyyymmdd') then add_months(t1.happ_dt - 1,t1.mon_tenor)  
            else to_date('29991231','yyyymmdd') 
        end	                                                                            --授信额度到期日期
       ,''                                                                              -- 审批通过批复编号
       ,t1.effect_flg                                                                   -- 授信额度生效标志
       ,t1.lmt_circl_flg                                                                -- 额度可循环标志
       ,decode(t1.prod_id, '100030000001', '1', '0')                                    -- 集团授信标志
       ,t3.invo_estate_fin_flg                                                          -- 房地产类融资标志
       ,t3.invo_gover_class_fin_flg                                                     -- 政府类融资标志
       ,t3.consm_serv_class_fin_flg                                                     -- 消费服务类融资标志
       ,t3.br_build_ifin_flg                                                            -- 一带一路建设类融资标志
       ,t3.green_crdt_fin_flg                                                           -- 绿色信贷类融资标志
       ,t3.final_apv_opinion_one                                                        -- 授信额度审批意见
       ,t1.usage_descb                                                                  -- 授信额度用途描述
       ,' '                                                                             -- 授信额度用款计划
       ,t1.main_guar_way_cd                                                             -- 主担保方式代码
       ,decode(t1.risk_type_cd,'02','1','01','0','03','0','-')                          -- 低风险业务标志
       ,t1.risk_type_cd                                                                 -- 低风险业务类型代码
       ,nvl(trim(t1.reply_type_cd),'00')                                                -- 批复类型代码
--       ,t1.create_cont_flg                                                              -- 合同登记标志
       ,case when t7.apv_flow_num is not null then '1' else '0' end                     -- 合同登记标志
       ,''                                                                              -- 文本合同编号
       ,0                                                                               -- 可用他用额度
       ,t3.ocup_o_use_lmt_flg                                                           -- 占用他用额度标志
       ,t3.o_use_lmt_flow_num                                                           -- 他用额度编号
       ,t3.o_use_lmt_type_cd                                                            -- 他用额度类型代码
       ,t3.o_use_lmt_owner_name                                                         -- 他用额度所有人编号
       ,t3.corp_lmt_amt                                                                 -- 集团授信额度公司部分
       ,t3.corp_open_amt                                                                -- 集团授信敞口公司部分
       ,t3.ibank_lmt_amt                                                                -- 集团授信额度同业部分
       ,t3.ibank_open_amt                                                               -- 集团授信敞口同业部分
       ,t3.group_apv_id                                                                 -- 关联集团批复编号
       ,t1.job_cd                                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                 -- 数据处理时间
  from ${iml_schema}.agt_loan_apv_basic_info_h t1
  inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd not in ('2','3','4')   --零售贷款,联合网贷,个人委托贷款
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_apv_lmt_attach_info_h t3
    on t1.agt_id = t3.agt_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${iol_schema}.icms_flow_object t4
    on t1.apv_flow_num = t4.objectno
   and (t4.objecttype = 'ApproveApply' or t4.objecttype = 'HXTYApproveApply')
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join (select ft.objectno   as objectno,
                    ft.objecttype as objecttype,
                    ft.userid     as userid
               from ${iol_schema}.icms_flow_task ft
               left join ${iol_schema}.icms_flow_task ft1
                      on ft.serialno = ft1.relativeserialno
                     and ft1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                     and ft1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                   where ft.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                     and ft.end_dt >to_date('${batch_date}', 'yyyymmdd')
                     and ft1.phaseno = '1000'
                     and (ft1.objecttype = 'ApproveApply' or ft1.objecttype = 'HXTYApproveApply')) t5
         on t4.objectno = t5.objectno
        and t4.objecttype = t5.objecttype
 left join (select  ft.objectno   as objectno,
                    ft.objecttype as objecttype,
                    ft.userid     as userid
               from ${iol_schema}.icms_flow_task ft
               left join ${iol_schema}.icms_flow_task ft1
                      on ft.serialno = ft1.relativeserialno
                     and ft1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                     and ft1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                   where ft.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                     and ft.end_dt >to_date('${batch_date}', 'yyyymmdd')
                     and ft1.phaseno = '1000'
                     and (ft1.objecttype = 'CreditApply' or ft1.objecttype = 'HXTYCreditApply')) t6
         on t6.objectno = t1.appl_flow_num
        and (t6.objecttype = 'CreditApply' or t6.objecttype = 'HXTYCreditApply')   
left join 
(select distinct apv_flow_num 
  from  ${iml_schema}.agt_loan_cont_info_h 
  where start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and end_dt > to_date('${batch_date}', 'yyyymmdd')
    and job_cd = 'icmsf1'
) t7	
    on t1.apv_flow_num=t7.apv_flow_num
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1';
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_crdt_lmt_apv_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_crdt_lmt_apv_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_crdt_lmt_apv_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_crdt_lmt_apv_info', partname => 'p_${batch_date}', estimate_percent => 10, method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);