/*
Purpose:    共性加工层-资金债券借贷表:数据来源于本币资金交易系统（CTMS） 
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_cap_bond_debit_crdt
Createdate: 20190821
Logs:       20200110 翟若平 增加字段[客户编号、记账机构编号]
            20200724 陈伟峰 增加标准产品编号字段取值
			      20200724 周沁晖 增加字段【交易清算账户账号、交易清算银行行号】
			      20200828 周沁晖 调整字段【当期余额、当期应计利息】的取数逻辑
			      20200828 陈伟峰 REF_DC_SUBJ_MAP（本币科目映射）算法变更，--去除etl_dt
			      20200911 陈伟峰 修改t5的关联条件，截取minor_asset_id前4位关联
			      20200925 周沁晖 增加字段【资产三分类代码】,对应调整M层删除表AGT_CAP_ASSET_POST_BAL
			      20200925 陈伟峰 增加T1表的过滤条件（tran_status_cd in ('A','M')）
			      20201111 陈伟峰 调整资产三分类取数逻辑，从agt_cap_asset_bal中直取
			      20201112 陈伟峰 修改记账机构的取值逻辑，从ref_dc_subj_map匹配科目取->从ctms_tbs_interface_portf_depart_mapping匹配交易账簿取
			      20210205 周沁晖 调整【当期余额】取数口径
            20210223 陈伟峰 调整【当期余额】取数口径，当交易方向为01时，取持仓余额
			      20210623 何桐金 调整【记账机构编号】取数口径
			      20220407 陈伟峰 调整【客户编号】取数口径
			      20220409 陈伟峰 新增字段【账簿属性代码、交易清算银行行名】
				    20220519 温旺清 1、调整临时表【T7-本币科目映射】的关联条件；
                                  2、调整字段【科目编号、应收利息科目编号、利息收入科目编号】的取数口径
                                  3、调整临时表T5的取数逻辑			
			      20230726 陈伟峰 调整【当期余额】取数逻辑，新一代改了记账逻辑，债券借贷融出不再用质押券的券面总额加总记账，改回用融出标的券的券面总额记账			
			      20240103 陈伟峰 调整【交易员编号、交易员名称】取数逻辑	  

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_cap_bond_debit_crdt drop partition p_${retain_day};
alter table ${icl_schema}.cmm_cap_bond_debit_crdt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_bond_debit_crdt_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cap_bond_debit_crdt_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_cap_bond_debit_crdt where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_cap_bond_debit_crdt_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bus_id                                --业务编号
    ,dept_id                               --部门编号
    ,entry_org_id                          --记账机构编号
    ,tran_acct_b_id                        --交易账簿编号
    ,tran_acct_b_name                      --交易账簿名称
    ,acct_b_attr_cd                        --账簿属性代码
	  ,std_prod_id                           --标准产品编号
	  ,asset_thd_cls_cd                      --资产三分类代码
    ,cust_id                               --客户编号
    ,cntpty_id                             --交易对手编号
    ,cntpty_name                           --交易对手名称
    ,portf_id                              --投组编号
    ,portf_name                            --投组名称
    ,subj_id                               --科目编号
    ,tran_dir_cd                           --交易方向代码
    ,tran_dt                               --交易日期
    ,value_dt                              --起息日期
    ,exp_dt                                --到期日期
    ,tran_amt                              --交易金额
    ,exp_stl_amt                           --到期结算金额
    ,curr_cd                               --币种代码
    ,debit_crdt_fee_rat                    --借贷费率
    ,debit_crdt_days                       --借贷天数
    ,bond_fac_val_comb                     --债券面值组合
    ,inpwn_bond_comb                       --质押债券组合
    ,underly_bond_id                       --标的债券编号
    ,acru_int                              --应计利息
    ,tm_bg_stl_way_cd                      --期初结算方式代码
    ,term_end_stl_way_cd                   --期末结算方式代码
    ,tran_fee                              --交易费用
    ,tran_tax                              --交易税金
    ,tran_comm                             --交易佣金
    ,currt_bal                             --当期余额
    ,currt_acru_int                        --当期应计利息
    ,dealer_id                             --交易员编号
    ,dealer_name                           --交易员名称
    ,tran_id                               --交易编号
    ,tran_ref_no                           --交易参考号
    ,tran_clear_acct_id 				           --交易清算账户编号
    ,tran_clear_bank_no					           --交易清算银行行号
    ,tran_clear_bank_name                  --交易清算银行行名
    ,job_cd
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') --数据日期
    ,t1.lp_id                           --法人编号
    ,case when t1.tran_dir_cd = '01' then 'QB_'||t1.bus_id else 'QS_'||t1.bus_id end --业务编号
    ,t1.dept_id                         --部门编号
   -- ,t6.departmentid                    --记账机构编号
    ,t7.org_id                          --记账机构编号
    ,t1.acct_b_id                       --交易账簿编号
    ,t1.acct_b_name                     --交易账簿名称
    ,t11.acct_b_attr_cd                 --账簿属性代码
	  ,t1.std_prod_id                     --标准产品编号
	  ,nvl(t5.asset_thd_cls_cd,'AC')      --资产三分类代码
    ,t4.cust_id                         --客户编号
    ,t1.cntpty_id                       --交易对手编号
    ,t1.cntpty_name                     --交易对手名称
    ,t1.portf_id                        --投组编号
    ,t1.portf_name                      --投组名称
    ,t5.pric_subj_id     --科目编号 
    ,t1.tran_dir_cd                     --交易方向代码
    ,t1.fst_tran_dt                     --交易日期
    ,t1.fst_dlvy_dt                     --起息日期
    ,t1.exp_dlvy_dt                     --到期日期
    ,t1.fst_stl_amt                     --交易金额
    ,t1.exp_stl_amt                     --到期结算金额
    ,nvl(t10.pric_curr_cd,'CNY')        --币种代码
    ,t1.debit_crdt_fee_rat              --借贷费率
    ,t1.debit_crdt_days                 --借贷天数
    ,t1.inpwn_bond_denom_comb           --债券面值组合
    ,t1.inpwn_bond_id_comb              --质押债券组合
    ,t1.underly_bond_id                 --标的债券编号
    ,t1.acru_int                        --应计利息
    ,t1.fst_stl_way_cd                  --期初结算方式代码
    ,t1.exp_stl_way_cd                  --期末结算方式代码
    ,t1.fst_fee                         --交易费用
    ,t1.fst_tax                         --交易税金
    ,t1.fst_comm                        --交易佣金
    ,coalesce(t5.hold_pos,0)            --当期余额
    ,coalesce(t5.int_cost,0)            --利息成本
    ,t1.dealer_id                       --交易员编号
    ,t1.dc_dealer_name                  --交易员名称
    ,t1.tran_id                         --交易编号
    ,t1.bag_id                          --交易参考号
    ,t9.cash_acc_no        				      --交易清算账户编号
    ,t9.cash_acc_bank_ex	 			        --交易清算银行行号
    ,t9.cash_acc_bank                   --交易清算银行行名
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
  from ${iml_schema}.agt_bond_debit_crdt t1 --债券借贷
/* left join (select t1.agt_id
                  ,sum(regexp_substr(t1.inpwn_bond_denom_comb,'[^,]+',1,t2.lv)) as hold_fac_val
              from ${iml_schema}.agt_bond_debit_crdt t1
             inner join (select level as lv
                           from (select max(regexp_count(inpwn_bond_denom_comb,'[^,]+',1)) as r_count
                                   from ${iml_schema}.agt_bond_debit_crdt
                                  where create_dt <= to_date('${batch_date}', 'yyyymmdd')
                                    and tran_dir_cd = '02'
                                    and job_cd = 'ctmsf1'
                                    and id_mark <> 'D'
                                  ) t connect by level <= t.r_count
                         )t2
                on 1=1
             where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.tran_dir_cd = '02'
               and t1.job_cd = 'ctmsf1'
               and t1.id_mark <> 'D'
               and regexp_substr(t1.inpwn_bond_denom_comb,'[^,]+',1,t2.lv) is not null
               and t1.tran_dir_cd = '02'
             group by t1.agt_id
              ) t3  --将面值组合拆分为多行，然后进行汇总。(即对交易对应的面值进行汇总)
    on t1.agt_id = t3.agt_id
    */
  left join ${iml_schema}.pty_cap_cntpty_info t4
    on t1.cntpty_id = t4.cntpty_id
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ctmsf1'
   and t4.id_mark <> 'D' 
  left join ${iol_schema}.ctms_v_lt_wtrade_lend t12
	  on t1.bus_id = t12.wtrade_lend_id
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ( select  minor_asset_id,asset_type_name,create_dt,job_cd,id_mark,stl_dt,asset_bal_id,hold_pos,int_cost,asset_thd_cls_cd,pric_subj_id
                      ,row_number () over(partition by minor_asset_id order by stl_dt,asset_bal_id desc) rn 
                from ${iml_schema}.agt_cap_asset_bal 
				   where asset_type_name = '债券借贷'
                   and create_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and job_cd = 'ctmsf1'
                   and id_mark <> 'D'
             ) t5
  	on substr(t5.minor_asset_id, 4) = t12.wtrade_lend_id_grand
  	--on t1.bus_id = t5.minor_asset_id
   and t5.rn=1
  left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t6
    on t1.acct_b_id =t6.keepfolder_id
   and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t6.end_dt >to_date('${batch_date}','yyyymmdd')
  left join (select subj_id,
                    curr_cd,
                    org_id ,
                    bus_dept_id
--                    row_number() over(partition by subj_id, curr_cd order by core_bus_id, org_id ) rn
               from ${iml_schema}.ref_dc_subj_map 
              where job_cd = 'ctmsf1'
                --and etl_dt = to_date('${batch_date}', 'yyyymmdd')
                --and id_mark <> 'D'
            ) t7
	on 'N'||t5.pric_subj_id = t7.subj_id  -- N：新科目体系
	and nvl(decode(trim(t7.curr_cd),'-',null,t7.curr_cd), 'CNY') = 'CNY'
	and t6.departmentid = t7.bus_dept_id
--   and t7.rn = 1 
  left join ${iol_schema}.ctms_wtrade_tr_si t9
	  on t1.dept_id = t9.aspclient_id
   and t1.tran_dir_cd = decode(t9.bs,'B','01','S','02','00')
   and t1.tran_id = t9.serial_number
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
 --  and t9.id_mark <> 'D'
  left join ${iml_schema}.prd_bond_basic_info t10
    on t5.minor_asset_id = t10.bond_id
   and t10.job_cd = 'ctmsf1'
   and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.id_mark <> 'D'
  left join ${iml_schema}.agt_acct_b t11
    on t1.acct_b_id = t11.acct_b_id
   and t11.job_cd = 'ctmsf1'
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.id_mark <> 'D' 
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and t1.id_mark <> 'D'
   and (('${batch_date}' > '20200925' and t1.tran_status_cd in ('A','M'))or('${batch_date}' <= '20200925'))
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_cap_bond_debit_crdt exchange partition p_${batch_date} with table ${icl_schema}.cmm_cap_bond_debit_crdt_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_cap_bond_debit_crdt_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_cap_bond_debit_crdt', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);