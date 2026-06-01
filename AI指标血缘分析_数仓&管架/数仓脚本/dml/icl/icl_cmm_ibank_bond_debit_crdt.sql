/*
Purpose:    共性加工层-同业债券借贷表:包括同业债券借贷的交易信息，数据来源于同业系统（IBMS）,结算方式均为实时全额交收；
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_ibank_bond_debit_crdt
Createdate: 20191025
Logs:       20250417 陈伟峰 新增模型
       
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_bond_debit_crdt drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_bond_debit_crdt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ibank_bond_debit_crdt_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_02 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_bond_debit_crdt_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ibank_bond_debit_crdt where 0=1;

--2.2 insert into tmp table
create table ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_01 as
select acctg_obj_id as obj_id,
       max(org_id)                                                as org_id,                      -- 机构编号
       max(decode(gzb_type, '1', subj_code, '')) as subj_id1,
       max(decode(gzb_type, '1', subj_code, '9', subj_code, '')) as subj_id,
       max(decode(gzb_type, '3.1', subj_code, '')) as int_subj_id,
       max(decode(gzb_type, 'X', subj_code, '')) as int_subj_id2,
       max(decode(gzb_type, '2', subj_code, '')) as int_adj_subj_id,
       max(decode(gzb_type, '4.1', subj_code, '')) as evha_val_chag_subj_id,
       max(decode(gzb_type, '5.1.1', subj_code, '')) as acru_int_inco_subj_id,
       max(decode(gzb_type, '5.1.2', subj_code, '5.1', subj_code, ''))  as amort_int_income_subj_id,
       max(decode(gzb_type, '5.3', subj_code, '')) as evha_val_chag_pl_subj_id,
       max(decode(gzb_type, '5.2.1', subj_code, '')) as spd_pl_subj_id,
       max(decode(gzb_type, '5.1.1', '22210202', '')) as acru_int_inco_subj_id_1,
       max(decode(gzb_type, '5.1.2', '22210203', '')) as amort_int_income_subj_id_1,
       max(decode(gzb_type, '5.2.1', '22210203', '')) as spd_pl_subj_id_1,
       max(decode(gzb_type, '3.2', subj_code, '')) as un_int_subj_id
  from (select distinct a.subj_code, a.acctg_obj_id, b.gzb_type,a.subj_org_id as org_id
               from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg a
                  left join ${iol_schema}.ibms_ttrd_accounting_entry_def b
                    on a.subj_code = b.acting_code
                  and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
              where a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and replace(a.beg_date, '-', '') = '${batch_date}') -- 20201027 翟若平 新增
 group by acctg_obj_id;
commit;


--手工记账利息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_02 as
 select tt1.subj_code, tt1.gzb_type,sum(tt1.value) as value,tt1.core_acct_name,tt1.trade_id,tt1.typename
   from (select t1.subj_id as subj_code,
                 case when t2.charge_type_cd='3.1'  --3利息，3.1应计利息
                 then case when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应收利息%' then '3.2'
                         when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应计利息%' then '3.1'
                            end
                  else t2.charge_type_cd
                  end as gzb_type,
                case when t1.debit_crdt_dir_cd = 'D' then t1.entry_amt
                         when t1.debit_crdt_dir_cd = 'C' then -1 * t1.entry_amt
                         end as value,
                t.tran_id as trade_id,
                t1.core_acct_name,
                case when t1.core_acct_name like '计入其他综合收益%' or t1.core_acct_name like '可供出售%' then 'FVOCI类'
                         when t1.core_acct_name like '交易性%' then 'FVTPL类'
                         when t1.core_acct_name like '以摊余成本计量%' or t1.core_acct_name like '应收款项%' then 'AC类'
                            else '' end  as typename
           from ${iml_schema}.evt_ibank_manual_entry_evt t --ttrd_manual_bk_record t
              left join ${iml_schema}.evt_ibank_acct_ety_evt t1 --ttrd_bookkeeping_entry_his t1
               on t.entry_flow_num = t1.entry_flow_num
             and t1.job_cd ='ibmsi1'
              left join ${iml_schema}.ref_ibank_accti_subj_para t2 --ttrd_accounting_entry_def t2
                on t1.subj_id=t2.accti_code
              and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t2.job_cd = 'ibmsf1'
              and t2.id_mark <> 'D'
         where t.entry_status_cd = '03'
              and t2.charge_type_cd in ('2','3.1','4.1')
              and t.entry_type_cd<>'03'
              and trim(t.tran_id) is not null
              and t.entry_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t.job_cd ='ibmsi1'
      ) tt1
 group by tt1.subj_code, tt1.trade_id, tt1.gzb_type,tt1.typename,tt1.core_acct_name;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_bond_debit_crdt_ex(
         etl_dt                                   --数据日期
        ,lp_id                                    --法人编号
        ,bus_id                                   --业务编号
        ,entry_org_id                          --记账机构编号
        ,ext_secu_acct_id                    --外部证券账户编号
        ,intnal_secu_acct_id                --内部证券账户编号
        ,fin_instm_id                           --金融工具编号
        ,asset_type_id                         --资产类型编号
        ,asset_type_name                   --资产类型名称
        ,market_type_id                     --市场类型编号
        ,obj_id                                    --对象编号
        ,asset_uniq_idf_id                   --资产唯一标识编号
        ,prod_type_cd                        --产品类型代码
        ,tran_acct_b_id                       --交易账簿编号
        ,tran_acct_b_name                  --交易账簿名称
        ,acct_b_attr_cd                       --账簿属性代码
        ,std_prod_id                           --标准产品编号
        ,asset_thd_cls_cd                    --资产三分类代码
        ,curr_cd                                  --币种代码
        ,tran_dir_cd                            --交易方向代码
        ,int_accr_base_cd                    --计息基准代码	
        ,cntpty_cust_id                        --交易对手客户编号
        ,cntpty_id                               --交易对手编号
        ,cntpty_name                         --交易对手名称
        ,portf_id                                --投组编号
        ,portf_name                           --投组名称
        ,pric_subj_id                           --本金科目编号
        ,int_subj_id                             --利息科目编号
        ,tran_dt                                  --交易日期
        ,value_dt                                --起息日期
        ,exp_dt                                   --到期日期
        ,tran_amt                                --交易金额
        ,exp_stl_amt                            --到期结算金额
        ,debit_crdt_fee_rat                   --借贷费率
        ,debit_crdt_days                      --借贷天数
        ,inpwn_bond_comb                 --质押债券组合
        ,underly_bond_id                     --标的债券编号
        ,inpwn_cert_face_lmt               --质押券面额
        ,acru_int                                  --应计利息
        ,int_recvbl                               --应收利息
        ,hold_pos                                --持有仓位
        ,currt_bal                                 --当期余额
        ,tran_id                                   --交易编号
        ,tran_clear_acct_id                   --交易清算账户编号
        ,tran_clear_bank_no                --交易清算银行行号
        ,tran_clear_bank_name            --交易清算银行行名
        ,job_cd                                    --任务代码
        ,etl_timestamp                        --数据处理时间
)
select 
        to_date('${batch_date}','yyyymmdd')                                                                --数据日期
       ,t1.lp_id                                                                                                               --法人编号
      , t1.tran_num                                                                                                       -- 业务编号
      , nvl(t2.belong_org_id, t10.org_id)                                                                       -- 记账机构编号
      , t1.ext_vch_acct_id                                                                                               -- 外部证券账户编号
      , t1.intnal_vch_acct_id                                                                                           -- 内部证券账户编号
      , t1.fin_instm_id                                                                                                    -- 金融工具编号
      , t1.asset_type_id                                                                                                   -- 资产类型编号
      , t3.prod_cls                                                                                                          -- 资产类型名称
      , t1.market_type_id                                                                                                -- 市场类型编号
      , t1.obj_id                                                                                                              -- 对象编号
      , nvl(trim(t9.approve_i_code), t1.fin_instm_id) ||case when t1.asset_type_id in ('SPT_BD', 'SPT_ABS') and t1.market_type_id = 'XSHG' 
                                                                                            then 'SH' when t1.asset_type_id in ('SPT_BD', 'SPT_ABS') and t1.market_type_id = 'XSHE'  
                                                                                            then 'SZ' else '' 
                                                                                            end|| '_' || t1.asset_thd_cls_cd || '_' || t1.intnal_vch_acct_id              -- 资产唯一标识编号
      , t3.prod_type_cd                                                                                                   -- 产品类型代码
      , t4.ext_cap_acct_id                                                                                                -- 交易账簿编号
      , t2.acct_name                                                                                                       -- 交易账簿名称
      , t4.acct_b_cate_cd                                                                                                 -- 账簿属性代码
      , t3.std_prod_id                                                                                                      -- 标准产品编号
      , t7.asset_thd_cls_cd                                                                                               -- 资产三分类代码
      , t3.curr_cd                                                                                                            -- 币种代码
      , decode(t4.tran_type_id,'2000100','01','2000101','02','00')                                   -- 交易方向代码
      , t14.int_accr_base_cd                                                                                            -- 计息基准代码	
      , t5.cust_id                                                                                                             -- 交易对手客户编号
      , t3.issue_org_id                                                                                                     -- 交易对手编号
      , t5.party_fname                                                                                                    -- 交易对手名称
      , t4.intnal_secu_acct_id                                                                                           -- 投组编号
      , t6.acct_name                                                                                                       -- 投组名称
      , nvl(t10.subj_id1,t13.pric_subj_id)                                                                         -- 本金科目编号
      , coalesce(t10.int_subj_id,t13.int_subj_id)                                                             -- 利息科目编号
      , t4.entr_dt                                                                                                             -- 交易日期
      , t3.value_dt                                                                                                           -- 起息日期
      , t3.exp_dt                                                                                                              -- 到期日期
      , t4.tran_qtty                                                                                                           -- 交易金额
      , nvl(t4.tran_qtty,0)+nvl(t4.tran_amt,0)                                                                -- 到期结算金额
      , t3.fac_val_int_rat                                                                                                   -- 借贷费率
      , t3.tenor_days                                                                                                        -- 借贷天数
      , t8.fin_instm_id                                                                                                       -- 质押债券组合
      , t3.underly_fin_instm_id                                                                                          -- 标的债券编号
      , t8.inpwn_cert_face_lmt                                                                                           --质押券面额
      , case when t3.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') 
                   then case when t3.src_pay_int_ped_cd = '0D' 
                                       then case when t11.gzb_type = '3.1' 
                                                           then t1.acru_int + nvl(t11.value, 0)
                                                            else t1.acru_int end
                                         else 0 end
                     else 0 end as acru_int                                                                            -- 应计利息
      , case when t3.prod_type_cd in ('0702','0703','0704','0705') then t12.receive_ai
                 when t3.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') 
                   then case when t3.src_pay_int_ped_cd <>'0D' 
                                        then case when t11.gzb_type = '3.2' then t1.acru_int + nvl(t11.value, 0)
                                                          else t1.acru_int end
                                          else 0 end
                   else t1.acru_int  + nvl(t11.value, 0) end as int_recvbl                            -- 应收利息
      , t1.actl_qtty                                                                                                            -- 持有仓位
      , t1.actl_bal                                                                                                              -- 当期余额
      , t4.apv_odd_no                                                                                                       -- 交易编号
      , t2.exchg_acct_id                                                                                                     -- 交易清算账户编号
      , t2.open_acct_bank_no                                                                                            -- 交易清算银行行号
      , t2.open_acct_bank_name                                                                                        -- 交易清算银行行名
        ,t1.job_cd
        ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp           --数据处理时间
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1  --证券账户核算余额历史
      left join ${iml_schema}.prd_fin_instm t3 --金融工具表
       on t1.fin_instm_id = t3.fin_instm_id
     and t1.asset_type_id = t3.asset_type_id
     and t1.market_type_id = t3.market_type_id
     and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t3.job_cd = 'ibmsf1'
     and t3.id_mark <> 'D'
   inner join (select t.*
                                    ,row_number() over(partition by t.fin_instm_id,t.asset_type_id,t.tran_market_id order by t.stl_dt) as rn
                         from ${iml_schema}.evt_ibank_tran t
                       where t.job_cd = 'ibmsi1'
                           and t.stl_status_cd = '999'
                           and t.tran_status_cd = '4'
                           and t.tran_type_id in ('2000100','2000101')  --2000100债券借入,2000101 债券借出
                  ) t4
       on t1.fin_instm_id = t4.fin_instm_id
     and t1.asset_type_id = t4.asset_type_id
     and t1.market_type_id = t4.tran_market_id
     and t4.rn = 1
     left join ${iml_schema}.agt_ext_cap_acct t2
       on t4.ext_cap_acct_id = t2.acct_id
     and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t2.job_cd = 'ibmsf1'
     and t2.id_mark <> 'D'
      left join ${iml_schema}.pty_ibank_cntpty_info t5
       on t4.cntpty_id = t5.src_party_id
     and t5.create_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t5.job_cd = 'ibmsf1'
     and t5.id_mark <> 'D'
     left join ${iml_schema}.agt_intnal_secu_acct t6 --内部证券账户
       on t1.intnal_vch_acct_id = t6.acct_id
     and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t6.job_cd = 'ibmsf1'
     and t6.id_mark <>'D'
      left join ${iml_schema}.ref_ibank_acctnt_type_cd t7
       on t7.cls_id = t6.acctnt_cls_cd
     and t7.create_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t7.job_cd = 'ibmsf1'
     and t7.id_mark <> 'D'
    left join ${iml_schema}.prd_inpwn_vch_pledge_type_repo t8
      on t1.fin_instm_id = t8.fin_instm_id 
     and t1.asset_type_id = t8.asset_type_id   
     and t1.market_type_id = t8.market_type_id
     and t8.job_cd = 'ibmsf1'
     left join ${iol_schema}.ibms_ttrd_credit_instrument_mapping t9
      on t1.fin_instm_id = t9.confirm_i_code
     and t1.asset_type_id = t9.confirm_a_type
     and t1.market_type_id = t9.confirm_m_type
     and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
    left join ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_01 t10
     on t1.obj_id = t10.obj_id
    left join ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_02 t11
     on t11.trade_id=t1.tran_num and t11.typename=t7.cls_name
    left join (select inst_i_code,inst_a_type,inst_m_type,receive_ai
                       from ${iol_schema}.ibms_ttrd_accounting_due_obj
                      where start_dt <=to_date('${batch_date}', 'yyyymmdd')
                        and end_dt >to_date('${batch_date}', 'yyyymmdd')
                        and to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                        and receive_ai <> 0
                      union all 
                     select inst_i_code,inst_a_type,inst_m_type,receive_ai
                       from ${iol_schema}.ibms_ttrd_accounting_due_obj_his
                      where to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                        and receive_ai <> 0
                     ) t12
      on t1.fin_instm_id = t12.inst_i_code  
     and t1.asset_type_id = t12.inst_a_type 
     and t1.market_type_id = t12.inst_m_type
     left join ${icl_schema}.cmm_ibank_bond_debit_crdt t13
       on t1.obj_id = t13.obj_id
     and t13.etl_dt =to_date('${batch_date}', 'yyyymmdd')-1
     left join ${iml_schema}.prd_ibank_bond t14
       on t3.underly_fin_instm_id = t14.fin_instm_id 
     and t3.un_asset_type_id = t14.asset_type_id 
     and t3.underly_market_type_id = t14.market_type_id
     and t14.create_dt <=to_date('${batch_date}', 'yyyymmdd')
     and t14.job_cd ='ibmsf1'
     and t14.id_mark<>'D'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t1.job_cd = 'ibmsf1'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_bond_debit_crdt exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_bond_debit_crdt_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_bond_debit_crdt_ex purge;
--drop table ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_01 purge;
--drop table ${icl_schema}.tmp_cmm_ibank_bond_debit_crdt_02 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_ibank_bond_debit_crdt',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
