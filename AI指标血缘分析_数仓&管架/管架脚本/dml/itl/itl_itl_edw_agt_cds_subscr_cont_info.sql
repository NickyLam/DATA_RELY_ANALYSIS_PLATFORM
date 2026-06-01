/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_agt_cds_subscr_cont_info
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
alter table ${itl_schema}.itl_edw_agt_cds_subscr_cont_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_agt_cds_subscr_cont_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_agt_cds_subscr_cont_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_agt_cds_subscr_cont_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,cont_id  -- 合约编号
    ,cust_id  -- 客户编号
    ,cust_acct_num  -- 客户账号
    ,cust_name  -- 客户名称
    ,prod_id  -- 产品编号
    ,src_prod_id  -- 源产品编号
    ,cont_status_cd  -- 合约状态代码
    ,curr_cd  -- 币种代码
    ,subscr_tot  -- 认购总额
    ,effect_dt  -- 生效日期
    ,invalid_dt  -- 失效日期
    ,exp_dt  -- 到期日期
    ,value_dt  -- 起息日期
    ,sign_chn_cd  -- 签订渠道代码
    ,dep_term_cd  -- 存期代码
    ,agt_rat  -- 协议利率
    ,pric_tran_in_acct_num  -- 本金转入账号
    ,int_tran_in_acct_num  -- 利息转入账号
    ,liab_acct_num  -- 负债账号
    ,dep_rcpt_acct_num  -- 存单账号
    ,acct_org_id  -- 账户机构编号
    ,sign_org_id  -- 签约机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,sign_emply_id  -- 签约员工编号
    ,sign_teller_id  -- 签约柜员编号
    ,sign_dt  -- 签订日期
    ,sign_flow_num  -- 签约流水号
    ,revo_dt  -- 撤销日期
    ,dep_prod_acct_id  -- 存款产品户编号
    ,matn_teller_id  -- 维护柜员编号
    ,matn_org_id  -- 维护机构编号
    ,matn_tm  -- 维护时间
    ,tm_stamp  -- 时间戳
    ,rec_status_cd  -- 记录状态代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'')  -- 合约编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'')  -- 客户账号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'')  -- 源产品编号
    ,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'')  -- 合约状态代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.subscr_tot  -- 认购总额
    ,t1.effect_dt  -- 生效日期
    ,t1.invalid_dt  -- 失效日期
    ,t1.exp_dt  -- 到期日期
    ,t1.value_dt  -- 起息日期
    ,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'')  -- 签订渠道代码
    ,replace(replace(t1.dep_term_cd,chr(13),''),chr(10),'')  -- 存期代码
    ,t1.agt_rat  -- 协议利率
    ,replace(replace(t1.pric_tran_in_acct_num,chr(13),''),chr(10),'')  -- 本金转入账号
    ,replace(replace(t1.int_tran_in_acct_num,chr(13),''),chr(10),'')  -- 利息转入账号
    ,replace(replace(t1.liab_acct_num,chr(13),''),chr(10),'')  -- 负债账号
    ,replace(replace(t1.dep_rcpt_acct_num,chr(13),''),chr(10),'')  -- 存单账号
    ,replace(replace(t1.acct_org_id,chr(13),''),chr(10),'')  -- 账户机构编号
    ,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'')  -- 签约机构编号
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.sign_emply_id,chr(13),''),chr(10),'')  -- 签约员工编号
    ,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'')  -- 签约柜员编号
    ,t1.sign_dt  -- 签订日期
    ,replace(replace(t1.sign_flow_num,chr(13),''),chr(10),'')  -- 签约流水号
    ,t1.revo_dt  -- 撤销日期
    ,replace(replace(t1.dep_prod_acct_id,chr(13),''),chr(10),'')  -- 存款产品户编号
    ,replace(replace(t1.matn_teller_id,chr(13),''),chr(10),'')  -- 维护柜员编号
    ,replace(replace(t1.matn_org_id,chr(13),''),chr(10),'')  -- 维护机构编号
    ,replace(replace(t1.matn_tm,chr(13),''),chr(10),'')  -- 维护时间
    ,t1.tm_stamp  -- 时间戳
    ,replace(replace(t1.rec_status_cd,chr(13),''),chr(10),'')  -- 记录状态代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iml.v_agt_cds_subscr_cont_info t1    --排队系统流水信息表-历史
where t1.create_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_agt_cds_subscr_cont_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);