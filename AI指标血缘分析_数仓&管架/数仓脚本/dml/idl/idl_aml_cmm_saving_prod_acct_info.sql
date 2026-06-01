/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_saving_prod_acct_info
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
alter table ${idl_schema}.aml_cmm_saving_prod_acct_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_saving_prod_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_saving_prod_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_saving_prod_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,cust_acct_id  -- 客户账户编号
    ,cust_id  -- 客户编号
    ,subj_id  -- 科目编号
    ,prod_id  -- 产品编号
    ,dep_term  -- 存期
    ,dep_kind_cd  -- 储种代码
    ,acct_cls_cd  -- 账户分类代码
    ,dep_acct_status_cd  -- 存款账户状态代码
    ,stop_pay_status_cd  -- 止付状态代码
    ,rc_flg  -- 定活标志
    ,general_exch_flg  -- 通兑标志
    ,advise_dep_flg  -- 通知存款标志
    ,ec_flg  -- 钞汇标志
    ,sleep_acct_flg  -- 睡眠户标志
    ,froz_flg  -- 冻结标志
    ,int_accr_base_cd  -- 计息基准代码
    ,int_set_way_cd  -- 结息方式代码
    ,int_accr_way_cd  -- 计息方式代码
    ,curr_cd  -- 币种代码
    ,open_acct_dt  -- 开户日期
    ,open_acct_tm  -- 开户时间
    ,clos_acct_dt  -- 销户日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,final_activ_acct_dt  -- 最后动户日期
    ,froz_dt  -- 冻结日期
    ,unfrz_dt  -- 解冻日期
    ,base_rat_type_cd  -- 基准利率类型代码
    ,base_rat  -- 基准利率
    ,exec_int_rat  -- 执行利率
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,open_acct_teller_id  -- 开户柜员编号
    ,clos_acct_teller_id  -- 销户柜员编号
    ,open_acct_org_id  -- 开户机构编号
    ,close_acct_org_id  -- 销户机构编号
    ,currt_bal  -- 当期余额
    ,aval_bal  -- 可用余额
    ,stop_pay_amt  -- 止付金额
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
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'')  -- 客户账户编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.dep_term,chr(13),''),chr(10),'')  -- 存期
    ,replace(replace(t1.dep_kind_cd,chr(13),''),chr(10),'')  -- 储种代码
    ,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'')  -- 账户分类代码
    ,replace(replace(t1.dep_acct_status_cd,chr(13),''),chr(10),'')  -- 存款账户状态代码
    ,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'')  -- 止付状态代码
    ,replace(replace(t1.rc_flg,chr(13),''),chr(10),'')  -- 定活标志
    ,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'')  -- 通兑标志
    ,replace(replace(t1.advise_dep_flg,chr(13),''),chr(10),'')  -- 通知存款标志
    ,replace(replace(t1.ec_flg,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'')  -- 睡眠户标志
    ,replace(replace(t1.froz_flg,chr(13),''),chr(10),'')  -- 冻结标志
    ,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'')  -- 计息基准代码
    ,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'')  -- 结息方式代码
    ,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'')  -- 计息方式代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.open_acct_dt  -- 开户日期
    ,t1.open_acct_tm  -- 开户时间
    ,t1.clos_acct_dt  -- 销户日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.final_activ_acct_dt  -- 最后动户日期
    ,t1.froz_dt  -- 冻结日期
    ,t1.unfrz_dt  -- 解冻日期
    ,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'')  -- 基准利率类型代码
    ,t1.base_rat  -- 基准利率
    ,t1.exec_int_rat  -- 执行利率
    ,t1.td_acru_int  -- 当日应计利息
    ,t1.currt_acru_int  -- 当期应计利息
    ,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'')  -- 开户柜员编号
    ,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'')  -- 销户柜员编号
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.close_acct_org_id,chr(13),''),chr(10),'')  -- 销户机构编号
    ,t1.currt_bal  -- 当期余额
    ,t1.aval_bal  -- 可用余额
    ,t1.stop_pay_amt  -- 止付金额
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
from ${icl_schema}.cmm_saving_prod_acct_info t1    --储蓄产品账户信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_saving_prod_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);