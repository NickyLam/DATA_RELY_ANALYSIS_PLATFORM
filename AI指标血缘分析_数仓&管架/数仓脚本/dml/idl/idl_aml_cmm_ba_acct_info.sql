/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_ba_acct_info
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
alter table ${idl_schema}.aml_cmm_ba_acct_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_ba_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_ba_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_ba_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,bill_num  -- 票据号码
    ,acpt_org_id  -- 承兑机构编号
    ,stl_acct_num  -- 结算账号
    ,subj_id  -- 科目编号
    ,bill_med_cd  -- 票据介质代码
    ,bill_type_cd  -- 票据类型代码
    ,margin_acct_num  -- 保证金账号
    ,margin_dep_term  -- 保证金存期
    ,draw_dt  -- 出票日期
    ,close_dt  -- 关闭日期
    ,close_flow  -- 关闭流水
    ,exp_dt  -- 到期日期
    ,bill_status  -- 票据状态
    ,close_way  -- 关闭方式
    ,pymc_acct_num  -- 备款账号
    ,pymc_dt  -- 备款日期
    ,pymc_flow  -- 备款流水
    ,pymc_way  -- 备款方式
    ,advc_flg  -- 垫款标志
    ,advc_dubil_id  -- 垫款借据编号
    ,advc_exec_int_rat  -- 垫款执行利率
    ,advc_int_rat_cu_ratio  -- 垫款利率上浮比例
    ,int_rat_base_type_cd  -- 利率基准类型代码
    ,fac_val_curr  -- 票面币种
    ,margin_curr  -- 保证金币种
    ,margin_ratio  -- 保证金比例
    ,margin_amt  -- 保证金金额
    ,advc_amt  -- 垫款金额
    ,comm_fee  -- 手续费
    ,fac_val_amt  -- 票面金额
    ,currt_bal  -- 当期余额
    ,cl_curr_currt_bal  -- 折本币当期余额
    ,ear_d_bal  -- 日初余额
    ,ear_m_bal  -- 月初余额
    ,ear_s_bal  -- 季初余额
    ,ear_y_bal  -- 年初余额
    ,y_acm_bal  -- 年累计余额
    ,s_acm_bal  -- 季累计余额
    ,m_acm_bal  -- 月累计余额
    ,cl_curr_ear_d_bal  -- 折本币日初余额
    ,cl_curr_ear_m_bal  -- 折本币月初余额
    ,cl_curr_ear_s_bal  -- 折本币季初余额
    ,cl_curr_ear_y_bal  -- 折本币年初余额
    ,cl_curr_y_acm_bal  -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal  -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal  -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    t1.etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.bill_num,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.acpt_org_id,chr(13),''),chr(10),'')  -- 承兑机构编号
    ,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'')  -- 结算账号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'')  -- 票据介质代码
    ,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'')  -- 票据类型代码
    ,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'')  -- 保证金账号
    ,replace(replace(t1.margin_dep_term,chr(13),''),chr(10),'')  -- 保证金存期
    ,t1.draw_dt  -- 出票日期
    ,t1.close_dt  -- 关闭日期
    ,replace(replace(t1.close_flow,chr(13),''),chr(10),'')  -- 关闭流水
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.bill_status,chr(13),''),chr(10),'')  -- 票据状态
    ,replace(replace(t1.close_way,chr(13),''),chr(10),'')  -- 关闭方式
    ,replace(replace(t1.pymc_acct_num,chr(13),''),chr(10),'')  -- 备款账号
    ,t1.pymc_dt  -- 备款日期
    ,replace(replace(t1.pymc_flow,chr(13),''),chr(10),'')  -- 备款流水
    ,replace(replace(t1.pymc_way,chr(13),''),chr(10),'')  -- 备款方式
    ,replace(replace(t1.advc_flg,chr(13),''),chr(10),'')  -- 垫款标志
    ,replace(replace(t1.advc_dubil_id,chr(13),''),chr(10),'')  -- 垫款借据编号
    ,t1.advc_exec_int_rat  -- 垫款执行利率
    ,t1.advc_int_rat_cu_ratio  -- 垫款利率上浮比例
    ,replace(replace(t1.int_rat_base_type_cd,chr(13),''),chr(10),'')  -- 利率基准类型代码
    ,replace(replace(t1.fac_val_curr,chr(13),''),chr(10),'')  -- 票面币种
    ,replace(replace(t1.margin_curr,chr(13),''),chr(10),'')  -- 保证金币种
    ,t1.margin_ratio  -- 保证金比例
    ,t1.margin_amt  -- 保证金金额
    ,t1.advc_amt  -- 垫款金额
    ,t1.comm_fee  -- 手续费
    ,t1.fac_val_amt  -- 票面金额
    ,t1.currt_bal  -- 当期余额
    ,t1.cl_curr_currt_bal  -- 折本币当期余额
    ,t1.ear_d_bal  -- 日初余额
    ,t1.ear_m_bal  -- 月初余额
    ,t1.ear_s_bal  -- 季初余额
    ,t1.ear_y_bal  -- 年初余额
    ,t1.y_acm_bal  -- 年累计余额
    ,t1.s_acm_bal  -- 季累计余额
    ,t1.m_acm_bal  -- 月累计余额
    ,t1.cl_curr_ear_d_bal  -- 折本币日初余额
    ,t1.cl_curr_ear_m_bal  -- 折本币月初余额
    ,t1.cl_curr_ear_s_bal  -- 折本币季初余额
    ,t1.cl_curr_ear_y_bal  -- 折本币年初余额
    ,t1.cl_curr_y_acm_bal  -- 折本币年累计余额
    ,t1.cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,t1.cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,t1.cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,t1.cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,t1.cl_curr_s_acm_bal  -- 折本币季累计余额
    ,t1.cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,t1.cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,t1.cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,t1.cl_curr_m_acm_bal  -- 折本币月累计余额
    ,t1.cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,t1.cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,t1.cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,t1.etl_timestamp  -- ETL处理时间戳
from ${icl_schema}.cmm_ba_acct_info t1    --银承账户信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_ba_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);