/*
Purpose:    共性加工层-同业资金余额表:数据来源于同业系统（IBMS）,包括所有同业账户资金余额
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_ibank_cap_bal
Createdate: 20191025
Logs:       20210626 陈伟峰 增加字段【交易对手客户编号】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_cap_bal drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_cap_bal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ibank_cap_bal_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_cap_bal_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ibank_cap_bal where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_cap_bal_ex(
     etl_dt                --数据日期
    ,lp_id                 --法人编号
    ,intnal_cap_acct_id    --内部资金账户编号
    ,ext_cap_acct_id       --外部资金账户编号
    ,acct_name             --账户名称
    ,tran_market_id        --交易市场编号
    ,exchg_acct_id         --交易所账户编号
    ,open_acct_bank_no     --开户银行行号
    ,open_acct_bank_name   --开户银行名称
    ,open_acct_dt          --开户日期
    ,cntpty_cust_id        --交易对手客户编号
    ,cntpty_id             --交易对手编号
    ,cntpty_name           --交易对手名称
    ,intnal_cap_acct_num   --内部资金账号
    ,cap_acct_type_cd      --资金账户类型代码
    ,intnal_acct_num       --内部账号
    ,intnal_acct_name      --内部账名称
    ,pay_int_freq          --付息频率
    ,prod_type_id          --产品类型编号
    ,prod_cls_name         --产品分类名称
    ,subj_id               --科目编号
    ,int_rat_def_id        --利率定义编号
    ,int_rat               --利率
    ,cap_type_cd           --资金类型代码
    ,bal_type_cd           --余额类型代码
    ,curr_cd               --币种代码
    ,actl_bal              --实际余额
    ,froz_bal              --冻结余额
    ,aval_bal              --可用余额
    ,stl_dt                --结算日期
    ,open_dt               --开仓日期
    ,entry_org_id          --记账机构编号
    ,belong_org_id         --所属机构编号
    ,job_cd
    ,etl_timestamp         --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')  as etl_dt               --数据日期
      ,t1.lp_id                             as lp_id                --法人编号
      ,t1.intnal_cap_acct_id                as intnal_cap_acct_id   --内部资金账户编号
      ,t1.ext_cap_acct_id                   as ext_cap_acct_id      --外部资金账户编号
      ,t3.acct_name                         as acct_name            --账户名称
      ,t3.tran_market_id                    as tran_market_id       --交易市场编号
      ,t3.exchg_acct_id                     as exchg_acct_id        --交易所账户编号
      ,t3.open_acct_bank_no                 as open_acct_bank_no    --开户银行行号
      ,t3.open_acct_bank_name               as open_acct_bank_name  --开户银行名称
      ,t3.open_acct_dt                      as open_acct_dt         --开户日期
      ,t6.cust_id                           as cntpty_cust_id       --交易对手客户编号
      ,t3.cntpty_id                         as cntpty_id            --交易对手编号
      ,t3.cntpty_name                       as cntpty_name          --交易对手名称
      ,t3.intnal_cap_acct_num               as intnal_cap_acct_num  --内部资金账号
      ,t3.cap_acct_type_cd                  as cap_acct_type_cd     --资金账户类型代码 CAP_ACCT_TYPE_CD
      ,t3.intnal_acct_num                   as intnal_acct_num      --内部账号
      ,t3.intnal_acct_name                  as intnal_acct_name     --内部账名称
      ,t3.pay_int_ped_freq                  as pay_int_freq         --付息周期频率
      ,t3.prod_type_id                      as prod_type_id         --产品类型编号
      ,t3.prod_cls_name                     as prod_cls_name        --产品分类名称
      ,t3.subj_id                           as subj_id              --科目编号
      ,t3.int_rat_def_id                    as int_rat_def_id       --利率定义编号
      ,t3.int_rat                           as int_rat              --利率
      ,t2.cap_type_cd                       as cap_type_cd          --资金类型代码 0自有资产（自营业务）、1客户资产（代客、理财）
      ,t1.bal_type_cd                       as bal_type_cd          --余额类型代码
      ,t1.curr_cd                           as curr_cd              --币种代码
      ,t1.bal                               as actl_bal             --余额
      ,t1.froz_bal                          as net_price_cost       --冻结余额
      ,t1.aval_bal                          as acru_int             --可用余额
      ,t1.stl_dt                            as stl_dt               --结算日期
      ,t1.open_dt                           as open_dt              --开仓日期
      ,t2.belong_org_id                     as entry_org_id         --所属机构编号
      ,t3.belong_org_id                     as belong_org_id        --所属机构编号
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.agt_ibank_cap_acct_bal_h t1  --同业资金账户余额历史
  left join ${iml_schema}.agt_intnal_cap_acct t2 --内部资金账户
    on t1.intnal_cap_acct_id = t2.acct_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_ext_cap_acct t3 --外部资金账户
    on t1.ext_cap_acct_id = t3.acct_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ibmsf1'
   and t3.id_mark <> 'D'
  left join ${iml_schema}.pty_ibank_cntpty_info t6
    on t3.cntpty_id = t6.src_party_id
   and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsf1'
   and t6.id_mark <> 'D'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_cap_bal exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_cap_bal_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_cap_bal_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ibank_cap_bal', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);