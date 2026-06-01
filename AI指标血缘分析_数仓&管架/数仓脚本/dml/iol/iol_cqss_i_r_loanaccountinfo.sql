/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_loanaccountinfo
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cqss_i_r_loanaccountinfo_ex purge;
alter table ${iol_schema}.cqss_i_r_loanaccountinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_loanaccountinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_loanaccountinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_loanaccountinfo where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_loanaccountinfo_ex(
    id -- 代码主键:
    ,msgidno -- 报文标识号:
    ,acc_id -- 账户编号:
    ,dbtcr_acc_tp -- 借贷账户类型:
    ,inst_tp -- 机构类型:
    ,mtit_ecd -- 业务管理机构代码:
    ,acc_idr -- 账户标识:
    ,crg_agrm_id -- 授信协议编号:
    ,idvdbtcr_bnctg_sbdvsn -- 个人借贷业务种类细分:
    ,ftm_estb_dt -- 开立日期:
    ,ccycd -- 币种代码:
    ,bnk_lnd_amt -- 贷款金额:
    ,acc_crgln -- 账户授信额度:
    ,shr_crgln -- 共享授信额度:
    ,exdat -- 到期日期:
    ,rpmd -- 还款方式:
    ,idv_cr_repy_frq -- 个人征信还款频率:
    ,repy_prd_num -- 还款期数:
    ,idv_cr_grtstl -- 个人征信担保方式:
    ,ln_dstr_form -- 贷款发放形式:
    ,jnt_ln_indcd -- 共同贷款标志代码:
    ,clm_sft_hr_s_repy_st -- 债权转移时的还款状态:
    ,dbtcraccbaspinstmdnum -- 借贷账户大额专项分期笔数:
    ,fyrs_prfmn_strt_yrmo -- 五年表现开始年月:
    ,fyrs_prfmn_ctof_yrmo -- 五年表现截止年月:
    ,odue_monum -- 逾期月数:
    ,sptxn_num -- 特殊交易个数:
    ,spcl_ev_num -- 特殊事件个数:
    ,rctly24etrsmrstrtyrmo -- 最近24个月还款开始年月:
    ,rctly24etrsmorcofyrmo -- 最近24个月还款截止年月:
    ,annttn_and_sttmnt_num -- 标注及声明个数:
    ,multi_tenancy_id -- 多实体标识:
    ,crt_dt_tm -- 创建日期时间:
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键:
    ,msgidno -- 报文标识号:
    ,acc_id -- 账户编号:
    ,dbtcr_acc_tp -- 借贷账户类型:
    ,inst_tp -- 机构类型:
    ,mtit_ecd -- 业务管理机构代码:
    ,acc_idr -- 账户标识:
    ,crg_agrm_id -- 授信协议编号:
    ,idvdbtcr_bnctg_sbdvsn -- 个人借贷业务种类细分:
    ,ftm_estb_dt -- 开立日期:
    ,ccycd -- 币种代码:
    ,bnk_lnd_amt -- 贷款金额:
    ,acc_crgln -- 账户授信额度:
    ,shr_crgln -- 共享授信额度:
    ,exdat -- 到期日期:
    ,rpmd -- 还款方式:
    ,idv_cr_repy_frq -- 个人征信还款频率:
    ,repy_prd_num -- 还款期数:
    ,idv_cr_grtstl -- 个人征信担保方式:
    ,ln_dstr_form -- 贷款发放形式:
    ,jnt_ln_indcd -- 共同贷款标志代码:
    ,clm_sft_hr_s_repy_st -- 债权转移时的还款状态:
    ,dbtcraccbaspinstmdnum -- 借贷账户大额专项分期笔数:
    ,fyrs_prfmn_strt_yrmo -- 五年表现开始年月:
    ,fyrs_prfmn_ctof_yrmo -- 五年表现截止年月:
    ,odue_monum -- 逾期月数:
    ,sptxn_num -- 特殊交易个数:
    ,spcl_ev_num -- 特殊事件个数:
    ,rctly24etrsmrstrtyrmo -- 最近24个月还款开始年月:
    ,rctly24etrsmorcofyrmo -- 最近24个月还款截止年月:
    ,annttn_and_sttmnt_num -- 标注及声明个数:
    ,multi_tenancy_id -- 多实体标识:
    ,crt_dt_tm -- 创建日期时间:
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_loanaccountinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_loanaccountinfo exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_loanaccountinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_loanaccountinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_loanaccountinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_loanaccountinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);