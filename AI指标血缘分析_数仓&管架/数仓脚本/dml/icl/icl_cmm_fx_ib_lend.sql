/*
Purpose:    共性加工层-外汇同业拆借
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20210713 icl_cmm_fx_ib_lend
CreateDate: 20190808
Logs:       20200110 翟若平 1、调整[当期余额]的取数逻辑
                            2、增加字段[客户编号、记账机构编号]
			      20200724 陈伟峰 增加字段[标准产品编号]，增加关联表agt_prod_rela_h取值
			      202009   周沁晖 增加字段【资产三分类代码】
            20210311 陈伟峰 修改科目过滤条件，增加科目2111%
            20210428 陈伟峰 增加字段【债券编号、债券面值、债券币种、质押比例、质押方式代码】
            20210520 陈伟峰 调整【债券面值】的取数逻辑，面值->面额
            20210621 陈伟峰 增加字段【应收利息科目编号、利息收入科目编号、利率调整频率代码、基准利率】
            20220315 陈伟峰 调整科目编号加工逻辑，去除101101和101102开头的科目
            20220519 温旺清	1、调整临时表【T9】的关联条件；
                            2、调整字段【科目编号、应收利息科目编号、利息收入科目编号】的取数口径
                            3、删除临时表【T5】
            20230628 徐子豪 新增字段【交易清算账户编号】、【交易对手账号】、【交易对手行号】、【交易对手行名称】
            20231023 徐子豪 新增字段【债券质押金额组合】
            20231229 饶雅   新增字段【交易员编号】
            20240710 陈伟峰 调整【当期余额】字段加工逻辑
            20240924 陈伟峰 调整【当日应计利息】字段加工逻辑，从余额变动表取
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_fx_ib_lend drop partition p_${retain_day};
alter table ${icl_schema}.cmm_fx_ib_lend add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_fx_ib_lend_ex purge;
drop table ${icl_schema}.cmm_fx_ib_lend_01 purge;

create table ${icl_schema}.cmm_fx_ib_lend_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_fx_ib_lend where 0=1;

-- 1.3 取【交易清算账户编号】、【交易对手账号】、【交易对手行号】、【交易对手行名称】
create table ${icl_schema}.cmm_fx_ib_lend_01
nologging
compress ${option_switch} for query high
as
select
   t9.tran_id as tran_id
   ,nvl(t10.recv_bank_acct_num,t11.recv_bank_acct_num) as ghb_clear_acct_id
   ,nvl(t12.recv_bank_acct_num,t13.recv_bank_acct_num) as cntpty_acct_id
   ,nvl(t12.acct_bank_bic_code,t13.acct_bank_bic_code) as cntpty_bank_no
   ,nvl(t12.acct_bank_name,t13.acct_bank_name) as cntpty_bank_name
 from ${iml_schema}.evt_tran_clear_route_info_h t9 --交易清算路径信息历史
left join ${iml_schema}.evt_clear_route_info_h t10 on t9.ghb_pay_clear_route_seq_num=t10.pk_seq_num
  and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t10.job_cd = 'ctmsf1'
left join ${iml_schema}.evt_clear_route_info_h t11 on t9.ghb_recvbl_clear_route_seq_num=t11.pk_seq_num
   and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t11.job_cd = 'ctmsf1'
left join ${iml_schema}.evt_clear_route_info_h t12 on t9.cntpty_pay_clear_route_seq_num = t12.pk_seq_num
  and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t12.job_cd = 'ctmsf1'
left join ${iml_schema}.evt_clear_route_info_h t13 on t9.cntpty_recvbl_clear_route_seq_num = t13.pk_seq_num
  and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t13.job_cd = 'ctmsf1'
where t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t9.job_cd = 'ctmsf1'
;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_fx_ib_lend_ex(
   etl_dt                 -- 数据日期
   ,lp_id                 -- 法人编号
   ,bus_id                -- 业务编号
   ,dept_id               -- 部门编号
   ,entry_org_id          -- 记账机构编号
   ,tran_acct_b_id        -- 交易账簿编号
   ,std_prod_id           -- 标准产品编号
   ,asset_thd_cls_cd      -- 资产三分类代码
   ,cust_id               -- 客户编号
   ,cntpty_id             -- 交易对手编号
   ,cntpty_name           -- 交易对手名称
   ,portf_id              -- 投组编号
   ,portf_name            -- 投组名称
   ,portf_class_name      -- 投组类型名称
   ,inv_port_status_cd    -- 投资组合状态代码
   ,subj_id               -- 科目编号
   ,int_recvbl_subj_id    -- 应收利息科目编号
   ,int_income_subj_id    -- 利息收入科目编号
   ,tran_aim_cd           -- 交易目的代码
   ,tran_dir_cd           -- 交易方向代码
   ,tran_mode_cd          -- 交易模式代码
   ,clear_way_cd          -- 清算方式代码
   ,ib_lend_type_cd       -- 拆借类型代码
   ,clear_org_cd          -- 清算机构代码
   ,input_dt              -- 录入日期
   ,tran_dt               -- 交易日期
   ,value_dt              -- 起息日期
   ,exp_dt                -- 到期日期
   ,tenor                 -- 期限
   ,int_rat_adj_way_cd    -- 利率调整方式代码
   ,int_rat_adj_freq_cd   -- 利率调整频率代码
   ,int_accr_base_cd      -- 计息基准代码
   ,int_rat_float_dir_cd  -- 利率浮动方向代码
   ,int_rat_float_point   -- 利率浮动点数
   ,int_rat_tenor_cd      -- 利率期限代码
   ,base_rat              -- 基准利率
   ,exec_int_rat          -- 执行利率
   ,curr_cd               -- 币种代码
   ,tran_amt              -- 交易金额
   ,exp_amt               -- 到期金额
   ,usd_tran_amt          -- 折美元交易金额
   ,inpwn_amt             -- 债券质押金额组合
   ,acru_int              -- 应计利息
   ,currt_bal             -- 当期余额
   ,td_acru_int           -- 当日应计利息
   ,currt_acru_int        -- 当期应计利息
   ,pay_int_ped_cd        -- 付息周期代码
   ,fir_pay_int_dt        -- 首次付息日期
   ,pay_stub_proc_way_cd  -- 付息残段处理方式代码
   ,bag_status_cd         -- 成交状态代码
   ,tran_src_cd           -- 交易来源代码
   ,tran_site_cd          -- 交易场所代码
   ,bag_id                -- 成交编号
   ,tran_id               -- 交易编号
   ,bond_id               -- 债券编号
   ,bond_fac_val          -- 债券面值
   ,bond_curr             -- 债券币种
   ,inpwn_ratio           -- 质押比例
   ,inpwn_way_cd          -- 质押方式代码
   ,ghb_clear_acct_id     -- 本方清算账户编号
   ,cntpty_acct_id        -- 交易对手账号
   ,cntpty_bank_no        -- 交易对手行号
   ,cntpty_bank_name      -- 交易对手行名称
   ,dealer_id             -- 交易员编号
   ,job_cd                -- 任务代码
   ,etl_timestamp         -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')  -- 数据日期
   ,t1.lp_id            -- 法人编号
   ,t1.bus_id           -- 业务编号
   ,t1.org_id           -- 部门编号
   ,t9.org_id           -- 记账机构编号
   ,t3.acct_b_id        -- 交易账簿编号
   ,t10.prod_id         -- 标准产品编号
   ,case when t3.asset_cate_name = '交易性金融资产' then 'FVTPL'
         when t3.asset_cate_name = '可供出售金融资产' then 'FVOCI'
         else 'AC' end  -- 资产三分类代码
   ,t8.cust_id          -- 客户编号
   ,t1.cntpty_id        -- 交易对手编号
   ,t1.cntpty_name      -- 交易对手名称
   ,t1.portf_id         -- 投组编号
   ,t1.portf_name       -- 投组名称
   ,t1.portf_type_name  -- 投组类型名称
   ,t1.portf_status_cd  -- 投资组合状态代码
   ,t3.pric_subj_id          -- 科目编号
   ,t3.int_cost_subj_id      -- 应收利息科目编号
   ,t3.int_income_subj_id    -- 利息收入科目编号
   ,t1.tran_aim_cd      -- 交易目的代码
   ,t1.tran_dir_cd      -- 交易方向代码
   ,t1.tran_mode_cd     -- 交易模式代码
   ,t1.clear_way_cd     -- 清算方式代码
   ,t1.ib_lend_type_cd  -- 拆借类型代码
   ,t1.clear_org_cd     -- 清算机构代码
   ,t1.input_dt         -- 录入日期
   ,t1.tran_dt          -- 交易日期
   ,t1.value_dt         -- 起息日期
   ,t1.exp_dt           -- 到期日期
   ,t1.ib_lend_days     -- 期限
   ,t1.int_rat_adj_way_cd   -- 利率调整方式代码
   ,''                      -- 利率调整频率代码
   ,t1.int_accr_base_cd     -- 计息基准代码
   ,t1.int_rat_float_dir_cd -- 利率浮动方向代码
   ,t1.int_rat_float_point  -- 利率浮动点数
   ,t1.int_rat_tenor_cd     -- 利率期限代码
   ,''                      -- 基准利率
   ,t1.ib_lend_int_rat      -- 执行利率
   ,t1.curr_cd              -- 币种代码
   ,t1.ib_lend_amt          -- 交易金额
   ,t1.term_end_stl_amt     -- 到期金额
   ,t1.convt_usd_curr_amt   -- 折美元交易金额
   ,t1.convt_amt            -- 债券质押金额组合
   ,t1.acru_int_tot         -- 应计利息
   --,t1.curr_bal           -- 当期余额
   ,abs(nvl(t3.hold_pos, 0)) --当期余额
   ,nvl(t3.td_acru_int,0)   -- 当日应计利息
   ,coalesce(t3.int_cost,0) -- 当期应计利息
   ,t1.pay_int_freq         -- 付息周期代码
   ,t1.fir_pay_int_dt       -- 首次付息日期
   ,t1.pay_stub_proc_way_cd -- 付息残段处理方式代码
   ,t6.tran_status_cd       -- 成交状态代码
   ,t1.tran_src_cd          -- 交易来源代码
   ,t1.tran_site_cd         -- 交易场所代码
   ,t1.bag_id               -- 成交编号
   ,t1.tran_flow_num        -- 交易编号
   ,t1.bond_id	            -- 债券编号
   ,nvl(trim(t1.cert_face_tot),0)	-- 债券面值
   ,substr(t1.bond_curr_cd,1,3)	              -- 币种代码
   ,nvl(trim(t1.convt_ratio),0)	  -- 折算比例
   ,t1.inpwn_way_descb	          -- 质押方式描述
   ,t11.ghb_clear_acct_id         -- 本方清算账户编号
   ,t11.cntpty_acct_id            -- 交易对手账号
   ,t11.cntpty_bank_no            -- 交易对手行号
   ,t11.cntpty_bank_name          -- 交易对手行名称
   ,t1.dealer_id                  -- 交易员编号
   ,t1.job_cd                     -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.agt_fx_ib_lend t1
  left join (select t1.acct_b_id,t1.int_cost,t1.hold_pos,t1.main_asset_id,t2.asset_cate_name,t1.pric_subj_id,t1.int_income_subj_id,t1.int_cost_subj_id,t3.int_cost as td_acru_int
               from ${iml_schema}.agt_fcurr_cap_asset_bal t1  --iol.t5/t6
              inner join (select acct_b_id
                                ,minor_asset_id
                                ,max(asset_bal_id) as asset_bal_id
                                ,asset_cate_name as asset_cate_name
                            from ${iml_schema}.agt_fcurr_cap_asset_bal
                           where bus_dt <= to_date('${batch_date}','yyyymmdd')
                             --and etl_dt = to_date('${batch_date}','yyyymmdd')
                             and job_cd = 'ctmsi1'
                           group by acct_b_id,minor_asset_id,asset_cate_name
                            ) t2
                on t1.asset_bal_id = t2.asset_bal_id
              left join ${iml_schema}.agt_fcurr_cap_asset_dtl t3
                on t1.bal_dtl_id=t3.bal_dtl_id
               and t3.bus_dt=to_date('${batch_date}','yyyymmdd') 
               and t3.etl_dt=to_date('${batch_date}','yyyymmdd') 
               and t3.job_cd ='ctmsi1'
             where t1.bus_cate_name in ('外币拆借/同存','外汇拆借/同存')
               and t1.job_cd = 'ctmsi1'
               --and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
               and t1.bus_dt <= to_date('${batch_date}','yyyymmdd')
                 ) t3
    on t1.bus_id = t3.main_asset_id
   left join (select t1.agt_id,t1.agt_status_cd as tran_status_cd
                from ${iml_schema}.agt_status_h t1
               where t1.agt_status_type_cd = 'CD1399'
                 and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 and t1.job_cd = 'ctmsf1'
                  ) t6
     on t1.agt_id = t6.agt_id
/*  left join (select aa.tran_flow_num, aa.exp_dt
               from ${iml_schema}.evt_fx_ib_lend_provi aa
              inner join (select tran_flow_num, max(provi_dt) as provi_dt
                           from ${iml_schema}.evt_fx_ib_lend_provi
                           where job_cd = 'ctmsi1'
                             and provi_dt <= to_date('${batch_date}', 'yyyymmdd')
                          group by tran_flow_num) bb
                 on aa.tran_flow_num = bb.tran_flow_num
                and aa.provi_dt = bb.provi_dt
              where aa.job_cd = 'ctmsi1'
                and aa.provi_dt <= to_date('${batch_date}', 'yyyymmdd')
                ) t7
    on t1.bus_id = t7.tran_flow_num
   and t7.exp_dt > to_date('${batch_date}', 'yyyymmdd')

  left join ${iml_schema}.evt_fx_ib_lend_provi t7
    on t1.bus_id = t7.tran_flow_num
   and t7.provi_dt = to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'ctmsi1'
*/
  left join ${iml_schema}.pty_fx_cap_cntpty t8
    on t1.cntpty_id = t8.cntpty_id
   and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'ctmsf1'
   and t8.id_mark <> 'D'
  left join (select core_bus_id,
                    curr_cd,
                    core_org_id as org_id,
                    row_number() over(partition by core_bus_id, curr_cd order by core_bus_id, core_org_id ) rn
               from ${iml_schema}.ref_fcurr_subj_map
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'ctmsf1'
            ) t9 --iol.t8
    on t3.pric_subj_id = t9.core_bus_id
   and t1.curr_cd = t9.curr_cd
   and t9.rn = 1
