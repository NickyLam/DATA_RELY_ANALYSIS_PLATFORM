/*
purpose:    共性加工层-对公贷款申请信息：包括所有对公信贷类业务的业务申请和额度申请信息，包含对公表内贷款业务、表外业务、同业表内业务、同业表外业务等业务的借据信息。数据来源于综合信贷管理系统ICMS。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_loan_appl_info
createdate: 20200513
logs:       20220401 陈伟峰 新增字段【外部评级结果代码、外部评级机构编号、外部评级日期、主办行行号、参贷行行号、代理行行号】、调整【他用额度所有人编号、他用额度编号、他用额度类型代码】取值逻辑，改为取批复表 business_approve
            20220425 李森辉 1、取数数据源调整，由原对公信贷系统改成新的综合信贷系统
                            2、调整字段【业务品种编号】的取数口径（置空，新信贷整合到标准产品）
            20220606 李森辉 1、新增字段【标准产品编号】
                            2、调整字段【贷款期限、主办行行名称、参贷行行名称、代理行行名称、集团授信公司额度、集团授信公司敞口、集团授信同业额度、集团授信同业敞口】的加工口径
                            3、新增字段【主办行行号、参贷行行号、代理行行号】
                            4、置空字段【授信协议编号-CRDT_AGT_ID、主要担保人编号-MAJOR_GUARTOR_ID、主要担保人名称-MAJOR_GUARTOR_NAME、主还款方式代码-MAIN_REPAY_WAY_CD、还款周期代码-REPAY_PED_CD、子还款方式代码-SUB_REPAY_WAY_CD、其他用途-OTHER_USAGE_DESCB、生效标志-EFFECT_FLG、营销单位名称-CAMP_CORP_NAME、营销渠道编号-CAMP_CHN_ID、贷款保险保障标志-LOAN_INSURE_GUAR_FLG、随借随还标志-BAR_FLG、风险经理平行操作标志-RISK_MGR_SIMUS_OPER_FLG、快易贷标志-KY_L_FLG、审批结果流水号-APV_REST_FLOW_NUM】
                            5、调整T1表过滤条件【(T1.ISINUSE IS NULL OR T1.ISINUSE <> '2') -》 SUBSTR(T1.PRODUCTID, 1, 3) NOT IN ('201', '202')】
                            6、调整T2表的关联方式【INNER JOIN -> LEFT JOIN】
		        20220908 黄俊杰 【授信区域代码】 t5.crdt_rg_cd-》nvl(trim(t5.crdt_rg_cd),'00')
            20230221 温旺清 新增字段【额度项下可售产品编号】
            20231027 徐子豪 新增字段【项目融资标志】
            20240530 饶雅   1、新增字段【归口管理部门编号】2、新增字段【审批状态代码】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_appl_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_loan_appl_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_corp_loan_appl_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_loan_appl_info_ex purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_appl_info_01 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_appl_info_02 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_appl_info_03 purge;

-- 1.3 insert data to tmp table
-- 获取业务审批基本信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_appl_info_01
nologging
compress ${option_switch} for query high
as
select t1.agt_id
        ,t1.apv_flow_num
        ,t1.appl_flow_num
        ,t1.happ_dt
        ,t1.start_dt
        ,t1.end_dt
        ,row_number() over(partition by t1.appl_flow_num order by t1.happ_dt desc) rn  -- 排序编号
   from ${iml_schema}.agt_loan_apv_basic_info_h t1
  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd = 'icmsf1'
;

-- 获取合同信息（最新审批金额、主要担保方式代码、担保方式1、担保方式2、其他担保方式标志、贷款投向行业代码、用途、资产风险分类代码等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_appl_info_02
nologging
compress ${option_switch} for query high
as
select t1.apv_flow_num
        ,t1.out_acct_dt
        ,t1.cont_amt
        ,t1.main_guar_way_cd
        ,t1.sub_guar_way_cd
        ,t1.guar_way_cd_two
        ,t1.supp_guar_way_flg
        ,t1.nat_std_indus_dir_cd
        ,t1.usage_descb
        ,t1.level11_cls_cd
        ,t1.data_input_integy_flg
        ,t1.start_dt
        ,t1.end_dt
        ,row_number() over(partition by t1.apv_flow_num order by t1.cont_effect_dt desc) rn
   from ${iml_schema}.agt_loan_cont_info_h t1
  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd = 'icmsf1'
;

-- 获取额度切分信息（集团授信公司额度、集团授信公司敞口、集团授信同业额度、集团授信同业敞口等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_appl_info_03
nologging
compress ${option_switch} for query high
as
select t1.obj_id as obj_id,
       sum(decode(t2.cust_type_cd, '2', t1.nmal_amt)) as group_crdt_corp_lmt,
       sum(decode(t2.cust_type_cd, '3', t1.nmal_amt)) as group_crdt_ibank_lmt,
       sum(decode(t2.cust_type_cd, '2', t1.open_amt)) as group_crdt_corp_open,
       sum(decode(t2.cust_type_cd, '3', t1.open_amt)) as group_crdt_ibank_open
  from ${iml_schema}.agt_loan_lmt_seg_h t1
  left join ${iml_schema}.pty_cust t2
    on t1.seg_obj_id = t2.cust_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
   and t2.id_mark <> 'D'
 where t1.obj_type_name = 'CreditApply'
   and t1.seg_obj_type_cd = '03'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'
 group by t1.obj_id
;

-- 2.1 create temporary table cmm_corp_loan_appl_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_appl_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_loan_appl_info where 0=1;

-- 2.2 insert into data to temporary table cmm_corp_loan_appl_info_ex
--第一组（共一组）对公申请信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_loan_appl_info_ex(
       etl_dt                    -- 数据日期
       ,lp_id                    -- 法人编号
       ,loan_appl_flow_num       -- 贷款申请流水号
       ,rela_appl_flow_num       -- 关联申请流水号
       ,bus_breed_id             -- 业务品种编号
       ,std_prod_id              -- 标准产品编号
       ,lmt_under_sellbl_prod_id -- 额度项下可售产品编号
       ,cust_id                  -- 客户编号
       ,appl_dt                  -- 申请日期
       ,oper_org_cd              -- 经办机构代码
       ,operr_id                 -- 经办人编号
       ,oper_dt                  -- 经办日期
       ,rgst_org_cd              -- 登记机构代码
       ,rgstrat_id               -- 登记人编号
       ,rgst_dt                  -- 登记日期
       ,cent_mgmt_dept_cd        -- 归口管理部门编号
       ,appl_way_cd              -- 申请方式代码
       ,tenor_mon                -- 期限月份
       ,loan_tenor               -- 贷款期限
       ,circl_lmt_flg            -- 循环额度标志
       ,curr_cd                  -- 币种代码
       ,appl_amt                 -- 申请金额
       ,apved_dt                 -- 审批通过日期
       ,latest_apv_amt           -- 最新审批金额
       ,apv_status_cd            -- 审批状态代码
       ,happ_type_cd             -- 发生类型代码
       ,cap_src_cd               -- 资金来源
       ,crdt_agt_id              -- 授信协议编号
       ,bank_fin_tot             -- 银行融资总额
       ,major_guartor_id         -- 主要担保人编号
       ,major_guar_way_cd        -- 主要担保方式代码
       ,guar_way_1               -- 担保方式1
       ,guar_way_2               -- 担保方式2
       ,other_guar_way_flg       -- 其他担保方式标志
       ,major_guartor_name       -- 主要担保人名称
       ,main_repay_way_cd        -- 主还款方式代码
       ,repay_ped_cd             -- 还款周期代码
       ,sub_repay_way_cd         -- 子还款方式代码
       ,dir_cd                   -- 贷款投向行业代码
       ,usage_descb              -- 用途
       ,other_usage_descb        -- 其他用途
       ,effect_flg               -- 生效标志
       ,cust_type_cd             -- 客户类型代码
       ,camp_corp_name           -- 营销单位名称
       ,camp_chn_id              -- 营销渠道编号
       ,host_bk_bank_no          -- 主办行行号
       ,host_bank_name           -- 主办行行名称
       ,patip_loan_bank_bank_no  -- 参贷行行号
       ,patip_loan_bank_name     -- 参贷行行名称
       ,agent_bank_bank_no       -- 代理行行号
       ,agent_bank_name          -- 代理行行名称
       ,agent_patip_loan_flg     -- 代理参贷标志
       ,low_risk_bus_flg         -- 低风险业务标志
       ,risk_type_cd             -- 风险类型代码
       ,asset_risk_cls_cd        -- 资产风险分类代码
       ,crdt_rg_cd               -- 授信区域代码
       ,class_crdt_flg           -- 类信贷标志
       ,group_crdt_corp_lmt      -- 集团授信公司额度
       ,group_crdt_corp_open     -- 集团授信公司敞口
       ,group_crdt_ibank_lmt     -- 集团授信同业额度
       ,group_crdt_ibank_open    -- 集团授信同业敞口
       ,loan_insure_guar_flg     -- 贷款保险保障标志
       ,remote_loan_flg          -- 异地贷款标志
       ,estate_fin_flg           -- 房地产融资标志
       ,gover_fin_flg            -- 政府类融资标志
       ,consm_serv_fin_flg       -- 消费服务类融资标志
       ,br_build_ifin_flg        -- 一带一路建设投融资标志
       ,green_crdt_fin_flg       -- 绿色信贷融资标志
       ,proj_fin_flg             -- 项目融资标志
       ,turn_crdt_flg            -- 转授信标志
       ,bar_flg                  -- 随借随还标志
       ,ta_crdt_flg              -- 商圈授信标志
       ,risk_mgr_simus_oper_flg  -- 风险经理平行操作标志
       ,sm_flg                   -- 小微标志
       ,ky_l_flg                 -- 快易贷标志
       ,ts_flg                   -- 暂存标志
       ,apv_rest_flow_num        -- 审批结果流水号
       ,o_use_lmt_all_id         -- 他用额度所有人编号
       ,o_use_lmt_id             -- 他用额度编号
       ,o_use_lmt_type_cd        -- 他用额度类型代码
       ,ext_rating_rest_cd       -- 外部评级结果代码
       ,ext_rating_org_name      -- 外部评级机构名称
       ,ext_rating_dt            -- 外部评级日期
       ,job_cd                   -- 任务代码
       ,etl_timestamp            -- 数据处理时间
)

select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.appl_flow_num                                                 -- 贷款申请流水号
       ,t1.rela_flow_num                                                 -- 关联申请流水号
       ,''                                                               -- 业务品种编号
       ,t1.prod_id                                                       -- 标准产品编号
       ,t1.lmt_base_prod_id                                              -- 额度项下可售产品编号
       ,t1.cust_id                                                       -- 客户编号
       ,t1.happ_dt                                                       -- 申请日期
       ,t1.oper_org_id                                                   -- 经办机构代码
       ,t1.oper_teller_id                                                -- 经办人编号
       ,t1.oper_dt                                                       -- 经办日期
       ,t1.rgst_org_id                                                   -- 登记机构代码
       ,t1.rgst_teller_id                                                -- 登记人编号
       ,t1.rgst_dt                                                       -- 登记日期
       ,t7.cent_mgmt_dept_cd                                             -- 归口管理部门编号
       ,t1.appl_way_cd                                                   -- 申请方式代码
       ,t1.mon_tenor                                                     -- 期限月份
       ,t1.mon_tenor                                                     -- 贷款期限
       ,nvl(trim(t1.lmt_circl_flg),'-')                                  -- 循环额度标志
       ,nvl(trim(t1.curr_cd),'CNY')                                      -- 币种代码
       ,t1.appl_amt                                                      -- 申请金额
       ,t5.apv_dt                                                        -- 审批通过日期
       ,t4.cont_amt                                                      -- 最新审批金额
       ,t1.apv_status_cd                                                 -- 审批状态代码
       ,t1.loan_distr_type_cd                                            -- 发生类型代码
       ,nvl(trim(t7.cap_src_cd),'-')                                     -- 资金来源
       ,''                                                               -- 授信协议编号
       ,t1.lmt_open_amt                                                  -- 银行融资总额
       ,''                                                               -- 主要担保人编号
       ,t4.main_guar_way_cd                                              -- 主要担保方式代码
       ,t4.sub_guar_way_cd                                               -- 担保方式1
       ,nvl(trim(t4.guar_way_cd_two),'-')                                -- 担保方式2
       ,t4.supp_guar_way_flg                                             -- 其他担保方式标志
       ,''                                                               -- 主要担保人名称
       ,''                                                               -- 主还款方式代码
       ,''                                                               -- 还款周期代码
       ,''                                                               -- 子还款方式代码
       ,t4.nat_std_indus_dir_cd                                          -- 贷款投向行业代码
       ,t4.usage_descb                                                   -- 用途
       ,''                                                               -- 其他用途
       ,''                                                               -- 生效标志
       ,nvl(trim(t6.cust_type_cd),'-')                                   -- 客户类型代码
       ,''                                                               -- 营销单位名称
       ,''                                                               -- 营销渠道编号
       ,t5.host_bank_no                                                  -- 主办行行号
       ,t5.host_bank_name                                                -- 主办行行名称
       ,t5.patip_loan_bank_no                                            -- 参贷行行号
       ,t5.patip_loan_bank_name                                          -- 参贷行行名称
       ,t5.agent_bank_no                                                 -- 代理行行号
       ,t5.agent_bank_name                                               -- 代理行行名称
       ,t5.agent_patip_loan_flg                                          -- 代理参贷标志
       ,t1.low_risk_bus_flg                                              -- 低风险业务标志
       ,nvl(trim(t1.risk_type_cd),'-')                                   -- 风险类型代码
       ,t4.level11_cls_cd                                                -- 资产风险分类代码
       ,nvl(trim(t5.crdt_rg_cd),'00')                                    -- 授信区域代码
       ,nvl(trim(t5.class_crdt_flg),'-')                                 -- 类信贷标志
       ,t8.group_crdt_corp_lmt                                           -- 集团授信公司额度
       ,t8.group_crdt_corp_open                                          -- 集团授信公司敞口
       ,t8.group_crdt_ibank_lmt                                          -- 集团授信同业额度
       ,t8.group_crdt_ibank_open                                         -- 集团授信同业敞口
       ,''                                                               -- 贷款保险保障标志
       ,nvl(trim(t1.remote_bus_flg),'-')                                 -- 异地贷款标志
       ,nvl(trim(t5.invo_estate_fin_flg),'-')                            -- 房地产融资标志
       ,nvl(trim(t5.invo_gover_class_fin_flg),'-')                       -- 政府类融资标志
       ,nvl(trim(t5.consm_serv_class_fin_flg),'-')                       -- 消费服务类融资标志
       ,nvl(trim(t5.br_build_ifin_flg),'-')                              -- 一带一路建设投融资标志
       ,nvl(trim(t5.green_crdt_fin_flg),'-')                             -- 绿色信贷融资标志
       ,nvl(trim(t7.proj_fin_flg),'-')                                   -- 项目融资标志
       ,nvl(trim(t7.turn_crdt_flg),'-')                                  -- 转授信标志
       ,''                                                               -- 随借随还标志
       ,nvl(trim(t7.ta_crdt_flg),'-')                                    -- 商圈授信标志
       ,''                                                               -- 风险经理平行操作标志
       ,nvl(trim(t7.sm_retl_flg),'-')                                    -- 小微标志
       ,''                                                               -- 快易贷标志
       ,nvl(trim(t4.data_input_integy_flg),'-')                          -- 暂存标志
       ,''                                                               -- 审批结果流水号
       ,t5.o_use_lmt_owner_name                                          -- 他用额度所有人编号
       ,t5.o_use_lmt_flow_num                                            -- 他用额度编号
       ,t5.o_use_lmt_type_cd                                             -- 他用额度类型代码
       ,nvl(trim(t7.ext_rating_rest_cd),'-')                              -- 外部评级结果代码
       ,t7.ext_rating_org_name                                           -- 外部评级机构名称
       ,t7.ext_rating_dt                                                 -- 外部评级日期
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_appl_basic_info_h t1
  inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd not in ('2','3','4')   --零售贷款,联合网贷,个人委托贷款
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${icl_schema}.tmp_cmm_corp_loan_appl_info_01 t3
    on t1.appl_flow_num = t3.appl_flow_num
   and t3.rn = 1
  left join ${icl_schema}.tmp_cmm_corp_loan_appl_info_02 t4
    on t3.apv_flow_num = t4.apv_flow_num
   and t4.rn = 1
  left join ${iml_schema}.agt_loan_apv_lmt_attach_info_h t5
    on t3.apv_flow_num = t5.apv_flow_num
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'icmsf1'
  left join ${iml_schema}.pty_cust t6
    on t1.cust_id = t6.cust_id
   and t6.id_mark <> 'D'
   and t6.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'eifsf1'
  left join ${iml_schema}.agt_loan_appl_lmt_attach_info_h t7
    on t1.appl_id = t7.appl_id
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'icmsf1'
  left join ${icl_schema}.tmp_cmm_corp_loan_appl_info_03 t8
    on t1.appl_flow_num = t8.obj_id
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1';
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_appl_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_appl_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_loan_appl_info_ex purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_appl_info_01 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_appl_info_02 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_appl_info_03 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_corp_loan_appl_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
