/*
Purpose:    共性加工层-资金同业拆借
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_cap_ib_lend
Createdate: 20191025
Logs:       20200110 翟若平 增加字段[客户编号、记账机构编号]
            20200724 陈伟峰 增加字段[标准产品编号]
            20200724 周沁晖 增加字段【交易清算账户账号、交易清算银行行号】
            20200828 周沁晖 增加字段【资产三分类代码】
            20200828 陈伟峰 REF_DC_SUBJ_MAP（本币科目映射）算法变更，去掉etl_dt
			      20200925 陈伟峰 增加T1表的过滤条件（tran_status_cd in ('A','M')）
			      20201111 陈伟峰 调整资产三分类取数逻辑，从agt_cap_asset_bal中直取
			      20201112 陈伟峰 修改记账机构的取值逻辑，从ref_dc_subj_map匹配科目取->从ctms_tbs_interface_portf_depart_mapping匹配交易账簿取
            20210621 陈伟峰 增加字段【应收利息科目编号、利息收入科目编号】
            20210623 何桐金 调整【记账机构编号】取数口径
            20220305 陈伟峰 新增字段【交易品种编号】
            20220409 陈伟峰 新增字段【账簿属性代码、交易清算银行行名】
			      20220519 温旺清 1、调整临时表【T11】的关联条件；
                            2、调整字段【科目编号、应收利息科目编号、利息收入科目编号】的取数口径
                            3、调整临时表【T5】的取数逻辑		
            20221114 陈伟峰 调整ref_cap_cntpty_cls 关联逻辑，加入super_cls_id in ('2','11')，拆借仅有这两个分类，其他不是

 */

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_cap_ib_lend drop partition p_${retain_day};
alter table ${icl_schema}.cmm_cap_ib_lend add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


-- 2.1 insert into ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_ib_lend_ex purge;

