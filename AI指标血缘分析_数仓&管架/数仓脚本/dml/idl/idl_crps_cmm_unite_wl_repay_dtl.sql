/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_repay_dtl
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.crps_cmm_unite_wl_repay_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_repay_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_repay_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,dubil_id  -- 借据编号
    ,cust_id  -- 客户编号
    ,prod_id  -- 产品编号
    ,repay_acct_id  -- 还款账户编号
    ,repay_flow_id  -- 还款流水编号
    ,repay_dt  -- 还款日期
    ,intnal_carr_flg  -- 内部结转标志
    ,wrt_off_flg  -- 核销标志
    ,adv_repay_flg  -- 提前还款标志
    ,ovdue_repay_flg  -- 逾期还款标志
    ,acru_non_acru_cd  -- 应计非应计代码
    ,repay_type_cd  -- 还款类型代码
    ,curr_cd  -- 币种代码
    ,curr_nomal_pric_bal  -- 当前正常本金余额
    ,currt_repay_amt  -- 当期还款金额
    ,currt_repay_pric  -- 当期还款本金
    ,currt_repay_nomal_pric  -- 当期还款正常本金
    ,currt_repay_ovdue_pric  -- 当期还款逾期本金
    ,curr_repay_int  -- 当前还款利息
    ,currt_repay_nomal_int  -- 当期还款正常利息
    ,currt_repay_ovdue_int  -- 当期还款逾期利息
    ,currt_repay_pnlt  -- 当期还款罚息
    ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
    ,currt_repay_ovdue_int_pnlt  -- 当期还款逾期利息罚息
    ,currt_repay_fee  -- 当期还款费用
    ,currt_repay_fee_rat  -- 当期还款费率
    ,bf_repay_recvbl_uncol_nomal_pric  -- 还款前的应收未收正常本金
    ,bf_repay_recvbl_uncol_ovdue_pric  -- 还款前的应收未收逾期本金
    ,bf_repay_recvbl_uncol_nomal_int  -- 还款前的应收未收正常利息
    ,bf_repay_recvbl_uncol_ovdue_int  -- 还款前的应收未收逾期利息
    ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
    ,bf_repay_recvbl_uncol_ovdue_int_pnlt  -- 还款前的应收未收逾期利息罚息
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id  -- 借据编号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id  -- 产品编号
    ,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id  -- 还款账户编号
    ,replace(replace(t.repay_flow_id,chr(13),''),chr(10),'') as repay_flow_id  -- 还款流水编号
    ,t.repay_dt as repay_dt  -- 还款日期
    ,replace(replace(t.intnal_carr_flg,chr(13),''),chr(10),'') as intnal_carr_flg  -- 内部结转标志
    ,replace(replace(t.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg  -- 核销标志
    ,replace(replace(t.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg  -- 提前还款标志
    ,replace(replace(t.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg  -- 逾期还款标志
    ,replace(replace(t.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd  -- 应计非应计代码
    ,replace(replace(t.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd  -- 还款类型代码
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,t.curr_nomal_pric_bal as curr_nomal_pric_bal  -- 当前正常本金余额
    ,t.currt_repay_amt as currt_repay_amt  -- 当期还款金额
    ,t.currt_repay_pric as currt_repay_pric  -- 当期还款本金
    ,t.currt_repay_nomal_pric as currt_repay_nomal_pric  -- 当期还款正常本金
    ,t.currt_repay_ovdue_pric as currt_repay_ovdue_pric  -- 当期还款逾期本金
    ,t.curr_repay_int as curr_repay_int  -- 当前还款利息
    ,t.currt_repay_nomal_int as currt_repay_nomal_int  -- 当期还款正常利息
    ,t.currt_repay_ovdue_int as currt_repay_ovdue_int  -- 当期还款逾期利息
    ,t.currt_repay_pnlt as currt_repay_pnlt  -- 当期还款罚息
    ,t.currt_repay_ovdue_pric_pnlt as currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
    ,t.currt_repay_ovdue_int_pnlt as currt_repay_ovdue_int_pnlt  -- 当期还款逾期利息罚息
    ,t.currt_repay_fee as currt_repay_fee  -- 当期还款费用
    ,t.currt_repay_fee_rat as currt_repay_fee_rat  -- 当期还款费率
    ,t.bf_repay_recvbl_uncol_nomal_pric as bf_repay_recvbl_uncol_nomal_pric  -- 还款前的应收未收正常本金
    ,t.bf_repay_recvbl_uncol_ovdue_pric as bf_repay_recvbl_uncol_ovdue_pric  -- 还款前的应收未收逾期本金
    ,t.bf_repay_recvbl_uncol_nomal_int as bf_repay_recvbl_uncol_nomal_int  -- 还款前的应收未收正常利息
    ,t.bf_repay_recvbl_uncol_ovdue_int as bf_repay_recvbl_uncol_ovdue_int  -- 还款前的应收未收逾期利息
    ,t.bf_repay_recvbl_uncol_ovdue_pric_pnlt as bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
    ,t.bf_repay_recvbl_uncol_ovdue_int_pnlt as bf_repay_recvbl_uncol_ovdue_int_pnlt  -- 还款前的应收未收逾期利息罚息
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_unite_wl_repay_dtl t--联合网贷还款明细
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.crps_cmm_unite_wl_repay_dtl to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_repay_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);