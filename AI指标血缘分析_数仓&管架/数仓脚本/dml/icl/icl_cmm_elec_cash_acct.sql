/*
Purpose:    共性加工层-电子现金账户信息：包括新核心系统电子现金模块的所有账户信息。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20230518 icl_cmm_elec_cash_acct
CreateDate: 20220323
Logs:       20220113 曹永茂 调整字段【当期余额】的加工口径
                            1. nvl(t1.elec_cash_acct_bal, 0) - nvl(t4.tran_amt, 0) -> nvl(t1.elec_cash_acct_bal, 0) + nvl(t4.tran_amt, 0)
                            2. setl_status = '0' -> setl_status in ('0','1')
            20240812 陈伟峰 调整客户号取数逻辑，从ncbs_rb_card_chg_msg补充
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_elec_cash_acct drop partition p_${retain_day};
alter table ${icl_schema}.cmm_elec_cash_acct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_elec_cash_acct_ex purge;
drop table ${icl_schema}.tmp_cmm_elec_cash_acct_01 purge;

-- 1.3 insert data to tmp table
-- 获取账户结算信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_elec_cash_acct_01
nologging
compress ${option_switch} for query high
as select  sdp.base_prod_id,
        sd.amt_type_cd,  
        sdp.prod_attr_cd,
        sd.bus_type_cd,    
        sd.subj_descb,
        sd.status_cd,
        sd.sob_id,
        sd.subj_id
    from ${iml_schema}.fin_accti_subj_rela_h sd
   inner join ${iml_schema}.fin_accti_prod_rela_info sdp
      on sd.accti_id = sdp.accti_id
     and sd.sob_id = sdp.sob_id
     and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
     and sdp.job_cd = 'tglsi1'
   where sd.sob_id = 2
     and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and sd.status_cd = '1'
     and sdp.base_prod_id = '1010101'
     and sd.amt_type_cd = 'BAL'
     and sd.job_cd = 'tglsf1';
commit;

create table ${icl_schema}.cmm_elec_cash_acct_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_elec_cash_acct where 0=1;

--第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_cash_acct_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,cust_acct_card_no         --客户账户卡号
       ,cust_acct_sub_acct_id     --账户子账号
       ,acct_name                 --账户名称
       ,cust_id                   --客户编号
       ,std_prod_id               --标准产品编号
       ,subj_id                   --科目编号
       ,acct_status_cd            --账户状态代码
       ,curr_cd                   --币种代码
       ,open_acct_dt              --开户日期
       ,open_acct_org_id          --开户机构编号
       ,clos_acct_dt              --销户日期
       ,clos_acct_flow_num        --销户流水号
       ,acct_bal_uplmi            --账户余额上限
       ,sig_tran_lmt              --单笔交易限额
       ,acm_load_amt              --累计圈存金额
       ,currt_bal                 --当期余额
       ,job_cd                    -- 任务代码
       ,etl_timestamp             -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.card_no                                                       --客户账户卡号
       ,t1.card_ser_num                                                  --账户子账号
       ,t1.acct_name                                                     --账户名称
       ,nvl(trim(t2.client_no),t5.client_no)                             --客户编号
       ,'101010100004'                                                   --标准产品编号
       ,t3.subj_id                                                       --科目编号
       ,t1.elec_cash_acct_status_cd                                      --账户状态代码
       ,t1.elec_cash_acct_curr_cd                                        --币种代码
       ,t1.elec_cash_acct_open_acct_dt                                   --开户日期
       ,t1.open_acct_org_id                                              --开户机构编号
       ,t1.clos_acct_dt                                                  --销户日期
       ,t1.clos_acct_flow_num                                            --销户流水号
       ,t1.elec_cash_bal_uplmi                                           --账户余额上限
       ,t1.elec_cash_sig_tran_lmt                                        --单笔交易限额
       ,t1.acm_load_amt                                                  --累计圈存金额
       ,nvl(t1.elec_cash_acct_bal, 0) + nvl(t4.tran_amt, 0)               --当期余额
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_ic_card_elec_cash_acct_h t1
  left join (select distinct re.card_no,re.client_no 
                        from ${iol_schema}.ncbs_rb_acct_client_relation re
                       where re.card_no is not null
                         and re.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                         and re.end_dt > to_date('${batch_date}', 'yyyymmdd')) t2
   on t1.card_no = t2.card_no
  left join ${icl_schema}.tmp_cmm_elec_cash_acct_01 t3
    on 1=1
  left join (select card_no as card_no
                   ,ic_card_seq as ic_card_seq
                   ,sum(tran_amt) as tran_amt
               from ${iol_schema}.ncbs_ic_ec_settle_reg
              where setl_status in ('0','1')
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
             group by card_no, ic_card_seq
            )t4
    on t1.card_no = t4.card_no
   and t1.card_ser_num = t4.ic_card_seq
  left join (select distinct re.old_card_no,re.client_no 
                        from ${iol_schema}.ncbs_rb_card_chg_msg re
                       where re.old_card_no is not null
                         and re.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                         and re.end_dt > to_date('${batch_date}', 'yyyymmdd')) t5
   on t1.card_no = t5.old_card_no
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and job_cd ='ncbsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_elec_cash_acct exchange partition p_${batch_date} with table ${icl_schema}.cmm_elec_cash_acct_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_elec_cash_acct_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_elec_cash_acct',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