create table ${icl_schema}.cmm_cap_ib_lend_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_cap_ib_lend where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_cap_ib_lend_ex(
   etl_dt               -- 数据日期
   ,lp_id               -- 法人编号
   ,bus_id              -- 业务编号
   ,dept_id             -- 部门编号
   ,entry_org_id        -- 记账机构编号
   ,tran_acct_b_id      -- 交易账簿编号
   ,tran_acct_b_name    -- 交易账簿名称
   ,acct_b_attr_cd      -- 账簿属性代码
   ,std_prod_id         -- 标准产品编号
   ,asset_thd_cls_cd	  -- 资产三分类代码
   ,cust_id             -- 客户编号
   ,cntpty_id           -- 交易对手编号
   ,cntpty_name         -- 交易对手名称
   ,cntpty_cls_id       -- 交易对手分类编号
   ,portf_id            -- 投组编号
   ,portf_name          -- 投组名称
   ,subj_id             -- 科目编号
   ,int_recvbl_subj_id  -- 应收利息科目编号
   ,int_income_subj_id  -- 利息收入科目编号
   ,tran_cate_cd        -- 交易类别代码
   ,tran_dir_cd         -- 交易方向代码
   ,tran_breed_id       -- 交易品种编号
   ,tran_dt             -- 交易日期
   ,value_dt            -- 起息日期
   ,exp_dt              -- 到期日期
   ,tenor               -- 期限
   ,exec_int_rat        -- 执行利率
   ,curr_cd             -- 币种代码
   ,tran_amt            -- 交易金额
   ,exp_amt             -- 到期金额
   ,acru_int            -- 应计利息
   ,tran_fee            -- 交易费用
   ,tran_tax            -- 交易税金
   ,tran_comm           -- 交易佣金
   ,currt_bal           -- 当期余额
   ,td_acru_int         -- 当日应计利息
   ,currt_acru_int      -- 当期应计利息
   ,dealer_id           -- 交易员编号
   ,dealer_name         -- 交易员名称
   ,cfets_tran_flg      -- cfets交易标志
   ,bag_id              -- 成交编号
   ,tran_id             -- 交易编号
   ,tran_clear_acct_id  -- 交易清算账户编号
   ,tran_clear_bank_no	-- 交易清算银行行号
   ,tran_clear_bank_name-- 交易清算银行名称
   ,job_cd
   ,etl_timestamp       --etl处理时间戳
)
select
    to_date('${batch_date}', 'yyyymmdd')    -- 数据日期
   ,t1.lp_id                       -- 法人编号
   ,case when t1.tran_dir_cd = '01' then 'II_'||t1.bus_id else 'IO_'||t1.bus_id end               -- 业务编号 01买入 02卖出
   ,t1.dept_id                     -- 部门编号
  -- ,t7.departmentid                -- 记账机构编号
   ,t11.org_id                     -- 记账机构编号
   ,t1.acct_b_id                   -- 交易账簿编号
   ,t1.acct_b_name                 -- 交易账簿名称
   ,t12.acct_b_attr_cd             -- 账簿属性代码
   ,t8.prod_id           	         -- 标准产品编号
   ,nvl(t4.asset_thd_cls_cd,'AC')	 -- 资产三分类代码
   ,t2.cust_id                     -- 客户编号
   ,t1.cntpty_id                   -- 交易对手编号
   ,t1.cntpty_name                 -- 交易对手名称
   --,t4.super_cls_id              -- 交易对手分类编号
   ,t3.super_cls_id                -- 交易对手分类编号
   ,t1.portf_id                    -- 投组编号
   ,t1.portf_name                  -- 投组名称
   ,t5.pric_subj_id                -- 科目编号
   ,t5.int_cost_subj_id            -- 应收利息科目编号
   ,t5.int_income_subj_id          -- 利息收入科目编号                
   ,t1.tran_cate_cd                -- 交易类别代码
   ,t1.tran_dir_cd                 -- 交易方向代码
   ,t1.repo_id                     -- 交易品种编号
   ,t1.fst_tran_dt                 -- 交易日期
   ,t1.fst_dlvy_dt                 -- 起息日期
   ,t1.exp_dlvy_dt                 -- 到期日期
   ,t1.ib_lend_days                -- 期限
   ,t1.ib_lend_int_rat             -- 执行利率
   ,nvl(t10.pric_curr_cd,'CNY')    -- 币种代码
   ,t1.fst_stl_amt                 -- 交易金额
   ,t1.exp_stl_amt                 -- 到期金额
   ,t1.acru_int                    -- 应计利息
   ,t1.fst_fee                     -- 交易费用
   ,t1.fst_tax                     -- 交易税金
   ,t1.fst_comm                    -- 交易佣金
   ,coalesce(t5.hold_pos,0)        -- 当期余额
   ,coalesce(t6.today_provi_int,0) -- 当日应计利息
   ,coalesce(t5.int_cost,0)        -- 当期应计利息
   ,t1.dealer_id                   -- 交易员编号
   ,t1.dealer_name                 -- 交易员名称
   ,t1.cfets_tran_flg              -- cfets交易标志
   ,t1.bag_id                      -- 成交编号
   ,t1.tran_id                     -- 交易编号
   ,t9.cash_acc_no        		     -- 交易清算账户编号
   ,t9.cash_acc_bank_ex	 		       -- 交易清算银行行号
   ,t9.cash_acc_bank               -- 交易清算银行名称
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.agt_cap_ib_lend t1  --资金同业拆借
  left join ${iml_schema}.pty_cap_cntpty_info t2 --资金交易对手信息
    on t1.cntpty_id = t2.cntpty_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ctmsf1'
   and t2.id_mark <> 'D'
  left join (select t1.cntpty_id
                    ,t2.tran_dir_cd
                    ,t2.super_cls_id
                    ,t2.cls_abbr
                    --,t3.subject_id
                from ${iml_schema}.pty_cap_cntpty_cls_h t1 --资金交易对手分类历史
                left join ${iml_schema}.ref_cap_cntpty_cls t2 --资金交易对手分类
                  on t1.cls_id = t2.cls_id
                 and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and t2.job_cd = 'ctmsf1'
                 and t2.super_cls_id in ('2','11')
                /* left join ${iml_schema}.fin_subject t3--科目
                  on t2.cls_abbr = t3.subj_name
                 and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd') */
               where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 and t1.job_cd = 'ctmsf1'
                ) t3
     on t2.cntpty_id = t3.cntpty_id
    and t1.tran_dir_cd = t3.tran_dir_cd
   left join (select dept_id,
   									 acct_b_id,
   									 minor_asset_id,
   									 main_asset_id,
   									 asset_type_name,
   									 bus_cate_name,
   									 stl_dt,
   									 asset_bal_id,
									 asset_thd_cls_cd,
   									 row_number() over(partition by dept_id,
                     acct_b_id,
                     minor_asset_id,
                     main_asset_id,
                     asset_type_name,
                     bus_cate_name order by stl_dt desc,asset_bal_id desc) as rn
   						 from ${iml_schema}.agt_cap_asset_bal
   						where create_dt <= to_date('${batch_date}', 'yyyymmdd')
    						and job_cd = 'ctmsf1'
    						and id_mark <> 'D') t4
   	 on (case when t1.tran_dir_cd = '01' then 'II_'||t1.bus_id else 'IO_'||t1.bus_id end) = t4.minor_asset_id
   	and t4.asset_type_name = '拆借'
   	and t4.rn = 1
   left join (select minor_asset_id
                    ,asset_bal_id
                    ,bus_table_name
                    ,acct_b_id
                    ,hold_pos
                    ,int_cost
                    ,stl_dt
					,pric_subj_id
					,int_cost_subj_id   
                    ,int_income_subj_id 
					,row_number() over(partition by minor_asset_id order by stl_dt desc,asset_bal_id desc) as rn
                from ${iml_schema}.agt_cap_asset_bal --资金资产持仓余额
               where asset_type_name = '拆借'
                 and job_cd = 'ctmsf1'
                --and etl_dt = to_date('${batch_date}', 'yyyymmdd')
                 and stl_dt <= to_date('${batch_date}', 'yyyymmdd')
                 ) t5 --取最新结算日期对应的余额
    on (case when t1.tran_dir_cd = '01' then 'II_'||t1.bus_id else 'IO_'||t1.bus_id end) = t5.minor_asset_id
   and t5.rn = 1
  left join ${iml_schema}.evt_cap_provi t6 --资金计提事件
    on t5.minor_asset_id = t6.main_asset_id
   and t5.acct_b_id = t6.acct_b_id
   and t6.provi_dt = to_date('${batch_date}', 'yyyymmdd') --计提日期
   and t6.job_cd = 'ctmsi1'
  left join ${iml_schema}.prd_bond_basic_info t10
    on t4.minor_asset_id = t10.bond_id
   and t10.job_cd = 'ctmsf1'
   and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.id_mark <> 'D'
  left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t7
    on t1.acct_b_id =t7.keepfolder_id
   and t7.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t7.end_dt >to_date('${batch_date}','yyyymmdd')
  left join (select subj_id,
                    curr_cd,
                    org_id as org_id,
                    bus_dept_id
--                    row_number() over(partition by subj_id, curr_cd order by core_bus_id, org_id ) rn
               from ${iml_schema}.ref_dc_subj_map 
              where job_cd = 'ctmsf1'
            ) t11
    on 'N'||t5.pric_subj_id = t11.subj_id  -- N：新科目体系
   and nvl(decode(trim(t11.curr_cd),'-',null,t11.curr_cd), 'CNY') = 'CNY'
   and t7.departmentid=t11.bus_dept_id
--   and t11.rn = 1    
  left join ${iml_schema}.agt_prod_rela_h t8
    on t1.agt_id=t8.agt_id 
   and t1.lp_id=t8.lp_id
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd in('ctmsf1','ctmsf2')
  left join ${iol_schema}.ctms_wtrade_tr_si t9
		on t1.dept_id = t9.aspclient_id
	 and t1.tran_dir_cd = decode(t9.bs,'B','01','S','02','00')
	 and t1.tran_id = t9.serial_number
	 and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
	 and t9.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_acct_b t12
    on t1.acct_b_id = t12.acct_b_id
   and t12.job_cd = 'ctmsf1'
   and t12.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t12.id_mark <> 'D'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and (('${batch_date}' > '20200925' and t1.tran_status_cd in ('A','M'))or('${batch_date}' <= '20200925'))
;

commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_cap_ib_lend exchange partition p_${batch_date} with table ${icl_schema}.cmm_cap_ib_lend_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_cap_ib_lend_ex purge;


-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_cap_ib_lend',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
