/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_agt_ext_cap_acct
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_agt_ext_cap_acct drop partition p_${last_date};
alter table ${idl_schema}.icrm_agt_ext_cap_acct drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_agt_ext_cap_acct add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_agt_ext_cap_acct partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,tran_market_id  -- 交易市场编号
    ,exchg_acct_id  -- 交易所账户编号
    ,curr_cd  -- 币种代码
    ,open_acct_bank_no  -- 开户银行行号
    ,open_acct_bank_name  -- 开户银行名称
    ,open_acct_dt  -- 开户日期
    ,cntpty_id  -- 交易对手编号
    ,cntpty_name  -- 交易对手名称
    ,intnal_cap_acct_num  -- 内部资金账号
    ,cap_acct_type_cd  -- 资金账户类型代码
    ,intnal_acct_num  -- 内部账号
    ,entry_org_id  -- 记账机构编号
    ,intnal_acct_name  -- 内部账名称
    ,src_pay_int_ped_cd  -- 源付息周期代码
    ,pay_int_ped_corp_cd  -- 付息周期单位代码
    ,pay_int_ped_freq  -- 付息周期频率
    ,int_rat_def_id  -- 利率定义编号
    ,cap_type_cd  -- 资金类型代码
    ,pay_mon  -- 支付月份
    ,pay_days  -- 支付天数
    ,int_rat  -- 利率
    ,clos_acct_dt  -- 销户日期
    ,prod_type_id  -- 产品类型编号
    ,prod_cls_name  -- 产品分类名称
    ,subj_id  -- 科目编号
    ,swift_cd  -- SWIFT代码
    ,belong_org_id  -- 所属机构编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'')  -- 交易市场编号
    ,replace(replace(t1.exchg_acct_id,chr(13),''),chr(10),'')  -- 交易所账户编号
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.open_acct_bank_no,chr(13),''),chr(10),'')  -- 开户银行行号
    ,replace(replace(t1.open_acct_bank_name,chr(13),''),chr(10),'')  -- 开户银行名称
    ,t1.open_acct_dt  -- 开户日期
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'')  -- 交易对手名称
    ,replace(replace(t1.intnal_cap_acct_num,chr(13),''),chr(10),'')  -- 内部资金账号
    ,replace(replace(t1.cap_acct_type_cd,chr(13),''),chr(10),'')  -- 资金账户类型代码
    ,replace(replace(t1.intnal_acct_num,chr(13),''),chr(10),'')  -- 内部账号
    ,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'')  -- 记账机构编号
    ,replace(replace(t1.intnal_acct_name,chr(13),''),chr(10),'')  -- 内部账名称
    ,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'')  -- 源付息周期代码
    ,replace(replace(t1.pay_int_ped_corp_cd,chr(13),''),chr(10),'')  -- 付息周期单位代码
    ,replace(replace(t1.pay_int_ped_freq,chr(13),''),chr(10),'')  -- 付息周期频率
    ,replace(replace(t1.int_rat_def_id,chr(13),''),chr(10),'')  -- 利率定义编号
    ,replace(replace(t1.cap_type_cd,chr(13),''),chr(10),'')  -- 资金类型代码
    ,t1.pay_mon  -- 支付月份
    ,t1.pay_days  -- 支付天数
    ,t1.int_rat  -- 利率
    ,t1.clos_acct_dt  -- 销户日期
    ,replace(replace(t1.prod_type_id,chr(13),''),chr(10),'')  -- 产品类型编号
    ,replace(replace(t1.prod_cls_name,chr(13),''),chr(10),'')  -- 产品分类名称
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.swift_cd,chr(13),''),chr(10),'')  -- SWIFT代码
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'')  -- 所属机构编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.agt_ext_cap_acct t1    --外部资金账户
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_agt_ext_cap_acct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);