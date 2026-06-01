/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_acct_ctrl_info
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
alter table ${idl_schema}.oass_agt_loan_acct_ctrl_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_acct_ctrl_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_acct_ctrl_info (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,dubil_id  -- 借据编号
    ,loan_cust_type_cd  -- 贷款客户类型代码
    ,promis_loan_flg  -- 承诺贷款标志
    ,circl_loan_flg  -- 循环贷款标志
    ,unite_loan_flg  -- 联合贷款代码
    ,deriv_loan_flg  -- 衍生贷款标志
    ,agent_loan_flg  -- 代理贷款标志
    ,acru_non_acru_accti_flg  -- 按应计非应计核算标志
    ,oots_accti_flg  -- 按一逾两呆核算标志
    ,loan_modal_subj_accti_flg  -- 贷款形态分科目核算标志
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.dubil_id,chr(13),''),chr(10),'')  -- 借据编号
    ,replace(replace(t1.loan_cust_type_cd,chr(13),''),chr(10),'')  -- 贷款客户类型代码
    ,replace(replace(t1.promis_loan_flg,chr(13),''),chr(10),'')  -- 承诺贷款标志
    ,replace(replace(t1.circl_loan_flg,chr(13),''),chr(10),'')  -- 循环贷款标志
    ,replace(replace(t1.unite_loan_flg,chr(13),''),chr(10),'')  -- 联合贷款代码
    ,replace(replace(t1.deriv_loan_flg,chr(13),''),chr(10),'')  -- 衍生贷款标志
    ,replace(replace(t1.agent_loan_flg,chr(13),''),chr(10),'')  -- 代理贷款标志
    ,replace(replace(t1.acru_non_acru_accti_flg,chr(13),''),chr(10),'')  -- 按应计非应计核算标志
    ,replace(replace(t1.oots_accti_flg,chr(13),''),chr(10),'')  -- 按一逾两呆核算标志
    ,replace(replace(t1.loan_modal_subj_accti_flg,chr(13),''),chr(10),'')  -- 贷款形态分科目核算标志
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.agt_loan_acct_ctrl_info t1    --贷款账户控制信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_acct_ctrl_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);