/* 2022-6-21 19:37:57：临时改用O层表IOL.CTMS_FBS_INTERFACE_ACCOUNT_MAPPING_V2
  left join (select t.accountingcode
                    ,t.core_accountingcode
                    ,t.crncy_code
                    ,t.core_org_id as org_id
                    ,row_number() over(partition by t.accountingcode, nvl(t.crncy_code, 'CNY') order by t.core_accountingcode, t.core_org_id) rn
               from ${iol_schema}.ctms_fbs_interface_account_mapping_v2 t
              where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')) t9
    on 'N'||t3.pric_subj_id = t9.accountingcode
   and t1.curr_cd = t9.crncy_code
   and t9.rn = 1
   */
  left join ${iml_schema}.agt_prod_rela_h t10
    on t1.agt_id=t10.agt_id
   and t1.lp_id=t10.lp_id
   and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd in('ctmsf1','ctmsf2')
  left join ${icl_schema}.cmm_fx_ib_lend_01 t11
    on t1.bus_id = t11.tran_id
 where t1.tran_dt <= to_date('${batch_date}','yyyymmdd') --交易日期
   and t1.job_cd = 'ctmsf1'
   and t1.id_mark <> 'D'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_fx_ib_lend exchange partition p_${batch_date} with table ${icl_schema}.cmm_fx_ib_lend_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_fx_ib_lend_ex purge;
--drop table ${icl_schema}.cmm_fx_ib_lend_01 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_fx_ib_lend',partname => 'p_${batch_date}', degree => 8, cascade => true);
