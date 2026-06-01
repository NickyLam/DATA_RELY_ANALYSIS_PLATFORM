/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mpcs_cmm_retl_loan_dubil_info
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
alter table ${idl_schema}.mpcs_cmm_retl_loan_dubil_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.mpcs_cmm_retl_loan_dubil_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.mpcs_cmm_retl_loan_dubil_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,dubil_id  -- 借据编号
    ,cust_name  -- 客户名称
    ,cert_no  -- 证件号码
    ,cont_id  -- 合同编号
    ,dubil_amt  -- 借据金额
    ,col_store_addr  -- 押品存放地址
    ,distr_dt  -- 放款日期
    ,operate  -- 1代表新增
    ,open_acct_org_id  -- 开户机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,acct_instit_id  -- 账务机构编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as loan_acct_id   -- 借据编号
    ,replace(replace(t2.cust_name,chr(13),''),chr(10),'') as cust_name   -- 客户名称
    ,replace(replace(t2.cert_no,chr(13),''),chr(10),'') as cert_no   -- 证件号码
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id   -- 合同编号
    ,t.dubil_amt  -- 借据金额
    ,replace(replace(t3.col_store_addr,chr(13),''),chr(10),'') as col_store_addr   -- 押品存放地址
    ,replace(replace(t.fir_distr_dt,chr(13),''),chr(10),'') as fir_distr_dt   -- 放款日期
    ,'1'  -- 1代表新增
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id   -- 开户机构编号
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id   -- 管理机构编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id   -- 账务机构编号
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from icl.cmm_retl_loan_dubil_info t--零售贷款借据信息
INNER JOIN icl.cmm_retl_loan_acct_info t1 --零售贷款账户信息
        ON t.dubil_id = t1.dubil_num  --借据号关联
       AND t1.etl_dt=to_date('${batch_date}','yyyymmdd')		
 LEFT JOIN icl.cmm_indv_cust_basic_info t2 --个人客户基本信息
        ON t.cust_id = t2.cust_id  --客户号关联
       AND t2.etl_dt=to_date('${batch_date}','yyyymmdd')		
 LEFT JOIN icl.cmm_loan_guar_cont_rela map01 --贷款合同与担保合同关系
        ON t.cont_id = map01.loan_cont_id --贷款合同号关联取担保合同号
       AND map01.etl_dt=to_date('${batch_date}','yyyymmdd')		
/* LEFT JOIN 
 (select t.*
        ,row_number() over(partition by guar_cont_id order by guar_cont_id ASC ) as a
   from iml.agt_guar_cont_guar_rela_h t --担保合同担保物关系历史
     where t.start_dt <= to_date('${batch_date}','yyyymmdd')		
       AND t.end_dt > to_date('${batch_date}','yyyymmdd')		
       AND t.job_cd = 'icmsf1'
  ) map02
       ON map01.guar_cont_id = map02.guar_cont_id --担保合同号关联取押品编号
      AND map02.a = 1
*/
 LEFT JOIN icl.cmm_col_guar_cont_rela map02 --押品与担保合同关系
        ON map01.guar_cont_id = map02.guar_cont_id --担保合同号关联取押品编号
       AND map02.etl_dt=to_date('${batch_date}','yyyymmdd')		
 INNER JOIN icl.cmm_col_info t3 --押品信息
        ON map02.col_id = t3.col_id --押品编号关联
       AND t3.guar_way_cd = 'DY'
       AND t3.etl_dt=to_date('${batch_date}','yyyymmdd')
where EXISTS (SELECT 1 FROM icl.cmm_intnal_org_info org --内部机构信息表
                                WHERE t1.open_acct_org_id = org.org_id
                                  AND org.org_name like '%惠州%'
                                  AND org.etl_dt=to_date('${batch_date}','yyyymmdd'))
  AND t.std_prod_id='201030100001'--个人一手房按揭贷款
  AND t.etl_dt=to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.mpcs_cmm_retl_loan_dubil_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mpcs_cmm_retl_loan_dubil_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);